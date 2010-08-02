Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58421 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0HBCPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 22:15:43 -0400
Received: by iwn7 with SMTP id 7so3633553iwn.19
        for <linux-media@vger.kernel.org>; Sun, 01 Aug 2010 19:15:42 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 2 Aug 2010 14:15:42 +1200
Message-ID: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
Subject: No audio in HW Compressed MPEG2 container on HVR-1300
From: Shane Harrison <shane.harrison@paragon.co.nz>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi There,

I am having a problem with getting an audio stream present in the
MPEG2 stream from an HVR-1300 card.

Background
~~~~~~~~~
I am using an HVR-1300 card in a Linux system running 2.6.28.6 vanilla
kernel and using latest v4l2 drivers from the repository.  We are
trying to use the onboard MPEG H/W encoder CX23416 to deliver an
MPEG-2 stream with both audio and video.

To test I capture using "cat /dev/video1 > test.mpg" and I am using
mplayer to play the subsequently captured stream.
Problem
~~~~~~
The delivered MPEG-2 stream generally has no audio component. Mplayer
reports "no audio found".

The same problem exists for both TV input and composite input.  By
repeatedly switching between the TV input and the Composite input we
can eventually get an audio component in the MPEG-2 stream.
Thereafter we always get the audio component until a power off and
restart.  Simply rebooting (no power off) seems to still leave things
in a state where the audio component is in the MPEG-2 stream.

There is a second problem, the audio stream always contains white
noise (I assume TV tuner noise - we don't have it tuned nor an aerial
attached) mixed with the signal applied to the analog in ports.

Analysis
~~~~~~
The most likely scenario is that the hardware is not being initialised
correctly most of the time, once it is initialised correctly then it
works thereafter.  Unfortunately it is difficult to determine the
actual audio path being used.  Clearly the audio comes into the WM8775
(DAC) via a bus switch that switches between the composite/audio on
the back panel and the white header.  It then enters the CX2388x via
the I2S input pins.  We initially assumed that the audio was then
routed through to the CX23416 (MPEG Encoder) via the I2S output pins
of the CX2388x, but we have begun to doubt this assumption since the
CX2388x is set in normal mode by the drivers and the captured audio
doesn't reflect the bit patterns we see on the I2S Data Out line using
an oscilloscope.  That is, when we apply *no* signal to the analog
input, the I2S Dout line is "quiet" yet we hear white noise.

Questions
~~~~~~~~
1) Anyone have any similar experiences?
2) Does anyone have more information on the "blackbird reference
design", in particular can the CX2388x be configured into passthrough
mode so the I2S from the WM8775 goes directly to the CX23416.  I think
the current wiring configuration of the CX23416 to the CX2388x
precludes this?
3) How might the analog signal be being routed to the CX23416 for
encoding if not via the I2S input?


Kind regards
Shane Harrison
Paragon Electronic Design
NZ
