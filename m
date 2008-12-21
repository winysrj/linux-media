Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBL21ZTw008457
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 21:01:35 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBL21Lsq012466
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 21:01:21 -0500
Date: Sun, 21 Dec 2008 03:01:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uy6ycr129.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812210201450.23780@axis700.grange>
References: <uy6ycr129.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH v6] Add tw9910 driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, 18 Dec 2008, Kuninori Morimoto wrote:

> This patch adds tw9910 driver that use soc_camera framework.
> It was tested on SH Migo-r board and mplayer.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Ok, let's do it this way. We take this version as a basis, but I only 
commit it after I get an incremental improvement patch from you:

> +static const struct tw9910_scale_ctrl*
> +tw9910_select_norm(struct soc_camera_device *icd, struct v4l2_pix_format *pix)
> +{
> +	const struct tw9910_scale_ctrl *scale;
> +	const struct tw9910_scale_ctrl *ret;
> +	v4l2_std_id norm = icd->vdev->current_norm;
> +	int size;
> +	int diff, tmp;
> +	int i;
> +
> +	if (norm & V4L2_STD_NTSC) {
> +		scale = tw9910_ntsc_scales;
> +		size = ARRAY_SIZE(tw9910_ntsc_scales);
> +	} else if (norm & V4L2_STD_PAL) {
> +		scale = tw9910_pal_scales;
> +		size = ARRAY_SIZE(tw9910_pal_scales);
> +	} else {
> +		return NULL;
> +	}
> +
> +	diff = icd->width_max + icd->height_max;

Here diff = 768 + 576 = 1344. Now if anyone requests something big like 
2048x1536 you don't find any scale for it. Then pix->width and pix->height 
are of type __u32. Then if anyone sets them to 0xffffffff (maybe to get 
the maximum possible picture) you get a problem with your int diff, tmp.
Better

+	__u32 diff = 0xffffffff, tmp;

> +	ret = NULL;
> +
> +	for (i = 0; i < size; i++) {
> +		tmp = abs(pix->width - scale[i].width) +
> +			abs(pix->height - scale[i].height);
> +		if (tmp < diff) {
> +			diff = tmp;
> +			ret  = scale + i;
> +		}
> +	}
> +
> +	return ret;
> +}

[snip]

