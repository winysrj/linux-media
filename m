Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0049.outbound.protection.outlook.com ([104.47.42.49]:45856
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755862AbeBPREo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 12:04:44 -0500
Date: Fri, 16 Feb 2018 09:04:33 -0800
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>
Subject: Re: [PATCH v3 7/9] v4l: xilinx: dma: Add multi-planar support
Message-ID: <20180216170432.GA9719@smtp.xilinx.com>
References: <1518676963-19660-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1518676963-19660-1-git-send-email-satishna@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satish,

Thanks for the patch.

On Wed, 2018-02-14 at 22:42:43 -0800, Satish Kumar Nagireddy wrote:
> The current v4l driver supports single plane formats. This patch
> will add support to handle multi-planar formats. Updated driver
> capabilities to multi-planar, where it can handle both single and
> multi-planar formats
> 
> Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
> ---
>  drivers/media/platform/xilinx/xilinx-dma.c  | 341 +++++++++++++++++++++++-----
>  drivers/media/platform/xilinx/xilinx-dma.h  |   2 +-
>  drivers/media/platform/xilinx/xilinx-vipp.c |  22 +-
>  3 files changed, 307 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index cb20ada..664981b 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -63,6 +63,7 @@ static int xvip_dma_verify_format(struct xvip_dma *dma)
>  	struct v4l2_subdev_format fmt;
>  	struct v4l2_subdev *subdev;
>  	int ret;
> +	int width, height;
>  
>  	subdev = xvip_dma_remote_subdev(&dma->pad, &fmt.pad);
>  	if (subdev == NULL)
> @@ -73,9 +74,18 @@ static int xvip_dma_verify_format(struct xvip_dma *dma)
>  	if (ret < 0)
>  		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
>  
> -	if (dma->fmtinfo->code != fmt.format.code ||
> -	    dma->format.height != fmt.format.height ||
> -	    dma->format.width != fmt.format.width)
> +	if (dma->fmtinfo->code != fmt.format.code)
> +		return -EINVAL;
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {

As discussed, let's plan to remove this check. :-) I think now it's
safe to assume there's no backward compatibility issue.

> +		width = dma->format.fmt.pix_mp.width;
> +		height = dma->format.fmt.pix_mp.height;
> +	} else {
> +		width = dma->format.fmt.pix.width;
> +		height = dma->format.fmt.pix.height;
> +	}
> +
> +	if (width != fmt.format.width || height != fmt.format.height)
>  		return -EINVAL;
>  
>  	return 0;
> @@ -302,6 +312,8 @@ static void xvip_dma_complete(void *param)
>  {
>  	struct xvip_dma_buffer *buf = param;
>  	struct xvip_dma *dma = buf->dma;
> +	u8 num_planes, i;
> +	int sizeimage;
>  
>  	spin_lock(&dma->queued_lock);
>  	list_del(&buf->queue);
> @@ -310,7 +322,28 @@ static void xvip_dma_complete(void *param)
>  	buf->buf.field = V4L2_FIELD_NONE;
>  	buf->buf.sequence = dma->sequence++;
>  	buf->buf.vb2_buf.timestamp = ktime_get_ns();
> -	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, dma->format.sizeimage);
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {
> +		/* Handling contiguous data with mplanes */
> +		if (dma->fmtinfo->buffers == 1) {
> +			sizeimage =
> +				dma->format.fmt.pix_mp.plane_fmt[0].sizeimage;
> +			vb2_set_plane_payload(&buf->buf.vb2_buf, 0, sizeimage);
> +		} else {
> +			/* Handling non-contiguous data with mplanes */
> +			num_planes = dma->format.fmt.pix_mp.num_planes;
> +			for (i = 0; i < num_planes; i++) {
> +				sizeimage =
> +				 dma->format.fmt.pix_mp.plane_fmt[i].sizeimage;
> +				vb2_set_plane_payload(&buf->buf.vb2_buf, i,
> +						      sizeimage);
> +			}
> +		}

Can this be done in a single loop with number of buffers?

> +	} else {
> +		sizeimage = dma->format.fmt.pix.sizeimage;
> +		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, sizeimage);
> +	}
> +
>  	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
>  }
>  
> @@ -320,13 +353,48 @@ xvip_dma_queue_setup(struct vb2_queue *vq,
>  		     unsigned int sizes[], struct device *alloc_devs[])
>  {
>  	struct xvip_dma *dma = vb2_get_drv_priv(vq);
> +	u8 i;
> +	int sizeimage;
> +
> +	/* Multi planar case: Make sure the image size is large enough */
> +	if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {
> +		if (*nplanes) {
> +			if (*nplanes != dma->format.fmt.pix_mp.num_planes)
> +				return -EINVAL;
> +
> +			for (i = 0; i < *nplanes; i++) {
> +			     sizeimage =
> +			      dma->format.fmt.pix_mp.plane_fmt[i].sizeimage;
> +			if (sizes[i] < sizeimage)
> +				return -EINVAL;
> +			}
> +		} else {
> +			/* Handling contiguous data with mplanes */
> +			if (dma->fmtinfo->buffers == 1) {
> +			    *nplanes = 1;

It seems a little confusing as use of 'nplanes' and 'number of buffers' is
mixed. Looks like definitions in v4l and this driver don't match exactly.
If that's the case Maybe a comment would be helpful.

> +			    sizes[0] =
> +			      dma->format.fmt.pix_mp.plane_fmt[0].sizeimage;
> +			    return 0;
> +			} else {
> +			    /* Handling non-contiguous data with mplanes */
> +			    *nplanes = dma->format.fmt.pix_mp.num_planes;
> +			    for (i = 0; i < *nplanes; i++) {
> +				 sizeimage =
> +				  dma->format.fmt.pix_mp.plane_fmt[i].sizeimage;
> +				 sizes[i] = sizeimage;
> +			    }
> +			}
> +		}

Even here, can't number of buffers instead of num_planes be used for the loop?

> +		return 0;
> +	}
>  
> -	/* Make sure the image size is large enough. */
> -	if (*nplanes)
> -		return sizes[0] < dma->format.sizeimage ? -EINVAL : 0;
> +	/* Single planar case: Make sure the image size is large enough */
> +	sizeimage = dma->format.fmt.pix.sizeimage;
> +	if (*nplanes == 1)
> +		return sizes[0] < sizeimage ? -EINVAL : 0;
>  
>  	*nplanes = 1;
> -	sizes[0] = dma->format.sizeimage;
> +	sizes[0] = sizeimage;
>  
>  	return 0;
>  }
> @@ -348,10 +416,11 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
>  	struct xvip_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
>  	struct xvip_dma_buffer *buf = to_xvip_dma_buffer(vbuf);
>  	struct dma_async_tx_descriptor *desc;
> +	u32 flags, luma_size;
>  	dma_addr_t addr = vb2_dma_contig_plane_dma_addr(vb, 0);
> -	u32 flags;
>  
> -	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +	    dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {

This is missing V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE.

>  		flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
>  		dma->xt.dir = DMA_DEV_TO_MEM;
>  		dma->xt.src_sgl = false;
> @@ -365,10 +434,50 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
>  		dma->xt.src_start = addr;
>  	}
>  
> -	dma->xt.frame_size = 1;
> -	dma->sgl[0].size = dma->format.width * dma->fmtinfo->bpp;
> -	dma->sgl[0].icg = dma->format.bytesperline - dma->sgl[0].size;
> -	dma->xt.numf = dma->format.height;
> +	/*
> +	 * DMA IP supports only 2 planes, so one datachunk is sufficient
> +	 * to get start address of 2nd plane
> +	 */
> +	if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {
> +		struct v4l2_pix_format_mplane *pix_mp;
> +
> +		pix_mp = &dma->format.fmt.pix_mp;
> +		dma->xt.frame_size = dma->fmtinfo->num_planes;
> +		dma->sgl[0].size = pix_mp->width * dma->fmtinfo->bpl_factor;
> +		dma->sgl[0].icg = pix_mp->plane_fmt[0].bytesperline -
> +							dma->sgl[0].size;
> +		dma->xt.numf = pix_mp->height;
> +
> +		/*
> +		 * dst_icg is the number of bytes to jump after last luma addr
> +		 * and before first chroma addr
> +		 */
> +
> +		/* Handling contiguous data with mplanes */
> +		if (dma->fmtinfo->buffers == 1) {
> +		    dma->sgl[0].dst_icg = 0;
> +		} else {
> +		    /* Handling non-contiguous data with mplanes */
> +		    if (vb->num_planes == 2) {

Ditto. number of buffers?

> +			dma_addr_t chroma_addr =
> +					vb2_dma_contig_plane_dma_addr(vb, 1);
> +			luma_size = pix_mp->plane_fmt[0].bytesperline *
> +								dma->xt.numf;

Nit. Please align.

> +			if (chroma_addr > addr)
> +			    dma->sgl[0].dst_icg =
> +				chroma_addr - addr - luma_size;

I don't think this is correct, assuming one memory chunk always has higher
starting address than the other. This should be removed. Please consider
proper way of doing this.

> +		    }
> +		}
> +	} else {
> +		struct v4l2_pix_format *pix;
> +
> +		pix = &dma->format.fmt.pix;
> +		dma->xt.frame_size = dma->fmtinfo->num_planes;
> +		dma->sgl[0].size = pix->width * dma->fmtinfo->bpl_factor;
> +		dma->sgl[0].icg = pix->bytesperline - dma->sgl[0].size;
> +		dma->xt.numf = pix->height;
> +		dma->sgl[0].dst_icg = dma->sgl[0].size;
> +	}
>  
>  	desc = dmaengine_prep_interleaved_dma(dma->dma, &dma->xt, flags);
>  	if (!desc) {
> @@ -496,10 +605,21 @@ xvip_dma_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
>  	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
>  			  | dma->xdev->v4l2_caps;
>  
> -	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> -	else
> -		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +	cap->device_caps = V4L2_CAP_STREAMING;
> +	switch (dma->queue.type) {
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE_MPLANE;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
> +		break;
> +	case V4L2_CAP_VIDEO_OUTPUT_MPLANE:
> +		cap->device_caps |= V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> +		break;
> +	case V4L2_CAP_VIDEO_OUTPUT:
> +		cap->device_caps |= V4L2_CAP_VIDEO_OUTPUT;
> +		break;
> +	}
>  
>  	strlcpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
>  	strlcpy(cap->card, dma->video.name, sizeof(cap->card));
> @@ -523,7 +643,11 @@ xvip_dma_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
>  	if (f->index > 0)
>  		return -EINVAL;
>  
> -	f->pixelformat = dma->format.pixelformat;
> +	if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type))
> +		f->pixelformat = dma->format.fmt.pix_mp.pixelformat;
> +	else
> +		f->pixelformat = dma->format.fmt.pix.pixelformat;
> +
>  	strlcpy(f->description, dma->fmtinfo->description,
>  		sizeof(f->description));
>  
> @@ -536,13 +660,17 @@ xvip_dma_get_format(struct file *file, void *fh, struct v4l2_format *format)
>  	struct v4l2_fh *vfh = file->private_data;
>  	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
>  
> -	format->fmt.pix = dma->format;
> +	if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type))
> +		format->fmt.pix_mp = dma->format.fmt.pix_mp;
> +	else
> +		format->fmt.pix = dma->format.fmt.pix;
>  
>  	return 0;
>  }
>  
>  static void
> -__xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
> +__xvip_dma_try_format(struct xvip_dma *dma,
> +		      struct v4l2_format *format,
>  		      const struct xvip_video_format **fmtinfo)
>  {
>  	const struct xvip_video_format *info;
> @@ -553,40 +681,91 @@ __xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
>  	unsigned int width;
>  	unsigned int align;
>  	unsigned int bpl;
> +	unsigned int i, hsub, vsub, plane_width, plane_height;
>  
>  	/* Retrieve format information and select the default format if the
>  	 * requested format isn't supported.
>  	 */
> -	info = xvip_get_format_by_fourcc(pix->pixelformat);
> +	if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type))
> +	    info = xvip_get_format_by_fourcc(format->fmt.pix_mp.pixelformat);
> +	else
> +	    info = xvip_get_format_by_fourcc(format->fmt.pix.pixelformat);
> +
>  	if (IS_ERR(info))
>  		info = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
>  
> -	pix->pixelformat = info->fourcc;
> -	pix->field = V4L2_FIELD_NONE;
> -
>  	/* The transfer alignment requirements are expressed in bytes. Compute
>  	 * the minimum and maximum values, clamp the requested width and convert
>  	 * it back to pixels.
>  	 */
> -	align = lcm(dma->align, info->bpp);
> +	align = lcm(dma->align, info->bpl_factor);

