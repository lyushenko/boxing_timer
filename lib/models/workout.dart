enum WorkoutPhase { prepare, work, rest }

class WorkoutModel {
  Duration roundLength;
  Duration breakLength;
  Duration preparationLength;
  int numOfRounds;

  WorkoutModel({
    this.roundLength,
    this.breakLength,
    this.preparationLength,
    this.numOfRounds,
  });

  bool isValid() {
    return roundLength.inSeconds > 0 && numOfRounds > 0;
  }

  shouldPrepare() {
    return preparationLength.inSeconds > 0;
  }

  shouldRest() {
    return breakLength.inSeconds > 0;
  }
}
