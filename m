Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:59514 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3BTSOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Feb 2013 13:14:51 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so4263850eei.3
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2013 10:14:49 -0800 (PST)
Message-ID: <512512C9.5070604@googlemail.com>
Date: Wed, 20 Feb 2013 19:15:37 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mr Goldcove <goldcove@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Wrongly identified easycap em28xx
References: <512294CA.3050401@gmail.com> <51229C2D.8060700@googlemail.com> <5122ACDF.1020705@gmail.com> <5123ACA0.2060503@googlemail.com> <20130219153024.6f468d43@redhat.com> <5123C849.6080207@googlemail.com> <20130219155303.25c5077a@redhat.com> <5123D651.1090108@googlemail.com> <20130219170343.00b92d18@redhat.com> <5123F94E.4090107@googlemail.com> <20130219194208.18210419@redhat.com>
In-Reply-To: <20130219194208.18210419@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.02.2013 23:42, schrieb Mauro Carvalho Chehab:
> Em Tue, 19 Feb 2013 23:14:38 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 19.02.2013 21:03, schrieb Mauro Carvalho Chehab:
>>> Em Tue, 19 Feb 2013 20:45:21 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>> It comes down to the following question:
>>>> Do we want to refuse fixing known/existing devices for the sake of
>>>> avoiding regression for unknown devices which even might not exist ? ;-)
>>> HUH? As I said: there are devices that work with the other board entry.
>>> If you remove the other entry, _then_ you'll be breaking the driver.
>> Which devices _with_audio_support_ are working with
>> EM2860_BOARD_SAA711X_REFERENCE_DESIGN ?
>>
>> AFAIK, the existence of such a device is pure theory at the moment.
>> But the Easycap DC-60 is reality !
> See the mailing lists archives. This driver is older than linux-media ML,
> and it used to have a separate em28xx mailing list in the past. Not sure
> if are there any mirror preserving the old logs for the em28xx ML, as this
> weren't hosted here.

Poor argumentation.
No evidences, just speculations.

> Please, don't pretend that you know all supported em28xx devices.

Huh ???
I didn't do that. Instead I pointed out risk due to the fact that we do
_not_ know all existing devices.
It was actually _you_ who pretended to know such devices, but you failed
to show us at least one of them.


>>>> I have no strong and final opinion yet. Still hoping someone knows how
>>>> the Empia driver handles these cases...
>>> What do you mean? The original driver? The parameters are hardcoded at the
>>> *.inf file. Once you get the driver, the *.inf file contains all the
>>> parameters for it to work there. If you have two empia devices with
>>> different models, you can only use the second one after removing the
>>> install for the first one.
>> Are you sure about that ? That's the worst case.
> Yes, I'm pretty sure about that.
>
>>>>> or to use the AC97
>>>>> chip ID as a hint. This works fine for devices that don't come with
>>>>> Empiatech em202, but with something else, like the case of the Realtek
>>>>> chip found on this device. The reference design for sure uses em202.
>>>> How could the AC97 chip ID help us in this situation ?
>>>> As far as I understand, it doesn't matter which AC97 IC is used.
>>>> They are all compatible and at least our driver uses the same code for
>>>> all of them.
>>> The em28xx Kernel driver uses a hint code to try to identify the device
>>> model. That hint code is not perfect, but it is the better we can do.
>>>
>>> There are two hint codes there, currently: 
>>> 1) device's eeprom hash, used when the device has an eeprom, but the
>>>    USB ID is not unique;
>>>
>>> 2) I2C scan bus hash: sometimes, different devices use different I2C
>>> addresses.
>> ???
>>
>> Again, how can the AC97 chip ID help us in this situation ?
>> You just described the current board hint mechanism which clearly fails
>> in this case.
>>
>>>> So even if you are are right and the Empia reference design uses an EMP202,
>>>> EM2860_BOARD_SAA711X_REFERENCE_DESIGN might work for devices with other
>>>> AC97-ICs, too.
>>> The vast majority of devices use emp202. There are very few ones using
>>> different models.
>>>
>>> The proposal here is to add a third hint code, that would distinguish
>>> the devices based on the ac97 ID.
>> I already explained why this is a potential source for regressions, too.
> Yes, that may mean that other devices will need other entries, if are out
> there any device that looks like the reference design.

So regressions are acceptable for you ?

> Yet, such device IS NOT the reference design, as it is very doubtful 
> that Empia would be shipping their reference design with an AC97
> chip manufactured by another vendor.

Hmm... you seem to make a lot of assumptions about board
EM2860_BOARD_SAA711X_REFERENCE_DESIGN...

Are you aware that it was called EM2860_BOARD_POINTNIX_INTRAORAL_CAMERA
before commit 3ed58baf ?
According to the commit message it seems like it has been renamed just
because a second device appeared.
The commit message also mentions that both devices known at this time
didn't have ("real") audio support, which is the reason why there is no
amux defined for the inputs.
So the audio configuration of this board is EM28XX_AMUX_VIDEO likely
just because there is no EM28XX_AMUX_NONE and noone ever tested it.

Why are you sure that this configuration matches the official Empia
reference board design (including the audio config) ?
Do you have any information from Empia about that ?

The second question is: do you think we can assume that the majority of
the devices with generic USB IDs are following the reference design ?

It should be easy to find out if the Easycap DC-60 follows the Empia
reference design by testing if it works with the generic Empia Windows
driver (http://home.eeti.com.tw/web20/eg/IC_support.htm).


Regards,
Frank

> There are, however, lots of device that just gets the Empia reference
> design as-is (the same applies to other vendors) and only "designs" a box with
> their logo. This is specially true for simpler devices like capture boards,
> where there are just a very few set of components on it.
>
> Cheers,
> Mauro

