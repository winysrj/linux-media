Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47089 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbeDDQP3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 12:15:29 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH 10/15] v4l: vsp1: Move DRM pipeline output setup code to a
 function
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-11-laurent.pinchart+renesas@ideasonboard.com>
 <daa6e220-0e20-d8cc-717a-dc9083ca8baf@ideasonboard.com>
 <3938270.yYcQyIxAEm@avalon>
Message-ID: <4a4f5fd1-4345-5f74-2a10-dadd0e1ba130@ideasonboard.com>
Date: Wed, 4 Apr 2018 17:15:19 +0100
MIME-Version: 1.0
In-Reply-To: <3938270.yYcQyIxAEm@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/04/18 13:35, Laurent Pinchart wrote:

<snip>

>>> +/* Setup the output side of the pipeline (WPF and LIF). */
>>> +static int vsp1_du_pipeline_setup_output(struct vsp1_device *vsp1,
>>> +					 struct vsp1_pipeline *pipe)
>>> +{
>>> +	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
>>> +	struct v4l2_subdev_format format = {
>>> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>>
>> Why do you initialise this .which here, but all the other member variables
>> below.
>>
>> Wouldn't it make more sense to group all of this initialisation together? or
>> is there a distinction in keeping the .which separate.
>>
>> (Perhaps this is just a way to initialise the rest of the structure to 0,
>> without using the memset?)
> 
> The initialization of the .which field is indeed there to avoid the memset, 
> but other than that there's no particular reason. I find it clearer to keep 
> the initialization of the structure close to the code that makes use of it 
> (the next v4l2_subdev_call in this case).
> 
> As initializing all members when declaring the variable doesn't make a change 
> in code size (gcc 6.4.0) but increases .rodata by 18 bytes and decreases 
> __modver by the same amount, I'm tempted to leave it as-is unless you think it 
> should be changed.

I'm happy to leave it as is - the query was as much to understand why the change
was the way it was :D

But on that logic (reducing .rodata, or rather not increasing it) what's the
benefit of initialising with one (random/psuedo random) member variable over
initialising to all zero, then initialising the .which alongside the rest of
them? Wouldn't the compiler just use the zero page or such to initialise then?


This way is fine if you are happy with how it reads :D


--
Kieran


>>> +	};
>>> +	int ret;
>>> +
>>> +	format.pad = RWPF_PAD_SINK;
>>> +	format.format.width = drm_pipe->width;
>>> +	format.format.height = drm_pipe->height;
>>> +	format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
>>> +	format.format.field = V4L2_FIELD_NONE;
>>> +
>>> +	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, set_fmt, 
> NULL,
>>> +			       &format);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
