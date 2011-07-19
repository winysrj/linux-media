Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp18.mail.ru ([94.100.176.155]:58360 "EHLO smtp18.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab1GSWCp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 18:02:45 -0400
Message-ID: <4E25FDE4.7040805@list.ru>
Date: Wed, 20 Jul 2011 01:57:56 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org>
In-Reply-To: <4E25DB37.8020609@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

19.07.2011 23:29, Mauro Carvalho Chehab wrote:
>> the additional element, they are fine already.
>> We can rename it to "Master Capture Switch",
>> or may not.
> Adding a new volume control that changes the mute values for the other controls
> or renaming it don't solve anything.
The proposed solution is to have the mute
control, that can be valid for all the cards/drivers.
Presumably, it should have the similar name
for all of them, even though for some it will be
a "virtual" control that will control several items,
and for others - it should map directly to their
single mute control.
If we have such a mute control, any app can use
it, and the auto-unmute logic can be removed
from the alsa driver. v4l2 is left as it is now.
So that's the proposal, what problems can you see
with it?

>> So, am I right that the only problem is that it is not
>> exported to the user by some _alsa_ drivers right now?
> I fail to see why this would be a problem.
But that was the problem _you_ named.
That is, that right now the app will have difficulties
unmuting the complex boards via the alsa interface,
because it will have to unmute several items instead
of one.
I propose to add the single item for that, except for
the drivers that already have only one mute switch.
With this, the problem you named, seems to be solved.
And then, perhaps, the auto-unmute logic can go away.
What am I missing?

> It is doable, although it is probably not trivial.
> Devices with saa7130 (PCI_DEVICE_ID_PHILIPS_SAA7130) doesn't enable the
> alsa module, as they don't support I2S transfers, required for PCM audio.
> So, we need to take care only on saa7133/4/5 devices.
>
> The mute code is at saa7134-tvaudio.c, mute_input_7134() function. For
> saa7134, it does:
>
>          if (PCI_DEVICE_ID_PHILIPS_SAA7134 == dev->pci->device)
>                  /* 7134 mute */
>                  saa_writeb(SAA7134_AUDIO_MUTE_CTRL, mute ?
>                                                      SAA7134_MUTE_MASK |
>                                                      SAA7134_MUTE_ANALOG |
>                                                      SAA7134_MUTE_I2S :
>                                                      SAA7134_MUTE_MASK);
>
> Clearly, there are two mute flags: SAA7134_MUTE_ANALOG and SAA7134_MUTE_I2S.
I was actually already playing with that piece of
code, and got no results. Will retry the next week-end
to see exactly why...
IIRC the problem was that this does not mute the
sound input from the back panel of the board, which
would then still go to the pass-through wire in case
you are capturing. The only way do mute it, was to
configure muxes the way you can't capture at the
same time. But I may be wrong with the recollections.
