class IgnoreCommit < Jenkins::Tasks::BuildWrapper
  display_name "Ignore Commits with Phrase"

  attr_accessor :ignore_commit_phrase

  def initialize(attrs)
    @ignore_commit_phrase = attrs['ignore_commit_phrase']
  end

  # Here we test if any of the changes warrant a build
  def setup(build, launcher, listener)
    begin
      changeset = build.native.getChangeSet()
      # XXX: Can there be files in the changeset if it's manually triggered?
      # If so, how do we check for manual trigger?
      if changeset.isEmptySet()
        listener.info "Empty changeset, running build."
        return
      end

      logs = changeset.getLogs()
      latest_commit = logs.get(logs.size - 1)
      comment = latest_commit.getComment()

      if comment.include? ignore_commit_phrase
        listener.info "Build is skipped through commit message."
        listener.info "Commit: #{latest_commit.getCommitId()}"
        listener.info "Message: #{comment}"
        
        build.native.setResult(Java.hudson.model.Result::NOT_BUILT)
        build.halt("Build is skipped by Ignore Commit Plugin.")
      end

    rescue
      listener.error "Encountered exception when scanning for filtered paths: #{$!}"
      listener.error "Allowing build by default."
      return
    end

    listener.error "Encountered exception when looking commit message: #{$!}"
    listener.error "Allowing build by default."
  end
end