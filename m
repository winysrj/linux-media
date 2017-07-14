Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40266 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdGNHg0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 03:36:26 -0400
Subject: Re: [PATCH v2 08/14] v4l: vsp1: Add support for new VSP2-BS, VSP2-DL
 and VSP2-D instances
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-9-laurent.pinchart+renesas@ideasonboard.com>
 <22c14966-67d6-82b2-e305-d371efde0d23@ideasonboard.com>
 <27780346.YnnMpKiiFZ@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <ca98d6f0-ac69-8fdd-990b-c91cbee2462d@ideasonboard.com>
Date: Fri, 14 Jul 2017 08:36:20 +0100
MIME-Version: 1.0
In-Reply-To: <27780346.YnnMpKiiFZ@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/07/17 00:31, Laurent Pinchart wrote:
> Hi Kieran,
> 
> On Thursday 13 Jul 2017 18:49:19 Kieran Bingham wrote:
>> On 26/06/17 19:12, Laurent Pinchart wrote:
>>> New Gen3 SoCs come with two new VSP2 variants names VSP2-BS and VSP2-DL,
>>> as well as a new VSP2-D variant on V3M and V3H SoCs. Add new entries for
>>> them in the VSP device info table.
>>>
>>> Signed-off-by: Laurent Pinchart
>>> <laurent.pinchart+renesas@ideasonboard.com>
>>
>> Code in the patch looks OK - but I can't see where the difference between
>> the horizontal widths are supported between VSPD H3/VC
>>
>> I see this in the datasheet: (32.1.1.6 in this particular part)
>>
>> Direct connection to display module
>> — Supporting 4096 pixels in horizontal direction [R-Car H3/R-Car M3-W/ R-Car
>> M3-N]
>> — Supporting 2048 pixels in horizontal direction [R-Car V3M/R-Car V3H/R-Car
>> D3/R-Car E3]
>>
>> Do we have this information encoded anywhere? or are they just talking about
>> maximum performance capability there?
> 
> No, we don't. It's a limit that we should have. I think we should fix that in 
> a separate patch, as the 4096 pixels limit isn't implemented either.

I'm not so worried about these limits (unless they cause the hardware to hang),
but I think they should be encoded somewhere, and I would certainly count that
as a separate patch.

Of course (excluding pipelines using BRU/BRS) the partition algorithm could
provide the capability to support image processing beyond limitations of the
pipeline maximum size...

But this can't cater for throughput limitations of bandwidth so there will be a
limit to how big an image we really want to support ...

Non realtime processing of large megapixel images might be relevant though - but
still not a use case to worry about here.

>> Also some features that are implied as supported aren't mentioned - but
>> that's not a blocker to adding in the initial devices at all.
>>
>> Therefore:
>>
>> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>>> ---
>>>
>>>  drivers/media/platform/vsp1/vsp1_drv.c  | 24 ++++++++++++++++++++++++
>>>  drivers/media/platform/vsp1/vsp1_regs.h | 15 +++++++++++++--
>>>  2 files changed, 37 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
>>> b/drivers/media/platform/vsp1/vsp1_drv.c index 6a9aeb71aedf..c4f2ac61f7d2
>>> 100644
>>> --- a/drivers/media/platform/vsp1/vsp1_drv.c
>>> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
>>> @@ -710,6 +710,14 @@ static const struct vsp1_device_info
>>> vsp1_device_infos[] = {> 
>>>  		.num_bru_inputs = 5,
>>>  		.uapi = true,
>>>  	}, {
>>> +		.version = VI6_IP_VERSION_MODEL_VSPBS_GEN3,
>>> +		.model = "VSP2-BS",
>>> +		.gen = 3,
>>> +		.features = VSP1_HAS_BRS,
>>
>> 32.1.1.5 implies:
>> | VSP1_HAS_WPF_VFLIP
>>
>> But Figure 32.5 implies that it doesn't ...
> 
> The figures only tell whether the full combination of rotation and H/V flip is 
> available. I think you're right, I'll add VSP1_HAS_WPF_VFLIP.
> 
>> Figure 32.5 also implies that | VSP1_HAS_CLU is there too on both RPF0, and
>> RPF1
> 
> Note that CLUT != CLU. I know it's confusing :-)

Oh ! :-S ... /me goes back to the datasheet ...

> 
>>> +		.rpf_count = 2,
>>> +		.wpf_count = 1,
>>> +		.uapi = true,
>>> +	}, {
>>>  		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
>>>  		.model = "VSP2-D",
>>>  		.gen = 3,
>>> @@ -717,6 +725,22 @@ static const struct vsp1_device_info
>>> vsp1_device_infos[] = {> 
>>>  		.rpf_count = 5,
>>>  		.wpf_count = 2,
>>>  		.num_bru_inputs = 5,
>>> +	}, {
>>> +		.version = VI6_IP_VERSION_MODEL_VSPD_V3,
>>> +		.model = "VSP2-D",
>>> +		.gen = 3,
>>> +		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,
>>> +		.rpf_count = 5,
>>> +		.wpf_count = 1,
>>> +		.num_bru_inputs = 5,
>>> +	}, {
>>> +		.version = VI6_IP_VERSION_MODEL_VSPDL_GEN3,
>>> +		.model = "VSP2-DL",
>>> +		.gen = 3,
>>> +		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,
>>
>> Hrm. 32.1.1.7 says:
>> — Vertical flipping in case of output to memory.
>> So thats some sort of a conditional : | VSP1_HAS_WPF_VFLIP
>>
>> So looking at this and the settings of the existing models, I guess it looks
>> like we don't support flip if we have an LIF output (as that would then be
>> unsupported)
> 
> On Gen3 vertical flipping seems to always be supported, unlike on Gen2 where 
> VSPD is specifically documented as not supporting vertical flipping. We could 
> add the WFLIP on all VSP2-D* instances. This would create a corresponding 
> control, which wouldn't do much harm as the VSPD instances on Gen3 are not 
> exposed to userspace, but that would waste a bit of memory for no good purpose 
> (beside correctness I suppose). I wonder if that's worth it, what do you think 
> ? If so, VSP2-D should be fixed too, so I'd prefer doing that in a separate 
> patch.

I think it's only worth specifying the capability if it can be used. If we have
no way to set the control of a DU pipeline, then there's no point adding the
feature, and if the entity does not expose UAPI, then also there is no point
adding it.

We could set the feature flag but gate on has_uapi() or such ...

This is likely a small corner case so it can wait until we have a feature
request or something related.

--
Kieran

> 
>>> +		.rpf_count = 5,
>>> +		.wpf_count = 2,
>>> +		.num_bru_inputs = 5,
>>>  	},
>>>  };
>>>
> 
> [snip]
> 
