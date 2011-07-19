Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1GSTaJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 15:30:09 -0400
Message-ID: <4E25DB37.8020609@infradead.org>
Date: Tue, 19 Jul 2011 16:29:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru>
In-Reply-To: <4E25CF35.7000802@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-07-2011 15:38, Stas Sergeev escreveu:
> 19.07.2011 22:06, Mauro Carvalho Chehab wrote:
>>> Unless I am mistaken, this control is usually called a
>>> "Master Playback Switch" in the alsa world.
>> No, you're mistaken: on most boards, you have only one volume control/switch,
>> for capture. So, it would be a "master capture switch",
> Well, for such a cards we don't need to export
> the additional element, they are fine already.
> We can rename it to "Master Capture Switch",
> or may not.

Adding a new volume control that changes the mute values for the other controls
or renaming it don't solve anything.

>>  but I don't think
>> that there's such alsa "generic" volume control. Even in the case where
>> you have a volume control for the LINE OUT pin[1], in general, you also need to
>> unmute the capture, so, it would be a "master capture and LINE OUT switch",
>> and, for sure alsa currently not provide anything like that.
> I think you can still call it a "Master Capture Switch",
> if it enables everything.

That would be wrong.

>>> So, am I right that the only problem is that it is not
>>> exported to the user by some drivers right now?
>> No, you're mistaken again. Such "master capture and LINE OUT switch" type of control
>> _is_exported_ via the V4L2 API as V4L2_CID_AUDIO_MUTE. 
> Sorry, I meant the _alsa_ drivers here.
> So, to rephrase:
> 
> So, am I right that the only problem is that it is not
> exported to the user by some _alsa_ drivers right now?

I fail to see why this would be a problem.

The problem I see is that PA is trying to handle a V4L device as if it would be a 
normal audio capture pin, and starting a capture while the device is not ready for that,
as no input or TV/radio station were selected at the time PA starts capturing.

>> Some applications like mplayer don't use V4L2_CID_AUDIO_MUTE to unmute a video
>> device. They assume the current behavior that starting video also unmutes audio.
>> (mplayer is not symmetric with regard to the usage of this control, as it uses
>> V4L2_CID_AUDIO_MUTE to mute the device after the end of a capture).
>>
>> So, changing the logic at the drivers will break existing applications.
> I do not propose changing any V4L2 ioctls, my
> change concerns only the alsa driver.
> 
>> It is probably doable to split the mute control for the LINE OUT pin from the
>> mute control of the PCM capture. Such patch would make sense, as the alsa
>> capture doesn't need to touch at the line out pin, but the patch should
>> let V4L2_CID_AUDIO_MUTE control to affect both LINE OUT and PCM capture
>> mutes, otherwise applications will break.
> That's exactly what I was talking about from the very
> beginning, saying that the single control currently controls
> way too much, and providing an examples about 2 separate
> controls. But... I haven't found the way to implement that,
> not sure of this is possible at all. :(

It is doable, although it is probably not trivial.

Devices with saa7130 (PCI_DEVICE_ID_PHILIPS_SAA7130) doesn't enable the
alsa module, as they don't support I2S transfers, required for PCM audio.
So, we need to take care only on saa7133/4/5 devices.

The mute code is at saa7134-tvaudio.c, mute_input_7134() function. For
saa7134, it does:

        if (PCI_DEVICE_ID_PHILIPS_SAA7134 == dev->pci->device)
                /* 7134 mute */
                saa_writeb(SAA7134_AUDIO_MUTE_CTRL, mute ?
                                                    SAA7134_MUTE_MASK |
                                                    SAA7134_MUTE_ANALOG |
                                                    SAA7134_MUTE_I2S :
                                                    SAA7134_MUTE_MASK);

Clearly, there are two mute flags: SAA7134_MUTE_ANALOG and SAA7134_MUTE_I2S.

I2S is for PCM (as it is a digital audio interface). The other flag is for
analog.

So, if the device is a saa7134, it is easy to split the analog output and the
PCM one. For saa7133 and saa7135, you probably need to double check at the
datasheet, is is there a way to disable/enable just the I2S interface, but,
from saa7134_enable_i2s():
	/* Start I2S */
        saa_writeb(SAA7134_I2S_AUDIO_OUTPUT, 0x11);

I bet that there is some value (maybe 0?) that disables I2S transfers, muting
the PCM stream. It should be tested if saa7133/5 devices accept to enable/disable
PCM streams if the device is already streaming.

Cheers,
Mauro
