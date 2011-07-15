Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab1GOBiw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 21:38:52 -0400
Message-ID: <4E1F9A25.1020208@infradead.org>
Date: Thu, 14 Jul 2011 22:38:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru>
In-Reply-To: <4E1E8108.3060305@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-07-2011 02:39, Stas Sergeev escreveu:
> 14.07.2011 02:00, Mauro Carvalho Chehab wrote:
> 
>>> Now that we don't have the output mute switch, we
>>> allow the alsa driver to unmute not only the recording
>>> that it may need, but also the sound output that goes
>>> to the sound card! IMHO, this is the entirely unwanted
>>> side effect, so I blame the saa driver, and not the pulseaudio.
>> Why this is unwanted? You shouldn't expect that the poor
>> users to control each mute control. They just need to control
>> one: the sound card outut.
> Controlling the sound card output makes no sense
> here: I don't want to mute the entire sound only when
> I want to mute the TV-tuner.
> On the other hand, why exactly would you unmute
> the output when capturing? Obviously to allow the
> capturing itself.
> Why, at the same time, would you enable the pass-through
> link to the sound card? Unwanted side-effect: it is
> not needed for capturing, and it gives the noise.
> That have to be fixed.
> So: even if pulseaudio wants to record the white
> noise for one reason or another, at least it doesn't
> output it to the sound card, so what it does is perfectly
> safe. Enabling the pass-through link to the sound card
> is a bug here.
> 
>>> There are also other things to consider:
>>> 1. You can't record anything (except for the white noise)
>>> before some xawtv sets up everything. So what is the
>>> use-case of the current (mis)behaveur?
> So is there a use-case?
> 
>> If you're getting a white noise, then there's a bug either
>> at xawtv, at the driver or both. It is likely board-specific,
>> as, at least the last time I tested, saa7134 audio were working
>> properly.
> I don't see your point, I described the bug precisely.

Huh? The first time, you said it were due to pulseaudio. Then, you
said it were due to xawtv, and now you're blaming Xorg startup.

Starting X should not be touching on anything, as Xorg itself doesn't 
have any code to handle an alsa device.

Let's reset this thread to the beginning. See bellow.

> The capture unmutes the pass-through link to the
> sound card, so whatever is captured (white noise),
> gets also immediately outputed to the speakers, even
> though pulseaudio does not feed that to the sound
> card.
> 
>> As I said before, the white noise bug should be fixed.
>> With what xawtv versions are you noticing problems? Are you using
>> xawtv 3.101? If so, xawtv 3.101 assumes that you're using digital
> There is nothing to do with xawtv here: as I said,
> the noise happens on xorg startup. Starting xawtv
> actually makes it to disappear, but I can't always
> start xawtv just for that.

The expected behavior of the driver should be to unmute the device only
if TV and/or radio starts streaming, and muting it at stream stop.

Detecting that radio is streaming is complex, as the API allows to 
start stream, while keeping the radio device closed. Anyway, in this
case, radio applications need to manually unmute the device.

Also, the alsa driver doesn't have any business to do when the
audio is wire connected, excepting by providing the mixer controls.

The mute/unmute logic is there due to the fact that, nowadays, most boards
provide audio PCM output, and such setup is generally preferred, as it
doesn't require an extra cabling, and gives more quality to the audio, as
it avoids an extra Digital/Analog and Analog/Digital conversion, thus
reducing the quantization noise and any analog interferences.

In any case, all V4L drivers should have the same behavior on that matter.

By looking at the alsa driver, the logic is muting/unmuting at device open
and not at device capture. So, it is not doing the expected behavior.

The proper fix seems to move that logic to capture start/stop. We need to
take care through, as capture start/stop happens at IRQ time. so, it can't
sleep. We may likely need to start a workqueue to mute/unmute the driver at
capture. We had to do something similar to that at the em28xx, as the
DMA start sequence there calls msleep(), and this is not allowed at IRQ time.

If you want, feel free to propose a patch fixing that logic at saa7134, instead
of just removing it.

Cheers,
Mauro
