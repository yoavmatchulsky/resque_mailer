module Resque
  module Mailer

    class << self
      attr_accessor :default_queue_name
      attr_reader :excluded_environments

      def excluded_environments=(envs)
        @excluded_environments = [*envs].map { |e| e.to_sym }
      end

      def included(base)
        base.extend(ClassMethods)
      end
    end

    self.default_queue_name = "mailer"
    self.excluded_environments = [:test]

    module ClassMethods
      def queue
        ::Resque::Mailer.default_queue_name
      end

      def excluded_environment?(name)
        ::Resque::Mailer.excluded_environments && ::Resque::Mailer.excluded_environments.include?(name.to_sym)
      end
    end
  end
end

if defined? Rails.root
  require "resque_mailer/rails3"
else
  require "resque_mailer/rails2"
end
