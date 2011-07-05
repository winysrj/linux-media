Return-path: <mchehab@localhost>
Received: from bear.ext.ti.com ([192.94.94.41]:59577 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1GETQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 15:16:20 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p65JGG5d001641
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 5 Jul 2011 14:16:19 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "JAIN, AMBER" <amber@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Semwal, Sumit" <sumit.semwal@ti.com>,
	"Nilofer, Samreen" <samreen@ti.com>
Date: Wed, 6 Jul 2011 00:46:15 +0530
Subject: RE: [PATCH 3/6] V4L2: OMAP: VOUT: Adapt to Multiplanar APIs
Message-ID: <19F8576C6E063C45BE387C64729E739404E3485E6F@dbde02.ent.ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
 <1307458058-29030-4-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-4-git-send-email-amber@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>


> -----Original Message-----
> From: JAIN, AMBER
> Sent: Tuesday, June 07, 2011 8:18 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav; Semwal, Sumit; JAIN, AMBER; Nilofer, Samreen
> Subject: [PATCH 3/6] V4L2: OMAP: VOUT: Adapt to Multiplanar APIs
> 
> Adapting the omap_vout driver for multiplanar API support.
> 
[Hiremath, Vaibhav] Personally I think it doesn't make sense to change function names only without adding functionality.

So I would suggest merging this patch with the actual multi-planar format support patch, which I believe is not part of this series.

Irrespective of this, can you create separate patch series for,

  V4L2: OMAP: VOUT: isr handling extended for DPI and HDMI interface
  V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers in qbuf and dqbuf
  V4l2: OMAP: VOUT: Minor Cleanup, removing the unnecessary code.

Thanks,
Vaibhav

> Signed-off-by: Amber Jain <amber@ti.com>
> Signed-off-by: Samreen <samreen@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 435fe65..70fb45e 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -1014,12 +1014,13 @@ static int vidioc_querycap(struct file *file, void
> *fh,
>  	strlcpy(cap->driver, VOUT_NAME, sizeof(cap->driver));
>  	strlcpy(cap->card, vout->vfd->name, sizeof(cap->card));
>  	cap->bus_info[0] = '\0';
> -	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT;
> +	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT |
> +				V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> 
>  	return 0;
>  }
> 
> -static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
> +static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *fh,
>  			struct v4l2_fmtdesc *fmt)
>  {
>  	int index = fmt->index;
> @@ -1038,7 +1039,7 @@ static int vidioc_enum_fmt_vid_out(struct file *file,
> void *fh,
>  	return 0;
>  }
> 
> -static int vidioc_g_fmt_vid_out(struct file *file, void *fh,
> +static int vidioc_g_fmt_vid_out_mplane(struct file *file, void *fh,
>  			struct v4l2_format *f)
>  {
>  	struct omap_vout_device *vout = fh;
> @@ -1048,7 +1049,7 @@ static int vidioc_g_fmt_vid_out(struct file *file,
> void *fh,
> 
>  }
> 
> -static int vidioc_try_fmt_vid_out(struct file *file, void *fh,
> +static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *fh,
>  			struct v4l2_format *f)
>  {
>  	struct omap_overlay *ovl;
> @@ -1071,7 +1072,7 @@ static int vidioc_try_fmt_vid_out(struct file *file,
> void *fh,
>  	return 0;
>  }
> 
> -static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
> +static int vidioc_s_fmt_vid_out_mplane(struct file *file, void *fh,
>  			struct v4l2_format *f)
>  {
>  	int ret, bpp;
> @@ -1817,10 +1818,10 @@ static int vidioc_g_fbuf(struct file *file, void
> *fh,
> 
>  static const struct v4l2_ioctl_ops vout_ioctl_ops = {
>  	.vidioc_querycap      			= vidioc_querycap,
> -	.vidioc_enum_fmt_vid_out 		= vidioc_enum_fmt_vid_out,
> -	.vidioc_g_fmt_vid_out			= vidioc_g_fmt_vid_out,
> -	.vidioc_try_fmt_vid_out			= vidioc_try_fmt_vid_out,
> -	.vidioc_s_fmt_vid_out			= vidioc_s_fmt_vid_out,
> +	.vidioc_enum_fmt_vid_out_mplane		=
> vidioc_enum_fmt_vid_out_mplane,
> +	.vidioc_g_fmt_vid_out_mplane		= vidioc_g_fmt_vid_out_mplane,
> +	.vidioc_try_fmt_vid_out_mplane		=
> vidioc_try_fmt_vid_out_mplane,
> +	.vidioc_s_fmt_vid_out_mplane		= vidioc_s_fmt_vid_out_mplane,
>  	.vidioc_queryctrl    			= vidioc_queryctrl,
>  	.vidioc_g_ctrl       			= vidioc_g_ctrl,
>  	.vidioc_s_fbuf				= vidioc_s_fbuf,
> --
> 1.7.1

