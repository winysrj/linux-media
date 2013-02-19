Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40791 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3BSWNw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 17:13:52 -0500
Received: by mail-ea0-f182.google.com with SMTP id a12so2991233eaa.27
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2013 14:13:50 -0800 (PST)
Message-ID: <5123F94E.4090107@googlemail.com>
Date: Tue, 19 Feb 2013 23:14:38 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mr Goldcove <goldcove@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Wrongly identified easycap em28xx
References: <512294CA.3050401@gmail.com> <51229C2D.8060700@googlemail.com> <5122ACDF.1020705@gmail.com> <5123ACA0.2060503@googlemail.com> <20130219153024.6f468d43@redhat.com> <5123C849.6080207@googlemail.com> <20130219155303.25c5077a@redhat.com> <5123D651.1090108@googlemail.com> <20130219170343.00b92d18@redhat.com>
In-Reply-To: <20130219170343.00b92d18@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.02.2013 21:03, schrieb Mauro Carvalho Chehab:
> Em Tue, 19 Feb 2013 20:45:21 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 19.02.2013 19:53, schrieb Mauro Carvalho Chehab:
>>> Em Tue, 19 Feb 2013 19:45:29 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>>> I don't like the idea of merging those two entries. As far as I remember
>>>>> there are devices that works out of the box with
>>>>> EM2860_BOARD_SAA711X_REFERENCE_DESIGN. A change like that can break
>>>>> the driver for them.
>>>> As described above, there is a good chance to break devices with both
>>>> solutions.
>>>>
>>>> What's your suggestion ? ;-)
>>>>
>>> As I said, just leave it as-is (documenting at web) 
>> That seems to be indeed the only 100%-regression-safe solution.
>> But also _no_ solution for this device.
>> A device which works only with a special module parameter passed on
>> driver loading isn't much better than an unsupported device.
> That's not true. There are dozens of devices that only work with
> modprobe parameter (even ones with their own USB or PCI address).

So the fact that we handle plenty devices this way makes the situation
for the user better ? ;-)
Not really !

>  The thing
> is that crappy vendors don't provide any way for a driver to detect what's
> there, as their driver rely on some *.inf config file with those parameters
> hardcoded.
>
> We can't do any better than what's provided by the device.
>
>> It comes down to the following question:
>> Do we want to refuse fixing known/existing devices for the sake of
>> avoiding regression for unknown devices which even might not exist ? ;-)
> HUH? As I said: there are devices that work with the other board entry.
> If you remove the other entry, _then_ you'll be breaking the driver.

Which devices _with_audio_support_ are working with
EM2860_BOARD_SAA711X_REFERENCE_DESIGN ?

AFAIK, the existence of such a device is pure theory at the moment.
But the Easycap DC-60 is reality !


>
>> I have no strong and final opinion yet. Still hoping someone knows how
>> the Empia driver handles these cases...
> What do you mean? The original driver? The parameters are hardcoded at the
> *.inf file. Once you get the driver, the *.inf file contains all the
> parameters for it to work there. If you have two empia devices with
> different models, you can only use the second one after removing the
> install for the first one.

Are you sure about that ? That's the worst case.

>
>>> or to use the AC97
>>> chip ID as a hint. This works fine for devices that don't come with
>>> Empiatech em202, but with something else, like the case of the Realtek
>>> chip found on this device. The reference design for sure uses em202.
>> How could the AC97 chip ID help us in this situation ?
>> As far as I understand, it doesn't matter which AC97 IC is used.
>> They are all compatible and at least our driver uses the same code for
>> all of them.
> The em28xx Kernel driver uses a hint code to try to identify the device
> model. That hint code is not perfect, but it is the better we can do.
>
> There are two hint codes there, currently: 
> 1) device's eeprom hash, used when the device has an eeprom, but the
>    USB ID is not unique;
>
> 2) I2C scan bus hash: sometimes, different devices use different I2C
> addresses.

???

Again, how can the AC97 chip ID help us in this situation ?
You just described the current board hint mechanism which clearly fails
in this case.

>
>> So even if you are are right and the Empia reference design uses an EMP202,
>> EM2860_BOARD_SAA711X_REFERENCE_DESIGN might work for devices with other
>> AC97-ICs, too.
> The vast majority of devices use emp202. There are very few ones using
> different models.
>
> The proposal here is to add a third hint code, that would distinguish
> the devices based on the ac97 ID.

I already explained why this is a potential source for regressions, too.

Regards,
Frank


>
>> We should also expect manufacturers to switch between them whenever they
>> want (e.g. because of price changes).
> Yes, and then we'll need other entries at the hint table.
>
> Regards
> Mauro

