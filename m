Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59596 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbbAaX4n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jan 2015 18:56:43 -0500
Date: Sun, 1 Feb 2015 00:56:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 6/8] WmT: adv7604 driver compatibility
In-Reply-To: <1422548388-28861-7-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1502010028150.26661@axis700.grange>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
 <1422548388-28861-7-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wills,

Thanks for the patch. First and foremost, the title of the patch is wrong. 
This patch does more than just adding some "adv7604 compatibility." It's 
adding pad-level API to soc-camera.

This is just a rough review. I'm not an expert in media-controller / 
pad-level API, I hope someone with a better knowledge of those areas will 
help me reviewing this.

Another general comment: it has been discussed since a long time, whether 
a wrapper wouldn't be desired to enable a seamless use of both subdev 
drivers using and not using the pad-level API. Maybe it's the right time 
now?..

On Thu, 29 Jan 2015, William Towle wrote:

> Add 'struct media_pad pad' member and suitable glue code, so that
> soc_camera/rcar_vin can become agnostic to whether an old or new-
> style driver (wrt pad API use) can sit underneath
> 
> This version has been reworked to include appropriate constant and
> datatype names for kernel v3.18
> ---
>  drivers/media/platform/soc_camera/soc_camera.c     |  148 +++++++++++++++++++-
>  drivers/media/platform/soc_camera/soc_scale_crop.c |   43 +++++-
>  include/media/soc_camera.h                         |    1 +
>  3 files changed, 182 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index f4be2a1..efc20bf 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -37,8 +37,11 @@
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-of.h>
> +#if 0
>  #include <media/videobuf-core.h>
>  #include <media/videobuf2-core.h>
> +#endif

No. These headers are needed even if the code can be compiled without 
them.

> +#include <media/v4l2-mediabus.h>

Well, maybe. This header is included indirectly via soc_mediabus.h, but 
yes, as I just said above, headers, whose defines, structs etc. are used, 
should be encluded directly. Further, you'll need more headers, e.g. 
media-entity.h, maybe some more.

