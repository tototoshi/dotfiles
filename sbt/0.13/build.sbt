shellPrompt := { state =>
  messageOnBuildFilesChanged(state) + GitCommand.prompt(state)
}
