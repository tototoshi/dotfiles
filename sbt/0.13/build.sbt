net.virtualvoid.sbt.graph.Plugin.graphSettings

shellPrompt := { state =>
  messageOnBuildFilesChanged(state) + GitCommand.prompt(state)
}
