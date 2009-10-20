Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:51978 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbZJTXAR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 19:00:17 -0400
Subject: Re: kworld studio terminator (saa7134) noise on capture
From: hermann pitton <hermann-pitton@arcor.de>
To: Asko Tamm <askotamm@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <130f3d140910200741j28954ecbtab12b17fb57d4ced@mail.gmail.com>
References: <130f3d140910200741j28954ecbtab12b17fb57d4ced@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 00:56:46 +0200
Message-Id: <1256079406.3311.19.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Asko, folks,

currently I don't have time for GNU/Linux and must care for family
members. Please try to get help by other list members.

Am Dienstag, den 20.10.2009, 17:41 +0300 schrieb Asko Tamm:
> Hi Hermann,
> 
> I found you have dealt with saa7134 driver noise and LNA issues
> (http://patchwork.kernel.org/patch/24348/). I hope you can direct me a
> bit further on the issue i'm having with Kworld studio terminator
> (pci)..
> 
> I am capturing old VHS from composite input. The strange thing is,
> that after first capture (mencoder interrupted with ctrl-c), the input
> becomes noisy. After unloading and reloading the saa7134* modules, i
> have one chance to capture cleanly again.
> 
> Also, sometimes (1 of about every 10 captures) i get a clean capture
> without reloading the module.
> 
> Could it be some LNA initialization issue on the noisy picture?  How
> to debug this?
> 
> some screenshots:
> http://84.50.124.61/snap_noise.png
> http://84.50.124.61/snap_nonoise.png
> 
> captures are from same tape.
> 
> It seems to happen only in high resolution (eg 720x576), did notice
> this in 352x576.
> I am capturing with mencoder like this:
> "mencoder -tv \
> driver=v4l2:width=720:height=576:input=1:norm=pal:fps=25:amode=1:alsa=yes:immediatemode=0:adevice=hw.1,0:audiorate=32000
> \
> tv:// -ovc raw -oac pcm \
> -o $1_raw.mpg"
> 
> i load the module with these parameters:
> options saa7134 card=65 tuner=54
> 
> 
> Thanks!
> --
> asko

That must be something else.

LNAs are only involved in tuner RF input amplification for what I know
so far.

User noticeable symptoms of missing LNA support, as reported so far, are
a horizontally moving black bar after switching channels, missing vsync,
or humming noise on analog audio and a sometimes flashing picture.

I admit that your both pictures look exactly like the tda8275 is driven
with one more passive splitter too much into more worse reception
conditions, but don't have a rhyme on it, why it should work for first
usage only.

Cheers,
Hermann




