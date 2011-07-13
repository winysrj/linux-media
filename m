Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.mail.ru ([94.100.176.130]:54449 "EHLO smtp2.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab1GMVQm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 17:16:42 -0400
Message-ID: <4E1E0A1D.6000604@list.ru>
Date: Thu, 14 Jul 2011 01:11:57 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org>
In-Reply-To: <4E1E05AC.2070002@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

14.07.2011 00:53, Mauro Carvalho Chehab wrote:
>> When pulseaudio enables the audio capturing, the
>> driver unmutes the sound. But, if no app have properly
>> tuned the tuner yet, you get the white noise.
>> I think the capturing must not touch the mute state,
>> because, without tuning the tuner first, you can't capture
>> anything anyway.
>> Without this patch I am getting the white noise on every
>> xorg/pulseaudio startup, which made me to always think
>> that pulseaudio is a joke and will soon be removed. :)
> Nack. We shouldn't patch a kernel driver due to an userspace bad behavior.
But I really think that the driver behaves badly here.
Suppose we had 2 separate mute switches: the input
mute, that mutes the signal as it just enters the saa
chip, and the output mute, that mutes only the output
of the tuner card, that is connected to the sound card's
line input.
With that configuration, we'd allow the alsa driver to
unmute only the input switch, so that it can record, but
leave the output switch still muted, so that the sound
not to come to the sound card directly.
Now that we don't have the output mute switch, we
allow the alsa driver to unmute not only the recording
that it may need, but also the sound output that goes
to the sound card! IMHO, this is the entirely unwanted
side effect, so I blame the saa driver, and not the pulseaudio.

There are also other things to consider:
1. You can't record anything (except for the white noise)
before some xawtv sets up everything. So what is the
use-case of the current (mis)behaveur?
2. The alsa driver, trying to manage the mute state on
its own, badly interwinds with the mute state of the
(xawtv) program. 2 programs cannot control the same
mute state for good, and of course the xawtv must have
the preference, as the alsa driver have no slightest
idea about the card's state.
3. The problem is very severe. Hearing the loud white
noise on every startup is not something the human can
easily tolerate. So deferring it for the unknown period
is simply not very productive.

Can you please name a few downsides of the approach
I proposed?
