Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52290 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750716AbdJLGuf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 02:50:35 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
 <d5034d03-1ef4-0253-0efc-ae7fd5cb09e9@ti.com>
 <9f921701-910c-d749-378c-038e8405f656@xs4all.nl>
 <f5d93c33-7825-1034-a605-ee38c796ca20@ti.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <185e0c6e-8776-67e3-363f-fe9ebef3ba29@xs4all.nl>
Date: Thu, 12 Oct 2017 08:50:28 +0200
MIME-Version: 1.0
In-Reply-To: <f5d93c33-7825-1034-a605-ee38c796ca20@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On 08/22/2017 11:44 AM, Tomi Valkeinen wrote:
> Hi Hans,
> 
>>>
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
> 
> On 11/08/17 13:57, Tomi Valkeinen wrote:
>>>
>>>> I'm doing some testing with this series on my panda. One issue I see is
>>>> that when I unload the display modules, I get:
>>>>
>>>> [   75.180206] platform 58006000.encoder: enabled after unload, idling
>>>> [   75.187896] platform 58001000.dispc: enabled after unload, idling
>>>> [   75.198242] platform 58000000.dss: enabled after unload, idling
>>>
>>> This one is caused by hdmi_cec_adap_enable() never getting called with
>>> enable=false when unloading the modules. Should that be called
>>> explicitly in hdmi4_cec_uninit, or is the CEC framework supposed to call it?
>>
>> Nicely found!
>>
>> The cec_delete_adapter() function calls __cec_s_phys_addr(CEC_PHYS_ADDR_INVALID)
>> which would normally call adap_enable(false), except when the device node was
>> already unregistered, in which case it just returns immediately.
>>
>> The patch below should fix this. Let me know if it works, and I'll post a proper
>> patch and get that in for 4.14 (and possible backported as well, I'll have to
>> look at that).
> 
> Thanks, this fixes the issue.
> 
> I again saw "HDMICORE: omapdss HDMICORE error: operation stopped when
> reading edid" when I loaded the modules. My panda also froze just now
> when unloading the display modules, and it doesn't react to sysrq.
> 
> After testing a bit without the CEC patches, I saw the above error, so I
> don't think it's related to your patches.
> 
> I can't test with a TV, so no CEC for me... But otherwise I think the
> series works ok now, and looks ok. So I'll apply, but it's a bit late
> for the next merge window, so I'll aim for 4.15 with this.

What is the status? Do you need anything from me? I'd like to get this in for 4.15.

Regards,

	Hans
