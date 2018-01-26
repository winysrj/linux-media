Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40040 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752773AbeAZOlp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 09:41:45 -0500
Date: Fri, 26 Jan 2018 16:41:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 02/12] v4l2-ioctl.c: use check_fmt for enum/g/s/try_fmt
Message-ID: <20180126144141.zvl2n4pzxjbyethh@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126124327.16653-3-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jan 26, 2018 at 01:43:17PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Don't duplicate the buffer type checks in enum/g/s/try_fmt.
> The check_fmt function does that already.
> 
> It is hard to keep the checks in sync for all these functions and
> in fact the check for VBI was wrong in the _fmt functions as it
> allowed SDR types as well. This caused a v4l2-compliance failure
> for /dev/swradio0 using vivid.
> 
> This simplifies the code and keeps the check in one place and
> fixes the SDR/VBI bug.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 140 ++++++++++++++---------------------
>  1 file changed, 54 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 59d2100eeff6..c7f6b65d3ad7 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1316,52 +1316,50 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
>  	struct v4l2_fmtdesc *p = arg;
> -	struct video_device *vfd = video_devdata(file);
> -	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
> -	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> -	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
> -	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
> -	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
> -	int ret = -EINVAL;
> +	int ret = check_fmt(file, p->type);

I'd separate this from the variable declaration. The function is doing more
than just fetch something to be used as a shorthand locally. I.e.

	int ret;

	ret = check_fmt(file, p->type);

Same elsewhere.

The patch appears to be making an assumption that get_fmt will be
universally supported on any buffer type, or that buffer type is not
supported at all. I don't see a problem with the approach, but it'd be nice
to document it, perhaps in struct v4l2_ioctl_ops KernelDoc documentation.

check_fmt() allows V4L2_BUF_TYPE_VBI_CAPTURE, V4L2_BUF_TYPE_VBI_OUTPUT,
V4L2_BUF_TYPE_SLICED_VBI_CAPTURE and V4L2_BUF_TYPE_SLICED_VBI_OUTPUT that
the original code did not for VIDIOC_ENUM_FMT. Is the change intentional?

Documentation should be updated regarding SDR and META formats (buffer
type) but that's out of scope of the patchset:

<URL:https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-enum-fmt.html>