> +static int tw9910_start_capture(struct soc_camera_device *icd)
> +{
> +	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> +
> +	if (!priv->scale) {
> +		dev_err(&icd->dev, "norm select error\n");
> +		return -EPERM;
> +	}
> +
> +	dev_dbg(&icd->dev, "%s %dx%d\n",
> +		 priv->scale->name,
> +		 priv->scale->width,
> +		 priv->scale->height);
> +
> +	return 0;
> +}
> +
> +static int tw9910_stop_capture(struct soc_camera_device *icd)
> +{
> +	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> +
> +	priv->scale = NULL;

This is wrong. If someone does

S_FMT
STREAMON
STREAMOFF
STREAMON

you fail.

> +	icd->vdev->current_norm = V4L2_STD_NTSC;
> +
> +	tw9910_reset(priv->client);

I think, you should leave your driver and the chip configured, so, both of 
these should go.

> +	return 0;
> +}
> +
> +static int tw9910_set_bus_param(struct soc_camera_device *icd,
> +				unsigned long flags)
> +{
> +	return 0;
> +}
> +
> +static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
> +{
> +	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> +	struct soc_camera_link *icl = priv->client->dev.platform_data;
> +	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
> +		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
> +		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
> +
> +	return soc_camera_apply_sensor_flags(icl, flags);
> +}
> +
> +static int tw9910_get_chip_id(struct soc_camera_device *icd,
> +			      struct v4l2_chip_ident *id)
> +{
> +	id->ident    = V4L2_IDENT_TW9910;
> +	id->revision = 0;
> +
> +	return 0;
> +}
> +
> +static int tw9910_set_std(struct soc_camera_device *icd,
> +			  v4l2_std_id *a)
> +{
> +	int ret = -EINVAL;
> +
> +	if (*a & V4L2_STD_NTSC || *a & V4L2_STD_PAL)

+	if (*a & (V4L2_STD_NTSC | V4L2_STD_PAL))

would be enough

[snip]

> +static int tw9910_set_fmt(struct soc_camera_device *icd, __u32 pixfmt,
> +			      struct v4l2_rect *rect)
> +{
> +	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> +	int                 ret  = -EINVAL;
> +	u8                  val;
> +
> +	/*
> +	 * reset hardware
> +	 */
> +	tw9910_reset(priv->client);
> +	ret = tw9910_write_array(priv->client, tw9910_default_regs);
> +	if (ret < 0)
> +		return ret;
> +	/*
> +	 * set bus width
> +	 */
> +	val = 0x00;
> +	if (SOCAM_DATAWIDTH_16 == priv->info->buswidth)
> +		val = LEN;
> +
> +	ret = tw9910_mask_set(priv->client, OPFORM, LEN, val);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * select MPOUT behavior
> +	 */
> +	switch (priv->info->mpout) {
> +	case MPO_VLOSS:
> +		val = RTSEL_VLOSS; break;
> +	case MPO_HLOCK:
> +		val = RTSEL_HLOCK; break;
> +	case MPO_SLOCK:
> +		val = RTSEL_SLOCK; break;
> +	case MPO_VLOCK:
> +		val = RTSEL_VLOCK; break;
> +	case MPO_MONO:
> +		val = RTSEL_MONO;  break;
> +	case MPO_DET50:
> +		val = RTSEL_DET50; break;
> +	case MPO_FIELD:
> +		val = RTSEL_FIELD; break;
> +	case MPO_RTCO:
> +		val = RTSEL_RTCO;  break;
> +	default:
> +		val = 0;
> +	}
> +
> +	ret = tw9910_mask_set(priv->client, VBICNTL, RTSEL_MASK, val);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * set scale
> +	 */
> +	ret = tw9910_set_scale(priv->client, priv->scale);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * set cropping
> +	 */
> +	ret = tw9910_set_cropping(priv->client, &tw9910_cropping_ctrl);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * set hsync
> +	 */
> +	ret = tw9910_set_hsync(priv->client, &tw9910_hsync_ctrl);
> +
> +	return ret;
> +}
> +
> +static int tw9910_try_fmt(struct soc_camera_device *icd,
> +			      struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> +
> +	if (V4L2_FIELD_ANY == pix->field) {
> +		pix->field = V4L2_FIELD_INTERLACED;
> +	} else if (V4L2_FIELD_INTERLACED != pix->field) {
> +		dev_err(&icd->dev, "Field type invalid.\n");
> +		return -EINVAL;
> +	}
> +
> +	priv->scale = tw9910_select_norm(icd, pix);

This is wrong too. According to the API TRY_FMT may be called at any time 
(also during a running streaming) and should _not_ change driver's state. 
And as you can see in soc_camera.c::soc_camera_s_fmt_vid_cap() we're not 
holding the mutex while calling soc_camera_try_fmt_vid_cap(), so, you have 
no guarantee in your set_fmt, that your try_fmt was last called from 
soc_camera_s_fmt_vid_cap() or even worse that it's not being called 
concurrently. Therefore, you have to call tw9910_select_norm() once more 
in your set_fmt, and in try_fmt you only verify if a suitable norm can be 
found and set pix->height and pix->width accordingly.

> +enum MPOUT_pin {
> +	MPO_VLOSS,
> +	MPO_HLOCK,
> +	MPO_SLOCK,
> +	MPO_VLOCK,
> +	MPO_MONO,
> +	MPO_DET50,
> +	MPO_FIELD,
> +	MPO_RTCO,
> +};

This is an exported enum, so, please make it

enum tw9910_mpout_pin {
	TW9910_MPO_VLOSS,
	...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
