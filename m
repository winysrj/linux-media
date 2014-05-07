Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46624 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaEGPdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 May 2014 11:33:49 -0400
Message-id: <536A5258.3080104@samsung.com>
Date: Wed, 07 May 2014 17:33:44 +0200
From: Tomasz Figa <t.figa@samsung.com>
MIME-version: 1.0
To: Rahul Sharma <rahul.sharma@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	sunil joshi <joshi@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Grant Likely <grant.likely@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Pawel Moll <Pawel.Moll@arm.com>
Subject: Re: [PATCHv2 1/3] phy: Add exynos-simple-phy driver
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
 <1396967856-27470-2-git-send-email-t.stanislaws@samsung.com>
 <534506B1.4040908@samsung.com>
 <CAPdUM4M109_kzY6cUMJQPSwgazvWmNDWL1JeXgiqnzvH8dhK2Q@mail.gmail.com>
 <53451A60.4050803@samsung.com> <53675D72.70103@ti.com>
 <CAPdUM4N+2VXpiFSiWW9gKfbte1zkpDbCOSF+KvEo4T1KLqqwjw@mail.gmail.com>
 <536A36F5.5080303@samsung.com>
 <CAPdUM4M6uk2KN_L487_cRkOqbgJrhhMRx9zpczA6-3LzSM3FSg@mail.gmail.com>
In-reply-to: <CAPdUM4M6uk2KN_L487_cRkOqbgJrhhMRx9zpczA6-3LzSM3FSg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[CCing more DT-folks :)]

On 07.05.2014 16:19, Rahul Sharma wrote:
> On 7 May 2014 19:06, Tomasz Stanislawski <t.stanislaws@samsung.com> wrote:
>> On 05/07/2014 12:38 PM, Rahul Sharma wrote:
>>> On 5 May 2014 15:14, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>>> Hi,
>>>>
>>>> On Wednesday 09 April 2014 03:31 PM, Sylwester Nawrocki wrote:
>>>>> Hi,
>>>>>
>>>>> On 09/04/14 11:12, Rahul Sharma wrote:
>>>>>> Idea looks good. How about keeping compatible which is independent
>>>>>> of SoC, something like "samsung,exynos-simple-phy" and provide Reg
>>>>>> and Bit through phy provider node. This way we can avoid SoC specific
>>>>>> hardcoding in phy driver and don't need to look into dt bindings for
>>>>>> each new SoC.
>>>>>
>>>>> I believe it is a not recommended approach.
>>>>
>>>> Why not? We should try to avoid hard coding in the driver code. Moreover by
>>>> avoiding hardcoding we can make it a generic driver for single bit PHYs.
>>>>
>>>
>>> +1.
>>>
>>> @Tomasz, any plans to consider this approach for simple phy driver?
>>>
>>> Regards,
>>> Rahul Sharma.
>>>
>>
>> Hi Rahul,
>> Initially, I wanted to make a very generic driver and to add bit and
>> register (or its offset) attribute to the PHY node.
>> However, there was a very strong opposition from DT maintainers
>> to adding any bit related configuration to DT.
>> The current solution was designed to be a trade-off between
>> being generic and being accepted :).
>>
> 
> Thanks Tomasz,
> Ok got it. lets discuss it again and conclude it.
> 
> @Kishon, DT-folks,
> 
> The original RFC patch from Tomasz (at https://lkml.org/lkml/2013/10/21/313)
> added simple phy driver as "Generic-simple-phy" with these properties:
> 
> + of_property_read_u32(dev->of_node, "mask", &sphy->mask);
> + of_property_read_u32(dev->of_node, "on-value", &sphy->on_value);
> + of_property_read_u32(dev->of_node, "off-value", &sphy->off_value);
> 
> Shall we consider the same solution again for generic simple phy
> driver which just expose on/off control through register bit.
> 
> Regards,
> Rahul Sharma
> 
>> Regards,
>> Tomasz Stanislawski
>>
>>
>>
>>>> Cheers
>>>> Kishon
>>>
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Best regards,
Tomasz
