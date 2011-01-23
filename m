Return-path: <mchehab@pedra>
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:60155 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1AWUzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 15:55:53 -0500
Date: Sun, 23 Jan 2011 20:55:50 +0000 (GMT)
From: Alex Butcher <linuxtv@assursys.co.uk>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
cc: linux-media@vger.kernel.org
Subject: Re: Hauppauge Nova-T-500; losing one tuner. Regression?
In-Reply-To: <AANLkTimtKKJkA35tn=wv+sONgWaUxjFcAQWfLfYzSOLW@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101232038420.26778@sbhezbfg.of5.nffheflf.cev>
References: <alpine.LFD.2.00.1101231119320.26778@sbhezbfg.of5.nffheflf.cev> <AANLkTimtKKJkA35tn=wv+sONgWaUxjFcAQWfLfYzSOLW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-577977028-1295816150=:26778"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-577977028-1295816150=:26778
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Devin -

[A confession; after my last post, I double-checked my MythTV config, and I
found that I had EIT scanning enabled on one of the tuners on the
Nova-T-500. This was the same configuration that used to work, so it
shouldn't have made any difference, but I've disabled EIT on both of the
Nova-T-500's tuners and enabled it on the Nova-T instead. I've also tried
setting the Nova-T-500 tuners to 'on demand' as
<http://forum.linuxmce.org/index.php?topic=5593.5;wap2> suggests it was part
of someone else's working config. We'll see if that helps any!]

On Sun, 23 Jan 2011, Devin Heitmueller wrote:

>> As a refresher, the drivers in the 2.6.26.6-49 kernel didn't yet include
>> support for the new I2C functions only supported by dib0700 firmware
>> revisions >= 1.20.  I don't think this is relevant to the Nova-T-500,
>> though, as only s5h1411_frontend_attach() and lgdt3305_frontend_attach() set
>> fw_use_new_i2c_api to 1.
>
> There were general fixes to the i2c in the 1.20 firmware which you get
> the benefits of regardless of using the new API.  The new API is
> required though for devices that perform i2c writes without a
> corresponding read (e.g. the s5h1411 and lgdt3305).  In fact, most
> Nova-T 500 users noted a significant improvement in the general
> reliability of the mt2060 i2c after upgrading to 1.20 (with the
> exception of the "warm boot problem").

Yup, that ties in with my experience, as I started using the Nova-T-500
before the 1.20 firmware was available. When I upgraded my old MythTV box to
using the 1.20 firmware reliability did seem to improve (i.e. from
usually-OK, to perfect).

I was thinking of hacking dib0700_core.c to add a parameter to force use of
the old I2C API regardless of firmware version, but then I spotted that it'd
have no effect on the Nova-T-500 with it's "Bristol" frontend.

[...]

>> 3) Load the dvb-usb-dib0700 module with force_lna_activation=1 to have the
>> LNA permanently enabled.
>
> People have mixed results with the LNA, largely dependent on their
> signal quality in general, as would be expected.  I believe most
> people who have had to force it's activation have general signal
> quality issues which have nothing to do with the mt2060 i2c issue.

It was stable and reliable for years with the LNA forced active, so I'd
expect it to be the same now. I could switch it back to Auto if you think
that might improve, rather than deteriorate things!

>> 5) Use the 1.20 firmware (MD5: f42f86e2971fd994003186a055813237) file and
>> ensure it's being properly loaded.
>
> That is the correct firmware,  It's bundled by default in Ubuntu now,
> and I thought Fedora was too (since I submitted it to the
> linux-firmware package).

Fedora does ship the 1.20 firmware as default (and *only* the 1.20
firmware).

>> I've also tried the 1.10 firmware (MD5:
>> 5878ebfcba2d8deb90b9120eb89b02da) with no apparent improvement.
>
> Well, *this* is very strange.  It suggests your problem has nothing to
> do with the new firmware at all.  Have you tried blowing the dust out
> the PCI slots and making sure the PCI connectors are clean?

