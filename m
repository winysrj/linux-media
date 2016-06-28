Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36769 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbcF1UMZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 16:12:25 -0400
Received: by mail-qk0-f182.google.com with SMTP id z142so26442850qkb.3
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 13:12:11 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Guillaume_Membr=C3=A9?= <guillaume.ml@gmail.com>
Date: Tue, 28 Jun 2016 22:12:09 +0200
Message-ID: <CAGni1hsq1Cf0dWbzxg-q+VXZ+wgvQqCb2Z9DqL27f6-+ZhU-Jg@mail.gmail.com>
Subject: Tuning problem with Pinnacle PCTV 2000e
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I asked this question on the mythtv mailling but without success :'(
I know that my question may not be appropriate, forgive me if I'm at
the wrong place.

I had a working mythtv 0.27.5 installation with a Pinnacle PCTV 2000e
(dual dvb-t usb card)  and I recently replaced my motherboard. I had
to upgrade the kernel due to compatibility issue with the usb-3 driver
and switch from 3.2.0 to 4.6.0.

Now, I can't record anything, recordings file are empty. I also tried
livetv : just after a fresh start of the bakend, the first channel is
working ok (tuning and playing ok) but when i try to switch to another
one, log fills up with "Ignoring PAT not containing our desired
program...".

In the example below, PID 257, 260, 261, 287, 369 belongs to the
multiplex with the frequency 682000000 Hz. The recording is on the
channel M6 which is on the multiplex with the frequency 738000000. The
PID displayed in log correspond to the previous tuned channel.
According to dvbtune, the reception is good (and SNR is as the same
level as 2 months ago) :
$ dvbtune -c 0 -m -tm 8 -cr AUTO -gi 8 -f 738000000
Using DVB card "DiBcom 7000PC"
tuning DVB-T (in United Kingdom) to 738000000 Hz
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
Event:  Frequency: 738000000
        SymbolRate: 0
        FEC_inner:  3
Bit error rate: 0
Signal strength: 26253
SNR: 228
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
Signal=26254, Verror=0, SNR=224dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=26213, Verror=0, SNR=232dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=26205, Verror=0, SNR=231dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=26206, Verror=0, SNR=229dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=26207, Verror=0, SNR=227dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=26146, Verror=0, SNR=232dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=26092, Verror=0, SNR=236dB, BlockErrors=0, (S|L|C|V|SY|)

If I record directly with tzap + cp, everything is good.

I tried a full rescan while deleting multiplex and channels through
mythtv-setup, I also increase tuning timeout without success.

Here is my setup :
debian jessie updated yesterday
kernel : 4.6.0-0.bpo.1-686-pae
Tuner : usb pinnacle double DVB-T PCTV 2000e, using dvb_usb_dib0700 driver
Mythtv version : 0.27.6

Have you any idea ?
Thanks a lot for your help

