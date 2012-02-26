Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:38888 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab2BZXk6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 18:40:58 -0500
Message-ID: <4F4AC2D5.1060007@iki.fi>
Date: Mon, 27 Feb 2012 01:40:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 26/33] omap3isp: Default link validation for ccp2,
 csi2, preview and resizer
References: <20120220015605.GI7784@valkosipuli.localdomain> <4620159.TXeRQHhZdd@avalon> <20120225013436.GC12602@valkosipuli.localdomain> <2204981.cc3x3nBuNt@avalon>
In-Reply-To: <2204981.cc3x3nBuNt@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Saturday 25 February 2012 03:34:36 Sakari Ailus wrote:
>> On Wed, Feb 22, 2012 at 12:01:26PM +0100, Laurent Pinchart wrote:
>>> On Monday 20 February 2012 03:57:05 Sakari Ailus wrote:
>>>> Use default link validation for ccp2, csi2, preview and resizer. On
>>>> ccp2, csi2 and ccdc we also collect information on external subdevs as
>>>> one may be connected to those entities.
>>>>
>>>> The CCDC link validation still must be done separately.
>>>>
>>>> Also set pipe->external correctly as we go
> 
> [snip]
> 
>>>> @@ -1999,6 +1999,27 @@ static int ccdc_set_format(struct v4l2_subdev
>>>> *sd,
>>>> struct v4l2_subdev_fh *fh, return 0;
>>>>
>>>>  }
>>>>
>>>> +static int ccdc_link_validate(struct v4l2_subdev *sd,
>>>> +			      struct media_link *link,
>>>> +			      struct v4l2_subdev_format *source_fmt,
>>>> +			      struct v4l2_subdev_format *sink_fmt)
>>>> +{
>>>> +	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
>>>> +	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
>>>> +	int rval;
>>>> +
>>>> +	/* We've got a parallel sensor here. */
>>>> +	if (ccdc->input == CCDC_INPUT_PARALLEL) {
>>>> +		pipe->external =
>>>> +			media_entity_to_v4l2_subdev(link->source->entity);
>>>> +		rval = omap3isp_get_external_info(pipe, link);
>>>> +		if (rval < 0)
>>>> +			return 0;
>>>> +	}
>>>
>>> Pending my comments on 25/33, this wouldn't be needed in this patch, and
>>> could be squashed with 27/33.
>>
>> If I moved this code out of pipeline validation, I'd have to walk the graph
>> one additional time. Do you think it's worth it, or are there easier ways to
>> find the external entity connected to a pipeline?
> 
> If I understand you correctly, the problem is that 
> omap3isp_get_external_info() can only be called when the external entity has 
> been located, and the CCDC link validation operation would be called before 
> that. Is that correct ?
> 
> One option would be to locate the external entity before validating the link. 
> When the validation pipeline walk operation gets to the CCDC entity, it would 
> first follow the link, check if the connected entity is external (and in that 
> case sotre it in pipe->external and call omap3isp_get_external_info()), and 
> then only call the CCDC link validation operation.
> 
> The other option is to leave the code as-is :-) Or rather modify it slightly: 
> assigning the entity to pipe->external and calling 
> omap3isp_get_external_info() should be done in ispvideo.c at pipeline 
> validation time.

I've modified it so that the entities which are part of the pipe will be
disovered by media_entity_pipeline_start() and stored in struct
media_pipeline.entities (as bitmask).

It's trivial to figure out the external entity from that one in the ISP
driver.

I did it so since I assume pretty much every single driver supporting
any non-linear data path must perform the same. It's also almost no work
in doing this in the above function, compared to a relatively
significant headache in the ISP driver.

I'll resend the patchset once I've gotten your reply on my selections
documentation changes. :-)

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
