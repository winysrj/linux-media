Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:49088 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbeIFLfJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 07:35:09 -0400
Subject: Re: [PATCH v8 4/8] media: platform: Add Cedrus VPU decoder driver
To: Paul Kocialkowski <contact@paulk.fr>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-sunxi@googlegroups.com
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
 <20180828073424.30247-5-paul.kocialkowski@bootlin.com>
 <5faf5eed-eb2c-f804-93e3-5a42f6204d99@xs4all.nl>
 <b7b3cb2320978d45acb34475d15abd7bf03da367.camel@paulk.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <461c6a0d-a346-b9da-b75e-4aab907054df@xs4all.nl>
Date: Thu, 6 Sep 2018 09:01:01 +0200
MIME-Version: 1.0
In-Reply-To: <b7b3cb2320978d45acb34475d15abd7bf03da367.camel@paulk.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2018 06:29 PM, Paul Kocialkowski wrote:
> Hi and thanks for the review!
> 
> Le lundi 03 septembre 2018 à 11:11 +0200, Hans Verkuil a écrit :
>> On 08/28/2018 09:34 AM, Paul Kocialkowski wrote:
>>> +static int cedrus_request_validate(struct media_request *req)
>>> +{
>>> +	struct media_request_object *obj, *obj_safe;
>>> +	struct v4l2_ctrl_handler *parent_hdl, *hdl;
>>> +	struct cedrus_ctx *ctx = NULL;
>>> +	struct v4l2_ctrl *ctrl_test;
>>> +	unsigned int i;
>>> +
>>> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
>>
>> You don't need to use the _safe variant during validation.
> 
> Okay, I'll use the regular one then.
> 
>>> +		struct vb2_buffer *vb;
>>> +
>>> +		if (vb2_request_object_is_buffer(obj)) {
>>> +			vb = container_of(obj, struct vb2_buffer, req_obj);
>>> +			ctx = vb2_get_drv_priv(vb->vb2_queue);
>>> +
>>> +			break;
>>> +		}
>>> +	}
>>
>> Interesting question: what happens if more than one buffer is queued in the
>> request? This is allowed by the request API and in that case the associated
>> controls in the request apply to all queued buffers.
>>
>> Would this make sense at all for this driver? If not, then you need to
>> check here if there is more than one buffer in the request and document in
>> the spec that this is not allowed.
> 
> Well, our driver was written with the (unformal) assumption that we
> only deal with a pair of one output and one capture buffer. So I will
> add a check for this at request validation time and document it in the
> spec. Should that be part of the MPEG-2 PIXFMT documentation (and
> duplicated for future formats we add support for)?

Can you make a patch for vb2_request_has_buffers() in videobuf2-core.c
renaming it to vb2_request_buffer_cnt() and returning the number of buffers
in the request?

Then you can call it here to check that you have only one buffer.

And this has to be documented with the PIXFMT.

Multiple buffers are certainly possible in non-codec scenarios (vim2m and
vivid happily accept that), so this is an exception that should be
documented and checked in the codec driver.

> 
>> If it does make sense, then you need to test this.
>>
>> Again, this can be corrected in a follow-up patch, unless there will be a
>> v9 anyway.
> 
> [...]

>>> +static int cedrus_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
>>> +			      unsigned int *nplanes, unsigned int sizes[],
>>> +			      struct device *alloc_devs[])
>>> +{
>>> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
>>> +	struct cedrus_dev *dev = ctx->dev;
>>> +	struct v4l2_pix_format_mplane *mplane_fmt;
>>> +	struct cedrus_format *fmt;
>>> +	unsigned int i;
>>> +
>>> +	switch (vq->type) {
>>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>>> +		mplane_fmt = &ctx->src_fmt;
>>> +		fmt = cedrus_find_format(mplane_fmt->pixelformat,
>>> +					 CEDRUS_DECODE_SRC,
>>> +					 dev->capabilities);
>>> +		break;
>>> +
>>> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>>> +		mplane_fmt = &ctx->dst_fmt;
>>> +		fmt = cedrus_find_format(mplane_fmt->pixelformat,
>>> +					 CEDRUS_DECODE_DST,
>>> +					 dev->capabilities);
>>> +		break;
>>> +
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (!fmt)
>>> +		return -EINVAL;
>>> +
>>> +	if (fmt->num_buffers == 1) {
>>> +		sizes[0] = 0;
>>> +
>>> +		for (i = 0; i < fmt->num_planes; i++)
>>> +			sizes[0] += mplane_fmt->plane_fmt[i].sizeimage;
>>> +	} else if (fmt->num_buffers == fmt->num_planes) {
>>> +		for (i = 0; i < fmt->num_planes; i++)
>>> +			sizes[i] = mplane_fmt->plane_fmt[i].sizeimage;
>>> +	} else {
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	*nplanes = fmt->num_buffers;
>>
>> This code does not take VIDIOC_CREATE_BUFFERS into account.
>>
>> If it is called from that ioctl, then *nplanes is non-zero and you need
>> to check if *nplanes equals fmt->num_buffers and that sizes[n] is >=
>> the required size of the format. If so, then return 0, otherwise return
>> -EINVAL.
> 
> Thanks for spotting this, I'll fix it as you suggested in the next
> revision.
> 
>> Doesn't v4l2-compliance fail on that? Or is that test skipped because this
>> is a decoder for which streaming is not supported (yet)?
> 
> Apparently, v4l2-compliance doesn't fail since I'm getting:
> test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK

It is tested, but only with the -s option. I'll see if I can improve the
tests.

Regards,

	Hans
