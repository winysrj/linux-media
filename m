Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65505 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab2KYEIY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Nov 2012 23:08:24 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so4906479iea.19
        for <linux-media@vger.kernel.org>; Sat, 24 Nov 2012 20:08:23 -0800 (PST)
Message-ID: <50B199A9.8050909@gmail.com>
Date: Sat, 24 Nov 2012 23:08:09 -0500
From: Bob Lightfoot <boblfoot@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Poor HVR 1600 Video Quality - Feedback for Devin Heitmueller
 2012-11-24
References: <50B1047B.4040901@gmail.com> <CAGoCfiwpj5ua79wOp8_CZfD_O9EOG7PAA4wE3L4n3-d-+FEhVg@mail.gmail.com>
In-Reply-To: <CAGoCfiwpj5ua79wOp8_CZfD_O9EOG7PAA4wE3L4n3-d-+FEhVg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Devin :
     Let me see if I can answer some of your questions.

1. lspci -nn -vvv returns the following for the HVR-1600 Card

> 01:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
> CX23418 Single-Chip MPEG-2 Encoder with Integrated Analog
> Video/Broadcast Audio Decoder [14f1:5b7a] Subsystem: Hauppauge
> computer works Inc. WinTV HVR-1600 [0070:7444] Control: I/O- Mem+
> BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR-
> FastB2B- DisINTx- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx- 
> Latency: 64 (500ns min, 50000ns max), Cache Line Size: 32 bytes 
> Interrupt: pin A routed to IRQ 17 Region 0: Memory at f4000000
> (32-bit, non-prefetchable) [size=64M] Capabilities: [44] Vital
> Product Data Not readable Capabilities: [4c] Power Management
> version 2 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 NoSoftRst- PME-Enable-
> DSel=0 DScale=0 PME- Kernel driver in use: cx18 Kernel modules:
> cx18


2.  Links on Google to files related to this issue :
A. The Main Can on the Tuner Card -
       https://docs.google.com/open?id=0B95B_9punKEmeHBUNHprMnVNV00
B. First of the Conextant Chips on Card -
       https://docs.google.com/open?id=0B95B_9punKEmT2wwbmltSzFWb2c
C. Second of the Conextant Chips on Card -
       https://docs.google.com/open?id=0B95B_9punKEmNTdVMENHUFllNzA
D. A Final ESMT Chip on Card -
       https://docs.google.com/open?id=0B95B_9punKEmYUd5eWNrWEhudWc
E. The v4l2-ctl and cat /dev/video2 file made from Svideo1
       https://docs.google.com/open?id=0B95B_9punKEmUGdJNTI3ZnR2T1k
F. The v4l2-ctl and cat /dev/video2 file made from Tuner1
       https://docs.google.com/open?id=0B95B_9punKEmOUhLWjNyRG02NDA

3.  I tested with both the SVideo and Coax Inputs for Analog.  As
you'll see from the 10 second videos the SVideo works fine but the
Coax Tuner is a problem.

4.  I don't know if I am capturing raw for MPEG compressed for certain
but I'll go over the test method used to make to two videos and that
should also answer this question.

5. As far as test tools I have used v4l2-ctl, mplayer, vlc and cat
commands for testing.

6.  Commands issued in order were as follows for the SVideo Capture:
    A. v4l2-ctl --list-devices
    B. v4l2-ctl -d /dev/video2 --list-inputs
    C. v4l2-ctl -d /dev/video2 --set-input=1  {Note this is SVideo1}
    D. v4l2-ctl -d /dev/video2 --list-standards | less
    E. v4l2-ctl -d /dev/video2 --set-standard=1  {Note this is NTSC}
    F. mplayer /dev/video2 -cache 8192
    G. close mplayer after successfully watching video
    H. cat /dev/video2 > hvr1600-svideo1.mpg

7.  Commands issued in order were as follows for the Tuner1 Capture:
    A. v4l2-ctl --list-devices
    B. v4l2-ctl -d /dev/video2 --list-inputs
    C. v4l2-ctl -d /dev/video2 --set-input=0 {Note this is Tuner1}
    D. v4l2-ctl -d /dev/video2 --list-standards | less
    E. v4l2-ctl -d /dev/video2 --set-standard=1  {Note this is NTSC}
    F. v4l2-ctl -d /dev/video2 -f 67.250  {Note this is us-bdcst chan 4}
    G. mplayer /dev/video2 -cache 8192
    H. close mplayer after successfully watching video
    I. cat /dev/video2 > hvr1600-Tuner1.mpg

8.  It should be obvious by this point, but I am too much of a
neophyte to be compiling kernels.  I am running Centos 6 and yum for
updates for anything I have applied has come through their packaging
and distribution system.

NOTES : This SVideo looks good but the Tuner1 is garbage.  I also
tested the coax input thru my HVR-1850 using xawtv and while it had no
audio the video was good although slightly greenish.  So I don't
suspect the coax cable, especially since when connected to a standard
TV it produces a good picture.

Hope you can shed an idea or three.

My end goal it to again record analog video in MythTV.

Sincerely,
Bob Lightfoot
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJQsZmpAAoJEKqgpLIhfz3XpXwIAKTIcmca98k3rbTU/T6Vz8LC
LCRI2J/ocFltV53QdPUOVmjmq/x3FTXZ1B1sSHcS6Av0fdDgU/GpDwp5aWv2apsv
lhUF6OtPFxylL8T9q23zPbZ3Io0p/PNzUTi/50LRYFXA+ATCn+AARoIiTHEOa1zW
ZEgvjETiCEKu5XxoRV8EUjITAR5F8KiiFeB+qdJkrpC0yee+R5rEL3Hvj3E5M+Cy
JbNRe7Su3SxcyaOVMaloxgIvreYaPmTlizBUKdKDphT9QnMIXQ8p55XiFNLX6jvo
ntaNaba0cm6sXzUjrSszgOUX4vj91hC/w5My6zkurLj19a9qog+iEFdHZoB3N6g=
=B7La
-----END PGP SIGNATURE-----
