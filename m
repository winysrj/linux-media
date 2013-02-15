Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57556 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab3BOPGz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 10:06:55 -0500
Received: by mail-ob0-f174.google.com with SMTP id 16so3669857obc.33
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 07:06:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511CD0E1.9010003@stevekerrison.com>
References: <CABXgeUHzMhk7rCtpoVuEz1zUYuGwUMEmxrFMKripnO8qvNX+Sg@mail.gmail.com>
 <510A821F.1060101@iki.fi> <CABXgeUF9dRS9zeWTCOGExRYOU3ZOxJ1bPZxM0GqogQOaUF580Q@mail.gmail.com>
 <511CD0E1.9010003@stevekerrison.com>
From: Michael Stilmant <stilmant.michael.rovi@gmail.com>
Date: Fri, 15 Feb 2013 16:06:34 +0100
Message-ID: <CABXgeUFcDjuO+KkGfYO0g5vbYdx0LVfLQ5j6jHJuLWi3FkTmTw@mail.gmail.com>
Subject: Re: DVB_T2 Multistream support (PLP)
To: Steve Kerrison <steve@stevekerrison.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Thank you.
Meanwhile I've contacted TBS and support told me that they have their
windows driver working (in lab) with multi PLP.
For now they don't want touching the Linux driver with that same
modification  because they wait confirmation on the field that the
Windows driver is working.
I'm not in Russia now therefore I can't confirm for them that their
windows driver works with a real life DVB-T2 broadcast...

I will maybe have an access in Tomsk but I'm not sure yet if there is
DVB-T2 broadcast with a multi PLP there...

Eventually, is there somebody in Russia under a DVB-T2 multi PLP
broadcast range?

Regards,

On Thu, Feb 14, 2013 at 12:56 PM, Steve Kerrison
<steve@stevekerrison.com> wrote:
> Hi Michael,
>
> In terms of Linux support I think you will struggle. The 290e is the only
> DVB-T2 device with (open) driver support in Linux. I haven't tried a TBS5880
> myself but the linuxtv Wiki page doesn't look promising
> http://www.linuxtv.org/wiki/index.php/TBS5880_USB_DVB-T2/T/C_CI_hybrid_TV_Box
>
> In any case, that device will have the same demod (CXD2820R), and if what
> Antti says about the Windows driver not supporting multi-PLP either (if I've
> read his remarks correctly), you're probably out of luck.
>
> As far as I know the CXD2820R is the only T2 demod that's made it into any
> USB/PCI receivers so there are no other options. There might be a datasheet
> somewhere that would hint at how to provide PLP selection and then it would
> need implementing. The question is where to find it and how much effort
> would be required.
>
> Regards,
> Steve.
>
>
> On 31/01/13 15:02, Michael Stilmant-Rovi wrote:
>>
>> Thanks,
>>
>> Looking for a tuner supporting multiple PLP, is it conceivable to add
>> to the driver the possibility to pass to the hardware that value? (I
>> don't know if that need other math though) ( I will look the sources
>> anyway but I don't have good knowledge)
>>
>> If I want to look for another USB stick how could I know if the driver
>> will support that feature?
>> For example is TBS5880 DVB-T2 USB TV Tuner ?
>>
>> I understand here that the difficulties is that few people are in a
>> MultiPLP DVB_T2 range. even myself.. .
>>
>> Regards,
>>
>> On Thu, Jan 31, 2013 at 3:39 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> On 01/31/2013 04:27 PM, Michael Stilmant-Rovi wrote:
>>>>
>>>> Hello,
>>>>
>>>> I would like to know the support status of Multiple PLPs in DVB-T2.
>>>> Is someone know if tests were performed in a broadcast with an
>>>> effective Multistream? (PLP Id: 0 and 1 for example)
>>>>
>>>> I'm out of range of such multiplex but I'm trying some tunes on London
>>>> DVB-T2 (CrystalPalace tower)
>>>> "unfortunately" that mux seems Single PLP and everything work well :-(
>>>>     ( yes tune always succeed :-D )
>>>>
>>>> I'm using DVB API 5.6.
>>>> If I tune with FE_SET_PROPERTY without or with DTV_DVBT2_PLP_ID set to
>>>> 0, 1 or 15. the tune succeed.
>>>>
>>>> I'm not sure of the expected behavior, I was expecting if I tune with
>>>> plp_id 1 that the tuner would fail somewhere finding that stream.
>>>>
>>>> So in short I don't understand what is the requirements to be able to
>>>> use the DVB_T2 Multistream support proposed in APIs:
>>>>    o I see that the DVB API 5.8(?) had some patch at that level and so
>>>> it is maybe requested?
>>>>    o How can I know if my driver support that feature on DVB API 5.6?
>>>> (PCTV nanoStick T2 290e)?
>>>>
>>>> Thank you for all indications.
>>>>
>>>> -Michael
>>>
>>>
>>> nanoStick T2 290e Linux driver does not support multiple PLPs. I did that
>>> driver and I has only Live signal with single TS. What I think Windows
>>> driver either supports that feature. It just tunes to first PLP
>>> regardless
>>> of whole property and that's it.
>>>
>>> regards
>>> Antti
>>>
>>> --
>>> http://palosaari.fi/
>>
>> On Thu, Jan 31, 2013 at 3:39 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> On 01/31/2013 04:27 PM, Michael Stilmant-Rovi wrote:
>>>>
>>>> Hello,
>>>>
>>>> I would like to know the support status of Multiple PLPs in DVB-T2.
>>>> Is someone know if tests were performed in a broadcast with an
>>>> effective Multistream? (PLP Id: 0 and 1 for example)
>>>>
>>>> I'm out of range of such multiplex but I'm trying some tunes on London
>>>> DVB-T2 (CrystalPalace tower)
>>>> "unfortunately" that mux seems Single PLP and everything work well :-(
>>>>     ( yes tune always succeed :-D )
>>>>
>>>> I'm using DVB API 5.6.
>>>> If I tune with FE_SET_PROPERTY without or with DTV_DVBT2_PLP_ID set to
>>>> 0, 1 or 15. the tune succeed.
>>>>
>>>> I'm not sure of the expected behavior, I was expecting if I tune with
>>>> plp_id 1 that the tuner would fail somewhere finding that stream.
>>>>
>>>> So in short I don't understand what is the requirements to be able to
>>>> use the DVB_T2 Multistream support proposed in APIs:
>>>>    o I see that the DVB API 5.8(?) had some patch at that level and so
>>>> it is maybe requested?
>>>>    o How can I know if my driver support that feature on DVB API 5.6?
>>>> (PCTV nanoStick T2 290e)?
>>>>
>>>> Thank you for all indications.
>>>>
>>>> -Michael
>>>
>>>
>>> nanoStick T2 290e Linux driver does not support multiple PLPs. I did that
>>> driver and I has only Live signal with single TS. What I think Windows
>>> driver either supports that feature. It just tunes to first PLP
>>> regardless
>>> of whole property and that's it.
>>>
>>> regards
>>> Antti
>>>
>>> --
>>> http://palosaari.fi/
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Steve Kerrison MEng Hons.
> http://www.stevekerrison.com/
>
