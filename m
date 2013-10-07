Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3010 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab3JGOC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 10:02:28 -0400
Message-ID: <5252BEE9.9020200@xs4all.nl>
Date: Mon, 07 Oct 2013 16:02:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-omap@vger.kernel.org, tomi.valkeinen@ti.com
Subject: Re: [PATCH v4 3/4] v4l: ti-vpe: Add VPE mem to mem driver
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1378462346-10880-1-git-send-email-archit@ti.com> <1378462346-10880-4-git-send-email-archit@ti.com> <525268F9.90409@xs4all.nl> <52527BFF.3060603@ti.com> <52528039.1080901@xs4all.nl> <52528B6D.5080500@ti.com>
In-Reply-To: <52528B6D.5080500@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2013 12:22 PM, Archit Taneja wrote:
> On Monday 07 October 2013 03:04 PM, Hans Verkuil wrote:
>> On 10/07/2013 11:16 AM, Archit Taneja wrote:
>>> On Monday 07 October 2013 01:25 PM, Hans Verkuil wrote:
>>>> Hi Archit,
>>>>
>>>> I've got a few comments below...
>>>>
>>>> On 09/06/2013 12:12 PM, Archit Taneja wrote:
>>>>> VPE is a block which consists of a single memory to memory path which can
>>>>> perform chrominance up/down sampling, de-interlacing, scaling, and color space
>>>>> conversion of raster or tiled YUV420 coplanar, YUV422 coplanar or YUV422
>>>>> interleaved video formats.
>>>>>
>>>>> We create a mem2mem driver based primarily on the mem2mem-testdev example.
>>>>> The de-interlacer, scaler and color space converter are all bypassed for now
>>>>> to keep the driver simple. Chroma up/down sampler blocks are implemented, so
>>>>> conversion beteen different YUV formats is possible.
>>>>>
>>>>> Each mem2mem context allocates a buffer for VPE MMR values which it will use
>>>>> when it gets access to the VPE HW via the mem2mem queue, it also allocates
>>>>> a VPDMA descriptor list to which configuration and data descriptors are added.
>>>>>
>>>>> Based on the information received via v4l2 ioctls for the source and
>>>>> destination queues, the driver configures the values for the MMRs, and stores
>>>>> them in the buffer. There are also some VPDMA parameters like frame start and
>>>>> line mode which needs to be configured, these are configured by direct register
>>>>> writes via the VPDMA helper functions.
>>>>>
>>>>> The driver's device_run() mem2mem op will add each descriptor based on how the
>>>>> source and destination queues are set up for the given ctx, once the list is
>>>>> prepared, it's submitted to VPDMA, these descriptors when parsed by VPDMA will
>>>>> upload MMR registers, start DMA of video buffers on the various input and output
>>>>> clients/ports.
>>>>>
>>>>> When the list is parsed completely(and the DMAs on all the output ports done),
>>>>> an interrupt is generated which we use to notify that the source and destination
>>>>> buffers are done.
>>>>>
>>>>> The rest of the driver is quite similar to other mem2mem drivers, we use the
>>>>> multiplane v4l2 ioctls as the HW support coplanar formats.
>>>>>
>>>>> Signed-off-by: Archit Taneja <archit@ti.com>
>>>>> ---
>>>>>    drivers/media/platform/Kconfig           |   16 +
>>>>>    drivers/media/platform/Makefile          |    2 +
>>>>>    drivers/media/platform/ti-vpe/Makefile   |    5 +
>>>>>    drivers/media/platform/ti-vpe/vpe.c      | 1750 ++++++++++++++++++++++++++++++
>>>>>    drivers/media/platform/ti-vpe/vpe_regs.h |  496 +++++++++
>>>>>    include/uapi/linux/v4l2-controls.h       |    4 +
>>>>>    6 files changed, 2273 insertions(+)
>>>>>    create mode 100644 drivers/media/platform/ti-vpe/Makefile
>>>>>    create mode 100644 drivers/media/platform/ti-vpe/vpe.c
>>>>>    create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h
>>>>>
>>>>
>>>> <snip>
>>>>
>>>>> +
>>>>> +static int vpe_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>>>>> +{
>>>>> +	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
>>>>> +	struct vpe_ctx *ctx = file2ctx(file);
>>>>> +	struct vb2_queue *vq;
>>>>> +	struct vpe_q_data *q_data;
>>>>> +	int i;
>>>>> +
>>>>> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
>>>>> +	if (!vq)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	q_data = get_q_data(ctx, f->type);
>>>>> +
>>>>> +	pix->width = q_data->width;
>>>>> +	pix->height = q_data->height;
>>>>> +	pix->pixelformat = q_data->fmt->fourcc;
>>>>> +	pix->colorspace = q_data->colorspace;
>>>>> +	pix->num_planes = q_data->fmt->coplanar ? 2 : 1;
>>>>> +
>>>>> +	for (i = 0; i < pix->num_planes; i++) {
>>>>> +		pix->plane_fmt[i].bytesperline = q_data->bytesperline[i];
>>>>> +		pix->plane_fmt[i].sizeimage = q_data->sizeimage[i];
>>>>> +	}
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
>>>>> +		       struct vpe_fmt *fmt, int type)
>>>>> +{
>>>>> +	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
>>>>> +	struct v4l2_plane_pix_format *plane_fmt;
>>>>> +	int i;
>>>>> +
>>>>> +	if (!fmt || !(fmt->types & type)) {
>>>>> +		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
>>>>> +			pix->pixelformat);
>>>>> +		return -EINVAL;
>>>>> +	}
>>>>> +
>>>>> +	pix->field = V4L2_FIELD_NONE;
>>>>> +
>>>>> +	v4l_bound_align_image(&pix->width, MIN_W, MAX_W, W_ALIGN,
>>>>> +			      &pix->height, MIN_H, MAX_H, H_ALIGN,
>>>>> +			      S_ALIGN);
>>>>> +
>>>>> +	pix->num_planes = fmt->coplanar ? 2 : 1;
>>>>> +	pix->pixelformat = fmt->fourcc;
>>>>> +	pix->colorspace = fmt->fourcc == V4L2_PIX_FMT_RGB24 ?
>>>>
>>>> You do this only for capture. Output sets the colorspace, so try_fmt should
>>>> leave the colorspace field untouched for the output direction.
>>>>
>>>>> +			V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;
>>>
>>> The input to the VPE block can be various YUV formats, and the VPE can
>>> generate both RGB and YUV formats.
>>>
>>> So, I guess the output(V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) side has
>>> choice only to set V4L2_COLORSPACE_SMPTE170M. And in the
>>> capture(V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) capture side we have both
>>> SRG and SMPTE170M options.
>>>
>>> One thing I am not clear about is whether the userspace application has
>>> to set the colorspace in the v4l2 format for OUTPUT or CAPTURE or both?
>>
>> The spec today says that the colorspace field is filled in by the driver.
>> It does not differentiate between output and capture. This is patently wrong,
>> since for output it should be set by the application since that's who is
>> telling the driver what colorspace the image has. The driver may change it
>> if it doesn't support that colorspace, but otherwise it should leave it as
>> is.
>>
>> A mem-to-mem device that doesn't care about the colorspace should just copy
>> the colorspace field from the output value into the capture.
>>
>> What is missing in today's API is a way to do colorspace conversion in a m2m
>> device since there is no way today to tell the driver the desired colorspace
>> that it should get back from the m2m device.
>>
>>>
>>>   From what I understood, the code should be as below.
>>>
>>> For output:
>>>
>>> if (!pix->colorspace)
>>> 	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
>>
>> I would leave off the 'if' part. If this colorspace is all you support on the
>> output, then always set it.
>>
>> However, since it can convert YUV to RGB, doesn't the hardware have to know
>> about the various YUV colorspaces? SDTV and HDTV have different colorspaces.
>>
>>>
>>> And for capture:
>>> 	pix->colorspace = fmt->fourcc == V4L2_PIX_FMT_RGB24 ?
>>> 		V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;
>>>
>>> Does this look correct?
>>
>> Yes, unless the hardware can take SDTV/HDTV YUV colorspaces into account. In
>> that case I need to think how the API should be improved.
> 
> The hardware can't convert one YUV color space to another. But it has a 
> programmable CSC block for YUV->RGB conversion in which we can program 
> coefficients based on the input YUV color space.
> 
> The color space conversion block isn't implemented by the driver yet. So 
> I didn't look too much into it.
> 
> I guess it will be eventually important to consider the output 
> colorspace. It doesn't need to be only SMPTE170M, it could be REC709 or 
> SMPTE240M based on what the user says.
> 
> When the color space conversion block is implemented and the capture 
> colorspace is RGB, the driver should see the input colorspace and choose 
> the coefficients accordingly.
> 
> With this new information about the hardware (:)), I guess it should be 
> as below for now:
> 
> output:
> /* inserted this check back since multiple YUV spaces supported */
> if (!pix->colorspace)	
> 	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
> 
> capture:
> /* removed SRGB sicne we don't support CSC yet */
> pix->colorspace = s_q_data->colorspace;
> 
> However, the above would imply that we need to s_fmt ioctl is called for 
> OUTPUT first, followed by s_fmt for CAPTURE. I don't think that's 
> something necessary according to the v4l spec.

Well, s_fmt(OUTPUT) influences the colorspace field returned by *_fmt(CAPTURE).
Which I think is OK. You can use either order, but to see the actual colorspace
used by capture you will have to call g_fmt(CAPTURE) after calling s_fmt(OUTPUT).

It's the logical order anyway for a m2m device to start with the output first.

> Besides this, I noticed a series "V4L2 mem-to-mem ioctl helpers" which I 
> should take use of. Do you suggest I base my patches over that?

I don't know when that will be merged. It might be easier to just add a new
patch converting the driver to the helpers, then we can apply all patches except
that last one if the helpers aren't merged yet.

Regards,

	Hans