>  /* Default to VGA resolution */
>  #define DEFAULT_WIDTH	640
> @@ -453,6 +456,98 @@ static int soc_camera_expbuf(struct file *file, void *priv,
>  		return vb2_expbuf(&icd->vb2_vidq, p);
>  }
>  
> +static int soc_camera_init_user_formats_pad(struct soc_camera_device *icd, int src_pad_idx)
> +{
> +	struct v4l2_subdev *sd= soc_camera_to_subdev(icd);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct v4l2_subdev_mbus_code_enum code;
> +	int fmts= 0, raw_fmts, i, ret;

Please, run this patch through checkpatch.pl. It will tell you to add a 
Signed-off-by line, (hopefully) to add spaces before "=" in multiple 
places, to place braces correctly, to not use C++-style comments etc. Only 
feel free to ignore 80-character warnings.

> +
> +	code.pad= src_pad_idx;
> +	code.index= 0;
> +
> +	// subdev_has_op -> enum_mbus_code vs enum_mbus_fmt
> +	if (v4l2_subdev_has_op(sd, pad, enum_mbus_code)) {

This function is called only once below and only after the above test has 
already returned success. Looks like you don't need it here again and the 
below "else" branch can be dropped completely?

> +		while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code))
> +			code.index++;
> +	} else {
> +		u32 pixcode;
> +
> +		while (!v4l2_subdev_call(sd, video, enum_mbus_fmt, code.index, &pixcode))
> +		{
> +			code.code= pixcode;
> +			code.index++;
> +		}
> +	}
> +	raw_fmts= code.index;
> +
> +	if (!ici->ops->get_formats) {
> +		/*
> +		 * Fallback mode - the host will have to serve all
> +		 * sensor-provided formats one-to-one to the user
> +		 */
> +		fmts = raw_fmts;
> +	}
> +	else {
> +		/*
> +		 * First pass - only count formats this host-sensor
> +		 * configuration can provide
> +		 */
> +		for (i = 0; i < raw_fmts; i++) {
> +			int ret = ici->ops->get_formats(icd, i, NULL);
> +			if (ret < 0)
> +				return ret;
> +			fmts += ret;
> +		}
> +	}
> +
> +	if (!fmts)
> +		return -ENXIO;
> +
> +	icd->user_formats =
> +		vmalloc(fmts * sizeof(struct soc_camera_format_xlate));
> +	if (!icd->user_formats)
> +		return -ENOMEM;
> +
> +	dev_dbg(icd->pdev, "Found %d supported formats.\n", fmts);
> +
> +	/* Second pass - actually fill data formats */
> +	fmts = 0;
> +	for (i = 0; i < raw_fmts; i++) {
> +		if (!ici->ops->get_formats) {
> +			code.index= i;
> +			// subdev_has_op -> enum_mbus_code vs enum_mbus_fmt
> +			if (v4l2_subdev_has_op(sd, pad, enum_mbus_code)) {

Same test again?? Or am I missing something? If indeed these tests are 
redundant, after you remove them this function will become very similar to 
the original soc_camera_init_user_formats(), so, maybe some code reuse 
will become possible.

> +				v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
> +			} else {
> +				u32 pixcode;
> +
> +				v4l2_subdev_call(sd, video, enum_mbus_fmt, code.index, &pixcode);
> +				code.code= pixcode;
> +			}
> +			icd->user_formats[fmts].host_fmt =
> +				soc_mbus_get_fmtdesc(code.code);
> +			if (icd->user_formats[fmts].host_fmt)
> +				icd->user_formats[fmts++].code = code.code;
> +		} else {
> +			ret = ici->ops->get_formats(icd, i,
> +						    &icd->user_formats[fmts]);
> +			if (ret < 0)
> +				goto egfmt;
> +			fmts += ret;
> +		}
> +	}
> +
> +	icd->num_user_formats = fmts;
> +	icd->current_fmt = &icd->user_formats[0];
> +
> +	return 0;
> +
> +egfmt:
> +	vfree(icd->user_formats);
> +	return ret;
> +}
> +
>  /* Always entered with .host_lock held */
>  static int soc_camera_init_user_formats(struct soc_camera_device *icd)
>  {
> @@ -1289,6 +1384,7 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	struct v4l2_mbus_framefmt mf;
> +	int src_pad_idx= -1;
>  	int ret;
>  
>  	sd->grp_id = soc_camera_grp_id(icd);
> @@ -1307,7 +1403,30 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>  	}
>  
>  	/* At this point client .probe() should have run already */
> -	ret = soc_camera_init_user_formats(icd);
> +	// subdev_has_op -> enum_mbus_code vs enum_mbus_fmt
> +	if (!v4l2_subdev_has_op(sd, pad, enum_mbus_code))

This is the test, that I meant above.