> +
> +	if (ret)
> +		return ret;
> +	ret = -EINVAL;
>  
>  	switch (p->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_enum_fmt_vid_cap))
> +		if (unlikely(!ops->vidioc_enum_fmt_vid_cap))
>  			break;
>  		ret = ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_cap_mplane))
> +		if (unlikely(!ops->vidioc_enum_fmt_vid_cap_mplane))
>  			break;
>  		ret = ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, arg);
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_overlay))
> +		if (unlikely(!ops->vidioc_enum_fmt_vid_overlay))
>  			break;
>  		ret = ops->vidioc_enum_fmt_vid_overlay(file, fh, arg);
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_vid_out))
> +		if (unlikely(!ops->vidioc_enum_fmt_vid_out))
>  			break;
>  		ret = ops->vidioc_enum_fmt_vid_out(file, fh, arg);
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_vid_out_mplane))
> +		if (unlikely(!ops->vidioc_enum_fmt_vid_out_mplane))
>  			break;
>  		ret = ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
>  		break;
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
> -		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_enum_fmt_sdr_cap))
> +		if (unlikely(!ops->vidioc_enum_fmt_sdr_cap))
>  			break;
>  		ret = ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
>  		break;
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
> -		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_enum_fmt_sdr_out))
> +		if (unlikely(!ops->vidioc_enum_fmt_sdr_out))
>  			break;
>  		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, arg);
>  		break;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_meta_cap))
> +		if (unlikely(!ops->vidioc_enum_fmt_meta_cap))
>  			break;
>  		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
>  		break;
> @@ -1375,13 +1373,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
>  	struct v4l2_format *p = arg;
> -	struct video_device *vfd = video_devdata(file);
> -	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
> -	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> -	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
> -	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
> -	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
> -	int ret;
> +	int ret = check_fmt(file, p->type);
> +
> +	if (ret)
> +		return ret;
>  
>  	/*
>  	 * fmt can't be cleared for these overlay types due to the 'clips'
> @@ -1409,7 +1404,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  
>  	switch (p->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_g_fmt_vid_cap))
> +		if (unlikely(!ops->vidioc_g_fmt_vid_cap))
>  			break;
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
> @@ -1417,23 +1412,15 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap_mplane))
> -			break;
>  		return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_overlay))
> -			break;
>  		return ops->vidioc_g_fmt_vid_overlay(file, fh, arg);
>  	case V4L2_BUF_TYPE_VBI_CAPTURE:
> -		if (unlikely(!is_rx || is_vid || !ops->vidioc_g_fmt_vbi_cap))
> -			break;
>  		return ops->vidioc_g_fmt_vbi_cap(file, fh, arg);
>  	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
> -		if (unlikely(!is_rx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_cap))
> -			break;
>  		return ops->vidioc_g_fmt_sliced_vbi_cap(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out))
> +		if (unlikely(!ops->vidioc_g_fmt_vid_out))
>  			break;
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		ret = ops->vidioc_g_fmt_vid_out(file, fh, arg);
> @@ -1441,32 +1428,18 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_mplane))
> -			break;
>  		return ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_overlay))
> -			break;
>  		return ops->vidioc_g_fmt_vid_out_overlay(file, fh, arg);
>  	case V4L2_BUF_TYPE_VBI_OUTPUT:
> -		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_vbi_out))
> -			break;
>  		return ops->vidioc_g_fmt_vbi_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> -		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_out))
> -			break;
>  		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
> -		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_g_fmt_sdr_cap))
> -			break;
>  		return ops->vidioc_g_fmt_sdr_cap(file, fh, arg);
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
> -		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_g_fmt_sdr_out))
> -			break;
>  		return ops->vidioc_g_fmt_sdr_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_meta_cap))
> -			break;
>  		return ops->vidioc_g_fmt_meta_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
> @@ -1492,12 +1465,10 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  {
>  	struct v4l2_format *p = arg;
>  	struct video_device *vfd = video_devdata(file);
> -	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
> -	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> -	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
> -	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
> -	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
> -	int ret;
> +	int ret = check_fmt(file, p->type);
> +
> +	if (ret)
> +		return ret;
>  
>  	ret = v4l_enable_media_source(vfd);
>  	if (ret)
> @@ -1506,37 +1477,37 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  
>  	switch (p->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_s_fmt_vid_cap))
> +		if (unlikely(!ops->vidioc_s_fmt_vid_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix);
>  		ret = ops->vidioc_s_fmt_vid_cap(file, fh, arg);
>  		/* just in case the driver zeroed it again */
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> -		if (is_tch)
> +		if (vfd->vfl_type == VFL_TYPE_TOUCH)
>  			v4l_pix_format_touch(&p->fmt.pix);
>  		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap_mplane))
> +		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_overlay))
> +		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.win);
>  		return ops->vidioc_s_fmt_vid_overlay(file, fh, arg);
>  	case V4L2_BUF_TYPE_VBI_CAPTURE:
> -		if (unlikely(!is_rx || is_vid || !ops->vidioc_s_fmt_vbi_cap))
> +		if (unlikely(!ops->vidioc_s_fmt_vbi_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.vbi);
>  		return ops->vidioc_s_fmt_vbi_cap(file, fh, arg);
>  	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
> -		if (unlikely(!is_rx || is_vid || !ops->vidioc_s_fmt_sliced_vbi_cap))
> +		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sliced);
>  		return ops->vidioc_s_fmt_sliced_vbi_cap(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out))
> +		if (unlikely(!ops->vidioc_s_fmt_vid_out))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix);
>  		ret = ops->vidioc_s_fmt_vid_out(file, fh, arg);
> @@ -1544,37 +1515,37 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_mplane))
> +		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_overlay))
> +		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.win);
>  		return ops->vidioc_s_fmt_vid_out_overlay(file, fh, arg);
>  	case V4L2_BUF_TYPE_VBI_OUTPUT:
> -		if (unlikely(!is_tx || is_vid || !ops->vidioc_s_fmt_vbi_out))
> +		if (unlikely(!ops->vidioc_s_fmt_vbi_out))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.vbi);
>  		return ops->vidioc_s_fmt_vbi_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> -		if (unlikely(!is_tx || is_vid || !ops->vidioc_s_fmt_sliced_vbi_out))
> +		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_out))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sliced);
>  		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
> -		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_s_fmt_sdr_cap))
> +		if (unlikely(!ops->vidioc_s_fmt_sdr_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_s_fmt_sdr_cap(file, fh, arg);
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
> -		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_s_fmt_sdr_out))
> +		if (unlikely(!ops->vidioc_s_fmt_sdr_out))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_s_fmt_sdr_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_meta_cap))
> +		if (unlikely(!ops->vidioc_s_fmt_meta_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.meta);
>  		return ops->vidioc_s_fmt_meta_cap(file, fh, arg);
> @@ -1586,19 +1557,16 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
>  	struct v4l2_format *p = arg;
> -	struct video_device *vfd = video_devdata(file);
> -	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
> -	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> -	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
> -	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
> -	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
> -	int ret;
> +	int ret = check_fmt(file, p->type);
> +
> +	if (ret)
> +		return ret;
>  
>  	v4l_sanitize_format(p);
>  
>  	switch (p->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_try_fmt_vid_cap))
> +		if (unlikely(!ops->vidioc_try_fmt_vid_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix);
>  		ret = ops->vidioc_try_fmt_vid_cap(file, fh, arg);
> @@ -1606,27 +1574,27 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_cap_mplane))
> +		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_overlay))
> +		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.win);
>  		return ops->vidioc_try_fmt_vid_overlay(file, fh, arg);
>  	case V4L2_BUF_TYPE_VBI_CAPTURE:
> -		if (unlikely(!is_rx || is_vid || !ops->vidioc_try_fmt_vbi_cap))
> +		if (unlikely(!ops->vidioc_try_fmt_vbi_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.vbi);
>  		return ops->vidioc_try_fmt_vbi_cap(file, fh, arg);
>  	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
> -		if (unlikely(!is_rx || is_vid || !ops->vidioc_try_fmt_sliced_vbi_cap))
> +		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sliced);
>  		return ops->vidioc_try_fmt_sliced_vbi_cap(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out))
> +		if (unlikely(!ops->vidioc_try_fmt_vid_out))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix);
>  		ret = ops->vidioc_try_fmt_vid_out(file, fh, arg);
> @@ -1634,37 +1602,37 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>  		return ret;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_mplane))
> +		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
>  		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
> -		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_overlay))
> +		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.win);
>  		return ops->vidioc_try_fmt_vid_out_overlay(file, fh, arg);
>  	case V4L2_BUF_TYPE_VBI_OUTPUT:
> -		if (unlikely(!is_tx || is_vid || !ops->vidioc_try_fmt_vbi_out))
> +		if (unlikely(!ops->vidioc_try_fmt_vbi_out))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.vbi);
>  		return ops->vidioc_try_fmt_vbi_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> -		if (unlikely(!is_tx || is_vid || !ops->vidioc_try_fmt_sliced_vbi_out))
> +		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_out))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sliced);
>  		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
> -		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_try_fmt_sdr_cap))
> +		if (unlikely(!ops->vidioc_try_fmt_sdr_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_try_fmt_sdr_cap(file, fh, arg);
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
> -		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_try_fmt_sdr_out))
> +		if (unlikely(!ops->vidioc_try_fmt_sdr_out))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_try_fmt_sdr_out(file, fh, arg);
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> -		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_meta_cap))
> +		if (unlikely(!ops->vidioc_try_fmt_meta_cap))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.meta);
>  		return ops->vidioc_try_fmt_meta_cap(file, fh, arg);
> -- 
> 2.15.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
