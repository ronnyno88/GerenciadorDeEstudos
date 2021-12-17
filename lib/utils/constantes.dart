import 'package:flutter/material.dart';
import 'package:pomodoro/model/pomodoro-status.dart';

const pomodoroTotalTime = 5;
const shotBreakTime = 3;
const longBreakTime = 6;
const pomodoroPerSet = 4;
String description = '';

const Map<PomodoroStatus, String> statusDescription = {
  PomodoroStatus.runningPomodoro: 'Ativo, mantenha o foco na atividade',
  PomodoroStatus.pausedPomodoro: 'Pausado, retorne para sua atividade',
  PomodoroStatus.runningShortBreak: 'Parada rápida para descanso',
  PomodoroStatus.pausedShortBreak: 'Pausado, retorne para sua atividade',
  PomodoroStatus.runningLongBreak:
      'Parada Longa, aproveite o tempo para descansar',
  PomodoroStatus.pausedLongBreak: 'Pausado, retorne para sua atividade',
  PomodoroStatus.setFinished: 'Parabéns, agora é hora de recomeçar',
};

const Map<PomodoroStatus, MaterialColor> statusColor = {
  PomodoroStatus.runningPomodoro: Colors.green,
  PomodoroStatus.pausedPomodoro: Colors.orange,
  PomodoroStatus.runningShortBreak: Colors.red,
  PomodoroStatus.pausedShortBreak: Colors.orange,
  PomodoroStatus.runningLongBreak: Colors.red,
  PomodoroStatus.pausedLongBreak: Colors.orange,
  PomodoroStatus.setFinished: Colors.orange,
};