> +		ret = soc_camera_init_user_formats(icd);
> +	else {
> +		ret = media_entity_init(&icd->vdev->entity, 1,
> +					&icd->pad, 0);

Ok, maybe this hard-coded 1 pad with no extras is justified here, but 
let's here what others say.

> +		if (!ret) {
> +			for (src_pad_idx= 0; src_pad_idx < sd->entity.num_pads; src_pad_idx++)
> +				if (sd->entity.pads[src_pad_idx].flags == MEDIA_PAD_FL_SOURCE)
> +					break;
> +
> +			if (src_pad_idx < sd->entity.num_pads) {
> +				ret = media_entity_create_link(
> +					&icd->vdev->entity, 0,
> +					&sd->entity, src_pad_idx,
> +					MEDIA_LNK_FL_IMMUTABLE |
> +					MEDIA_LNK_FL_ENABLED);

Let's try to preserve the style. I normally try to avoid splitting the 
line after "f(" and adding at least the first function parameter above 
will not make that line longer, than the ones above. So, let's do that.

> +			}
> +		}
> +
> +		if (!ret)
> +			ret = soc_camera_init_user_formats_pad(icd,
> +							src_pad_idx);

Probably no need to break the line here either.

> +	}
>  	if (ret < 0)
>  		goto eusrfmt;
>  
> @@ -1318,11 +1437,28 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>  		goto evidstart;
>  
>  	/* Try to improve our guess of a reasonable window format */
> -	if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
> -		icd->user_width		= mf.width;
> -		icd->user_height	= mf.height;
> -		icd->colorspace		= mf.colorspace;
> -		icd->field		= mf.field;
> +	// subdev_has_op -> get_fmt vs g_mbus_fmt
> +	if (v4l2_subdev_has_op(sd, pad, enum_mbus_code)
> +		&& v4l2_subdev_has_op(sd, pad, get_fmt)
> +		&& src_pad_idx != -1) {

The rest of the file puts operations after the first argument, not before 
the second one when breaking the line. Let's do that here too.

Thanks
Guennadi

> +		struct v4l2_subdev_format sd_format;
> +
> +		sd_format.pad= src_pad_idx;
> +		sd_format.which= V4L2_SUBDEV_FORMAT_ACTIVE;
> +
> +		if (!v4l2_subdev_call(sd, pad, get_fmt, NULL, &sd_format)) {
> +			icd->user_width		= sd_format.format.width;
> +			icd->user_height	= sd_format.format.height;
> +			icd->colorspace		= sd_format.format.colorspace;
> +			icd->field		= sd_format.format.field;
> +		}
> +	} else {
> +		if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
> +			icd->user_width		= mf.width;
> +			icd->user_height	= mf.height;
> +			icd->colorspace		= mf.colorspace;
> +			icd->field		= mf.field;
> +		}
>  	}
>  	soc_camera_remove_device(icd);
>  
> diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
> index 8e74fb7..8a1ca05 100644
> --- a/drivers/media/platform/soc_camera/soc_scale_crop.c
> +++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
> @@ -224,9 +224,27 @@ static int client_s_fmt(struct soc_camera_device *icd,
>  	bool host_1to1;
>  	int ret;
>  
> -	ret = v4l2_device_call_until_err(sd->v4l2_dev,
> -					 soc_camera_grp_id(icd), video,
> -					 s_mbus_fmt, mf);
> +	// subdev_has_op -> set_fmt vs s_mbus_fmt
> +	if (v4l2_subdev_has_op(sd, pad, set_fmt)) {
> +		struct v4l2_subdev_format sd_format;
> +		struct media_pad *remote_pad;
> +
> +		remote_pad= media_entity_remote_pad(
> +			&icd->vdev->entity.pads[0]);
> +		sd_format.pad = remote_pad->index;
> +		sd_format.which= V4L2_SUBDEV_FORMAT_ACTIVE;
> +		sd_format.format= *mf;
> +
> +		ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +			soc_camera_grp_id(icd), pad, set_fmt, NULL,
> +			&sd_format);
> +
> +		mf->width = sd_format.format.width;
> +		mf->height = sd_format.format.height;
> +	} else {
> +		ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +			 soc_camera_grp_id(icd), video, s_mbus_fmt, mf);
> +	}
>  	if (ret < 0)
>  		return ret;
>  
> @@ -264,9 +282,26 @@ static int client_s_fmt(struct soc_camera_device *icd,
>  		tmp_h = min(2 * tmp_h, max_height);
>  		mf->width = tmp_w;
>  		mf->height = tmp_h;
> -		ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +		// subdev_has_op -> set_fmt vs s_mbus_fmt
> +		if (v4l2_subdev_has_op(sd, pad, set_fmt)) {
> +			struct v4l2_subdev_format sd_format;
> +			struct media_pad *remote_pad;
> +
> +			remote_pad= media_entity_remote_pad(
> +				&icd->vdev->entity.pads[0]);
> +			sd_format.pad = remote_pad->index;
> +			sd_format.which= V4L2_SUBDEV_FORMAT_ACTIVE;
> +			sd_format.format= *mf;
> +
> +			ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +					soc_camera_grp_id(icd),
> +					pad, set_fmt, NULL,
> +					&sd_format);
> +		} else {
> +			ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  					soc_camera_grp_id(icd), video,
>  					s_mbus_fmt, mf);
> +		}
>  		dev_geo(dev, "Camera scaled to %ux%u\n",
>  			mf->width, mf->height);
>  		if (ret < 0) {
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 2f6261f..f0c5238 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -42,6 +42,7 @@ struct soc_camera_device {
>  	unsigned char devnum;		/* Device number per host */
>  	struct soc_camera_sense *sense;	/* See comment in struct definition */
>  	struct video_device *vdev;
> +	struct media_pad pad;
>  	struct v4l2_ctrl_handler ctrl_handler;
>  	const struct soc_camera_format_xlate *current_fmt;
>  	struct soc_camera_format_xlate *user_formats;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
