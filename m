Return-path: <linux-media-owner@vger.kernel.org>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:42006 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934230Ab3BNMGH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 07:06:07 -0500
Message-ID: <511CD0E1.9010003@stevekerrison.com>
Date: Thu, 14 Feb 2013 11:56:17 +0000
From: Steve Kerrison <steve@stevekerrison.com>
MIME-Version: 1.0
To: Michael Stilmant-Rovi <stilmant.michael.rovi@gmail.com>
CC: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: DVB_T2 Multistream support (PLP)
References: <CABXgeUHzMhk7rCtpoVuEz1zUYuGwUMEmxrFMKripnO8qvNX+Sg@mail.gmail.com> <510A821F.1060101@iki.fi> <CABXgeUF9dRS9zeWTCOGExRYOU3ZOxJ1bPZxM0GqogQOaUF580Q@mail.gmail.com>
In-Reply-To: <CABXgeUF9dRS9zeWTCOGExRYOU3ZOxJ1bPZxM0GqogQOaUF580Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

In terms of Linux support I think you will struggle. The 290e is the 
only DVB-T2 device with (open) driver support in Linux. I haven't tried 
a TBS5880 myself but the linuxtv Wiki page doesn't look promising 
http://www.linuxtv.org/wiki/index.php/TBS5880_USB_DVB-T2/T/C_CI_hybrid_TV_Box

In any case, that device will have the same demod (CXD2820R), and if 
what Antti says about the Windows driver not supporting multi-PLP either 
(if I've read his remarks correctly), you're probably out of luck.

As far as I know the CXD2820R is the only T2 demod that's made it into 
any USB/PCI receivers so there are no other options. There might be a 
datasheet somewhere that would hint at how to provide PLP selection and 
then it would need implementing. The question is where to find it and 
how much effort would be required.

Regards,
Steve.

On 31/01/13 15:02, Michael Stilmant-Rovi wrote:
> Thanks,
>
> Looking for a tuner supporting multiple PLP, is it conceivable to add
> to the driver the possibility to pass to the hardware that value? (I
> don't know if that need other math though) ( I will look the sources
> anyway but I don't have good knowledge)
>
> If I want to look for another USB stick how could I know if the driver
> will support that feature?
> For example is TBS5880 DVB-T2 USB TV Tuner ?
>
> I understand here that the difficulties is that few people are in a
> MultiPLP DVB_T2 range. even myself.. .
>
> Regards,
>
> On Thu, Jan 31, 2013 at 3:39 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 01/31/2013 04:27 PM, Michael Stilmant-Rovi wrote:
>>> Hello,
>>>
>>> I would like to know the support status of Multiple PLPs in DVB-T2.
>>> Is someone know if tests were performed in a broadcast with an
>>> effective Multistream? (PLP Id: 0 and 1 for example)
>>>
>>> I'm out of range of such multiplex but I'm trying some tunes on London
>>> DVB-T2 (CrystalPalace tower)
>>> "unfortunately" that mux seems Single PLP and everything work well :-(
>>>     ( yes tune always succeed :-D )
>>>
>>> I'm using DVB API 5.6.
>>> If I tune with FE_SET_PROPERTY without or with DTV_DVBT2_PLP_ID set to
>>> 0, 1 or 15. the tune succeed.
>>>
>>> I'm not sure of the expected behavior, I was expecting if I tune with
>>> plp_id 1 that the tuner would fail somewhere finding that stream.
>>>
>>> So in short I don't understand what is the requirements to be able to
>>> use the DVB_T2 Multistream support proposed in APIs:
>>>    o I see that the DVB API 5.8(?) had some patch at that level and so
>>> it is maybe requested?
>>>    o How can I know if my driver support that feature on DVB API 5.6?
>>> (PCTV nanoStick T2 290e)?
>>>
>>> Thank you for all indications.
>>>
>>> -Michael
>>
>> nanoStick T2 290e Linux driver does not support multiple PLPs. I did that
>> driver and I has only Live signal with single TS. What I think Windows
>> driver either supports that feature. It just tunes to first PLP regardless
>> of whole property and that's it.
>>
>> regards
>> Antti
>>
>> --
>> http://palosaari.fi/
> On Thu, Jan 31, 2013 at 3:39 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 01/31/2013 04:27 PM, Michael Stilmant-Rovi wrote:
>>> Hello,
>>>
>>> I would like to know the support status of Multiple PLPs in DVB-T2.
>>> Is someone know if tests were performed in a broadcast with an
>>> effective Multistream? (PLP Id: 0 and 1 for example)
>>>
>>> I'm out of range of such multiplex but I'm trying some tunes on London
>>> DVB-T2 (CrystalPalace tower)
>>> "unfortunately" that mux seems Single PLP and everything work well :-(
>>>     ( yes tune always succeed :-D )
>>>
>>> I'm using DVB API 5.6.
>>> If I tune with FE_SET_PROPERTY without or with DTV_DVBT2_PLP_ID set to
>>> 0, 1 or 15. the tune succeed.
>>>
>>> I'm not sure of the expected behavior, I was expecting if I tune with
>>> plp_id 1 that the tuner would fail somewhere finding that stream.
>>>
>>> So in short I don't understand what is the requirements to be able to
>>> use the DVB_T2 Multistream support proposed in APIs:
>>>    o I see that the DVB API 5.8(?) had some patch at that level and so
>>> it is maybe requested?
>>>    o How can I know if my driver support that feature on DVB API 5.6?
>>> (PCTV nanoStick T2 290e)?
>>>
>>> Thank you for all indications.
>>>
>>> -Michael
>>
>> nanoStick T2 290e Linux driver does not support multiple PLPs. I did that
>> driver and I has only Live signal with single TS. What I think Windows
>> driver either supports that feature. It just tunes to first PLP regardless
>> of whole property and that's it.
>>
>> regards
>> Antti
>>
>> --
>> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/

