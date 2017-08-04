Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:34179 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752153AbdHDM0y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 08:26:54 -0400
Subject: Re: [PATCH v1 5/5] [media] stm32-dcmi: g_/s_selection crop support
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1501236302-18097-1-git-send-email-hugues.fruchet@st.com>
 <1501236302-18097-6-git-send-email-hugues.fruchet@st.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4babd451-14c6-74fd-cf13-f72f02e6193d@xs4all.nl>
Date: Fri, 4 Aug 2017 14:26:51 +0200
MIME-Version: 1.0
In-Reply-To: <1501236302-18097-6-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/07/17 12:05, Hugues Fruchet wrote:
> Implements g_/s_selection crop support by using DCMI crop
> hardware feature.
> User can first get the maximum supported resolution of the sensor
> by calling g_selection(V4L2_SEL_TGT_CROP_BOUNDS).
> Then user call to s_selection(V4L2_SEL_TGT_CROP) will reset sensor
> to its maximum resolution and crop request is saved for later usage
> in s_fmt().
> Next call to s_fmt() will check if sensor can do frame size request
> with crop request. If sensor supports only discrete frame sizes,
> the frame size which is larger than user request is selected in
> order to be able to match the crop request. Then s_fmt() resolution
> user request is adjusted to match crop request resolution.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/platform/stm32/stm32-dcmi.c | 367 +++++++++++++++++++++++++++++-
>  1 file changed, 363 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
> index 2be56b6..f1fb0b3 100644
> --- a/drivers/media/platform/stm32/stm32-dcmi.c
> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
> @@ -33,6 +33,7 @@
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-image-sizes.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-rect.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #define DRV_NAME "stm32-dcmi"
> @@ -107,6 +108,11 @@ struct dcmi_format {
>  	u8	bpp;
>  };
>  
> +struct dcmi_framesize {
> +	u32	width;
> +	u32	height;
> +};
> +
>  struct dcmi_buf {
>  	struct vb2_v4l2_buffer	vb;
>  	bool			prepared;
> @@ -131,10 +137,16 @@ struct stm32_dcmi {
>  	struct v4l2_async_notifier	notifier;
>  	struct dcmi_graph_entity	entity;
>  	struct v4l2_format		fmt;
> +	struct v4l2_rect		crop;
> +	bool				do_crop;
>  
>  	const struct dcmi_format	**sd_formats;
>  	unsigned int			nb_of_sd_formats;
>  	const struct dcmi_format	*sd_format;
> +	struct dcmi_framesize		*sd_framesizes;
> +	unsigned int			nb_of_sd_framesizes;

num_of_sd_framesizes is better.

> +	struct dcmi_framesize		sd_framesize;
> +	struct v4l2_rect		sd_bounds;
>  
>  	/* Protect this data structure */
>  	struct mutex			lock;
> @@ -325,6 +337,28 @@ static int dcmi_start_capture(struct stm32_dcmi *dcmi)
>  	return 0;
>  }
>  
> +static void dcmi_set_crop(struct stm32_dcmi *dcmi)
> +{
> +	u32 size, start;
> +
> +	/* Crop resolution */
> +	size = ((dcmi->crop.height - 1) << 16) |
> +		((dcmi->crop.width << 1) - 1);
> +	reg_write(dcmi->regs, DCMI_CWSIZE, size);
> +
> +	/* Crop start point */
> +	start = ((dcmi->crop.top) << 16) |
> +		 ((dcmi->crop.left << 1));
> +	reg_write(dcmi->regs, DCMI_CWSTRT, start);
> +
> +	dev_dbg(dcmi->dev, "Cropping to %ux%u@%u:%u\n",
> +		dcmi->crop.width, dcmi->crop.height,
> +		dcmi->crop.left, dcmi->crop.top);
> +
> +	/* Enable crop */
> +	reg_set(dcmi->regs, DCMI_CR, CR_CROP);
> +}
> +
>  static irqreturn_t dcmi_irq_thread(int irq, void *arg)
>  {
>  	struct stm32_dcmi *dcmi = arg;
> @@ -540,6 +574,10 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
>  
>  	reg_write(dcmi->regs, DCMI_CR, val);
>  
> +	/* Set crop */
> +	if (dcmi->do_crop)
> +		dcmi_set_crop(dcmi);
> +
>  	/* Enable dcmi */
>  	reg_set(dcmi->regs, DCMI_CR, CR_ENABLE);
>  
> @@ -697,10 +735,37 @@ static const struct dcmi_format *find_format_by_fourcc(struct stm32_dcmi *dcmi,
>  	return NULL;
>  }
>  
> +static void __find_outer_frame_size(struct stm32_dcmi *dcmi,
> +				    struct v4l2_pix_format *pix,
> +				    struct dcmi_framesize *framesize)
> +{
> +	struct dcmi_framesize *match = NULL;
> +	unsigned int i;
> +	unsigned int min_err = UINT_MAX;
> +
> +	for (i = 0; i < dcmi->nb_of_sd_framesizes; i++) {
> +		struct dcmi_framesize *fsize = &dcmi->sd_framesizes[i];
> +		int w_err = (fsize->width - pix->width);
> +		int h_err = (fsize->height - pix->height);
> +		int err = w_err + h_err;
> +
> +		if ((w_err >= 0) && (h_err >= 0) && (err < min_err)) {
> +			min_err = err;
> +			match = fsize;
> +		}
> +	}
> +	if (!match)
> +		match = &dcmi->sd_framesizes[0];
> +
> +	*framesize = *match;
> +}
> +
>  static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
> -			const struct dcmi_format **sd_format)
> +			const struct dcmi_format **sd_format,
> +			struct dcmi_framesize *sd_framesize)
>  {
>  	const struct dcmi_format *sd_fmt;
> +	struct dcmi_framesize sd_fsize;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
>  	struct v4l2_subdev_pad_config pad_cfg;
>  	struct v4l2_subdev_format format = {
> @@ -718,6 +783,17 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
>  	pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH);
>  	pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT);
>  
> +	if (dcmi->do_crop && dcmi->nb_of_sd_framesizes) {
> +		struct dcmi_framesize outer_sd_fsize;
> +		/*
> +		 * If crop is requested and sensor have discrete frame sizes,
> +		 * select the frame size that is just larger than request
> +		 */
> +		__find_outer_frame_size(dcmi, pix, &outer_sd_fsize);
> +		pix->width = outer_sd_fsize.width;
> +		pix->height = outer_sd_fsize.height;
> +	}
> +
>  	v4l2_fill_mbus_format(&format.format, pix, sd_fmt->mbus_code);
>  	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, set_fmt,
>  			       &pad_cfg, &format);
> @@ -727,6 +803,31 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
>  	/* Update pix regarding to what sensor can do */
>  	v4l2_fill_pix_format(pix, &format.format);
>  
> +	/* Save resolution that sensor can actually do */
> +	sd_fsize.width = pix->width;
> +	sd_fsize.height = pix->height;
> +
> +	if (dcmi->do_crop) {
> +		struct v4l2_rect c = dcmi->crop;
> +		struct v4l2_rect max_rect;
> +
> +		/*
> +		 * Adjust crop by making the intersection between
> +		 * format resolution request and crop request
> +		 */
> +		max_rect.top = 0;
> +		max_rect.left = 0;
> +		max_rect.width = pix->width;
> +		max_rect.height = pix->height;
> +		v4l2_rect_map_inside(&c, &max_rect);
> +		c.top  = clamp_t(s32, c.top, 0, pix->height - c.height);
> +		c.left = clamp_t(s32, c.left, 0, pix->width - c.width);
> +		dcmi->crop = c;
> +
> +		/* Adjust format resolution request to crop */
> +		pix->width = dcmi->crop.width;
> +		pix->height = dcmi->crop.height;
> +	}
>  
>  	pix->field = V4L2_FIELD_NONE;
>  	pix->bytesperline = pix->width * sd_fmt->bpp;
> @@ -734,6 +835,8 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
>  
>  	if (sd_format)
>  		*sd_format = sd_fmt;
> +	if (sd_framesize)
> +		*sd_framesize = sd_fsize;
>  
>  	return 0;
>  }
> @@ -744,24 +847,41 @@ static int dcmi_set_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f)
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
>  	const struct dcmi_format *sd_format;
> +	struct dcmi_framesize sd_framesize;
>  	struct v4l2_mbus_framefmt *mf = &format.format;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
>  	int ret;
>  
> -	ret = dcmi_try_fmt(dcmi, f, &sd_format);
> +	/*
> +	 * Try format, fmt.width/height could have been changed
> +	 * to match sensor capability or crop request
> +	 * sd_format & sd_framesize will contain what subdev
> +	 * can do for this request.
> +	 */
> +	ret = dcmi_try_fmt(dcmi, f, &sd_format, &sd_framesize);
>  	if (ret)
>  		return ret;
>  
>  	/* pix to mbus format */
>  	v4l2_fill_mbus_format(mf, pix,
>  			      sd_format->mbus_code);
> +	mf->width = sd_framesize.width;
> +	mf->height = sd_framesize.height;
> +
>  	ret = v4l2_subdev_call(dcmi->entity.subdev, pad,
>  			       set_fmt, NULL, &format);
>  	if (ret < 0)
>  		return ret;
>  
> +	dev_dbg(dcmi->dev, "Sensor format set to 0x%x %ux%u\n",
> +		mf->code, mf->width, mf->height);
> +	dev_dbg(dcmi->dev, "Buffer format set to %4.4s %ux%u\n",
> +		(char *)&pix->pixelformat,
> +		pix->width, pix->height);
> +
>  	dcmi->fmt = *f;
>  	dcmi->sd_format = sd_format;
> +	dcmi->sd_framesize = sd_framesize;
>  
>  	return 0;
>  }
> @@ -782,7 +902,7 @@ static int dcmi_try_fmt_vid_cap(struct file *file, void *priv,
>  {
>  	struct stm32_dcmi *dcmi = video_drvdata(file);
>  
> -	return dcmi_try_fmt(dcmi, f, NULL);
> +	return dcmi_try_fmt(dcmi, f, NULL, NULL);
>  }
>  
>  static int dcmi_enum_fmt_vid_cap(struct file *file, void  *priv,
> @@ -797,6 +917,186 @@ static int dcmi_enum_fmt_vid_cap(struct file *file, void  *priv,
>  	return 0;
>  }
>  
> +static int dcmi_get_sensor_format(struct stm32_dcmi *dcmi,
> +				  struct v4l2_pix_format *pix)
> +{
> +	struct v4l2_subdev_format fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	int ret;
> +
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, get_fmt, NULL, &fmt);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_fill_pix_format(pix, &fmt.format);
> +
> +	return 0;
> +}
> +
> +static int dcmi_set_sensor_format(struct stm32_dcmi *dcmi,
> +				  struct v4l2_pix_format *pix)
> +{
> +	const struct dcmi_format *sd_fmt;
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_TRY,
> +	};
> +	struct v4l2_subdev_pad_config pad_cfg;
> +	int ret;
> +
> +	sd_fmt = find_format_by_fourcc(dcmi, pix->pixelformat);
> +	if (!sd_fmt) {
> +		sd_fmt = dcmi->sd_formats[dcmi->nb_of_sd_formats - 1];
> +		pix->pixelformat = sd_fmt->fourcc;
> +	}
> +
> +	v4l2_fill_mbus_format(&format.format, pix, sd_fmt->mbus_code);
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, set_fmt,
> +			       &pad_cfg, &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int dcmi_get_sensor_bounds(struct stm32_dcmi *dcmi,
> +				  struct v4l2_rect *r)
> +{
> +	struct v4l2_subdev_selection bounds = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +		.target = V4L2_SEL_TGT_CROP_BOUNDS,
> +	};
> +	unsigned int max_width, max_height, max_pixsize;
> +	struct v4l2_pix_format pix;
> +	unsigned int i;
> +	int ret;
> +
> +	/*
> +	 * Get sensor bounds first
> +	 */
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, get_selection,
> +			       NULL, &bounds);
> +	if (!ret)
> +		*r = bounds.r;
> +	if (ret != -ENOIOCTLCMD)
> +		return ret;
> +
> +	/*
> +	 * If selection is not implemented,
> +	 * fallback by enumerating sensor frame sizes
> +	 * and take the largest one
> +	 */
> +	max_width = 0;
> +	max_height = 0;
> +	max_pixsize = 0;
> +	for (i = 0; i < dcmi->nb_of_sd_framesizes; i++) {
> +		struct dcmi_framesize *fsize = &dcmi->sd_framesizes[i];
> +		unsigned int pixsize = fsize->width * fsize->height;
> +
> +		if (pixsize > max_pixsize) {
> +			max_pixsize = pixsize;
> +			max_width = fsize->width;
> +			max_height = fsize->height;
> +		}
> +	}
> +	if (max_pixsize > 0) {
> +		r->top = 0;
> +		r->left = 0;
> +		r->width = max_width;
> +		r->height = max_height;
> +		return 0;
> +	}
> +
> +	/*
> +	 * If frame sizes enumeration is not implemented,
> +	 * fallback by getting current sensor frame size
> +	 */
> +	ret = dcmi_get_sensor_format(dcmi, &pix);
> +	if (ret)
> +		return ret;
> +
> +	r->top = 0;
> +	r->left = 0;
> +	r->width = pix.width;
> +	r->height = pix.height;
> +
> +	return 0;
> +}
> +
> +static int dcmi_g_selection(struct file *file, void *fh,
> +			    struct v4l2_selection *s)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +	struct v4l2_rect crop;
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	if (dcmi->do_crop) {
> +		crop = dcmi->crop;
> +	} else {
> +		crop.top = 0;
> +		crop.left = 0;
> +		crop.width = dcmi->fmt.fmt.pix.width;
> +		crop.height = dcmi->fmt.fmt.pix.height;
> +	}

