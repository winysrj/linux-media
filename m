Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56706 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757561AbcHDNUI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 09:20:08 -0400
Subject: Re: [PATCH] v4l: platform: Add Renesas R-Car FDP1 Driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>
References: <1467294083-1811-1-git-send-email-kieran@bingham.xyz>
 <1467294083-1811-2-git-send-email-kieran@bingham.xyz>
 <578E1CEC.1060002@cisco.com> <15479328.76d63PMRIr@avalon>
Cc: Kieran Bingham <kieran@ksquared.org.uk>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b66bcfbc-b9b2-29ee-f261-13f8a6f031f8@xs4all.nl>
Date: Thu, 4 Aug 2016 15:20:00 +0200
MIME-Version: 1.0
In-Reply-To: <15479328.76d63PMRIr@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/04/2016 03:01 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the review.
> 
> I'll temporarily take over work on the FDP driver until the end of this month 
> as Kieran is away.
> 
> On Tuesday 19 Jul 2016 14:28:28 Hans Verkuil wrote:
>> Hi Kieran,
>>
>> Hmm, I don't think I ever reviewed this one.
>>
>> So here is my quick review:
>>
>> General note: I need to see the v4l2-compliance output. Make sure you run
>> with the latest version from v4l-utils.
> 
> I'll do that and provide results.
> 
>> On 06/30/16 15:41, Kieran Bingham wrote:
>>> The FDP1 driver performs advanced de-interlacing on a memory 2 memory
>>> based video stream, and supports conversion from YCbCr/YUV
>>> to RGB pixel formats
>>>
>>> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
>>> ---
>>>
>>>  MAINTAINERS                        |    9 +
>>>  drivers/media/platform/Kconfig     |   13 +
>>>  drivers/media/platform/Makefile    |    1 +
>>>  drivers/media/platform/rcar_fdp1.c | 2395 +++++++++++++++++++++++++++++++
>>>  4 files changed, 2418 insertions(+)
>>>  create mode 100644 drivers/media/platform/rcar_fdp1.c
> 
> [snip]
> 
>>> diff --git a/drivers/media/platform/rcar_fdp1.c
>>> b/drivers/media/platform/rcar_fdp1.c new file mode 100644
>>> index 000000000000..c7280183262a
>>> --- /dev/null
>>> +++ b/drivers/media/platform/rcar_fdp1.c
> 
> [snip]
> 
>>> +/* Per-queue, driver-specific private data */
>>> +struct fdp1_q_data {
>>> +	const struct fdp1_fmt	*fmt;
>>> +	struct v4l2_pix_format_mplane format;
>>> +
>>> +	unsigned int		vsize;
>>> +	unsigned int		stride_y;
>>> +	unsigned int		stride_c;
>>> +};
>>> +
>>> +/* Custom controls */
>>> +#define V4L2_CID_DEINT_MODE		(V4L2_CID_USER_BASE + 0x1000)
>>
>> You have to reserve a range for driver controls in v4l2-controls.h.
>> This to avoid getting duplicate control IDs.
>>
>> If the intention is that apps can use this ID, then it needs to be part
>> of a public driver header as well.
>>
>> Also clearly document the control, either in the source or in a .txt (or
>> now probably .rst) file.
>>
>> Frankly, I wonder if this shouldn't be added as a standard control rather
>> than driver specific. It's a fairly common feature.
> 
> As discussed on IRC, I'll turn that into a standard control, but will leave 
> the menu items driver-specific as it's not clear (at least at the moment) how 
> much standardization of deinterlacing methods could be possible across 
> devices. One of the issues is that hardware documentation rarely explains how 
> deinterlacing is performed in details.
> 
> [snip]
> 
>>> +static struct fdp1_q_data *get_q_data(struct fdp1_ctx *ctx,
>>> +					 enum v4l2_buf_type type)
>>> +{
>>> +	if (V4L2_TYPE_IS_OUTPUT(type))
>>> +		return &ctx->out_q;
>>> +	else
>>
>> 'else' can be dropped. checkpatch should have complained about that AFAIK.
> 
> I generally agree when the condition is unbalanced. If you check for the 
> normal or abnormal case and process it quickly first, dropping the else allows 
> lowering the indentation of the rest of the code. In this case, however, the 
> two branches are perfectly balanced, the two cases have exactly the same 
> probability. Keeping the else improves readability in my opinion.
> 
>>> +		return &ctx->cap_q;
>>> +}
> 
> [snip]
> 
>>> +static void fdp1_configure_wpf(struct fdp1_ctx *ctx,
>>> +			       struct fdp1_job *job)
>>> +{
>>> +	struct fdp1_dev *fdp1 = ctx->fdp1;
>>> +	struct fdp1_q_data *src_q_data = &ctx->out_q;
>>> +	struct fdp1_q_data *q_data = &ctx->cap_q;
>>> +	u32 pstride;
>>> +	u32 format;
>>> +	u32 swap;
>>> +	u32 rndctl;
>>> +
>>> +	pstride = q_data->format.plane_fmt[0].bytesperline
>>> +			<< FD1_WPF_PSTRIDE_Y_SHIFT;
>>> +
>>> +	if (q_data->format.num_planes > 1)
>>> +		pstride |= q_data->format.plane_fmt[1].bytesperline
>>> +			<< FD1_WPF_PSTRIDE_C_SHIFT;
>>> +
>>> +	format = q_data->fmt->fmt; /* Output Format Code */
>>> +
>>> +	if (q_data->fmt->swap_yc)
>>> +		format |= FD1_WPF_FORMAT_WSPYCS;
>>> +
>>> +	if (q_data->fmt->swap_uv)
>>> +		format |= FD1_WPF_FORMAT_WSPUVS;
>>> +
>>> +	if (fdp1_fmt_is_rgb(q_data->fmt)) {
>>> +		/* Enable Colour Space conversion */
>>> +		format |= FD1_WPF_FORMAT_CSC;
>>> +
>>> +		/* Set WRTM */
>>> +		if (src_q_data->format.ycbcr_enc == V4L2_COLORSPACE_REC709)
>>
>> Wrong define, should be V4L2_YCBCR_ENC_709.
> 
> Fixed.
> 
>>> +			format |= FD1_WPF_FORMAT_WRTM_709_16;
>>
>> There is no FD1_WPF_FORMAT_WRTM_709_0?
> 
> No, the hardware doesn't support that.
> 
>>> +		else if (src_q_data->format.quantization ==
>>> +				V4L2_QUANTIZATION_FULL_RANGE)
>>> +			format |= FD1_WPF_FORMAT_WRTM_601_0;
>>> +		else
>>> +			format |= FD1_WPF_FORMAT_WRTM_601_16;
>>> +	}
>>> +
>>> +	/* Set an alpha value into the Pad Value */
>>> +	format |= ctx->alpha << FD1_WPF_FORMAT_PDV_SHIFT;
>>> +
>>> +	/* Determine picture rounding and clipping */
>>> +	rndctl = FD1_WPF_RNDCTL_CBRM; /* Rounding Off */
>>> +	rndctl |= FD1_WPF_RNDCTL_CLMD_NOCLIP;
>>> +
>>> +	/* WPF Swap needs both ISWAP and OSWAP setting */
>>> +	swap = q_data->fmt->swap << FD1_WPF_SWAP_OSWAP_SHIFT;
>>> +	swap |= src_q_data->fmt->swap << FD1_WPF_SWAP_SSWAP_SHIFT;
>>> +
>>> +	fdp1_write(fdp1, format, FD1_WPF_FORMAT);
>>> +	fdp1_write(fdp1, rndctl, FD1_WPF_RNDCTL);
>>> +	fdp1_write(fdp1, swap, FD1_WPF_SWAP);
>>> +	fdp1_write(fdp1, pstride, FD1_WPF_PSTRIDE);
>>> +
>>> +	fdp1_write(fdp1, job->dst.addrs[0], FD1_WPF_ADDR_Y);
>>> +	fdp1_write(fdp1, job->dst.addrs[1], FD1_WPF_ADDR_C0);
>>> +	fdp1_write(fdp1, job->dst.addrs[2], FD1_WPF_ADDR_C1);
>>> +}
> 
> [snip]
> 
>>> +/*
>>> + * prepare_buffer: Prepare an fdp1_buffer, from a vb2_v4l2_buffer
>>> + *
>>> + * This helps us serialise buffers containing two fields into
>>> + * sequential top and bottom fields.
>>> + * Destination buffers also go through this function to
>>> + * set the vb and addrs in the same manner.
>>> + */
>>> +static void prepare_buffer(struct fdp1_ctx *ctx,
>>> +			   struct fdp1_buffer *buf,
>>> +			   struct vb2_v4l2_buffer *vb,
>>> +			   bool next_field, bool last_field)
>>> +{
>>> +	struct fdp1_q_data *q_data = get_q_data(ctx, vb->vb2_buf.type);
>>> +	unsigned int i;
>>> +
>>> +	buf->vb = vb;
>>> +	buf->last_field = last_field;
>>> +
>>> +	for (i = 0; i < vb->vb2_buf.num_planes; ++i)
>>> +		buf->addrs[i] = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf,
>>> i);
>>> +
>>> +	switch (vb->field) {
>>> +	case V4L2_FIELD_INTERLACED:
>>
>> For INTERLACED field order the order depends on the chosen TV standard: for
>> 60 Hz BOTTOM comes first, for 50 Hz TOP comes first.
>>
>> Don't shoot the messenger :-)
> 
> As this is a mem-to-mem driver there's no concept of TV standard. Should we 
> drop V4L2_FIELD_INTERLACED support and require userspace to specify the field 
> order explicitly by using V4L2_FIELD_INTERLACED_TB or V4L2_FIELD_INTERLACED_BT 
> ?

You are right, it is a mem2mem driver.

Either drop FIELD_INTERLACED or use the height as heuristic: < 576 means INTERLACED_BT,
otherwise it is _TB.

> 
>>> +	case V4L2_FIELD_INTERLACED_TB:
>>> +	case V4L2_FIELD_SEQ_TB:
>>> +		buf->field = (next_field) ? V4L2_FIELD_BOTTOM :
>>> V4L2_FIELD_TOP;
>>> +		break;
>>> +	case V4L2_FIELD_INTERLACED_BT:
>>> +	case V4L2_FIELD_SEQ_BT:
>>> +		buf->field = (next_field) ? V4L2_FIELD_TOP :
>>> V4L2_FIELD_BOTTOM;
>>> +		break;
>>> +	default:
>>> +		buf->field = vb->field;
>>
>> Please add a break here.
> 
> Fixed.
> 
>>> +	}
>>> +
>>> +	/* Buffer is completed */
>>> +	if (next_field == false)
>>> +		return;
>>> +
>>> +	/* Adjust buffer addresses for second field */
>>> +	switch (vb->field) {
>>> +	case V4L2_FIELD_INTERLACED:
>>> +	case V4L2_FIELD_INTERLACED_TB:
>>> +	case V4L2_FIELD_INTERLACED_BT:
>>> +		for (i = 0; i < vb->vb2_buf.num_planes; i++)
>>> +			buf->addrs[i] +=
>>> +				(i == 0 ? q_data->stride_y : q_data->
>>> stride_c);
>>> +		break;
>>> +	case V4L2_FIELD_SEQ_TB:
>>> +	case V4L2_FIELD_SEQ_BT:
>>> +		for (i = 0; i < vb->vb2_buf.num_planes; i++)
>>> +			buf->addrs[i] += q_data->vsize *
>>> +				(i == 0 ? q_data->stride_y : q_data->
>>> stride_c);
>>> +		break;
>>> +	}
>>> +}
> 
> [snip]
> 
>>> +static int __fdp1_try_fmt(struct fdp1_ctx *ctx, const struct fdp1_fmt
>>> **fmtinfo,
>>> +			  struct v4l2_pix_format_mplane *pix,
>>> +			  enum v4l2_buf_type type)
>>> +{
>>> +	const struct fdp1_fmt *fmt;
>>> +	unsigned int width = pix->width;
>>> +	unsigned int height = pix->height;
>>> +	unsigned int fmt_type;
>>> +	unsigned int i;
>>> +
>>> +	fmt_type = V4L2_TYPE_IS_OUTPUT(type) ? FDP1_OUTPUT : FDP1_CAPTURE;
>>> +
>>> +	fmt = fdp1_find_format(pix->pixelformat);
>>> +	if (!fmt || !(fmt->types & fmt_type))
>>> +		fmt = fdp1_find_format(V4L2_PIX_FMT_YUYV);
>>> +
>>> +	pix->pixelformat = fmt->fourcc;
>>> +
>>> +	/* Manage colorspace on the two queues */
>>> +	if (V4L2_TYPE_IS_OUTPUT(type)) {
>>> +		if (pix->colorspace == V4L2_COLORSPACE_DEFAULT)
>>> +			pix->colorspace = V4L2_COLORSPACE_REC709;
>>
>> Please read https://hverkuil.home.xs4all.nl/cec.html#colorspaces carefully.
>>
>> The colorspace has nothing to do with YUV vs RGB.
>>
>> I don't know the functionality of this m2m device, but my guess is that it
>> has a standard 4x3 matrix to do 'colorspace' conversion (I quote it because
>> it is almost never a real colorspace conversion, but just an RGB/YUV
>> conversion).
> 
> The hardware supports the following output conversions (no conversion is 
> supported at the input):
> 
> BT.601 (16, 235/240) to RGB (0,  255)
> BT.709 (16, 235/240) to RGB (0,  255)
> BT.601 (0,  255)     to RGB (0,  255)
> BT.709 (16, 235/240) to RGB (16, 235)
> 
>> As of today the application is expected to set the colorspace information on
>> the OUTPUT format and the driver fills it in for the CAPTURE side.
>>
>> But here you probably want to let the application give some information as
>> well, specifically YCBCR_ENC_601 vs 709 and FULL vs LIM_RANGE.
> 
> The hardware can't change the YUV encoding. While it could conceivably be 
> possible to select a BT.601 to RGB transformation when the input is BT.709 (or 
> the other way around) that wouldn't make much sense.

Agreed.

> 
> Quantization, on the other hand, is configurable. When outputting YUV the 
> hardware can use full range, limited range ([16-235/240]), or [1-254]. I still 
> need to investigate this, as quantization is not configurable at the input of 
> the deinterlacer. The hardware seems to process YUV frames without caring 
> about encoding or quantization, so specifying a different output quantization 
> method than what is provided to the input of the deinterlacer might lead to 
> bad results and need to be disallowed.

This is really up to you whether you want to implement this or not. It really
depends on the use-case whether this is needed or not. In general RGB is full
range, but there are cases where you need limited range RGB. But would you ever
use this device for that? No idea. Same with YCbCr: usually limited range, but
full range in some cases (sYCC, AdobeYCC).

> 
>> If that's the case, then look at this old patch of mine, adding support for
>> this:
>>
>> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=csc&id=d0e588c1a36
>> 604538e16f24cad3444c84f5da73e
>>
>>> +		if (pix->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
>>> +			pix->ycbcr_enc =
>>> +				V4L2_MAP_YCBCR_ENC_DEFAULT(pix->colorspace);
>>> +
>>> +		if (pix->quantization == V4L2_QUANTIZATION_DEFAULT)
>>> +			pix->quantization =
>>> +				V4L2_MAP_QUANTIZATION_DEFAULT(false,
>>> +						pix->colorspace,
>>> +						pix->ycbcr_enc);
>>> +	} else {
>>> +		/* Manage the CAPTURE Queue */
>>> +		struct fdp1_q_data *src_data = &ctx->out_q;
>>> +
>>> +		if (fdp1_fmt_is_rgb(fmt)) {
>>> +			pix->colorspace = V4L2_COLORSPACE_SRGB;
>>> +			pix->ycbcr_enc = V4L2_YCBCR_ENC_SYCC;
>>> +			pix->quantization = V4L2_QUANTIZATION_FULL_RANGE;
>>> +		} else {
>>> +			/* Copy input queue colorspace across */
>>> +			pix->colorspace = src_data->format.colorspace;
>>> +			pix->ycbcr_enc = src_data->format.ycbcr_enc;
>>> +			pix->quantization = src_data->format.quantization;
>>> +		}
>>> +	}
>>> +
>>> +	/* We should be allowing FIELDS through on the Output queue !*/
>>> +	if (V4L2_TYPE_IS_OUTPUT(type)) {
>>> +		/* Clamp to allowable field types */
>>> +		if (pix->field == V4L2_FIELD_ANY ||
>>> +		    pix->field == V4L2_FIELD_NONE)
>>> +			pix->field = V4L2_FIELD_NONE;
>>> +		else if (!V4L2_FIELD_HAS_BOTH(pix->field))
>>> +			pix->field = V4L2_FIELD_INTERLACED;
>>> +
>>> +		dprintk(ctx->fdp1, "Output Field Type set as %d\n", pix->
>>> field);
>>> +	} else {
>>> +		pix->field = V4L2_FIELD_NONE;
>>> +	}
>>> +
>>> +	pix->num_planes = fmt->num_planes;
>>> +
>>> +	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
>>> +	width = round_down(width, fmt->hsub);
>>> +	height = round_down(height, fmt->vsub);
>>> +
>>> +	/* Clamp the width and height */
>>> +	pix->width = clamp(width, FDP1_MIN_W, FDP1_MAX_W);
>>> +	pix->height = clamp(height, FDP1_MIN_H, FDP1_MAX_H);
>>> +
>>> +	/* Compute and clamp the stride and image size. While not documented
>>> in
>>> +	 * the datasheet, strides not aligned to a multiple of 128 bytes
>>> result
>>> +	 * in image corruption.
>>> +	 */
>>> +	for (i = 0; i < min_t(unsigned int, fmt->num_planes, 2U); ++i) {
>>> +		unsigned int hsub = i > 0 ? fmt->hsub : 1;
>>> +		unsigned int vsub = i > 0 ? fmt->vsub : 1;
>>> +		 /* From VSP : TODO: Confirm alignment limits for FDP1 */
>>> +		unsigned int align = 128;
>>> +		unsigned int bpl;
>>> +
>>> +		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
>>> +			      pix->width / hsub * fmt->bpp[i] / 8,
>>> +			      round_down(65535U, align));
>>> +
>>> +		pix->plane_fmt[i].bytesperline = round_up(bpl, align);
>>> +		pix->plane_fmt[i].sizeimage = pix->plane_fmt[i].bytesperline
>>> +					    * pix->height / vsub;
>>> +
>>> +		memset(pix->plane_fmt[i].reserved, 0,
>>> +				sizeof(pix->plane_fmt[i].reserved));
>>> +	}
>>> +
>>> +	if (fmt->num_planes == 3) {
>>> +		/* The second and third planes must have the same stride. */
>>> +		pix->plane_fmt[2].bytesperline = pix->
>>> plane_fmt[1].bytesperline;
>>> +		pix->plane_fmt[2].sizeimage = pix->plane_fmt[1].sizeimage;
>>> +
>>> +		memset(pix->plane_fmt[2].reserved, 0,
>>> +				sizeof(pix->plane_fmt[2].reserved));
>>> +	}
>>> +
>>> +	pix->num_planes = fmt->num_planes;
>>> +
>>> +	if (fmtinfo)
>>> +		*fmtinfo = fmt;
>>> +
>>> +	return 0;
>>> +}
> 

Regards,

	Hans
