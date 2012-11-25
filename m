Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:32872 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2KYE7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Nov 2012 23:59:31 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so7021981qcr.19
        for <linux-media@vger.kernel.org>; Sat, 24 Nov 2012 20:59:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B199A9.8050909@gmail.com>
References: <50B1047B.4040901@gmail.com>
	<CAGoCfiwpj5ua79wOp8_CZfD_O9EOG7PAA4wE3L4n3-d-+FEhVg@mail.gmail.com>
	<50B199A9.8050909@gmail.com>
Date: Sat, 24 Nov 2012 23:59:30 -0500
Message-ID: <CAGoCfiwoe9Pb2UyCrhQTHuwO1X3ARE5fRMYNDigWSFcbiBDgjA@mail.gmail.com>
Subject: Re: Poor HVR 1600 Video Quality - Feedback for Devin Heitmueller 2012-11-24
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bob Lightfoot <boblfoot@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 24, 2012 at 11:08 PM, Bob Lightfoot <boblfoot@gmail.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Devin :
>      Let me see if I can answer some of your questions.
>
> 1. lspci -nn -vvv returns the following for the HVR-1600 Card
>
>> 01:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
>> CX23418 Single-Chip MPEG-2 Encoder with Integrated Analog
>> Video/Broadcast Audio Decoder [14f1:5b7a] Subsystem: Hauppauge
>> computer works Inc. WinTV HVR-1600 [0070:7444] Control: I/O- Mem+
>> BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR-
>> FastB2B- DisINTx- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
>> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>> Latency: 64 (500ns min, 50000ns max), Cache Line Size: 32 bytes
>> Interrupt: pin A routed to IRQ 17 Region 0: Memory at f4000000
>> (32-bit, non-prefetchable) [size=64M] Capabilities: [44] Vital
>> Product Data Not readable Capabilities: [4c] Power Management
>> version 2 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 NoSoftRst- PME-Enable-
>> DSel=0 DScale=0 PME- Kernel driver in use: cx18 Kernel modules:
>> cx18
>
>
> 2.  Links on Google to files related to this issue :
> A. The Main Can on the Tuner Card -
>        https://docs.google.com/open?id=0B95B_9punKEmeHBUNHprMnVNV00
> B. First of the Conextant Chips on Card -
>        https://docs.google.com/open?id=0B95B_9punKEmT2wwbmltSzFWb2c
> C. Second of the Conextant Chips on Card -
>        https://docs.google.com/open?id=0B95B_9punKEmNTdVMENHUFllNzA
> D. A Final ESMT Chip on Card -
>        https://docs.google.com/open?id=0B95B_9punKEmYUd5eWNrWEhudWc
> E. The v4l2-ctl and cat /dev/video2 file made from Svideo1
>        https://docs.google.com/open?id=0B95B_9punKEmUGdJNTI3ZnR2T1k
> F. The v4l2-ctl and cat /dev/video2 file made from Tuner1
>        https://docs.google.com/open?id=0B95B_9punKEmOUhLWjNyRG02NDA
>
> 3.  I tested with both the SVideo and Coax Inputs for Analog.  As
> you'll see from the 10 second videos the SVideo works fine but the
> Coax Tuner is a problem.
>
> 4.  I don't know if I am capturing raw for MPEG compressed for certain
> but I'll go over the test method used to make to two videos and that
> should also answer this question.
>
> 5. As far as test tools I have used v4l2-ctl, mplayer, vlc and cat
> commands for testing.
>
> 6.  Commands issued in order were as follows for the SVideo Capture:
>     A. v4l2-ctl --list-devices
>     B. v4l2-ctl -d /dev/video2 --list-inputs
>     C. v4l2-ctl -d /dev/video2 --set-input=1  {Note this is SVideo1}
>     D. v4l2-ctl -d /dev/video2 --list-standards | less
>     E. v4l2-ctl -d /dev/video2 --set-standard=1  {Note this is NTSC}
>     F. mplayer /dev/video2 -cache 8192
>     G. close mplayer after successfully watching video
>     H. cat /dev/video2 > hvr1600-svideo1.mpg
>
> 7.  Commands issued in order were as follows for the Tuner1 Capture:
>     A. v4l2-ctl --list-devices
>     B. v4l2-ctl -d /dev/video2 --list-inputs
>     C. v4l2-ctl -d /dev/video2 --set-input=0 {Note this is Tuner1}
>     D. v4l2-ctl -d /dev/video2 --list-standards | less
>     E. v4l2-ctl -d /dev/video2 --set-standard=1  {Note this is NTSC}
>     F. v4l2-ctl -d /dev/video2 -f 67.250  {Note this is us-bdcst chan 4}
>     G. mplayer /dev/video2 -cache 8192
>     H. close mplayer after successfully watching video
>     I. cat /dev/video2 > hvr1600-Tuner1.mpg
>
> 8.  It should be obvious by this point, but I am too much of a
> neophyte to be compiling kernels.  I am running Centos 6 and yum for
> updates for anything I have applied has come through their packaging
> and distribution system.
>
> NOTES : This SVideo looks good but the Tuner1 is garbage.  I also
> tested the coax input thru my HVR-1850 using xawtv and while it had no
> audio the video was good although slightly greenish.  So I don't
> suspect the coax cable, especially since when connected to a standard
> TV it produces a good picture.
>
> Hope you can shed an idea or three.
>
> My end goal it to again record analog video in MythTV.

Ok, so this narrows it down quite a bit.  The fact that the s-video is
working but the tuner isn't suggests either the tuner is off tune, or
the analog demod isn't setup properly.  After running the "v4l2-ctl -s
1" command, do you see the standard set to NTSC-M if you then run
"v4l2-ctl --all" ?  Also, do you hear audio properly despite the video
being corrupt?

My guess is that some recent subtle change to the subdev framework is
probably resulting in the commands not actually being delivered to the
demod.  I ran into similar problems a few months ago when doing some
work on the cx18 driver for WSS configuration, although I didn't get a
chance to push any patches upstream.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