Here is a log of a mythtv recording starting but failling :
2016-06-25 21:02:10.909647 C  mythbackend version: fixes/0.27
[v0.27.6-26-g28b7db2-dirty] www.mythtv.org
2016-06-25 21:02:10.909678 C  Qt version: compile: 4.8.6, runtime: 4.8.6
2016-06-25 21:02:10.909687 N  Enabled verbose msgs:  general record channel
2016-06-25 21:02:10.909704 N  Setting Log Level to LOG_INFO
2016-06-25 21:02:10.911076 I  Added logging to the console
2016-06-25 21:02:10.911390 I  Setup Interrupt handler
2016-06-25 21:02:10.911411 I  Setup Terminated handler
2016-06-25 21:02:10.911434 I  Setup Segmentation fault handler
2016-06-25 21:02:10.911452 I  Setup Aborted handler
2016-06-25 21:02:10.911474 I  Setup Bus error handler
2016-06-25 21:02:10.911497 I  Setup Floating point exception handler
2016-06-25 21:02:10.911516 I  Setup Illegal instruction handler
2016-06-25 21:02:10.911541 I  Setup Real-time signal 0 handler
2016-06-25 21:02:10.911563 I  Setup Hangup handler
2016-06-25 21:02:10.911670 N  Using runtime prefix = /usr
2016-06-25 21:02:10.911699 N  Using configuration directory =
/home/mythtv/.mythtv
2016-06-25 21:02:10.911872 I  Assumed character encoding: en_US.UTF-8
2016-06-25 21:02:10.912931 N  Empty LocalHostName.
2016-06-25 21:02:10.912953 I  Using localhost value of popeye
2016-06-25 21:02:10.997799 N  Setting QT default locale to FR_US
2016-06-25 21:02:10.998391 I  Current locale FR_US
2016-06-25 21:02:10.998599 E  No locale defaults file for FR_US, skipping
2016-06-25 21:02:11.044372 I  Current MythTV Schema Version (DBSchemaVer): 1317
2016-06-25 21:02:11.050614 I  Loading fr translation for module mythfrontend
2016-06-25 21:02:11.068623 N  MythBackend: Starting up as the master server.
2016-06-25 21:02:11.114050 I  TVRec[1]:
SetRecordingStatus(Inconnu->Inconnu) on line 157
2016-06-25 21:02:11.115839 I  TVRec[1]: GetStartChannel(1, 'DVBInput')
2016-06-25 21:02:11.123796 I  TVRec[1]: Start channel: 2.
2016-06-25 21:02:11.123912 I  TVRec[1]: CreateChannel(2)
2016-06-25 21:02:11.146557 I  Added logging to mythlogserver at TCP:35327
2016-06-25 21:02:11.201562 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Opening DVB channel
2016-06-25 21:02:11.252759 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Using DVB card /dev/dvb/adapter0/frontend0, with frontend 'DiBcom
7000PC'.
2016-06-25 21:02:11.272954 I  ChannelBase[1]: Input #10: 'DVBInput'
schan(2) sourceid(1) ccid(1)
2016-06-25 21:02:11.273000 I  ChannelBase[1]: Current Input #10: 'DVBInput'
2016-06-25 21:02:11.274438 I  DTVChan[1](/dev/dvb/adapter0/frontend0):
SetChannelByString(2):
2016-06-25 21:02:11.285889 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:11.286046 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Old Params: 0 auto a auto auto a a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
            DVBChan[1](/dev/dvb/adapter0/frontend0): New Params:
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:11.286089 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Tune(): Tuning to 682000000Hz
2016-06-25 21:02:12.799780 I  DVBChan: wait_for_backend: Status:
Signal,Carrier,FEC Stable,Sync,Lock,
2016-06-25 21:02:12.799878 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Tune(): Frequency tuning successful.
2016-06-25 21:02:12.799931 I  DTVChan[1](/dev/dvb/adapter0/frontend0):
SetChannelByString(2): success
2016-06-25 21:02:12.800018 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Closing DVB channel
2016-06-25 21:02:12.858142 I  TVRec[1]: SetFlags(RunMainLoop,) -> RunMainLoop,
2016-06-25 21:02:12.858353 I  TVRec[1]:
ClearFlags(ExitPlayer,FinishRecording,) -> RunMainLoop,
2016-06-25 21:02:12.873659 I  TVRec[2]:
SetRecordingStatus(Inconnu->Inconnu) on line 157
2016-06-25 21:02:12.876141 I  TVRec[2]: GetStartChannel(2, 'DVBInput')
2016-06-25 21:02:12.878056 I  TVRec[2]: Start channel: 2.
2016-06-25 21:02:12.878385 I  TVRec[2]: CreateChannel(2)
2016-06-25 21:02:12.902742 I  DVBChan[2](/dev/dvb/adapter0/frontend0):
Opening DVB channel
2016-06-25 21:02:12.902831 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Opening DVB channel
2016-06-25 21:02:12.950894 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Using DVB card /dev/dvb/adapter0/frontend0, with frontend 'DiBcom
7000PC'.
2016-06-25 21:02:12.969876 I  ChannelBase[1]: Input #10: 'DVBInput'
schan(2) sourceid(1) ccid(1)
2016-06-25 21:02:12.969923 I  ChannelBase[1]: Current Input #10: 'DVBInput'
2016-06-25 21:02:12.989094 I  ChannelBase[2]: Input #12: 'DVBInput'
schan(2) sourceid(1) ccid(2)
2016-06-25 21:02:12.989148 I  ChannelBase[2]: Current Input #12: 'DVBInput'
2016-06-25 21:02:12.992158 I  DTVChan[2](/dev/dvb/adapter0/frontend0):
SetChannelByString(2):
2016-06-25 21:02:13.008004 I  DVBChan[2](/dev/dvb/adapter0/frontend0):
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:13.008069 I  DVBChan[2](/dev/dvb/adapter0/frontend0):
tuning on slave channel
2016-06-25 21:02:13.008266 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Old Params: 682000000 auto a auto auto 8 a auto a v fec: auto msys:
UNDEFINED rolloff: 0.35
            DVBChan[1](/dev/dvb/adapter0/frontend0): New Params:
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:13.008326 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Tune(): Tuning to 682000000Hz
2016-06-25 21:02:14.522747 I  DVBChan: wait_for_backend: Status:
Signal,Carrier,FEC Stable,Sync,Lock,
2016-06-25 21:02:14.522838 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Tune(): Frequency tuning successful.
2016-06-25 21:02:14.522900 I  DTVChan[2](/dev/dvb/adapter0/frontend0):
SetChannelByString(2): success
2016-06-25 21:02:14.522976 I  DVBChan[2](/dev/dvb/adapter0/frontend0):
Closing DVB channel
2016-06-25 21:02:14.523053 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Closing DVB channel
2016-06-25 21:02:14.524296 I  TVRec[2]: SetFlags(RunMainLoop,) -> RunMainLoop,
2016-06-25 21:02:14.524416 I  TVRec[2]:
ClearFlags(ExitPlayer,FinishRecording,) -> RunMainLoop,
2016-06-25 21:02:14.528144 I  TVRec[3]:
SetRecordingStatus(Inconnu->Inconnu) on line 157
2016-06-25 21:02:14.531811 I  TVRec[3]: GetStartChannel(3, 'DVBInput')
2016-06-25 21:02:14.534440 I  TVRec[3]: Start channel: 2.
2016-06-25 21:02:14.534690 I  TVRec[3]: CreateChannel(2)
2016-06-25 21:02:14.572505 I  DVBChan[3](/dev/dvb/adapter0/frontend0):
Opening DVB channel
2016-06-25 21:02:14.572587 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Opening DVB channel
2016-06-25 21:02:14.619281 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Using DVB card /dev/dvb/adapter0/frontend0, with frontend 'DiBcom
7000PC'.
2016-06-25 21:02:14.640184 I  ChannelBase[1]: Input #10: 'DVBInput'
schan(2) sourceid(1) ccid(1)
2016-06-25 21:02:14.640254 I  ChannelBase[1]: Current Input #10: 'DVBInput'
2016-06-25 21:02:14.659544 I  ChannelBase[3]: Input #11: 'DVBInput'
schan(2) sourceid(1) ccid(3)
2016-06-25 21:02:14.659603 I  ChannelBase[3]: Current Input #11: 'DVBInput'
2016-06-25 21:02:14.662806 I  DTVChan[3](/dev/dvb/adapter0/frontend0):
SetChannelByString(2):
2016-06-25 21:02:14.682401 I  DVBChan[3](/dev/dvb/adapter0/frontend0):
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:14.682483 I  DVBChan[3](/dev/dvb/adapter0/frontend0):
tuning on slave channel
2016-06-25 21:02:14.682742 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Old Params: 682000000 auto a auto auto 8 a auto a v fec: auto msys:
UNDEFINED rolloff: 0.35
            DVBChan[1](/dev/dvb/adapter0/frontend0): New Params:
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:14.682825 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Tune(): Tuning to 682000000Hz
2016-06-25 21:02:16.197583 I  DVBChan: wait_for_backend: Status:
Signal,Carrier,FEC Stable,Sync,Lock,
2016-06-25 21:02:16.197674 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Tune(): Frequency tuning successful.
2016-06-25 21:02:16.197735 I  DTVChan[3](/dev/dvb/adapter0/frontend0):
SetChannelByString(2): success
2016-06-25 21:02:16.197809 I  DVBChan[3](/dev/dvb/adapter0/frontend0):
Closing DVB channel
2016-06-25 21:02:16.197880 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Closing DVB channel
2016-06-25 21:02:16.199213 I  TVRec[3]: SetFlags(RunMainLoop,) -> RunMainLoop,
2016-06-25 21:02:16.199453 I  TVRec[3]:
ClearFlags(ExitPlayer,FinishRecording,) -> RunMainLoop,
2016-06-25 21:02:16.203123 I  TVRec[4]:
SetRecordingStatus(Inconnu->Inconnu) on line 157
2016-06-25 21:02:16.205742 I  TVRec[4]: GetStartChannel(4, 'DVBInput')
2016-06-25 21:02:16.208269 I  TVRec[4]: Start channel: 2.
2016-06-25 21:02:16.208514 I  TVRec[4]: CreateChannel(2)
2016-06-25 21:02:16.245444 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Opening DVB channel
2016-06-25 21:02:16.245538 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Using DVB card /dev/dvb/adapter1/frontend0, with frontend 'DiBcom
7000PC'.
2016-06-25 21:02:16.258685 I  ChannelBase[4]: Input #7: 'DVBInput'
schan(2) sourceid(1) ccid(4)
2016-06-25 21:02:16.258733 I  ChannelBase[4]: Current Input #7: 'DVBInput'
2016-06-25 21:02:16.260706 I  DTVChan[4](/dev/dvb/adapter1/frontend0):
SetChannelByString(2):
2016-06-25 21:02:16.270811 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:16.270976 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Old Params: 0 auto a auto auto a a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
            DVBChan[4](/dev/dvb/adapter1/frontend0): New Params:
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:16.271024 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Tune(): Tuning to 682000000Hz
2016-06-25 21:02:17.785505 I  DVBChan: wait_for_backend: Status:
Signal,Carrier,FEC Stable,Sync,Lock,
2016-06-25 21:02:17.785599 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Tune(): Frequency tuning successful.
2016-06-25 21:02:17.785651 I  DTVChan[4](/dev/dvb/adapter1/frontend0):
SetChannelByString(2): success
2016-06-25 21:02:17.785727 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Closing DVB channel
2016-06-25 21:02:17.787123 I  TVRec[4]: SetFlags(RunMainLoop,) -> RunMainLoop,
2016-06-25 21:02:17.787240 I  TVRec[4]:
ClearFlags(ExitPlayer,FinishRecording,) -> RunMainLoop,
2016-06-25 21:02:17.804087 I  TVRec[5]:
SetRecordingStatus(Inconnu->Inconnu) on line 157
2016-06-25 21:02:17.806705 I  TVRec[5]: GetStartChannel(5, 'DVBInput')
2016-06-25 21:02:17.808959 I  TVRec[5]: Start channel: 2.
2016-06-25 21:02:17.809216 I  TVRec[5]: CreateChannel(2)
2016-06-25 21:02:17.837669 I  DVBChan[5](/dev/dvb/adapter1/frontend0):
Opening DVB channel
2016-06-25 21:02:17.837754 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Opening DVB channel
2016-06-25 21:02:17.886997 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Using DVB card /dev/dvb/adapter1/frontend0, with frontend 'DiBcom
7000PC'.
2016-06-25 21:02:17.906975 I  ChannelBase[4]: Input #7: 'DVBInput'
schan(2) sourceid(1) ccid(4)
2016-06-25 21:02:17.907025 I  ChannelBase[4]: Current Input #7: 'DVBInput'
2016-06-25 21:02:17.920038 I  ChannelBase[5]: Input #8: 'DVBInput'
schan(2) sourceid(1) ccid(5)
2016-06-25 21:02:17.920113 I  ChannelBase[5]: Current Input #8: 'DVBInput'
2016-06-25 21:02:17.921962 I  DTVChan[5](/dev/dvb/adapter1/frontend0):
SetChannelByString(2):
2016-06-25 21:02:17.930279 I  DVBChan[5](/dev/dvb/adapter1/frontend0):
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:17.930323 I  DVBChan[5](/dev/dvb/adapter1/frontend0):
tuning on slave channel
2016-06-25 21:02:17.930458 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Old Params: 682000000 auto a auto auto 8 a auto a v fec: auto msys:
UNDEFINED rolloff: 0.35
            DVBChan[4](/dev/dvb/adapter1/frontend0): New Params:
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:17.930499 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Tune(): Tuning to 682000000Hz
2016-06-25 21:02:19.444361 I  DVBChan: wait_for_backend: Status:
Signal,Carrier,FEC Stable,Sync,Lock,
2016-06-25 21:02:19.444452 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Tune(): Frequency tuning successful.
2016-06-25 21:02:19.444513 I  DTVChan[5](/dev/dvb/adapter1/frontend0):
SetChannelByString(2): success
2016-06-25 21:02:19.444593 I  DVBChan[5](/dev/dvb/adapter1/frontend0):
Closing DVB channel
2016-06-25 21:02:19.444667 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Closing DVB channel
2016-06-25 21:02:19.445864 I  TVRec[5]: SetFlags(RunMainLoop,) -> RunMainLoop,
2016-06-25 21:02:19.445960 I  TVRec[5]:
ClearFlags(ExitPlayer,FinishRecording,) -> RunMainLoop,
2016-06-25 21:02:19.449582 I  TVRec[6]:
SetRecordingStatus(Inconnu->Inconnu) on line 157
2016-06-25 21:02:19.452340 I  TVRec[6]: GetStartChannel(6, 'DVBInput')
2016-06-25 21:02:19.455025 I  TVRec[6]: Start channel: 2.
2016-06-25 21:02:19.455294 I  TVRec[6]: CreateChannel(2)
2016-06-25 21:02:19.493607 I  DVBChan[6](/dev/dvb/adapter1/frontend0):
Opening DVB channel
2016-06-25 21:02:19.493695 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Opening DVB channel
2016-06-25 21:02:19.542406 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Using DVB card /dev/dvb/adapter1/frontend0, with frontend 'DiBcom
7000PC'.
2016-06-25 21:02:19.564642 I  ChannelBase[4]: Input #7: 'DVBInput'
schan(2) sourceid(1) ccid(4)
2016-06-25 21:02:19.564706 I  ChannelBase[4]: Current Input #7: 'DVBInput'
2016-06-25 21:02:19.578506 I  ChannelBase[6]: Input #9: 'DVBInput'
schan(2) sourceid(1) ccid(6)
2016-06-25 21:02:19.578559 I  ChannelBase[6]: Current Input #9: 'DVBInput'
2016-06-25 21:02:19.580153 I  DTVChan[6](/dev/dvb/adapter1/frontend0):
SetChannelByString(2):
2016-06-25 21:02:19.587047 I  DVBChan[6](/dev/dvb/adapter1/frontend0):
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:19.587088 I  DVBChan[6](/dev/dvb/adapter1/frontend0):
tuning on slave channel
2016-06-25 21:02:19.587197 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Old Params: 682000000 auto a auto auto 8 a auto a v fec: auto msys:
UNDEFINED rolloff: 0.35
            DVBChan[4](/dev/dvb/adapter1/frontend0): New Params:
