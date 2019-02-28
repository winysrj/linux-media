Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3907C43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 15:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 754D4218AE
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 15:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfB1Pmc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:42:32 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:52578 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727858AbfB1Pmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 10:42:32 -0500
Received: from [IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a] ([IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zNpMgDeHeLMwIzNpOgdkwl; Thu, 28 Feb 2019 16:42:30 +0100
Subject: Re: [PATCH v2] media: vim2m: better handle cap/out buffers with
 different sizes
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
References: <8d0a822ce02e1eb95f4a59cc9aabceb5a5661dda.1551202576.git.mchehab+samsung@kernel.org>
 <84696204-2b3a-74ed-f470-52cc54fa201b@xs4all.nl>
 <20190228110914.0b2613eb@coco.lan>
 <4cc0d8e1-7e25-1b9d-8bfe-921716522909@xs4all.nl>
 <20190228122139.6ac6c25d@coco.lan>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <170efbf2-794a-7314-179d-d5c4af4d7e57@xs4all.nl>
Date:   Thu, 28 Feb 2019 16:42:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190228122139.6ac6c25d@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDP9jqU61wr3uo19uzdMsFXlRt9aSP8vSDX7M79LHU8Z3hVs2wvxQ4qwcLZcPpvFE/j9cG8UNzahzAIM5d0kpl5KXTl2x/gTEYXbxVcPaLCko8iVS+RI
 pVNygQqg9Fml6i86xHw8hyVkgPXjYlwOO8wCT5xd3JgQTOcBjDej+RwH7PYWERTusMu4GFFCjzTcRO4Z5oMGKFVGC7FD69lu4q8KUKxAFtEKsjf0yGmHXCYS
 dxFPkybtOZwjm4SyMc4PPEO32lv7s95mzw3ib+hu4p5EfPnIAygOzRSM+Y85xjg/QrU0Yy4JaeKc1pPxRqD7kP8O4KnOHZd8dBntTcaZaCuco3Bq4S32pAKH
 y9x1hrfvSXGX+M4frVCU/3oWIpvlVbvHHqYmuovrOPXn/YwPLzrXrh+mh5xpPPhSrtos8cev
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/28/19 4:21 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 28 Feb 2019 15:35:07 +0100
> Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:
> 
>> On 2/28/19 3:09 PM, Mauro Carvalho Chehab wrote:
>>> Em Thu, 28 Feb 2019 13:30:49 +0100
>>> Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:
>>>   
>>>> On 2/26/19 6:36 PM, Mauro Carvalho Chehab wrote:  
>>>>> The vim2m driver doesn't enforce that the capture and output
>>>>> buffers would have the same size. Do the right thing if the
>>>>> buffers are different, zeroing the buffer before writing,
>>>>> ensuring that lines will be aligned and it won't write past
>>>>> the buffer area.    
>>>>
>>>> I don't really like this. Since the vimc driver doesn't scale it shouldn't
>>>> automatically crop either. If you want to crop/compose, then the
>>>> selection API should be implemented.
>>>>
>>>> That would be the right approach to allowing capture and output
>>>> formats (we're talking formats here, not buffer sizes) with
>>>> different resolutions.  
>>>
>>> The original vim2m implementation assumes that this driver would
>>> "scale" and do format conversions (except that it didn't do neither).  
>>
>> I'm not sure we should assume anything about the original implementation.
>> It had lots of issues. I rather do this right then keep supporting hacks.
> 
> True, but we are too close to the merge window. That's why I opted on
> solving the bug, and not changing the behavior.

Then that should be documented in the commit log: i.e. it is a temporary
fix until we have a better solution. I'm fine with that.

> 
>>
>>> While I fixed the format conversion on a past patchset, vim2m
>>> still allows a "free" image size on both sides of the pipeline.
>>>
>>> I agree with you that the best would be to implement a scaler
>>> (and maybe crop/compose), but for now, we need to solve an issue that
>>> vim2m is doing a very poor job to confine the image at the destination
>>> buffer's resolution.
>>>
>>> Also, as far as I remember, the first M2M devices have scalers, so
>>> existing apps likely assume that such devices will do scaling.  
>>
>> Most m2m devices are codecs and codecs do not do scaling (at least,
>> I'm not aware of any).
> 
> At least on GStreamer, codecs are implemented on a separate logic.
> GStreamer checks it using the FOURCC types. If one of the sides is
> compressed, it is either an encoder or a decoder. Otherwise, it is
> a transform device.
> 
> From what I understood from the code (and from my tests), it
> assumes that scaler is supported for transform devices.

I find it hard to believe that it assumes a transform device can always
scale. Nicolas?

> 
>> I don't think there are many m2m devices that do scaling: most do
>> format conversion of one type or another (codecs, deinterlacers,
>> yuv-rgb converters). Scalers tend to be integrated into a video
>> pipeline. The only m2m drivers I found that also scale are
>> exynos-gsc, ti-vpe, mtk-mdp and possibly sti/bdisp.
> 
> Well, the M2M API was added with Exynos. 
> 
>>>
>>> So, a non-scaling M2M device is something that, in thesis, we don't
>>> support[1].
>>>
>>> [1] Very likely we have several ones that don't do scaling, but the
>>> needed API bits for apps to detect if scaling is supported or not
>>> aren't implemented.
>>>
>>> The problem of enforcing the resolution to be identical on both capture
>>> and output buffers is that the V4L2 API doesn't really have
>>> a way for userspace apps to identify that it won't scale until
>>> too late.
>>>
>>> How do you imagine an application negotiating the image resolution?
>>>
>>> I mean, application A may set first the capture buffer to, let's say,
>>> 320x200 and then try to set the output buffer. 
>>>
>>> Application B may do the reverse, e. g. set first the output buffer
>>> to 320x200 and then try to set the capture buffer.
>>>
>>> Application C could try to initialize with some default for both 
>>> capture and output buffers and only later decide what resolution
>>> it wants and try to set both sides.
>>>
>>> Application D could have setup both sides, started streaming at 
>>> 320x200. Then, it stopped streaming and changed the capture 
>>> resolution to, let's say 640x480, without changing the resolution
>>> of the output buffer.
>>>
>>> For all the above scenarios, the app may either first set both
>>> sides and then request the buffer for both, or do S_FMT/REQBUFS
>>> for one side and then to the other side.
>>>
>>> What I mean is that, wit just use the existing ioctls and flags, I 
>>> can't see any way for all the above scenarios work on devices that
>>> don't scale.  
>>
>> If the device cannot scale, then setting the format on either capture
>> or output will modify the format on the other side as well.
> 
> That's one way to handle it, but what happens if buffers were already
> allocated at one side?

Then trying to change the format on the other side will simply return
the current format.

 If the buffer is USERPTR, this is even worse,
> as the size may not fit the image anymore.

That's why you shouldn't remove the check in buf_prepare :-)

> 
> Also, changing drivers to this new behavior could break some stuff.

I'm not at all certain if all m2m drivers are safe when in comes to this.
The v4l2-compliance testing for m2m devices has always lagged behind the
testing for non-m2m devices, so we don't do in-depth tests. Otherwise we'd
found this vim2m issue a long time ago.

And I don't think it is new behavior. When it comes to m2m devices
they just behave according to the standard v4l2 behavior: the driver
always tries to fulfill the last ioctl to the best of its ability.

That said, this has never been made explicit in the spec.

> 
> (with this particular matter, changing vim2m code doesn't count as a
> change, as this driver should not be used in production - but if any
> other driver is doing something different, then we're limited to do
> such change)
> 
>>
>> If the device also support cropping and composing, then it becomes
>> more complicated, but the basics remain the same.
>>
> 
> I suspect that the above are just assumptions (and perhaps the current
> implementation on most drivers). At least, I was unable to find any mention
> about the M2M chapter at the V4L2 specs.
> 
>> It would certainly be nice if there was a scaling capability. I suspect
>> one reason that nobody requested this is that you usually know what
>> you are doing when you use an m2m device.
> 
> And that's a bad assumption, as it prevents having generic apps
> using it. The expected behavior for having and not having scaler
> should be described, and we need to be able to cope with legacy stuff.

We should likely write up something similar as what we are doing for
the codec documentation, but then for m2m transform devices.

> 
>>
>>> One solution would be to filter the output of ENUM_FMT, TRY_FMT,
>>> G_FMT and S_FMT when one of the sides of the M2M buffer is set,
>>> but that would break some possible real usecases.  
>>
>> Not sure what you mean here.
> 
> I mean that one possible solution would be that, if one side sets 
> resolution, the answer for the ioctls on the other side would be
> different. IMHO, that's a bad idea.
> 
>>>
>>> I suspect that the option that it would work best is to have a
>>> flag to indicate that a M2M device has scalers.
>>>
>>> In any case, this should be discussed and properly documented
>>> before we would be able to implement a non-scaling M2M device.  
>>
>> I don't know where you get the idea that most m2m devices scale.
>> The reverse is true, very few m2m devices have a scaler.
> 
> No, I didn't say that most m2m devices scale. I said that the initial
> M2M implementations scale, and that's probably one of the reasons why 
> this is the behavior that Gstreamer expects scales on transform devices.

Well, it doesn't really matter. The fact is that gstreamer apparently
makes assumptions that are not in general valid.

And all this is made worse by insufficiently detailed documentation and
insufficient compliance testing.

Patches are welcome.

Regarding this vim2m patch: I'm fine with this patch if it is clear that
it is a temporary fix and that it should really implement a real scaler
instead of cropping.

Regards,

	Hans

> 
>>
>>>
>>> -
>>>
>>> Without a clear way for the API to report that the device can't scale,
>>> an application like, for example, the GStreamer plugin, won't be able to 
>>> detect that the resolutions should be identical until too late (at
>>> STREAMON).
>>>
>>> IMO, this is something that we should address, but it is out of the
>>> scope of this fixup patch.
>>>
>>> That's why I prefer to keep vim2m working supporting different
>>> resolutions on each side of the M2M device.  
>>
>> I suspect it was always just a bug in vim2m that it allowed different
>> resolutions for capture and output.
>>
>>>
>>> -
>>>
>>> That's said, I may end working on a very simple scaler patch for vim2m.   
>>
>> v4l2-tpg-core.c uses Coarse Bresenham scaling to implement the scaler.
> 
> Yeah, we could reuse part of the logic there, but the challenge here is
> to do that at the same logic we already do HFLIP/VFLIP and image transform.
> 
> I'll seek for some time to do that.
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> I suspect that a simple decimation filtering like:
>>>
>>> #define x_scale xout_max / xin_max
>>> #define y_scale yout_max / yin_max
>>>
>>> 	out_pixel(x, y) = in_pixel(x * x_scale, y * y_scale)
>>>
>>> would be simple enough to implement at the current image copy
>>> thread.
>>>
>>> Regards,
>>> Mauro
>>>   
>>>>  
>>>>>
>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>>>>> ---
>>>>>  drivers/media/platform/vim2m.c | 26 +++++++++++++++++++-------
>>>>>  1 file changed, 19 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
>>>>> index 89384f324e25..46e3e096123e 100644
>>>>> --- a/drivers/media/platform/vim2m.c
>>>>> +++ b/drivers/media/platform/vim2m.c
>>>>> @@ -481,7 +481,9 @@ static int device_process(struct vim2m_ctx *ctx,
>>>>>  	struct vim2m_dev *dev = ctx->dev;
>>>>>  	struct vim2m_q_data *q_data_in, *q_data_out;
>>>>>  	u8 *p_in, *p, *p_out;
>>>>> -	int width, height, bytesperline, x, y, y_out, start, end, step;
>>>>> +	unsigned int width, height, bytesperline, bytesperline_out;
>>>>> +	unsigned int x, y, y_out;
>>>>> +	int start, end, step;
>>>>>  	struct vim2m_fmt *in, *out;
>>>>>  
>>>>>  	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
>>>>> @@ -491,8 +493,15 @@ static int device_process(struct vim2m_ctx *ctx,
>>>>>  	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
>>>>>  
>>>>>  	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
>>>>> +	bytesperline_out = (q_data_out->width * q_data_out->fmt->depth) >> 3;
>>>>>  	out = q_data_out->fmt;
>>>>>  
>>>>> +	/* Crop to the limits of the destination image */
>>>>> +	if (width > q_data_out->width)
>>>>> +		width = q_data_out->width;
>>>>> +	if (height > q_data_out->height)
>>>>> +		height = q_data_out->height;
>>>>> +
>>>>>  	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
>>>>>  	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
>>>>>  	if (!p_in || !p_out) {
>>>>> @@ -501,6 +510,10 @@ static int device_process(struct vim2m_ctx *ctx,
>>>>>  		return -EFAULT;
>>>>>  	}
>>>>>  
>>>>> +	/* Image size is different. Zero buffer first */
>>>>> +	if (q_data_in->width  != q_data_out->width ||
>>>>> +	    q_data_in->height != q_data_out->height)
>>>>> +		memset(p_out, 0, q_data_out->sizeimage);
>>>>>  	out_vb->sequence = get_q_data(ctx,
>>>>>  				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
>>>>>  	in_vb->sequence = q_data_in->sequence++;
>>>>> @@ -524,6 +537,11 @@ static int device_process(struct vim2m_ctx *ctx,
>>>>>  		for (x = 0; x < width >> 1; x++)
>>>>>  			copy_two_pixels(in, out, &p, &p_out, y_out,
>>>>>  					ctx->mode & MEM2MEM_HFLIP);
>>>>> +
>>>>> +		/* Go to the next line at the out buffer*/    
>>>>
>>>> Add space after 'buffer'.
>>>>  
>>>>> +		if (width < q_data_out->width)
>>>>> +			p_out += ((q_data_out->width - width)
>>>>> +				  * q_data_out->fmt->depth) >> 3;
>>>>>  	}
>>>>>  
>>>>>  	return 0;
>>>>> @@ -977,12 +995,6 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
>>>>>  	dprintk(ctx->dev, 2, "type: %s\n", type_name(vb->vb2_queue->type));
>>>>>  
>>>>>  	q_data = get_q_data(ctx, vb->vb2_queue->type);
>>>>> -	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
>>>>> -		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
>>>>> -				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
>>>>> -		return -EINVAL;
>>>>> -	}
>>>>> -    
>>>>
>>>> As discussed on irc, this can't be removed. It checks if the provided buffer
>>>> is large enough for the current format.
>>>>
>>>> Regards,
>>>>
>>>> 	Hans
>>>>  
>>>>>  	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
>>>>>  
>>>>>  	return 0;
>>>>>     
>>>>  
>>>
>>>
>>>
>>> Thanks,
>>> Mauro
>>>   
>>
> 
> 
> 
> Thanks,
> Mauro
> 

