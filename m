Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63520 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab3BTSWg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Feb 2013 13:22:36 -0500
Received: by mail-ee0-f49.google.com with SMTP id d4so4113447eek.8
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2013 10:22:35 -0800 (PST)
Message-ID: <5125149C.6030208@googlemail.com>
Date: Wed, 20 Feb 2013 19:23:24 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mr Goldcove <goldcove@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Wrongly identified easycap em28xx
References: <512294CA.3050401@gmail.com> <51229C2D.8060700@googlemail.com> <5122ACDF.1020705@gmail.com> <5123ACA0.2060503@googlemail.com> <20130219153024.6f468d43@redhat.com> <5123C849.6080207@googlemail.com> <20130219155303.25c5077a@redhat.com> <5123D651.1090108@googlemail.com> <20130219170343.00b92d18@redhat.com> <alpine.LNX.2.02.1302192234130.27265@banach.math.auburn.edu> <20130220075134.4d07213f@redhat.com>
In-Reply-To: <20130220075134.4d07213f@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<snip>

Am 20.02.2013 11:51, schrieb Mauro Carvalho Chehab:
> Em Tue, 19 Feb 2013 23:09:16 -0600 (CST)
> Theodore Kilgore <kilgota@banach.math.auburn.edu> escreveu:
>
>> On Tue, 19 Feb 2013, Mauro Carvalho Chehab wrote:
>>
>>>> So even if you are are right and the Empia reference design uses an EMP202,
>>>> EM2860_BOARD_SAA711X_REFERENCE_DESIGN might work for devices with other
>>>> AC97-ICs, too.
>>> The vast majority of devices use emp202. There are very few ones using
>>> different models.
>>>
>>> The proposal here is to add a third hint code, that would distinguish
>>> the devices based on the ac97 ID.
>>>
>>>> We should also expect manufacturers to switch between them whenever they
>>>> want (e.g. because of price changes).
>>> Yes, and then we'll need other entries at the hint table.
>>>
>>> Regards
>>> Mauro
>> I see the dilemma. Devices which are not uniquely identifiable. Mauro is 
>> right in pinpointing the problem, and he is also right that one can not 
>> expect the manufacturers to pay any attention. Mauro is also absolutely 
>> right that it is not good to break what works already for some people, 
>> hoping to please some others who are presently unhappy. A better solution 
>> needs to be found.
>>
>> Could I make a suggestion?
>>
>> Sometimes it is possible to find some undocumented way to identify 
>> uniquely which one of two devices you have. 
> The hardware is identical, except for the audio decoder. Both devices have
> only 3 chips on it: the em2860 chip, an saa7113 video decoder and the ac97
> audio mixer, that it is different on each device. 
>
> One board comes with an ac97 chip ID=0xffffffff [1](emp202, found on the
> reference design and clones). The other one comes with an ac97 chip 
> with ID=0x414c4761 (a Realtek ALC653, only found so far on EasyCap DC-60).
>
> Btw, the issue between them is because of the different mixers found:
> the mixer channel used by the DC-60 is different than the mixer channel
> used by the reference design. At the reference design, the audio
> channel is EM28XX_AMUX_VIDEO. At DC-60, it is EM28XX_AMUX_LINE_IN.

Now you got it.
The relevant difference is the _channel_configuration_, not the used
AC97 IC manufacturer+model.

> I can't think on any other way do distinguish between them except by
> checking if the audio decoder matches the expected one.
>
> Adding a logic for such check is simple enough, as the probing logic already
> contains the needed bits for it.

I'm not convinced, for the following reasons:
You can't infer from the usage of a particular AC97 IC how the device is
wired internally / which channel configuration it uses.
We also can't assume a fixed binding between a particular AC97 IC and a
product/board.

So _if_ we really decide to leave the conservative path and take the
risk of regressions for the sake of fixing other devices,
we should at least be sure that we fix more devices than we break. (Even
then it still sucks !)

Regards,
Frank

> [1] There is a variant of emp202 at address 0x83847650.
>
> Regards,
> Mauro

