Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp22.services.sfr.fr ([93.17.128.12]:59501 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0HBL75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 07:59:57 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2213.sfr.fr (SMTP Server) with ESMTP id 411D9700008D
	for <linux-media@vger.kernel.org>; Mon,  2 Aug 2010 13:59:56 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (81.148.200-77.rev.gaoland.net [77.200.148.81])
	by msfrf2213.sfr.fr (SMTP Server) with SMTP id E704D700008B
	for <linux-media@vger.kernel.org>; Mon,  2 Aug 2010 13:59:55 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.148.81] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 13:59:54 +0200
Subject: Re: Fwd: No audio in HW Compressed MPEG2 container on HVR-1300
From: lawrence rust <lawrence@softsystem.co.uk>
To: Shane Harrison <shane.harrison@paragon.co.nz>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
	 <1280741544.1361.17.camel@gagarin>
	 <AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
	 <AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 13:59:54 +0200
Message-ID: <1280750394.1361.87.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-08-02 at 22:19 +1200, Shane Harrison wrote:
[snip]
> Thanks Lawrence, will give that a whirl tomorrow and the muting idea
> might be important in this case as well.  Wierd you posted Saturday
> the day after I last worked on this and looked at the archives :-)
> 
> I am not ruling out initialisation problems with the WM8775 but I do
> always seem to get an I2S output from it that has data in it that
> reflects the input.  However it could be the wrong variant of I2S or
> some other configuration that isn't set right.

Currently in wm8775.c line 223, R11 is set to 0x21 which is 24-bit left
justified mode.  This is wrong, it should be i2s mode (0x22).  My patch
correctly sets this register and also disables ALC mode which is
irrelevant when setting input level via ALSA and can cause hiss during
quiet sections.

> Strange how eventually
> I do get audio (albeit mixed with the TV source it appears) simply by
> looping thru and changing input sources with v4l2-ctl.

Probably switching glitches eventually hit the right data
synchronisation format.

> I note that the Nova-S doesn't have the hardware MPEG encoding

Correct.

>  so
> still hoping someone can enlighten me on the audio path when using
> that chip.

When a Blackbird cx23416 MPEG encoder is fitted, i2s audio data from the
wm8775 is routed through the cx23883.  The i2s output of the cx23883 is
enabled by the function set_audio_finish() in cx88-tvaudio.c line 148.
The cx23416 can accept stereo Sony I2S format audio data when quoting
from the Conexant datasheet "running its AILR sync signal through an
inverting flip-flop, clocked by an inverted AICKIN".

-- Lawrence Rust


