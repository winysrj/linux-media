Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp22.services.sfr.fr ([93.17.128.10]:30447 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab0HCNs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 09:48:26 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2204.sfr.fr (SMTP Server) with ESMTP id 4E3B9700008E
	for <linux-media@vger.kernel.org>; Tue,  3 Aug 2010 15:48:24 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (81.148.200-77.rev.gaoland.net [77.200.148.81])
	by msfrf2204.sfr.fr (SMTP Server) with SMTP id EE55E7000084
	for <linux-media@vger.kernel.org>; Tue,  3 Aug 2010 15:48:23 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.148.81] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Tue, 03 Aug 2010 15:48:22 +0200
Subject: Re: Fwd: No audio in HW Compressed MPEG2 container on HVR-1300
From: lawrence rust <lawrence@softsystem.co.uk>
To: Shane Harrison <shane.harrison@paragon.co.nz>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTi=V3eKuJ1jXPcBuSxUy6djCoK4q2pR-V0zo_cMS@mail.gmail.com>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
	 <1280741544.1361.17.camel@gagarin>
	 <AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
	 <AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
	 <1280750394.1361.87.camel@gagarin>
	 <AANLkTi=V3eKuJ1jXPcBuSxUy6djCoK4q2pR-V0zo_cMS@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 15:48:19 +0200
Message-ID: <1280843299.1492.127.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-08-03 at 09:02 +1200, Shane Harrison wrote:
[snip]
> Thanks for the audio path info.  While you are on a roll, a few more questions ?
> 1) So do you know how the I2S input (from WM8775) is looped back to
> the I2S output that is fed to the MPEG encoder?  I can only assume in
> software?

Yes, it is looped through the cx23883 under s/w control.

>   I note that the driver has a comment re. using passthrough
> mode in the CX2388x but actually uses normal mode which isn't a
> loopback.  Hence something else must generate the I2S output source.

I believe that as long as b13 of AUD_CTL is set then i2s data is output
- this bit is set in set_audio_finish().  The code comment is wrong, as
you say, the i2sctl register is set to normal mode.  In normal mode the
i2s data output is either i2s-in or the demodulated audio from the
analog tuner, dependent upon configuration.

> 2)  I interpreted the following note in the CX23416 datasheet slightly
> differently than you:
>        "The CX23416 audio input interface is designed to work with most commonly
>        available audio analog-to-digital converters (ADCs) that are
> compatible with the Sony
>        I2S data format. An I2S-compatible audio part can be supported
> by running its AILR
>        sync signal through an inverting flip-flop, clocked by an
> inverted AICKIN, before
>        passing it to the CX23416.
> I assumed it was saying it accepted standard Sony variant but you
> could connect to Philips I2S if you used a flip-flop to invert and
> synchronise with the AICKIN.

Yes you are correct, the flip-flop is needed (which is what I wanted to
emphasise) only for _Philips_ mode but the cx23883 i2sout is programmed
for Sony mode in set_audio_finish() i.e. AUD_I2SOUTPUTCNT = 1.

>   I did notice that the HVR1300 board has
> a footprint for an IC that is connected to the I2S outputs in some
> manner.  I wondered what this was - does something need to be fitted
> then to make these two devices talk directly?  I also note that the
> driver sets the I2S input to be Philips (as output by the WM8775) and
> the I2S output as Sony which seems like an attempt to talk directly.
> A bit confused here.....

The wm8775 outputs Philips format in i2s mode and that's what
cx88_set_tvaudio() programs the cx23883 to accept on i2sin.

If the cx23883 were programmed for pass-thru mode then the cx23416 would
receive the wrong data format.  I believe that's the reason for using
'normal' mode.

However, I believe there may be a problem in set_audio_finish() when
CX88_MPEG_BLACKBIRD is set.  If core->tvaudio == WW_I2SADC (which it
true for s-video and composite inputs) then cx88_set_tvaudio() calls
set_audio_finish(core, EN_I2SIN_ENABLE) to enable i2s audio input but in
the CX88_MPEG_BLACKBIRD case the EN_I2SIN_ENABLE is never written to
AUD_CTL.  This may account for the white noise you hear.  You could test
this easily by forcing the cx88 module parameter 'analog' to 1

> 3) Given I am getting audio sometimes in the MPEG2 stream, is it using
> another path into the CX23416.  The idea of getting lucky on switching
> glitches seems improbable on the I2S interface since once I get audio
> I continue to have it until a hard reboot.  Switching glitches and
> race conditions on the control interfaces being successful every so
> often I could buy.
> 
> Still to try the patch - will let you know.  Unfortunately our
> HVR-1300 is in the process of being swapped out since the supplier
> wanted to try swapping boards first :-(

Let us know how you get on.

-- Lawrence Rust


