Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40198 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1LFQMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 11:12:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v2 4/4] v4l: Update subdev drivers to handle framesamples parameter
Date: Tue, 6 Dec 2011 17:12:29 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	g.liakhovetski@gmx.de, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <1322734853-8759-1-git-send-email-s.nawrocki@samsung.com> <1322734853-8759-5-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1322734853-8759-5-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112061712.30748.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 01 December 2011 11:20:53 Sylwester Nawrocki wrote:
> Update the sub-device drivers having a devnode enabled so they properly
> handle the new framesamples field of struct v4l2_mbus_framefmt.
> These drivers don't support compressed (entropy encoded) formats so the
> framesamples field is simply initialized to 0.

Wouldn't it be better to memset the whole structure before filling it ? This 
would handle reserved fields as well. One option would be to make the caller 
zero the structure, I think that would likely result in a smaller patch.

> There is a few other drivers that expose a devnode (mt9p031, mt9t001,
> mt9v032) but they already implicitly initialize the new data structure
> field to 0, so they don't need to be touched.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/noon010pc30.c         |    6 ++++--
>  drivers/media/video/omap3isp/ispccdc.c    |    1 +
>  drivers/media/video/omap3isp/ispccp2.c    |    1 +
>  drivers/media/video/omap3isp/ispcsi2.c    |    1 +
>  drivers/media/video/omap3isp/isppreview.c |    1 +
>  drivers/media/video/omap3isp/ispresizer.c |    1 +
>  drivers/media/video/s5k6aa.c              |    1 +
>  7 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/noon010pc30.c
> b/drivers/media/video/noon010pc30.c index 50838bf..ad94ffe 100644
> --- a/drivers/media/video/noon010pc30.c
> +++ b/drivers/media/video/noon010pc30.c
> @@ -523,9 +523,10 @@ static int noon010_get_fmt(struct v4l2_subdev *sd,
> struct v4l2_subdev_fh *fh, mf->height = info->curr_win->height;
>  	mf->code = info->curr_fmt->code;
>  	mf->colorspace = info->curr_fmt->colorspace;
> -	mf->field = V4L2_FIELD_NONE;
> -
>  	mutex_unlock(&info->lock);
> +
> +	mf->field = V4L2_FIELD_NONE;
> +	mf->framesamples = 0;
>  	return 0;
>  }
> 
> @@ -555,6 +556,7 @@ static int noon010_set_fmt(struct v4l2_subdev *sd,
> struct v4l2_subdev_fh *fh, nf = noon010_try_fmt(sd, &fmt->format);
>  	noon010_try_frame_size(&fmt->format, &size);
>  	fmt->format.colorspace = V4L2_COLORSPACE_JPEG;
> +	fmt->format.framesamples = 0;
> 
>  	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
>  		if (fh) {
> diff --git a/drivers/media/video/omap3isp/ispccdc.c
> b/drivers/media/video/omap3isp/ispccdc.c index b0b0fa5..3dff028 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -1863,6 +1863,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct
> v4l2_subdev_fh *fh, */
>  	fmt->colorspace = V4L2_COLORSPACE_SRGB;
>  	fmt->field = V4L2_FIELD_NONE;
> +	fmt->framesamples = 0;
>  }
> 
>  /*
> diff --git a/drivers/media/video/omap3isp/ispccp2.c
> b/drivers/media/video/omap3isp/ispccp2.c index 904ca8c..fd9dba6 100644
> --- a/drivers/media/video/omap3isp/ispccp2.c
> +++ b/drivers/media/video/omap3isp/ispccp2.c
> @@ -711,6 +711,7 @@ static void ccp2_try_format(struct isp_ccp2_device
> *ccp2,
> 
>  	fmt->field = V4L2_FIELD_NONE;
>  	fmt->colorspace = V4L2_COLORSPACE_SRGB;
> +	fmt->framesamples = 0;
>  }
> 
>  /*
> diff --git a/drivers/media/video/omap3isp/ispcsi2.c
> b/drivers/media/video/omap3isp/ispcsi2.c index 0c5f1cb..6b973f5 100644
> --- a/drivers/media/video/omap3isp/ispcsi2.c
> +++ b/drivers/media/video/omap3isp/ispcsi2.c
> @@ -888,6 +888,7 @@ csi2_try_format(struct isp_csi2_device *csi2, struct
> v4l2_subdev_fh *fh, /* RGB, non-interlaced */
>  	fmt->colorspace = V4L2_COLORSPACE_SRGB;
>  	fmt->field = V4L2_FIELD_NONE;
> +	fmt->framesamples = 0;
>  }
> 
>  /*
> diff --git a/drivers/media/video/omap3isp/isppreview.c
> b/drivers/media/video/omap3isp/isppreview.c index ccb876f..6f4bdf0 100644
> --- a/drivers/media/video/omap3isp/isppreview.c
> +++ b/drivers/media/video/omap3isp/isppreview.c
> @@ -1720,6 +1720,7 @@ static void preview_try_format(struct isp_prev_device
> *prev, }
> 
>  	fmt->field = V4L2_FIELD_NONE;
> +	fmt->framesamples = 0;
>  }
> 
>  /*
> diff --git a/drivers/media/video/omap3isp/ispresizer.c
> b/drivers/media/video/omap3isp/ispresizer.c index 50e593b..923ba1b 100644
> --- a/drivers/media/video/omap3isp/ispresizer.c
> +++ b/drivers/media/video/omap3isp/ispresizer.c
> @@ -1363,6 +1363,7 @@ static void resizer_try_format(struct isp_res_device
> *res,
> 
>  	fmt->colorspace = V4L2_COLORSPACE_JPEG;
>  	fmt->field = V4L2_FIELD_NONE;
> +	fmt->framesamples = 0;
>  }
> 
>  /*
> diff --git a/drivers/media/video/s5k6aa.c b/drivers/media/video/s5k6aa.c
> index 86ee35b..efc5ba3 100644
> --- a/drivers/media/video/s5k6aa.c
> +++ b/drivers/media/video/s5k6aa.c
> @@ -1087,6 +1087,7 @@ static void s5k6aa_try_format(struct s5k6aa *s5k6aa,
>  	mf->colorspace	= s5k6aa_formats[index].colorspace;
>  	mf->code	= s5k6aa_formats[index].code;
>  	mf->field	= V4L2_FIELD_NONE;
> +	mf->framesamples = 0;
>  }
> 
>  static int s5k6aa_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> *fh,

-- 
Regards,

Laurent Pinchart
