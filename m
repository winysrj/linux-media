Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52500 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726151AbeLDNHO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 08:07:14 -0500
Date: Tue, 4 Dec 2018 15:07:09 +0200
From: sakari.ailus@iki.fi
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>, kernel@collabora.com
Subject: Re: [PATCH v2] v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields
Message-ID: <20181204130709.gwm2i7h6zsild2ww@valkosipuli.retiisi.org.uk>
References: <20181127220756.26913-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127220756.26913-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 27, 2018 at 07:07:56PM -0300, Ezequiel Garcia wrote:
> Make the core set the reserved fields to zero in
> vv4l2_pix_format_mplane.4l2_plane_pix_format,
> for _MPLANE queue types.
> 
> Moving this to the core avoids having to do so in each
> and every driver.
> 
> Suggested-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> --
> v2:
>   * Drop unneeded clear in g_fmt.
>     The sturct was already being cleared here.
>   * Only zero plane_fmt reserved fields.
>   * Use CLEAR_FIELD_MACRO.
> 
>  drivers/media/v4l2-core/v4l2-ioctl.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index e384142d2826..2506b602481f 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1512,6 +1512,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_format *p = arg;
>  	struct video_device *vfd = video_devdata(file);
>  	int ret = check_fmt(file, p->type);
> +	int i;

unsigned int; same below.

With that,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>  
>  	if (ret)
>  		return ret;
> @@ -1536,6 +1537,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
>  		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
> @@ -1564,6 +1567,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
>  		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>  		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
> @@ -1604,6 +1609,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  {
>  	struct v4l2_format *p = arg;
>  	int ret = check_fmt(file, p->type);
> +	int i;
>  
>  	if (ret)
>  		return ret;
> @@ -1623,6 +1629,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
>  		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
> @@ -1651,6 +1659,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
>  		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>  		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
