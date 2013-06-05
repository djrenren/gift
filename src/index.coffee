{exec} = require 'child_process'
Repo   = require './repo'
cmd    = require './git'

# Public: Create a Repo from the given path.
# 
# Returns Repo.
module.exports = Git = (path, bare=false) ->
  return new Repo path, bare


# Public: Initialize a git repository.
# 
# path     - The directory to run `git init .` in.
# callback - Receives `(err, repo)`.
# 
Git.init = (path, callback) ->
  exec "git init .", {cwd: path}
  , (err, stdout, stderr) ->
    return callback err if err
    return callback err, (new Repo path)

Git.clone = (path, url, ssh, callback) ->
  bash = "git clone #{url} #{path}"
  if ssh
    bash = "ssh-agent bash -c 'ssh-add #{ssh}; #{bash}'"
  exec bash,{}, (err, stdout, stderr) ->
    return callback err if err
    repo = new Repo path
    repo.add_ssh_key ssh
    return callback err, repo