Just move this down to the V4L2_SEL_TGT_CROP case:

		if (dcmi->do_crop) {
			s->r = dcmi->crop;
		} else {
			...
		}

> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		s->r = dcmi->sd_bounds;
> +		return 0;
> +	case V4L2_SEL_TGT_CROP:
> +		s->r = crop;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dcmi_s_selection(struct file *file, void *priv,
> +			    struct v4l2_selection *s)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +	struct v4l2_rect r = s->r;
> +	struct v4l2_rect max_rect;
> +	struct v4l2_pix_format pix;
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +	    s->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;
> +
> +	/* Reset sensor resolution to max resolution */
> +	pix.pixelformat = dcmi->fmt.fmt.pix.pixelformat;
> +	pix.width = dcmi->sd_bounds.width;
> +	pix.height = dcmi->sd_bounds.height;
> +	dcmi_set_sensor_format(dcmi, &pix);
> +
> +	/*
> +	 * Make the intersection between
> +	 * sensor resolution
> +	 * and crop request
> +	 */
> +	max_rect.top = 0;
> +	max_rect.left = 0;
> +	max_rect.width = pix.width;
> +	max_rect.height = pix.height;
> +	v4l2_rect_map_inside(&r, &max_rect);
> +	r.top  = clamp_t(s32, r.top, 0, pix.height - r.height);
> +	r.left = clamp_t(s32, r.left, 0, pix.width - r.width);
> +
> +	dcmi->crop = r;
> +	s->r = r;
> +	dcmi->do_crop = true;

