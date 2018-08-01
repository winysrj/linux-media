Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38251 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389907AbeHASKU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 14:10:20 -0400
Received: by mail-wm0-f67.google.com with SMTP id t25-v6so7684120wmi.3
        for <linux-media@vger.kernel.org>; Wed, 01 Aug 2018 09:23:50 -0700 (PDT)
Subject: Re: [PATCH 18/22] partial revert of "[media] tvp5150: add HW input
 connectors support"
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-19-m.felsch@pengutronix.de>
 <20180730151842.0fd99d01@coco.lan>
 <3a9f8715-a3a6-b250-82ad-6f2df6500767@redhat.com>
 <20180731070659.43afe417@coco.lan>
 <759d76b0-dab2-17bb-970c-38233bafc708@redhat.com>
 <20180731123652.r23m4zlkdulet22z@pengutronix.de>
 <7c849709-f3e4-98bb-fad9-a85f6e90bb71@redhat.com>
 <20180731133056.rqaolpoz7lea4y4f@pengutronix.de>
 <20180801154917.dtopi2ubmqff7ru2@pengutronix.de>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <2577d2dd-2b87-9ef5-b2f0-7c188cb97efe@redhat.com>
Date: Wed, 1 Aug 2018 18:23:29 +0200
MIME-Version: 1.0
In-Reply-To: <20180801154917.dtopi2ubmqff7ru2@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marco,

On 08/01/2018 05:49 PM, Marco Felsch wrote:
> Hi Javier,
> 
> On 18-07-31 15:30, Marco Felsch wrote:
>> Hi Javier,
>>
>> On 18-07-31 14:52, Javier Martinez Canillas wrote:
>>> Hi Marco,
>>>
>>> On 07/31/2018 02:36 PM, Marco Felsch wrote:
>>>
>>> [snip]
>>>
>>>>>
>>>>> Yes, another thing that patch 19/22 should take into account is DTs that
>>>>> don't have input connectors defined. So probably TVP5150_PORT_YOUT should
>>>>> be 0 instead of TVP5150_PORT_NUM - 1 as is the case in the current patch.
>>>>>
>>>>> In other words, it should work both when input connectors are defined in
>>>>> the DT and when these are not defined and only an output port is defined.
>>>>
>>>> Yes, it would be a approach to map the output port dynamicaly to the
>>>> highest port number. I tried to keep things easy by a static mapping.
>>>> Maybe a follow up patch can change this behaviour.
>>>>
>>>> Anyway, input connectors aren't required. There must be at least one
>>>> port child node with a correct port-number in the DT.
>>>>
>>>
>>> Yes, that was my point. But your patch uses the port child reg property as
>>> the index for the struct device_node *endpoints[TVP5150_PORT_NUM] array.
>>>
>>> If there's only one port child (for the output) then the DT binding says
>>> that the reg property isn't required, so this will be 0 and your patch will
>>> wrongly map it to TVP5150_PORT_AIP1A. That's why I said that the output port
>>> should be the first one in your enum tvp5150_ports and not the last one.
>>
>> Yes, now I got you. I implemted this in such a way in my first apporach.
>> But at the moment I don't know why I changed this. Maybe to keep the
>> decoder->input number in sync with the em28xx devices, which will set the
>> port by the s_routing() callback.
>>
>> Let me check this.
> 
> I checked it again. Your're right, it should be doable but IMHO it isn't
> the right solution. I checked some drivers which use of_graph and all of
> them put the output at the end. So the tvp5150 will be the only one
> which maps the out put to the first pad and it isn't intuitive.
> 

Ah, I didn't notice that the tvp5150 was the exception. I just mentioned due
DT maintainers always ask for driver changes to be DTB backward compatible.

> I discused it with a colleague. We think a better solution would be to fix
> the v4l2-core parser code to allow a independent dt-port<->pad mapping.
> Since now the pad's correspond to the port number. This mapping should
> be done by a driver callback, so each driver can do it's own custom
> mapping.
>

That sounds good to me.
 
> Regards,
> Marco
> 

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
