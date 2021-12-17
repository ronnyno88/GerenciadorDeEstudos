import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pomodoro/model/pomodoro-status.dart';
import 'package:pomodoro/utils/constantes.dart';
import 'package:pomodoro/widget/custon-button.dart';
import 'package:pomodoro/widget/progress_icons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

const _buttonTextStart = 'START';
const _buttonTextResumePomodoro = 'RESUME POMODORO';
const _buttonTextResumeBreak = 'RESUME BREAK';
const _buttonStartShortBreak = 'START SHORT BREAK';
const _buttonStartLongBreak = 'START LONG BREAK';
const _buttonStartNewSet = 'START NEW SET';
const _buttonTextPause = 'PAUSE';
const _buttonTextReset = 'RESET';

class _HomeState extends State<Home> {
  static AudioCache player = AudioCache();
  int remainingTime = pomodoroTotalTime;
  String mainButtonText = _buttonTextStart;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer _time = Timer(Duration(seconds: 1), () {});
  int pomodoroNum = 0;
  int setNum = 0;
  @override
  void dispose() {
    _cancelTime();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    player.load('bell.wav');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Disciplinas: $pomodoroNum',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              Text(
                'Inserir Número: $setNum',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 220.0,
                      lineWidth: 15.0,
                      percent: _getPomodoropercentage(),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        _secondToFormatedString(remainingTime),
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      progressColor: statusColor[pomodoroStatus],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ProgressIcons(
                      total: pomodoroPerSet,
                      done: pomodoroNum - (setNum * pomodoroPerSet),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      statusDescription[pomodoroStatus] as String,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustonButton(
                      onTap: _mainButtonPressed,
                      text: mainButtonText,
                    ),
                    CustonButton(
                      onTap: _resetButtonPressed,
                      text: _buttonTextReset,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _secondToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;

    if (remainingSeconds < 10) {
      remainingSecondsFormated = '0$remainingSeconds';
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }
    return '$roundedMinutes:$remainingSecondsFormated';
  }

  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runningPomodoro;
    _cancelTime();

    _time = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                    mainButtonText = _buttonTextPause;
                  })
                }
              else
                {
                  _playSound(),
                  pomodoroNum++,
                  _cancelTime(),
                  if (pomodoroNum % pomodoroPerSet == 0)
                    {
                      pomodoroStatus = PomodoroStatus.pausedLongBreak,
                      setState(() {
                        remainingTime = longBreakTime;
                        mainButtonText = _buttonStartLongBreak;
                      }),
                    }
                  else
                    {
                      pomodoroStatus = PomodoroStatus.pausedShortBreak,
                      setState(() {
                        remainingTime = shotBreakTime;
                        mainButtonText = _buttonStartLongBreak;
                      })
                    }
                }
            });
  }

  _cancelTime() {
    if (_time != null) {
      _time.cancel();
    } else {}
  }

//
  _mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runningPomodoro:
        _pausePomodoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreak();
        break;
      case PomodoroStatus.setFinished:
        setNum++;
        _startPomodoroCountdown();
        break;
    }
  }

  _getPomodoropercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.runningPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shotBreakTime;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shotBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTotalTime;
        break;
    }

    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  _pausePomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTime();
    setState(() {
      mainButtonText = _buttonTextResumePomodoro;
    });
  }

  _resetButtonPressed() {
    pomodoroNum = 0;
    setNum = 0;
    _cancelTime();
    _stopCountdown();
  }

  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainButtonText = _buttonTextStart;
      remainingTime = pomodoroTotalTime;
    });
  }

  _pauseShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pauseBreakCountdown();
  }

  _pauseLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown() {
    _cancelTime();
    setState(() {
      mainButtonText = _buttonTextResumeBreak;
    });
  }

  _startShortBreak() {
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainButtonText = _buttonTextPause;
    });
    _cancelTime();
    _time = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  })
                }
              else
                {
                  _playSound(),
                  remainingTime = pomodoroTotalTime,
                  _cancelTime(),
                  pomodoroStatus = PomodoroStatus.pausedPomodoro,
                  setState(() {
                    mainButtonText = _buttonTextStart;
                  })
                }
            });
  }

  _startLongBreak() {
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainButtonText = _buttonTextPause;
    });
    _cancelTime();
    _time = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  })
                }
              else
                {
                  _playSound(),
                  remainingTime = pomodoroTotalTime,
                  _cancelTime(),
                  pomodoroStatus = PomodoroStatus.setFinished,
                  setState(() {
                    mainButtonText = _buttonStartNewSet;
                  })
                }
            });
  }

  _playSound() {
    player.play('beep.mp3');
  }
}