They should be as it's a brand new machine built from new parts and only
online for about two weeks so far! As I said, the second tuner on the
Nova-T-500 can be working at the same time as one apparently isn't, so that
suggests things are OK on the PCI side of things.

>> 6) Ensure that the machine is cold-booted (thereby forcing a firmware load
>> onto the Nova-T-500) every time due to reports of warm boots being
>> problematic.
>
> Correct:  This is the one known issue with the 1.20 firmware,
> specifically on the Nova-T 500.  It has to do with the power routing
> on that board compared to all other dib0700 based designs.

*shoots self in head*

I for one would pay more for hardware which Just Flippin' Worked. :-]

>> 7) Disable EIT scanning by MythTV on both of the two Nova-T-500 tuners. Only
>> leave it enabled on the Nova-T card.
>
> This is a good idea.  I've heard mixed results from users where this
> has an effect, although I've never seen it personally.

See above. Oops.

>> Can anyone offer any tips for regaining reliability? Failing that, is there
>> any further logging I can enable, and entries to look out for?
>
> Exactly what errors are you seeing? I2c write errors in dmesg?

No, nothing in the kernel logs, which is what I would expect if the hardware
was crashing in some way.  Maybe it /was/ just that MythTV was using a tuner
for EIT and so it couldn't stop the EIT scan to use it for a recording after
all.

> Perhaps you should post some actual log output showing the failure
> rather than the vague characterization of "one of the tuners on the
> Nova-T-500 ceasing to respond randomly many hours after boot"

The only thing I have is from the mythbackend log. For a working recording:

