Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp13.mail.ru ([94.100.176.90]:53295 "EHLO smtp13.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab1GOFpd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 01:45:33 -0400
Message-ID: <4E1FD2DF.6090302@list.ru>
Date: Fri, 15 Jul 2011 09:40:47 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org>
In-Reply-To: <4E1F9A25.1020208@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

15.07.2011 05:38, Mauro Carvalho Chehab wrote:
> Huh? The first time, you said it were due to pulseaudio. Then, you
Yes: pulseaudio does some capturing at startup.
(or, possibly, just opens the capture device). Without
it, nothing bad happens, but I never said the bug is
in pulseaudio.

> said it were due to xawtv,
No, I was mentioned xawtv as an app that have to
set everything up properly, before you can capture
anything else than the white noise.
So my point was, and is, that, before something like
xawtv sets up the tuner, unmuting the audio makes
_zero_ sense.

>   and now you're blaming Xorg startup.
I am not _blaming_ it, just mentioning it.
Indeed, the pulseaudio starts on the xorg startup,
at least on fedora. So, from the mere user's point
of view, you start xorg and get the noise.

> Starting X should not be touching on anything, as Xorg itself doesn't
> have any code to handle an alsa device.
But, with some magic scripts, it starts pulseaudio.

> The expected behavior of the driver should be to unmute the device only
> if TV and/or radio starts streaming, and muting it at stream stop.
What does "streaming" means here, exactly?

> Also, the alsa driver doesn't have any business to do when the
> audio is wire connected, excepting by providing the mixer controls.
The problem is exactly here: the single mixer control
controls both the pass-through wire and the input
for capturing.
Be there the 2 separate controls, or be there a control
_only_ for the pass-through write, the problem would
not exist. But currently the single mixer control controls
too much.

> The mute/unmute logic is there due to the fact that, nowadays, most boards
> provide audio PCM output, and such setup is generally preferred, as it
> doesn't require an extra cabling, and gives more quality to the audio, as
> it avoids an extra Digital/Analog and Analog/Digital conversion, thus
> reducing the quantization noise and any analog interferences.
Please clarify that part a bit.
How exactly the expected mute/unmute logic should
affect the pass-through wire, and how exactly should
it affect the PCM capture.

> By looking at the alsa driver, the logic is muting/unmuting at device open
> and not at device capture. So, it is not doing the expected behavior.
>
> The proper fix seems to move that logic to capture start/stop. We need to
What if pulseaudio really captures something, rather than
just opens the device? Not that I have checked it does, but
it may be the case if he wants to calibrate some clocks by
recording something.
Why just recording from the alsa device, without feeding
the sound to the sound card, should ever produce any
sound from the speakers? No program in the world would
expect that behaveor, and the pulseaudio's case may or
may not be fixed by that (depends on luck, and, possibly,
the pulseaudio version), so why doing such a change?
