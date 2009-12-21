Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52606 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZLUPIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2009 10:08:07 -0500
Received: by fxm7 with SMTP id 7so4962631fxm.29
        for <linux-media@vger.kernel.org>; Mon, 21 Dec 2009 07:08:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <74fd948d0912201540u287dedaby81932da32359a11a@mail.gmail.com>
References: <74fd948d0912200907j21fcc7b1qd2bfd2da00d4f72@mail.gmail.com>
	 <829197380912201032re3590ael3c4f70ce2afa6349@mail.gmail.com>
	 <74fd948d0912201540u287dedaby81932da32359a11a@mail.gmail.com>
Date: Mon, 21 Dec 2009 10:08:03 -0500
Message-ID: <829197380912210708r5908276ege9854fd5957a0a30@mail.gmail.com>
Subject: Re: Pinnacle PCTV Hybrid (2) dvb woes
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 20, 2009 at 6:40 PM, Pedro Ribeiro <pedrib@gmail.com> wrote:
> Damn, I suspected that.
>
> Anyway, I'm having trouble viewing analog TV. I can scan and watch
> channels fine, but there is no audio, and I don't know how to
> configure it. If you could help me, I would really appreciate it
>
> Should I use the em28xx soundcard for output or my own internal soundcard?
>
> tvtime only uses ALSA, but my internal soundcard as OSS mixer
> emulation (the em28xx has not). However, I cannot control the volume
> in tvtime
>
> Alsa says that the em28xx soundcard has no mixer controls.

Hello Pedro,

Tvtime doesn't support reading on ALSA devices - this is an issue not
specific to the em28xx, but effects pretty much every modern tuner -
tvtime was written during a time when capture cards had a line out
cable that you would connect to speakers.  I've written about the
topic at length on the kernellabs.com blog if you want more info.

Note that the em28xx provides a PCM *input* device.  To get audio, you
will typically read on the em28xx PCM device and output to your sound
card.

To make it work in tvtime, run tvtime, open a separate window, and try
the following:

arecord -D hw:1,0 -c 2 -r 48000 -f S16_LE | aplay -

(assuming that the em28xx board is detected as "1,0" if you run "arecord -l")

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