682000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:19.587228 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Tune(): Tuning to 682000000Hz
2016-06-25 21:02:21.101480 I  DVBChan: wait_for_backend: Status:
Signal,Carrier,FEC Stable,Sync,Lock,
2016-06-25 21:02:21.101564 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Tune(): Frequency tuning successful.
2016-06-25 21:02:21.101620 I  DTVChan[6](/dev/dvb/adapter1/frontend0):
SetChannelByString(2): success
2016-06-25 21:02:21.101692 I  DVBChan[6](/dev/dvb/adapter1/frontend0):
Closing DVB channel
2016-06-25 21:02:21.101762 I  DVBChan[4](/dev/dvb/adapter1/frontend0):
Closing DVB channel
2016-06-25 21:02:21.102916 I  TVRec[6]: SetFlags(RunMainLoop,) -> RunMainLoop,
2016-06-25 21:02:21.103033 I  TVRec[6]:
ClearFlags(ExitPlayer,FinishRecording,) -> RunMainLoop,
2016-06-25 21:02:21.156117 I  Found 1 distinct programid authorities
2016-06-25 21:02:21.156600 I  New static DB connectionSchedCon
2016-06-25 21:02:21.156639 I  Registering HouseKeeperTask 'LogClean'.
2016-06-25 21:02:21.156854 I  Registering HouseKeeperTask 'DBCleanup'.
2016-06-25 21:02:21.157081 I  Registering HouseKeeperTask
'ThemeUpdateNotifications'.
2016-06-25 21:02:21.157155 I  Registering HouseKeeperTask
'RecordedArtworkUpdate'.
2016-06-25 21:02:21.164747 I  Registering HouseKeeperTask 'MythFillDB'.
2016-06-25 21:02:21.164971 I  Registering HouseKeeperTask 'JobQueueRecover'.
2016-06-25 21:02:21.165007 I  Registering HouseKeeperTask 'HardwareProfiler'.
2016-06-25 21:02:21.172215 I  Starting HouseKeeper.
2016-06-25 21:02:21.177922 I  Listening on TCP 127.0.0.1:6544
2016-06-25 21:02:21.178018 I  Listening on TCP 10.0.0.1:6544
2016-06-25 21:02:21.191917 N  *** The UPNP service has been DISABLED
with the --noupnp option ***
2016-06-25 21:02:21.191968 I  Main::Registering HttpStatus Extension
2016-06-25 21:02:21.201920 W  Unable to find IPv6 address to bind
2016-06-25 21:02:21.202494 I  Listening on TCP 127.0.0.1:6543
2016-06-25 21:02:21.202829 I  Listening on TCP 10.0.0.1:6543
2016-06-25 21:02:21.213768 N  AutoExpire: CalcParams(): Max required
Free Space: 2.0 GB w/freq: 15 min
2016-06-25 21:02:24.210041 I  Reschedule requested for MATCH 0 0 0 -
SchedulerInit
2016-06-25 21:02:24.447952 I  MainServer::ANN Playback
2016-06-25 21:02:24.448016 I  adding: MBP-de-gme.home as a client (events: 0)
2016-06-25 21:02:24.455484 I  MainServer::ANN Monitor
2016-06-25 21:02:24.455542 I  adding: MBP-de-gme.home as a client (events: 1)
2016-06-25 21:02:24.806709 I  Scheduled 74 items in 0.5 = 0.22 match +
0.12 check + 0.15 place
2016-06-25 21:02:24.842232 I  Scheduler: Seem to be woken up by USER
2016-06-25 21:02:48.974974 I  Reschedule requested for PLACE Reactivate
2016-06-25 21:02:49.157405 I  Scheduled 74 items in 0.1 = 0.00 match +
0.00 check + 0.12 place
2016-06-25 21:02:49.160748 I  CardUtil:   Group ID 5
2016-06-25 21:02:49.161263 I  CardUtil:   Card ID 2
2016-06-25 21:02:49.161277 I  CardUtil:   Card ID 3
2016-06-25 21:02:49.162458 I  TVRec[1]: RecordPending on inputid 10
2016-06-25 21:02:49.163260 I  CardUtil:   Group ID 5
2016-06-25 21:02:49.163856 I  CardUtil:   Card ID 2
2016-06-25 21:02:49.163870 I  CardUtil:   Card ID 3
2016-06-25 21:02:49.163895 I  TVRec[2]: RecordPending on inputid 10
2016-06-25 21:02:49.163923 I  TVRec[3]: RecordPending on inputid 10
2016-06-25 21:02:49.164008 I  TVRec[1]: StartRecording("Football
(Croatie / Portugal)")
2016-06-25 21:02:49.164062 I  TVRec[1]:
SetRecordingStatus(Inconnu->Interrompu) on line 422
2016-06-25 21:02:49.164644 I  TVRec[1]: Checking input group recorders - begin
2016-06-25 21:02:49.164775 I  TVRec[1]: Checking input group recorders - done
2016-06-25 21:02:49.211972 I  TVRec[3]: ASK_RECORDING 3 0 0 0
2016-06-25 21:02:49.278959 I  TVRec[1]:
StartedRecording(1056_2016-06-25T19:03:00Z)
fn(/mnt/media/enregistrements/1056_20160625190300.mpg)
2016-06-25 21:02:49.284967 I  Using profile 'Default' to record
2016-06-25 21:02:49.287212 I  TVRec[1]:
ClearFlags(CancelNextRecording,) -> RunMainLoop,
2016-06-25 21:02:49.288712 I  TVRec[1]:
SetRecordingStatus(Interrompu->Syntonisation) on line 608
2016-06-25 21:02:49.289364 I  TVRec[1]: Changing from None to RecordingOnly
2016-06-25 21:02:49.289402 I  TVRec[1]:
ClearFlags(FrontendReady,CancelNextRecording,) -> RunMainLoop,
2016-06-25 21:02:49.289599 I  TVRec[1]: HandleTuning Request:
Program(ProgramInfo(1056_20160625190300.mpg): channame(M6) startts(Sat
Jun 25 19:00:00 2016) endts(Sat Jun 25 20:55:00 2016)
             recstartts(Sat Jun 25 19:03:00 2016) recendts(Sat Jun 25
21:12:00 2016)
             title(Football (Croatie / Portugal))) channel() input()
flags(Recording,)
2016-06-25 21:02:49.296493 I  TVRec[1]: HW Tuner: 1->1
2016-06-25 21:02:49.296552 I  TVRec[1]: ClearFlags(PENDINGACTIONS,) ->
RunMainLoop,
2016-06-25 21:02:49.296613 I  TVRec[1]: No recorder yet, calling TuningFrequency
2016-06-25 21:02:49.298514 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Opening DVB channel
2016-06-25 21:02:49.321438 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Using DVB card /dev/dvb/adapter0/frontend0, with frontend 'DiBcom
7000PC'.
2016-06-25 21:02:49.352203 I  ChannelBase[1]: Input #10: 'DVBInput'
schan(2) sourceid(1) ccid(1)
2016-06-25 21:02:49.352230 I  ChannelBase[1]: Current Input #10: 'DVBInput'
2016-06-25 21:02:49.352339 I  DTVChan[1](/dev/dvb/adapter0/frontend0):
SetChannelByString(6):
2016-06-25 21:02:49.366284 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
738000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:49.366388 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Old Params: 682000000 auto a auto auto 8 a auto a v fec: auto msys:
UNDEFINED rolloff: 0.35
            DVBChan[1](/dev/dvb/adapter0/frontend0): New Params:
738000000 auto a auto auto 8 a auto a v fec: auto msys: UNDEFINED
rolloff: 0.35
2016-06-25 21:02:49.366414 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Tune(): Tuning to 738000000Hz
2016-06-25 21:02:49.538457 I  TVRec[2]: ASK_RECORDING 2 0 0 0
2016-06-25 21:02:50.881205 I  DVBChan: wait_for_backend: Status:
Signal,Carrier,FEC Stable,Sync,Lock,
2016-06-25 21:02:50.881295 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Tune(): Frequency tuning successful.
2016-06-25 21:02:50.881348 I  DTVChan[1](/dev/dvb/adapter0/frontend0):
SetChannelByString(6): success
2016-06-25 21:02:50.881418 I  TVRec[1]: Starting Signal Monitor
2016-06-25 21:02:50.881501 I  TVRec[1]: SetupSignalMonitor(1, 0)
2016-06-25 21:02:50.881684 I  DVBChan[1](/dev/dvb/adapter0/frontend0):
Opening DVB channel
2016-06-25 21:02:50.887508 I
DVBSigMon[1](/dev/dvb/adapter0/frontend0): Can measure Signal Strength
2016-06-25 21:02:50.891442 I
DVBSigMon[1](/dev/dvb/adapter0/frontend0): Can measure S/N
2016-06-25 21:02:50.895008 I
DVBSigMon[1](/dev/dvb/adapter0/frontend0): Can measure Bit Error Rate
2016-06-25 21:02:50.897134 I
DVBSigMon[1](/dev/dvb/adapter0/frontend0): Can count Uncorrected
Blocks
2016-06-25 21:02:50.897255 I
DVBSigMon[1](/dev/dvb/adapter0/frontend0): DVBSignalMonitor::ctor
initial flags Seen() Match() Wait(Sig,SNR,BER,UB,)
2016-06-25 21:02:50.897491 I  TVRec[1]: Signal monitor successfully created
2016-06-25 21:02:50.897566 I  TVRec[1]: Setting up table monitoring.
2016-06-25 21:02:50.917159 I  Using profile 'Live TV' to record
2016-06-25 21:02:50.917329 I  TVRec[1]: MPEG program number: 1025
2016-06-25 21:02:50.917460 I
DTVSigMon[1](/dev/dvb/adapter0/frontend0)::SetProgramNumber(1025):
2016-06-25 21:02:50.917597 I  MPEGStream[1](0x4b22ae30): SetDesiredProgram(1025)
2016-06-25 21:02:50.917719 I  TVRec[1]: Successfully set up MPEG table
monitoring.
2016-06-25 21:02:50.919085 I  TVRec[1]:
SetFlags(SignalMonitorRunning,) -> RunMainLoop,SignalMonitorRunning,
2016-06-25 21:02:50.919185 I  TVRec[1]: ClearFlags(WaitingForSignal,)
-> RunMainLoop,SignalMonitorRunning,
2016-06-25 21:02:50.919261 I  TVRec[1]: SetFlags(WaitingForSignal,) ->
RunMainLoop,WaitingForSignal,SignalMonitorRunning,
2016-06-25 21:02:50.919482 I  TVRec[1]:
ClearFlags(NeedToStartRecorder,) ->
RunMainLoop,WaitingForSignal,SignalMonitorRunning,
2016-06-25 21:02:50.919563 I  TVRec[1]: SetFlags(NeedToStartRecorder,)
-> RunMainLoop,WaitingForSignal,NeedToStartRecorder,SignalMonitorRunning,
2016-06-25 21:02:50.919788 I  TVRec[1]: TuningSignalCheck: Still
waiting.  Will timeout @ 23:12:00.000
2016-06-25 21:02:50.931640 I
DVBSigMon[1](/dev/dvb/adapter0/frontend0): UpdateValues -- Signal
Locked
2016-06-25 21:02:50.931741 I  SH(/dev/dvb/adapter0/frontend0):
AddListener(0x4b22ae30) -- begin
2016-06-25 21:02:50.931796 I  SH(/dev/dvb/adapter0/frontend0):
AddListener(0x4b22ae30) -- locked
2016-06-25 21:02:50.932801 I  DVBSH(/dev/dvb/adapter0/frontend0): run(): begin
2016-06-25 21:02:50.933707 I  PIDInfo(/dev/dvb/adapter0/frontend0):
Opening filter for pid 0x0
2016-06-25 21:02:50.937139 I  PIDInfo(/dev/dvb/adapter0/frontend0):
Closing filter for pid 0x0
2016-06-25 21:02:50.939363 N  AutoExpire: CalcParams(): Max required
Free Space: 4.0 GB w/freq: 14 min
2016-06-25 21:02:50.943037 I  Tuning recording: "Football (Croatie /
Portugal)": channel 1056 on cardid 1, sourceid 1
2016-06-25 21:02:50.945783 I  DVBSH(/dev/dvb/adapter0/frontend0): RunTS(): begin
2016-06-25 21:02:50.945882 I  PIDInfo(/dev/dvb/adapter0/frontend0):
Opening filter for pid 0x0
2016-06-25 21:02:50.949824 I  PIDInfo(/dev/dvb/adapter0/frontend0):
Opening filter for pid 0x1
2016-06-25 21:02:50.984746 E
DTVSigMon[1](/dev/dvb/adapter0/frontend0): Program #1025 not found in
PAT!
Program Association Section
 PSIP tableID(0x0) length(33) extension(0x1)
      version(3) current(1) section(0) last_section(0)
      tsid(1) programCount(6)
  program number     0 has PID 0x0010
  program number   257 has PID 0x006e
  program number   260 has PID 0x0136
  program number   261 has PID 0x01fe
  program number   287 has PID 0x00d2
  program number   369 has PID 0x02c6