2011-01-22 20:55:01.402 TVRec(1): StartRecording("Journey to the Edge of the
Universe")
2011-01-22 20:55:01.410 TVRec(1): Checking input group recorders - begin
2011-01-22 20:55:01.419 TVRec(1): Checking input group recorders - done
2011-01-22 20:55:01.458 TVRec(1): StartedRecording(0x7fcfa40c2080)
fn(/srv/myth/video-R1e/recordings/1014_20110122205500.mpg)
2011-01-22 20:55:01.499 TVRec(1): ClearFlags(CancelNextRecording,) ->
RunMainLoop,SignalMonitorRunning,EITScannerRunning,
2011-01-22 20:55:01.531 TVRec(1): ClearFlags(EITScannerRunning,) ->
RunMainLoop,SignalMonitorRunning,
2011-01-22 20:55:01.540 TVRec(1): Changing from None to RecordingOnly
2011-01-22 20:55:01.554 TVRec(1):
ClearFlags(FrontendReady,CancelNextRecording,) ->
RunMainLoop,SignalMonitorRunning,
2011-01-22 20:55:01.563 TVRec(1): HandleTuning Request: Program(yes)
channel() input() flags(Recording,)
2011-01-22 20:55:01.575 TVRec(1): HW Tuner: 1->1
2011-01-22 20:55:01.607 TVRec(1): TeardownSignalMonitor() -- begin
2011-01-22 20:55:01.616 DVBSH(/dev/dvb/adapter1/frontend0):
RemoveListener(0x7fcf6c14a368) -- begin
2011-01-22 20:55:01.624 DVBSH(/dev/dvb/adapter1/frontend0):
RemoveListener(0x7fcf6c14a368) -- locked
2011-01-22 20:55:01.667 DVBSH(/dev/dvb/adapter1/frontend0): RunTS():
shutdown
2011-01-22 20:55:01.674 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x0
2011-01-22 20:55:01.689 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x10
2011-01-22 20:55:01.697 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x11
2011-01-22 20:55:01.706 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x12
2011-01-22 20:55:01.716 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x14
2011-01-22 20:55:01.724 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x12d
2011-01-22 20:55:01.739 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x12e
2011-01-22 20:55:01.746 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x12f
2011-01-22 20:55:01.754 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x130
2011-01-22 20:55:01.766 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0x3eb
2011-01-22 20:55:01.774 PIDInfo(/dev/dvb/adapter1/frontend0): Closing filter
for pid 0xf02
2011-01-22 20:55:01.784 DVBSH(/dev/dvb/adapter1/frontend0): RunTS(): end
2011-01-22 20:55:01.796 DVBSH(/dev/dvb/adapter1/frontend0):
RemoveListener(0x7fcf6c14a368) -- end
2011-01-22 20:55:01.804 TVRec(1): TeardownSignalMonitor() -- end
2011-01-22 20:55:01.816 TVRec(1): ClearFlags(SignalMonitorRunning,) ->
RunMainLoop,
2011-01-22 20:55:01.824 TVRec(1): ClearFlags(PENDINGACTIONS,) ->
RunMainLoop,
2011-01-22 20:55:01.833 TVRec(1): No recorder yet, calling TuningFrequency
2011-01-22 20:55:01.847 TVRec(1): Starting Signal Monitor
2011-01-22 20:55:01.855 TVRec(1): SetupSignalMonitor(1, 0)
2011-01-22 20:55:02.218 TVRec(1): Signal monitor successfully created
2011-01-22 20:55:02.242 TVRec(1): Setting up table monitoring.
2011-01-22 20:55:02.242 TVRec(1): SetFlags(SignalMonitorRunning,) ->
RunMainLoop,SignalMonitorRunning,
2011-01-22 20:55:02.256 Using profile 'Live TV' to record
2011-01-22 20:55:02.263 TVRec(1): ClearFlags(WaitingForSignal,) ->
RunMainLoop,SignalMonitorRunning,
2011-01-22 20:55:02.271 TVRec(1): DVB service_id 8442 on net_id 9018 tsid
8204
2011-01-22 20:55:02.284 TVRec(1): SetFlags(WaitingForSignal,) ->
RunMainLoop,WaitingForSignal,SignalMonitorRunning,
2011-01-22 20:55:02.291 TVRec(1): Successfully set up DVB table monitoring.
2011-01-22 20:55:02.299 TVRec(1): ClearFlags(NeedToStartRecorder,) ->
RunMainLoop,WaitingForSignal,SignalMonitorRunning,
2011-01-22 20:55:02.315 DVBSH(/dev/dvb/adapter1/frontend0):
AddListener(0x7fcf7019f288) -- begin
2011-01-22 20:55:02.318 TVRec(1): SetFlags(NeedToStartRecorder,) ->
RunMainLoop,WaitingForSignal,NeedToStartRecorder,SignalMonitorRunning,
2011-01-22 20:55:02.329 DVBSH(/dev/dvb/adapter1/frontend0):
AddListener(0x7fcf7019f288) -- locked
2011-01-22 20:55:02.363 AutoExpire: CalcParams(): Max required Free Space:
3.0 GB w/freq: 14 min
2011-01-22 20:55:02.365 DVBSH(/dev/dvb/adapter1/frontend0):
AddListener(0x7fcf7019f288) -- end
2011-01-22 20:55:02.366 DVBSH(/dev/dvb/adapter1/frontend0): RunTS(): begin
2011-01-22 20:55:02.415 PIDInfo(/dev/dvb/adapter1/frontend0): Opening filter
for pid 0x0
2011-01-22 20:55:02.424 PIDInfo(/dev/dvb/adapter1/frontend0): Opening filter
for pid 0x10
2011-01-22 20:55:02.431 PIDInfo(/dev/dvb/adapter1/frontend0): Opening filter
for pid 0x11
2011-01-22 20:55:02.439 PIDInfo(/dev/dvb/adapter1/frontend0): Opening filter
for pid 0x14
2011-01-22 20:55:02.448 CreatePATSingleProgram()
2011-01-22 20:55:02.459 PAT in input stream
2011-01-22 20:55:02.466 Program Association Table
  PSIP tableID(0x0) length(53) extension(0x200c)
       version(2) current(1) section(0) last_section(0)
          tsid: 8204
  programCount: 11
   program number     0 has PID 0x  10   data  0x 0 0x 0 0xe0 0x10
   program number  8268 has PID 0x 100   data  0x20 0x4c 0xe1 0x 0
   program number  8325 has PID 0x 102   data  0x20 0x85 0xe1 0x 2
   program number  8636 has PID 0x 112   data  0x21 0xbc 0xe1 0x12
   program number  8384 has PID 0x 12c   data  0x20 0xc0 0xe1 0x2c
   program number  8448 has PID 0x 130   data  0x21 0x 0 0xe1 0x30
   program number  8442 has PID 0x 10e   data  0x20 0xfa 0xe1 0x e
   program number  8452 has PID 0x 131   data  0x21 0x 4 0xe1 0x31
   program number  8577 has PID 0x 120   data  0x21 0x81 0xe1 0x20
   program number  8500 has PID 0x 121   data  0x21 0x34 0xe1 0x21
   program number  8368 has PID 0x 122   data  0x20 0xb0 0xe1 0x22
[...]

For a failed recording (mythfrontend's "Upcoming Recordings" shows it
'stuck' in the 'tuning' state, and no file created):

2011-01-22 21:55:01.219 TVRec(3): StartRecording("Van Wilder")
2011-01-22 21:55:01.228 TVRec(3): Checking input group recorders - begin
2011-01-22 21:55:01.235 TVRec(3): Checking input group recorders - done
2011-01-22 21:55:01.257 TVRec(3): StartedRecording(0x7fcfa40db440)
fn(/srv/myth/video-R1c/recordings/1024_20110122215500.mpg)
2011-01-22 21:55:01.279 TVRec(3): ClearFlags(CancelNextRecording,) ->
RunMainLoop,
2011-01-22 21:55:01.286 TVRec(3): Changing from None to RecordingOnly
2011-01-22 21:55:01.295 TVRec(3):
ClearFlags(FrontendReady,CancelNextRecording,) -> RunMainLoop,
2011-01-22 21:55:01.304 TVRec(3): HandleTuning Request: Program(yes)
channel() input() flags(Recording,)
2011-01-22 21:55:01.314 TVRec(3): HW Tuner: 3->3
2011-01-22 21:55:01.361 TVRec(3): ClearFlags(PENDINGACTIONS,) ->
RunMainLoop,
2011-01-22 21:55:01.369 TVRec(3): No recorder yet, calling TuningFrequency
2011-01-22 21:55:01.385 TVRec(3): Starting Signal Monitor
2011-01-22 21:55:01.393 TVRec(3): SetupSignalMonitor(1, 0)
2011-01-22 21:55:01.796 TVRec(3): Signal monitor successfully created
2011-01-22 21:55:01.840 TVRec(3): Setting up table monitoring.
2011-01-22 21:55:01.840 TVRec(3): SetFlags(SignalMonitorRunning,) ->
RunMainLoop,SignalMonitorRunning,
2011-01-22 21:55:01.850 Using profile 'Live TV' to record
2011-01-22 21:55:01.856 TVRec(3): ClearFlags(WaitingForSignal,) ->
RunMainLoop,SignalMonitorRunning,
2011-01-22 21:55:01.876 TVRec(3): SetFlags(WaitingForSignal,) ->
RunMainLoop,WaitingForSignal,SignalMonitorRunning,
2011-01-22 21:55:01.887 TVRec(3): ClearFlags(NeedToStartRecorder,) ->
RunMainLoop,WaitingForSignal,SignalMonitorRunning,
2011-01-22 21:55:01.896 TVRec(3): SetFlags(NeedToStartRecorder,) ->
RunMainLoop,WaitingForSignal,NeedToStartRecorder,SignalMonitorRunning,
2011-01-22 21:55:01.865 TVRec(3): DVB service_id 28032 on net_id 9018 tsid
24640
2011-01-22 21:55:01.917 TVRec(3): Successfully set up DVB table monitoring.

> Devin

Many thanks for your clear explanations.

Best Regards,
Alex
--8323328-577977028-1295816150=:26778--
