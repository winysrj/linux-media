Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.1]:34945 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0HBJgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 05:36:01 -0400
Received: from smtp21.services.sfr.fr (msfrf2122 [10.18.25.36])
	by msfrf2105.sfr.fr (SMTP Server) with ESMTP id 0C7747001198
	for <linux-media@vger.kernel.org>; Mon,  2 Aug 2010 11:35:31 +0200 (CEST)
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2122.sfr.fr (SMTP Server) with ESMTP id 1D6D97000099
	for <linux-media@vger.kernel.org>; Mon,  2 Aug 2010 11:32:27 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (81.148.200-77.rev.gaoland.net [77.200.148.81])
	by msfrf2122.sfr.fr (SMTP Server) with SMTP id C335D7000088
	for <linux-media@vger.kernel.org>; Mon,  2 Aug 2010 11:32:26 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.148.81] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 11:32:25 +0200
Subject: Re: No audio in HW Compressed MPEG2 container on HVR-1300
From: lawrence rust <lawrence@softsystem.co.uk>
To: Shane Harrison <shane.harrison@paragon.co.nz>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 11:32:24 +0200
Message-ID: <1280741544.1361.17.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-08-02 at 14:15 +1200, Shane Harrison wrote:
> Hi There,
> 
> I am having a problem with getting an audio stream present in the
> MPEG2 stream from an HVR-1300 card.

[snip]

> Problem
> ~~~~~~
> The delivered MPEG-2 stream generally has no audio component. Mplayer
> reports "no audio found".
> 
> The same problem exists for both TV input and composite input.  By
> repeatedly switching between the TV input and the Composite input we
> can eventually get an audio component in the MPEG-2 stream.
> Thereafter we always get the audio component until a power off and
> restart.  Simply rebooting (no power off) seems to still leave things
> in a state where the audio component is in the MPEG-2 stream.
> 
> There is a second problem, the audio stream always contains white
> noise (I assume TV tuner noise - we don't have it tuned nor an aerial
> attached) mixed with the signal applied to the analog in ports.
> 
> Analysis
> ~~~~~~
> The most likely scenario is that the hardware is not being initialised
> correctly most of the time, once it is initialised correctly then it
> works thereafter.  Unfortunately it is difficult to determine the
> actual audio path being used.  Clearly the audio comes into the WM8775
> (DAC) via a bus switch that switches between the composite/audio on
> the back panel and the white header.  It then enters the CX2388x via
> the I2S input pins.  We initially assumed that the audio was then
> routed through to the CX23416 (MPEG Encoder) via the I2S output pins
> of the CX2388x, but we have begun to doubt this assumption since the
> CX2388x is set in normal mode by the drivers and the captured audio
> doesn't reflect the bit patterns we see on the I2S Data Out line using
> an oscilloscope.  That is, when we apply *no* signal to the analog
> input, the I2S Dout line is "quiet" yet we hear white noise.
> 
> Questions
> ~~~~~~~~
> 1) Anyone have any similar experiences?

This sounds very much like the problems that I had with my Nova-S-plus
card while developing a patch to capture line-in audio with composite
video.  Looking at the docs for the wm8775 it appeared that it wasn't
being correctly initialised.  I also found need to change the cx88 code
to mute/un-mute audio in.  Maybe you should try applying this patch, I
posted it to this group on Saturday - see.

http://www.mail-archive.com/linux-media@vger.kernel.org/msg21030.html

-- Lawrence Rust


