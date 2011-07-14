Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp15.mail.ru ([94.100.176.133]:39921 "EHLO smtp15.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab1GNFoG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 01:44:06 -0400
Message-ID: <4E1E8108.3060305@list.ru>
Date: Thu, 14 Jul 2011 09:39:20 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org>
In-Reply-To: <4E1E1571.6010400@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

14.07.2011 02:00, Mauro Carvalho Chehab wrote:

>> Now that we don't have the output mute switch, we
>> allow the alsa driver to unmute not only the recording
>> that it may need, but also the sound output that goes
>> to the sound card! IMHO, this is the entirely unwanted
>> side effect, so I blame the saa driver, and not the pulseaudio.
> Why this is unwanted? You shouldn't expect that the poor
> users to control each mute control. They just need to control
> one: the sound card outut.
Controlling the sound card output makes no sense
here: I don't want to mute the entire sound only when
I want to mute the TV-tuner.
On the other hand, why exactly would you unmute
the output when capturing? Obviously to allow the
capturing itself.
Why, at the same time, would you enable the pass-through
link to the sound card? Unwanted side-effect: it is
not needed for capturing, and it gives the noise.
That have to be fixed.
So: even if pulseaudio wants to record the white
noise for one reason or another, at least it doesn't
output it to the sound card, so what it does is perfectly
safe. Enabling the pass-through link to the sound card
is a bug here.

>> There are also other things to consider:
>> 1. You can't record anything (except for the white noise)
>> before some xawtv sets up everything. So what is the
>> use-case of the current (mis)behaveur?
So is there a use-case?

> If you're getting a white noise, then there's a bug either
> at xawtv, at the driver or both. It is likely board-specific,
> as, at least the last time I tested, saa7134 audio were working
> properly.
I don't see your point, I described the bug precisely.
The capture unmutes the pass-through link to the
sound card, so whatever is captured (white noise),
gets also immediately outputed to the speakers, even
though pulseaudio does not feed that to the sound
card.

> As I said before, the white noise bug should be fixed.
> With what xawtv versions are you noticing problems? Are you using
> xawtv 3.101? If so, xawtv 3.101 assumes that you're using digital
There is nothing to do with xawtv here: as I said,
the noise happens on xorg startup. Starting xawtv
actually makes it to disappear, but I can't always
start xawtv just for that.
