Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51197 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab3IEF5m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Sep 2013 01:57:42 -0400
Message-ID: <52281D20.6010204@ti.com>
Date: Thu, 5 Sep 2013 11:26:48 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] v4l: ti-vpe: Add VPE mem to mem driver
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1377779572-22624-1-git-send-email-archit@ti.com> <1377779572-22624-4-git-send-email-archit@ti.com> <201308291528.21281.hverkuil@xs4all.nl>
In-Reply-To: <201308291528.21281.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 29 August 2013 06:58 PM, Hans Verkuil wrote:
> On Thu 29 August 2013 14:32:49 Archit Taneja wrote:
>> VPE is a block which consists of a single memory to memory path which can
>> perform chrominance up/down sampling, de-interlacing, scaling, and color space
>> conversion of raster or tiled YUV420 coplanar, YUV422 coplanar or YUV422
>> interleaved video formats.
>>
>> We create a mem2mem driver based primarily on the mem2mem-testdev example.
>> The de-interlacer, scaler and color space converter are all bypassed for now
>> to keep the driver simple. Chroma up/down sampler blocks are implemented, so
>> conversion beteen different YUV formats is possible.
>>
>> Each mem2mem context allocates a buffer for VPE MMR values which it will use
>> when it gets access to the VPE HW via the mem2mem queue, it also allocates
>> a VPDMA descriptor list to which configuration and data descriptors are added.
>>
>> Based on the information received via v4l2 ioctls for the source and
>> destination queues, the driver configures the values for the MMRs, and stores
>> them in the buffer. There are also some VPDMA parameters like frame start and
>> line mode which needs to be configured, these are configured by direct register
>> writes via the VPDMA helper functions.
>>
>> The driver's device_run() mem2mem op will add each descriptor based on how the
>> source and destination queues are set up for the given ctx, once the list is
>> prepared, it's submitted to VPDMA, these descriptors when parsed by VPDMA will
>> upload MMR registers, start DMA of video buffers on the various input and output
>> clients/ports.
>>
>> When the list is parsed completely(and the DMAs on all the output ports done),
>> an interrupt is generated which we use to notify that the source and destination
>> buffers are done.
>>
>> The rest of the driver is quite similar to other mem2mem drivers, we use the
>> multiplane v4l2 ioctls as the HW support coplanar formats.
>>
>> Signed-off-by: Archit Taneja <archit@ti.com>
>
> Thanks for the patch. Just a few small comments below...
>
>> ---
>>   drivers/media/platform/Kconfig           |   16 +
>>   drivers/media/platform/Makefile          |    2 +
>>   drivers/media/platform/ti-vpe/Makefile   |    5 +
>>   drivers/media/platform/ti-vpe/vpe.c      | 1740 ++++++++++++++++++++++++++++++
>>   drivers/media/platform/ti-vpe/vpe_regs.h |  496 +++++++++
>>   5 files changed, 2259 insertions(+)
>>   create mode 100644 drivers/media/platform/ti-vpe/Makefile
>>   create mode 100644 drivers/media/platform/ti-vpe/vpe.c
>>   create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h
>>
>> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
>> new file mode 100644
>> index 0000000..85b0880
>> --- /dev/null
>> +++ b/drivers/media/platform/ti-vpe/vpe.c
>

<snip>

>> +
>> +static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
>> +		       struct vpe_fmt *fmt, int type)
>> +{
>> +	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
>> +	struct v4l2_plane_pix_format *plane_fmt;
>> +	int i;
>> +
>> +	if (!fmt || !(fmt->types & type)) {
>> +		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
>> +			pix->pixelformat);
>> +		return -EINVAL;
>> +	}
>> +
>> +	pix->field = V4L2_FIELD_NONE;
>> +
>> +	v4l_bound_align_image(&pix->width, MIN_W, MAX_W, W_ALIGN,
>> +			      &pix->height, MIN_H, MAX_H, H_ALIGN,
>> +			      S_ALIGN);
>> +
>> +	pix->num_planes = fmt->coplanar ? 2 : 1;
>> +	pix->pixelformat = fmt->fourcc;
>> +	pix->colorspace = fmt->fourcc == V4L2_PIX_FMT_RGB24 ?
>> +			V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;
>
> pix->priv should be set to NULL as well.

I wanted to point out that we use v4l2_pix_format_mplane in the 
v4l2_format fmt union. So I suppose we don't have a priv field in the 
pix structure here.

Thanks,
Archit