This is incorrect. Use bits-per-pixel / 8.

>  	min_width = roundup(XVIP_DMA_MIN_WIDTH, align);
>  	max_width = rounddown(XVIP_DMA_MAX_WIDTH, align);
> -	width = rounddown(pix->width * info->bpp, align);
>  
> -	pix->width = clamp(width, min_width, max_width) / info->bpp;
> -	pix->height = clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
> -			    XVIP_DMA_MAX_HEIGHT);
> +	if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {
> +		struct v4l2_pix_format_mplane *pix_mp;
> +
> +		pix_mp = &format->fmt.pix_mp;
> +		pix_mp->field = V4L2_FIELD_NONE;
> +		width = rounddown(pix_mp->width * info->bpl_factor, align);

As commented earlier, not sure what bpl_factor is for.

> +		pix_mp->width = clamp(width, min_width, max_width) /
> +							info->bpl_factor;
> +		pix_mp->height = clamp(pix_mp->height, XVIP_DMA_MIN_HEIGHT,
> +				       XVIP_DMA_MAX_HEIGHT);
> +
> +		/*
> +		 * Clamp the requested bytes per line value. If the maximum
> +		 * bytes per line value is zero, the module doesn't support
> +		 * user configurable line sizes. Override the requested value
> +		 * with the minimum in that case.
> +		 */
> +
> +		/* Handling contiguous data with mplanes */
> +		if (info->buffers == 1) {
> +			min_bpl = pix_mp->width * info->bpl_factor;
> +			max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
> +			bpl = rounddown(pix_mp->plane_fmt[0].bytesperline,
> +					dma->align);
> +			pix_mp->plane_fmt[0].bytesperline = clamp(bpl, min_bpl,
> +								  max_bpl);
> +			pix_mp->plane_fmt[0].sizeimage =
> +			      (pix_mp->width * pix_mp->height * info->bpp) >> 3;

Nit. '/ 8' would be more clear for bits to bytes conversion in my opinion,
but up to you. Then it should be rounded up not to lose fractional,
DIV_ROUND_UP().

> +		} else {
> +			/* Handling non-contiguous data with mplanes */
> +			hsub = info->hsub;
> +			vsub = info->vsub;
> +			for (i = 0; i < info->num_planes; i++) {
> +				plane_width = pix_mp->width / (i ? hsub : 1);
> +				plane_height = pix_mp->height / (i ? vsub : 1);
> +				min_bpl = plane_width * info->bpl_factor;
> +				max_bpl = rounddown(XVIP_DMA_MAX_WIDTH,
> +						    dma->align);
> +				bpl = pix_mp->plane_fmt[i].bytesperline;
> +				bpl = rounddown(bpl, dma->align);
> +				pix_mp->plane_fmt[i].bytesperline =
> +						clamp(bpl, min_bpl, max_bpl);
> +				pix_mp->plane_fmt[i].sizeimage =
> +					pix_mp->plane_fmt[i].bytesperline *
> +								plane_height;
> +			}
> +		}
> +	} else {
> +		struct v4l2_pix_format *pix;
>  
> -	/* Clamp the requested bytes per line value. If the maximum bytes per
> -	 * line value is zero, the module doesn't support user configurable line
> -	 * sizes. Override the requested value with the minimum in that case.
> -	 */
> -	min_bpl = pix->width * info->bpp;
> -	max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
> -	bpl = rounddown(pix->bytesperline, dma->align);
> +		pix = &format->fmt.pix;
> +		pix->field = V4L2_FIELD_NONE;
> +
> +		width = rounddown(pix->width * info->bpp, align);

'width' is number of pixels per line here, but the result is not, as info->bpp
is now bits-per-pixel.

> +		pix->width = clamp(width, min_width, max_width) / info->bpp;
> +		pix->height = clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
> +				    XVIP_DMA_MAX_HEIGHT);
>  
> -	pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
> -	pix->sizeimage = pix->bytesperline * pix->height;
> +		min_bpl = pix->width * info->bpl_factor;
> +		max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
> +		bpl = rounddown(pix->bytesperline, dma->align);
> +		pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
> +		pix->sizeimage = (pix->width * pix->height * info->bpp) >> 3;
> +	}
>  
>  	if (fmtinfo)
>  		*fmtinfo = info;
> @@ -598,7 +777,7 @@ xvip_dma_try_format(struct file *file, void *fh, struct v4l2_format *format)
>  	struct v4l2_fh *vfh = file->private_data;
>  	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
>  
> -	__xvip_dma_try_format(dma, &format->fmt.pix, NULL);
> +	__xvip_dma_try_format(dma, format, NULL);
>  	return 0;
>  }
>  
> @@ -609,12 +788,16 @@ xvip_dma_set_format(struct file *file, void *fh, struct v4l2_format *format)
>  	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
>  	const struct xvip_video_format *info;
>  
> -	__xvip_dma_try_format(dma, &format->fmt.pix, &info);
> +	__xvip_dma_try_format(dma, format, &info);
>  
>  	if (vb2_is_busy(&dma->queue))
>  		return -EBUSY;
>  
> -	dma->format = format->fmt.pix;
> +	if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type))
> +		dma->format.fmt.pix_mp = format->fmt.pix_mp;
> +	else
> +		dma->format.fmt.pix = format->fmt.pix;
> +
>  	dma->fmtinfo = info;
>  
>  	return 0;
> @@ -623,11 +806,15 @@ xvip_dma_set_format(struct file *file, void *fh, struct v4l2_format *format)
>  static const struct v4l2_ioctl_ops xvip_dma_ioctl_ops = {
>  	.vidioc_querycap		= xvip_dma_querycap,
>  	.vidioc_enum_fmt_vid_cap	= xvip_dma_enum_format,
> +	.vidioc_enum_fmt_vid_cap_mplane	= xvip_dma_enum_format,
>  	.vidioc_g_fmt_vid_cap		= xvip_dma_get_format,
> +	.vidioc_g_fmt_vid_cap_mplane	= xvip_dma_get_format,
>  	.vidioc_g_fmt_vid_out		= xvip_dma_get_format,
>  	.vidioc_s_fmt_vid_cap		= xvip_dma_set_format,
> +	.vidioc_s_fmt_vid_cap_mplane	= xvip_dma_set_format,
>  	.vidioc_s_fmt_vid_out		= xvip_dma_set_format,
>  	.vidioc_try_fmt_vid_cap		= xvip_dma_try_format,
> +	.vidioc_try_fmt_vid_cap_mplane	= xvip_dma_try_format,
>  	.vidioc_try_fmt_vid_out		= xvip_dma_try_format,
>  	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
>  	.vidioc_querybuf		= vb2_ioctl_querybuf,
> @@ -661,6 +848,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
>  {
>  	char name[16];
>  	int ret;
> +	u32 i, hsub, vsub, width, height;
>  
>  	dma->xdev = xdev;
>  	dma->port = port;
> @@ -670,17 +858,55 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
>  	spin_lock_init(&dma->queued_lock);
>  
>  	dma->fmtinfo = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
> -	dma->format.pixelformat = dma->fmtinfo->fourcc;
> -	dma->format.colorspace = V4L2_COLORSPACE_SRGB;
> -	dma->format.field = V4L2_FIELD_NONE;
> -	dma->format.width = XVIP_DMA_DEF_WIDTH;
> -	dma->format.height = XVIP_DMA_DEF_HEIGHT;
> -	dma->format.bytesperline = dma->format.width * dma->fmtinfo->bpp;
> -	dma->format.sizeimage = dma->format.bytesperline * dma->format.height;
> +	dma->format.type = type;
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(type)) {
> +		struct v4l2_pix_format_mplane *pix_mp;
> +
> +		pix_mp = &dma->format.fmt.pix_mp;
> +		pix_mp->pixelformat = dma->fmtinfo->fourcc;
> +		pix_mp->colorspace = V4L2_COLORSPACE_SRGB;
> +		pix_mp->field = V4L2_FIELD_NONE;
> +		pix_mp->width = XVIP_DMA_DEF_WIDTH;
> +
> +		/* Handling contiguous data with mplanes */
> +		if (dma->fmtinfo->buffers == 1) {
> +		    pix_mp->plane_fmt[0].bytesperline =
> +		      pix_mp->width * dma->fmtinfo->bpl_factor;
> +		    pix_mp->plane_fmt[0].sizeimage =
> +		      (pix_mp->width * pix_mp->height * dma->fmtinfo->bpp) >> 3;
> +		} else {
> +		    /* Handling non-contiguous data with mplanes */
> +		    hsub = dma->fmtinfo->hsub;
> +		    vsub = dma->fmtinfo->vsub;
> +		    for (i = 0; i < dma->fmtinfo->num_planes; i++) {

Ditto. Please check num_planes vs num buffers.

> +				width  = pix_mp->width / (i ? hsub : 1);
> +				height = pix_mp->height / (i ? vsub : 1);
> +				pix_mp->plane_fmt[i].bytesperline = width *
> +						dma->fmtinfo->bpl_factor;
> +				pix_mp->plane_fmt[i].sizeimage = width * height;
> +		    }
> +		}
> +	} else {
> +		struct v4l2_pix_format *pix;
> +
> +		pix = &dma->format.fmt.pix;
> +		pix->pixelformat = dma->fmtinfo->fourcc;
> +		pix->colorspace = V4L2_COLORSPACE_SRGB;
> +		pix->field = V4L2_FIELD_NONE;
> +		pix->width = XVIP_DMA_DEF_WIDTH;
> +		pix->height = XVIP_DMA_DEF_HEIGHT;
> +		pix->bytesperline = pix->width * dma->fmtinfo->bpl_factor;
> +		pix->sizeimage =
> +			(pix->width * pix->height * dma->fmtinfo->bpp) >> 3;
> +	}
>  
>  	/* Initialize the media entity... */
> -	dma->pad.flags = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
> -		       ? MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
> +	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +	    type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		dma->pad.flags = MEDIA_PAD_FL_SINK;
> +	else
> +		dma->pad.flags = MEDIA_PAD_FL_SOURCE;
>  
>  	ret = media_entity_pads_init(&dma->video.entity, 1, &dma->pad);
>  	if (ret < 0)
> @@ -692,11 +918,18 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
>  	dma->video.queue = &dma->queue;
>  	snprintf(dma->video.name, sizeof(dma->video.name), "%s %s %u",
>  		 xdev->dev->of_node->name,
> -		 type == V4L2_BUF_TYPE_VIDEO_CAPTURE ? "output" : "input",
> +		 (type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +		 type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +					? "output" : "input",

Need to set OUTPUT_MPLANE.

>  		 port);
> +
>  	dma->video.vfl_type = VFL_TYPE_GRABBER;
> -	dma->video.vfl_dir = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
> -			   ? VFL_DIR_RX : VFL_DIR_TX;
> +	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +	    type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		dma->video.vfl_dir = VFL_DIR_RX;
> +	else
> +		dma->video.vfl_dir = VFL_DIR_TX;
> +
>  	dma->video.release = video_device_release_empty;
>  	dma->video.ioctl_ops = &xvip_dma_ioctl_ops;
>  	dma->video.lock = &dma->lock;
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/platform/xilinx/xilinx-dma.h
> index e95d136..b352bef 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.h
> +++ b/drivers/media/platform/xilinx/xilinx-dma.h
> @@ -83,7 +83,7 @@ struct xvip_dma {
>  	unsigned int port;
>  
>  	struct mutex lock;
> -	struct v4l2_pix_format format;
> +	struct v4l2_format format;
>  	const struct xvip_video_format *fmtinfo;
>  
>  	struct vb2_queue queue;
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
> index 6bb28cd..508cfac 100644
> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -30,6 +30,15 @@
>  #define XVIPP_DMA_S2MM				0
>  #define XVIPP_DMA_MM2S				1
>  
> +/*
> + * This is for backward compatibility for existing applications,
> + * and planned to be deprecated
> + */
> +static bool xvip_is_mplane = true;
> +MODULE_PARM_DESC(is_mplane,
> +		 "v4l2 device capability to handle multi planar formats");
> +module_param_named(is_mplane, xvip_is_mplane, bool, 0444);
> +

As commented above, let's work toward removing this. It will simplify changes
a lot.

Thanks,
-hyun

>  /**
>   * struct xvip_graph_entity - Entity in the video graph
>   * @list: list entry in a graph entities list
> @@ -434,7 +443,8 @@ static int xvip_graph_dma_init_one(struct xvip_composite_device *xdev,
>  		return ret;
>  
>  	if (strcmp(direction, "input") == 0)
> -		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +		type = xvip_is_mplane ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
> +						V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  	else if (strcmp(direction, "output") == 0)
>  		type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>  	else
> @@ -454,8 +464,14 @@ static int xvip_graph_dma_init_one(struct xvip_composite_device *xdev,
>  
>  	list_add_tail(&dma->list, &xdev->dmas);
>  
> -	xdev->v4l2_caps |= type == V4L2_BUF_TYPE_VIDEO_CAPTURE
> -			 ? V4L2_CAP_VIDEO_CAPTURE : V4L2_CAP_VIDEO_OUTPUT;
> +	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		xdev->v4l2_caps |= V4L2_CAP_VIDEO_CAPTURE_MPLANE;
> +	else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		xdev->v4l2_caps |= V4L2_CAP_VIDEO_CAPTURE;
> +	else if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		xdev->v4l2_caps |= V4L2_CAP_VIDEO_OUTPUT;
> +	else if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		xdev->v4l2_caps |= V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>  
>  	return 0;
>  }
> -- 
> 2.7.4
> 