Hmm, isn't do_crop only true if s->r != dcmi->sd_bounds?

I.e. if you call s_selection with 640x480, then that means to stop
cropping.

> +
> +	dev_dbg(dcmi->dev, "s_selection: crop %ux%u@(%u,%u) from %ux%u\n",
> +		r.width, r.height, r.left, r.top, pix.width, pix.height);
> +
> +	return 0;
> +}
> +
>  static int dcmi_querycap(struct file *file, void *priv,
>  			 struct v4l2_capability *cap)
>  {
> @@ -903,7 +1203,7 @@ static int dcmi_set_default_fmt(struct stm32_dcmi *dcmi)
>  	};
>  	int ret;
>  
> -	ret = dcmi_try_fmt(dcmi, &f, NULL);
> +	ret = dcmi_try_fmt(dcmi, &f, NULL, NULL);
>  	if (ret)
>  		return ret;
>  	dcmi->sd_format = dcmi->sd_formats[0];
> @@ -938,6 +1238,8 @@ static int dcmi_open(struct file *file)
>  	if (ret < 0 && ret != -ENOIOCTLCMD)
>  		goto fh_rel;
>  
> +	dcmi->do_crop = false;
> +

Same as my comment in the previous patch: opening a video device should have no
effect on the internal state.

>  	ret = dcmi_set_default_fmt(dcmi);
>  	if (ret)
>  		goto power_off;
> @@ -983,6 +1285,8 @@ static int dcmi_release(struct file *file)
>  	.vidioc_g_fmt_vid_cap		= dcmi_g_fmt_vid_cap,
>  	.vidioc_s_fmt_vid_cap		= dcmi_s_fmt_vid_cap,
>  	.vidioc_enum_fmt_vid_cap	= dcmi_enum_fmt_vid_cap,
> +	.vidioc_g_selection		= dcmi_g_selection,
> +	.vidioc_s_selection		= dcmi_s_selection,
>  
>  	.vidioc_enum_input		= dcmi_enum_input,
>  	.vidioc_g_input			= dcmi_g_input,
> @@ -1082,6 +1386,49 @@ static int dcmi_formats_init(struct stm32_dcmi *dcmi)
>  	return 0;
>  }
>  
> +static int dcmi_framesizes_init(struct stm32_dcmi *dcmi)
> +{
> +	unsigned int num_fsize = 0;
> +	struct v4l2_subdev *subdev = dcmi->entity.subdev;
> +	struct v4l2_subdev_frame_size_enum fse = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +		.code = dcmi->sd_format->mbus_code,
> +	};
> +	unsigned int ret;
> +	unsigned int i;
> +
> +	/* Allocate discrete framesizes array */
> +	while (!v4l2_subdev_call(subdev, pad, enum_frame_size,
> +				 NULL, &fse))
> +		fse.index++;
> +
> +	num_fsize = fse.index;
> +	if (!num_fsize)
> +		return 0;
> +
> +	dcmi->nb_of_sd_framesizes = num_fsize;
> +	dcmi->sd_framesizes = devm_kcalloc(dcmi->dev, num_fsize,
> +					   sizeof(struct dcmi_framesize),
> +					   GFP_KERNEL);
> +	if (!dcmi->sd_framesizes) {
> +		dev_err(dcmi->dev, "Could not allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Fill array with sensor supported framesizes */
> +	dev_dbg(dcmi->dev, "Sensor supports %u frame sizes:\n", num_fsize);
> +	for (i = 0; i < dcmi->nb_of_sd_framesizes; i++) {
> +		fse.index = i;
> +		if (v4l2_subdev_call(subdev, pad, enum_frame_size, NULL, &fse))
> +			return ret;

As the kbuild post said: ret is uninitialized here.

> +		dcmi->sd_framesizes[fse.index].width = fse.max_width;
> +		dcmi->sd_framesizes[fse.index].height = fse.max_height;
> +		dev_dbg(dcmi->dev, "%ux%u\n", fse.max_width, fse.max_height);
> +	}
> +
> +	return 0;
> +}
> +
>  static int dcmi_graph_notify_complete(struct v4l2_async_notifier *notifier)
>  {
>  	struct stm32_dcmi *dcmi = notifier_to_dcmi(notifier);
> @@ -1094,6 +1441,18 @@ static int dcmi_graph_notify_complete(struct v4l2_async_notifier *notifier)
>  		return ret;
>  	}
>  
> +	ret = dcmi_framesizes_init(dcmi);
> +	if (ret) {
> +		dev_err(dcmi->dev, "Could not initialize framesizes\n");
> +		return ret;
> +	}
> +
> +	ret = dcmi_get_sensor_bounds(dcmi, &dcmi->sd_bounds);
> +	if (ret) {
> +		dev_err(dcmi->dev, "Could not get sensor bounds\n");
> +		return ret;
> +	}
> +
>  	ret = dcmi_set_default_fmt(dcmi);
>  	if (ret) {
>  		dev_err(dcmi->dev, "Could not set default format\n");
> 

OK, I'll have another look once v2 is posted. Always tricky code to review...

Regards,

	Hans