2016-06-25 21:02:50.984842 W  MPEGStream[1](0x4b22ae30): ProcessPAT:
PAT is missing program, setting timeout
2016-06-25 21:02:51.032427 I  SH(/dev/dvb/adapter0/frontend0):
AddListener(0x4b22ae30) -- end
2016-06-25 21:02:51.389086 E  MPEGStream[1](0x4b22ae30): ProcessPAT:
Program not found in PAT. Rescan your transports.
2016-06-25 21:02:51.389170 I  MPEGStream[1](0x4b22ae30):
CreatePATSingleProgram()
2016-06-25 21:02:51.389228 I  MPEGStream[1](0x4b22ae30): PAT in input stream
2016-06-25 21:02:51.389496 I  MPEGStream[1](0x4b22ae30): Program
Association Section
 PSIP tableID(0x0) length(33) extension(0x1)
      version(3) current(1) section(0) last_section(0)
      tsid(1) programCount(6)
  program number     0 has PID 0x0010
  program number   257 has PID 0x006e
  program number   260 has PID 0x0136
  program number   261 has PID 0x01fe
  program number   287 has PID 0x00d2
  program number   369 has PID 0x02c6

2016-06-25 21:02:51.389570 I  MPEGStream[1](0x4b22ae30):
desired_program(1025) pid(0x0)
2016-06-25 21:02:51.389636 E  MPEGStream[1](0x4b22ae30): Desired
program #1025 not found in PAT.
            Cannot create single program PAT.
2016-06-25 21:02:55.922151 I  TVRec[1]: TuningSignalCheck: Still
waiting.  Will timeout @ 23:12:00.000
2016-06-25 21:03:01.925265 I  TVRec[1]: TuningSignalCheck: Still
waiting.  Will timeout @ 23:12:00.000
2016-06-25 21:03:07.928496 I  TVRec[1]: TuningSignalCheck: Still
waiting.  Will timeout @ 23:12:00.000
