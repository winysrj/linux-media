Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50846 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab1GMWAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 18:00:45 -0400
Message-ID: <4E1E1571.6010400@infradead.org>
Date: Wed, 13 Jul 2011 19:00:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru>
In-Reply-To: <4E1E0A1D.6000604@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-07-2011 18:11, Stas Sergeev escreveu:
> 14.07.2011 00:53, Mauro Carvalho Chehab wrote:
>>> When pulseaudio enables the audio capturing, the
>>> driver unmutes the sound. But, if no app have properly
>>> tuned the tuner yet, you get the white noise.
>>> I think the capturing must not touch the mute state,
>>> because, without tuning the tuner first, you can't capture
>>> anything anyway.
>>> Without this patch I am getting the white noise on every
>>> xorg/pulseaudio startup, which made me to always think
>>> that pulseaudio is a joke and will soon be removed. :)
>> Nack. We shouldn't patch a kernel driver due to an userspace bad behavior.
> But I really think that the driver behaves badly here.
> Suppose we had 2 separate mute switches: the input
> mute, that mutes the signal as it just enters the saa
> chip, and the output mute, that mutes only the output
> of the tuner card, that is connected to the sound card's
> line input.
> With that configuration, we'd allow the alsa driver to
> unmute only the input switch, so that it can record, but
> leave the output switch still muted, so that the sound
> not to come to the sound card directly.

Well, on such configuration, there are, in fact, 4 mutes:
the two ones you've mentioned, plus the sound card LINE IN
mute and the sound card master output.

The media drivers should control the input that belongs to
saa7134. The userspace applications like pulseaudio should
control the sound card volume/mute, but the driver should
control the saa7134 mute/audio switch.

> Now that we don't have the output mute switch, we
> allow the alsa driver to unmute not only the recording
> that it may need, but also the sound output that goes
> to the sound card! IMHO, this is the entirely unwanted
> side effect, so I blame the saa driver, and not the pulseaudio.

Why this is unwanted? You shouldn't expect that the poor
users to control each mute control. They just need to control
one: the sound card outut.

> There are also other things to consider:
> 1. You can't record anything (except for the white noise)
> before some xawtv sets up everything. So what is the
> use-case of the current (mis)behaveur?

If you're getting a white noise, then there's a bug either
at xawtv, at the driver or both. It is likely board-specific,
as, at least the last time I tested, saa7134 audio were working
properly.

> 2. The alsa driver, trying to manage the mute state on
> its own, badly interwinds with the mute state of the
> (xawtv) program. 2 programs cannot control the same
> mute state for good, and of course the xawtv must have
> the preference, as the alsa driver have no slightest
> idea about the card's state.

There's no sense on keeping the device unmuted after
stop streaming.

> 3. The problem is very severe. Hearing the loud white
> noise on every startup is not something the human can
> easily tolerate. So deferring it for the unknown period
> is simply not very productive.

As I said before, the white noise bug should be fixed.
With what xawtv versions are you noticing problems? Are you using
xawtv 3.101? If so, xawtv 3.101 assumes that you're using digital
streams. Maybe your board entry is broken for digital streams.
> 
> Can you please name a few downsides of the approach
> I proposed?

