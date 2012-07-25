module ActiveScaffold::Config
  class Subform < Base
    def initialize(core_config)
      super
      @layout = self.class.layout # default layout
    end

    # global level configuration
    # --------------------------

    cattr_accessor :layout
    @@layout = :horizontal

    # instance-level configuration
    # ----------------------------

    attr_accessor :layout

    def columns_for(what_for)
      return_cols = self.columns
      if @columns_for and @columns_for.has_key?(what_for)
        return_cols = @columns_for[what_for]
      end

      return return_cols
    end


   def set_columns_for(what_for, *what_cols)
      @columns_for ||= {}
      nc = ActiveScaffold::DataStructures::ActionColumns.new(*what_cols)
      nc.action = self
      nc.set_columns(@core.columns) if nc.respond_to?(:set_columns)
      @columns_for[what_for] = nc
      nc
    end


    # provides access to the list of columns specifically meant for the Sub-Form to use
    def columns
      # we want to delay initializing to the @core.update.columns set for as long as possible. but we have to eventually clone, or else have a configuration "leak"
      unless @columns
        if @core.actions.include? :update
          @columns = @core.update.columns.clone
        else
          self.columns = @core.columns._inheritable
        end
      end

      @columns
    end

    public :columns=
  end
end
