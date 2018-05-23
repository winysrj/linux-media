Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39459 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932281AbeEWJjx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 05:39:53 -0400
Message-ID: <1527068392.6875.6.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] media: platform: add driver for TI SCAN921226H
 video deserializer
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 23 May 2018 11:39:52 +0200
In-Reply-To: <20180504124903.6276-3-jlu@pengutronix.de>
References: <20180504124903.6276-1-jlu@pengutronix.de>
         <20180504124903.6276-3-jlu@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

Hans just pointed out a few issues in my video-mux compliance patch [1]
that also apply to this driver, see below.

[1] v1: https://patchwork.linuxtv.org/patch/49827/
    v2: https://patchwork.linuxtv.org/patch/49839/

On Fri, 2018-05-04 at 14:49 +0200, Jan Luebbe wrote:
[...]
> diff --git a/drivers/media/platform/scan921226h.c b/drivers/media/platform/scan921226h.c
> new file mode 100644
> index 000000000000..59fcd55ceaa2
> --- /dev/null
> +++ b/drivers/media/platform/scan921226h.c
[...]
> +static int video_des_set_format(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *sdformat)
> +{
> +	struct video_des *vdes = v4l2_subdev_to_video_des(sd);
> +	struct v4l2_mbus_framefmt *mbusformat;
> +	struct media_pad *pad = &vdes->pads[sdformat->pad];
> +
> +	mbusformat = __video_des_get_pad_format(sd, cfg, sdformat->pad,
> +					    sdformat->which);
> +	if (!mbusformat)
> +		return -EINVAL;
> +
> +	mutex_lock(&vdes->lock);
> +
> +	/* Source pad mirrors sink pad, no limitations on sink pads */
> +	if ((pad->flags & MEDIA_PAD_FL_SOURCE)) {
> +		sdformat->format = vdes->format_mbus;
> +	} else {
> +		/* any sizes are allowed */
> +		v4l_bound_align_image(
> +			&sdformat->format.width, 1, UINT_MAX-1, 0,
> +			&sdformat->format.height, 1, UINT_MAX-1, 0,

Reduce from UINT_MAX-1 to 65536 to avoid potential overflow issues.

> +			0);
> +		if (sdformat->format.field == V4L2_FIELD_ANY)
> +			sdformat->format.field = V4L2_FIELD_NONE;
> +		switch (sdformat->format.code) {
> +		/* only 8 bit formats are supported */
> +		case MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE:
> +		case MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE:
[...]
> +		case MEDIA_BUS_FMT_JPEG_1X8:
> +		case MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8:
> +			break;
> +		default:
> +			sdformat->format.code = MEDIA_BUS_FMT_Y8_1X8;

A
			break;
should be added here.

> +		}
> +	}
> +
> +	*mbusformat = sdformat->format;
> +
> +	mutex_unlock(&vdes->lock);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops video_des_pad_ops = {
> +	.get_fmt = video_des_get_format,
> +	.set_fmt = video_des_set_format,
> +};
> +
> +static int video_des_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct video_des *vdes = v4l2_subdev_to_video_des(sd);
> +	struct v4l2_mbus_framefmt *format;
> +
> +	mutex_lock(&vdes->lock);
> +
> +	format = v4l2_subdev_get_try_format(sd, fh->pad, 0);
> +	*format = vdes->format_mbus;
> +	format = v4l2_subdev_get_try_format(sd, fh->pad, 1);
> +	*format = vdes->format_mbus;
> +
> +	mutex_unlock(&vdes->lock);
> +
> +	return 0;
> +}

This should be done in the .init_cfg pad op.

> +
> +static const struct v4l2_subdev_internal_ops video_des_subdev_internal_ops = {
> +	.open = video_des_open,
> +};

Internal ops can then be dropped.

regards
Philipp
