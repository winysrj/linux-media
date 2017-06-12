Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:32949 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751969AbdFLJ6J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 05:58:09 -0400
Subject: Re: [RFC PATCH v3 07/11] [media] vimc: cap: Support several image
 formats
To: Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: jgebben@codeaurora.org, mchehab@osg.samsung.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
 <1496458714-16834-1-git-send-email-helen.koike@collabora.com>
 <1496458714-16834-8-git-send-email-helen.koike@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5ef11f98-4f67-69e4-9d2d-e644054d3f7c@xs4all.nl>
Date: Mon, 12 Jun 2017 11:58:02 +0200
MIME-Version: 1.0
In-Reply-To: <1496458714-16834-8-git-send-email-helen.koike@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2017 04:58 AM, Helen Koike wrote:
> Allow user space to change the image format as the frame size, the
> pixel format, colorspace, quantization, field YCbCr encoding
> and the transfer function
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> 
> ---
> 
> Changes in v3:
> [media] vimc: cap: Support several image formats
> 	- use *_DEFAULT macros for colorimetry in the default format
> 	- clamp height and width of the image by an even value
> 	- is user try to set colorspace to an invalid format, set all
> 	colorimetry parameters to _DEFAULT
> 	- remove V4L2_FMT_FLAG_COMPRESSED from vimc_cap_enum_fmt_vid_cap
> 	- remove V4L2_BUF_TYPE_VIDEO_CAPTURE from vimc_cap_enum_fmt_vid_cap
> 	- increase step_width and step_height to 2 instead of 1
> 	- remove link validate function, use the one in vimc-common.c
> 
> Changes in v2:
> [media] vimc: cap: Support several image formats
> 	- this is a new commit in the serie (the old one was splitted in two)
> 	- allow user space to change all fields from struct v4l2_pix_format
> 	  (e.g. colospace, quantization, field, xfer_func, ycbcr_enc)
> 	- link_validate and try_fmt: also checks colospace, quantization, field, xfer_func, ycbcr_enc
> 	- add struct v4l2_pix_format fmt_default
> 	- add enum_framesizes
> 	- enum_fmt_vid_cap: enumerate all formats from vimc_pix_map_table
> 	- add mode dev_dbg
> 
> 
> ---
>   drivers/media/platform/vimc/vimc-capture.c | 131 +++++++++++++++++++++++++----
>   1 file changed, 115 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
> index 5bdecd1..e943267 100644
> --- a/drivers/media/platform/vimc/vimc-capture.c
> +++ b/drivers/media/platform/vimc/vimc-capture.c
> @@ -40,6 +40,14 @@ struct vimc_cap_device {
>   	struct media_pipeline pipe;
>   };
>   
> +static const struct v4l2_pix_format fmt_default = {
> +	.width = 640,
> +	.height = 480,
> +	.pixelformat = V4L2_PIX_FMT_RGB24,
> +	.field = V4L2_FIELD_NONE,
> +	.colorspace = V4L2_COLORSPACE_SRGB,
> +};
> +
>   struct vimc_cap_buffer {
>   	/*
>   	 * struct vb2_v4l2_buffer must be the first element
> @@ -73,7 +81,7 @@ static void vimc_cap_get_format(struct vimc_ent_device *ved,
>   	*fmt = vcap->format;
>   }
>   
> -static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
> +static int vimc_cap_g_fmt_vid_cap(struct file *file, void *priv,
>   				  struct v4l2_format *f)
>   {
>   	struct vimc_cap_device *vcap = video_drvdata(file);
> @@ -83,16 +91,112 @@ static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
>   	return 0;
>   }
>   
> +static int vimc_cap_try_fmt_vid_cap(struct file *file, void *priv,
> +				    struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format *format = &f->fmt.pix;
> +	const struct vimc_pix_map *vpix;
> +
> +	format->width = clamp_t(u32, format->width, VIMC_FRAME_MIN_WIDTH,
> +				VIMC_FRAME_MAX_WIDTH) & ~1;
> +	format->height = clamp_t(u32, format->height, VIMC_FRAME_MIN_HEIGHT,
> +				 VIMC_FRAME_MAX_HEIGHT) & ~1;
> +
> +	/* Don't accept a pixelformat that is not on the table */
> +	vpix = vimc_pix_map_by_pixelformat(format->pixelformat);
> +	if (!vpix) {
> +		format->pixelformat = fmt_default.pixelformat;
> +		vpix = vimc_pix_map_by_pixelformat(format->pixelformat);
> +	}
> +	/* TODO: Add support for custom bytesperline values */
> +	format->bytesperline = format->width * vpix->bpp;
> +	format->sizeimage = format->bytesperline * format->height;
> +
> +	if (format->field == V4L2_FIELD_ANY)
> +		format->field = fmt_default.field;
> +
> +	if (format->colorspace == V4L2_COLORSPACE_DEFAULT)
> +		format->colorspace = fmt_default.colorspace;
> +
> +	/* Check if values are out of range */
> +	if (format->colorspace > V4L2_COLORSPACE_DCI_P3) {
> +		format->colorspace = fmt_default.colorspace;
> +		format->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +		format->quantization = V4L2_QUANTIZATION_DEFAULT;
> +		format->xfer_func = V4L2_XFER_FUNC_DEFAULT;
> +	}
> +	if (format->ycbcr_enc > V4L2_YCBCR_ENC_SMPTE240M)
> +		format->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +	if (format->quantization > V4L2_QUANTIZATION_LIM_RANGE)
> +		format->quantization = V4L2_QUANTIZATION_DEFAULT;
> +	if (format->xfer_func > V4L2_XFER_FUNC_SMPTE2084)
> +		format->xfer_func = V4L2_XFER_FUNC_DEFAULT;

You might want to move this to common, since the sensor has the same code.

> +	return 0;
> +}
> +
> +static int vimc_cap_s_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct vimc_cap_device *vcap = video_drvdata(file);
> +
> +	/* Do not change the format while stream is on */
> +	if (vb2_is_busy(&vcap->queue))
> +		return -EBUSY;
> +
> +	vimc_cap_try_fmt_vid_cap(file, priv, f);
> +
> +	dev_dbg(vcap->vdev.v4l2_dev->dev, "%s: format update: "
> +		"old:%dx%d (0x%x, %d, %d, %d, %d) "
> +		"new:%dx%d (0x%x, %d, %d, %d, %d)\n", vcap->vdev.name,
> +		/* old */
> +		vcap->format.width, vcap->format.height,
> +		vcap->format.pixelformat, vcap->format.colorspace,
> +		vcap->format.quantization, vcap->format.xfer_func,
> +		vcap->format.ycbcr_enc,
> +		/* new */
> +		f->fmt.pix.width, f->fmt.pix.height,
> +		f->fmt.pix.pixelformat,	f->fmt.pix.colorspace,
> +		f->fmt.pix.quantization, f->fmt.pix.xfer_func,
> +		f->fmt.pix.ycbcr_enc);
> +
> +	vcap->format = f->fmt.pix;
> +
> +	return 0;
> +}
> +
>   static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
>   				     struct v4l2_fmtdesc *f)
>   {
> -	struct vimc_cap_device *vcap = video_drvdata(file);
> +	const struct vimc_pix_map *vpix = vimc_pix_map_by_index(f->index);
> +
> +	if (!vpix)
> +		return -EINVAL;
> +
> +	f->pixelformat = vpix->pixelformat;
> +
> +	return 0;
> +}
> +
> +static int vimc_cap_enum_framesizes(struct file *file, void *fh,
> +				    struct v4l2_frmsizeenum *fsize)
> +{
> +	const struct vimc_pix_map *vpix;
>   
> -	if (f->index > 0)
> +	if (fsize->index)
>   		return -EINVAL;
>   
> -	/* We only support one format for now */
> -	f->pixelformat = vcap->format.pixelformat;
> +	/* Only accept code in the pix map table */
> +	vpix = vimc_pix_map_by_code(fsize->pixel_format);
> +	if (!vpix)
> +		return -EINVAL;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
> +	fsize->stepwise.min_width = VIMC_FRAME_MIN_WIDTH;
> +	fsize->stepwise.max_width = VIMC_FRAME_MAX_WIDTH;
> +	fsize->stepwise.min_height = VIMC_FRAME_MIN_HEIGHT;
> +	fsize->stepwise.max_height = VIMC_FRAME_MAX_HEIGHT;
> +	fsize->stepwise.step_width = 2;
> +	fsize->stepwise.step_height = 2;
>   
>   	return 0;
>   }
> @@ -110,10 +214,11 @@ static const struct v4l2_file_operations vimc_cap_fops = {
>   static const struct v4l2_ioctl_ops vimc_cap_ioctl_ops = {
>   	.vidioc_querycap = vimc_cap_querycap,
>   
> -	.vidioc_g_fmt_vid_cap = vimc_cap_fmt_vid_cap,
> -	.vidioc_s_fmt_vid_cap = vimc_cap_fmt_vid_cap,
> -	.vidioc_try_fmt_vid_cap = vimc_cap_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap = vimc_cap_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap = vimc_cap_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap = vimc_cap_try_fmt_vid_cap,
>   	.vidioc_enum_fmt_vid_cap = vimc_cap_enum_fmt_vid_cap,
> +	.vidioc_enum_framesizes = vimc_cap_enum_framesizes,
>   
>   	.vidioc_reqbufs = vb2_ioctl_reqbufs,
>   	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> @@ -360,15 +465,9 @@ struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
>   	INIT_LIST_HEAD(&vcap->buf_list);
>   	spin_lock_init(&vcap->qlock);
>   
> -	/* Set the frame format (this is hardcoded for now) */
> -	vcap->format.width = 640;
> -	vcap->format.height = 480;
> -	vcap->format.pixelformat = V4L2_PIX_FMT_RGB24;
> -	vcap->format.field = V4L2_FIELD_NONE;
> -	vcap->format.colorspace = V4L2_COLORSPACE_SRGB;
> -
> +	/* Set default frame format */
> +	vcap->format = fmt_default;
>   	vpix = vimc_pix_map_by_pixelformat(vcap->format.pixelformat);
> -
>   	vcap->format.bytesperline = vcap->format.width * vpix->bpp;
>   	vcap->format.sizeimage = vcap->format.bytesperline *
>   				 vcap->format.height;
> 

Regards,

	Hans
