Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp18.mail.ru ([94.100.176.155]:59144 "EHLO smtp18.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1GTFdp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 01:33:45 -0400
Message-ID: <4E266799.8030706@list.ru>
Date: Wed, 20 Jul 2011 09:28:57 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org>
In-Reply-To: <4E262772.9060509@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

20.07.2011 04:55, Mauro Carvalho Chehab wrote:
>> The proposed solution is to have the mute
>> control, that can be valid for all the cards/drivers.
>> Presumably, it should have the similar name
>> for all of them, even though for some it will be
>> a "virtual" control that will control several items,
>> and for others - it should map directly to their
>> single mute control.
>> If we have such a mute control, any app can use
>> it,
> Any app can do it right now via the V4L2 api.
I am just following your logic, you said that
---
Moving such logic to happen at userspace would be very complex, and will
break existing applications.
---
To solve that, I proposed adding such mixer control
to where it is missing right now.
But if this is no longer a problem and the app
can just use v4l2 for that instead, then what still
keeps us from removing the auto-unmute things?

>> and the auto-unmute logic can be removed
>> from the alsa driver. v4l2 is left as it is now.
> What is the sense of capturing data for a device that is not ready
> for stream?
This may be a PA's hack, or a user's mistake, or
whatever, but whatever it is, it shouldn't lead to
any sounds from speakers. Just starting the capture,
willingly or by mistake, should never lead to any
sound from speakers, IMO. So that's the bug too.
And the simpler one to fix.

>> So that's the proposal, what problems can you see
>> with it?
> Userspace application breakage is not allowed. A change like
> that will break the existing applications like mplayer.
No, because, as you said, it uses v4l2, not alsa,
to unmute.
And my proposal only affects alsa, so what's the
breakage?

> Maybe your device is not a saa7134. For saa7133/saa7135, the
> mute/unmute seems to be done via GPIO, and via amux.
Yes, and that's exacly why unmuting only I2S
does nothing: the muxes are still set up for mute.

>> IIRC the problem was that this does not mute the
>> sound input from the back panel of the board, which
>> would then still go to the pass-through wire in case
>> you are capturing. The only way do mute it, was to
>> configure muxes the way you can't capture at the
>> same time. But I may be wrong with the recollections.
> Well, the change seems to be simple, as we don't actually need to
> split the mute. We just need to control the I2S input/output at
> the alsa driver.
>
> The enclosed patch probably does the trick (completely untested).
I'll be able to test it on avertv 307 the next week-end.
But what is the expected effect of that patch?
It looks much like mine: mostly just removes auto-unmute,
doing that in a not-so-obvious way.
The card is muted by setting up the muxes.
Now you unmute it by enabling I2S, but the muxes
are still set to mute, so nothing happens, and you
will capture the silence.
I think this patch is _correct_, as it removes the
auto-unmute logic; exactly what I proposed. :)
Just a slightly different implementation, unless
I am missing something obvious...
By the way, do you need to do

saa7134_i2s_mute(dev, mute);

from mute_input_7134() ? Maybe leaving that I2S
control entirely for alsa, and not touching it elsewhere?
The function itself can probably then be moved to
saa7134-alsa.c.

Thanks!
