Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45506 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2CHOqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 09:46:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5.1 35/35] smiapp: Add driver
Date: Thu, 08 Mar 2012 15:46:33 +0100
Message-ID: <2156787.Alpb00gqF2@avalon>
In-Reply-To: <1331215050-20823-2-git-send-email-sakari.ailus@iki.fi>
References: <1960253.l1xo097dr7@avalon> <1331215050-20823-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thursday 08 March 2012 15:57:30 Sakari Ailus wrote:
> Add driver for SMIA++/SMIA image sensors. The driver exposes the sensor as
> three subdevs, pixel array, binner and scaler --- in case the device has a
> scaler.

> Currently it relies on the board code for external clock handling. There is
> no fast way out of this dependency before the ISP drivers (omap3isp) among
> others will be able to export that clock through the clock framework
> instead.

[snip]

> +static int smiapp_set_format(struct v4l2_subdev *subdev,
> +                            struct v4l2_subdev_fh *fh,
> +                            struct v4l2_subdev_format *fmt)
> +{
> +       struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +       struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +       struct v4l2_rect *crops[SMIAPP_PADS];
> +       const struct smiapp_csi_data_format *csi_format = sensor-
> >csi_format;
> +       unsigned i;
> +
> +       mutex_lock(&sensor->mutex);
> +
> +       smiapp_get_crop_compose(subdev, fh, crops, NULL, fmt->which);
> +
> +       if (subdev == &sensor->src->sd && fmt->pad == SMIAPP_PAD_SRC) {
> +               for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
> +                       if (sensor->mbus_frame_fmts & (1 << i) &&
> +                           smiapp_csi_data_formats[i].code
> +                           == fmt->format.code) {
> +                               csi_format = &smiapp_csi_data_formats[i];
> +                               if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +                                       sensor->csi_format = csi_format;
> +                               break;
> +                       }
> +               }
> +       }
> +
> +       if (fmt->pad == ssd->source_pad) {
> +               int rval;
> +
> +               rval = __smiapp_get_format(subdev, fh, fmt);
> +               fmt->format.code = csi_format->code;
> +
> +               mutex_unlock(&sensor->mutex);
> +               return rval;
> +       }

That's still not good I'm afraid. The pixel array source format code will be 
set to the sensor source format code, which isn't right.

> +
> +       fmt->format.code = __smiapp_get_mbus_code(subdev, fmt->pad);
> +       fmt->format.width &= ~1;
> +       fmt->format.height &= ~1;
> +
> +       fmt->format.width =
> +               clamp(fmt->format.width,
> +                     sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
> +                     sensor->limits[SMIAPP_LIMIT_MAX_X_OUTPUT_SIZE]);
> +       fmt->format.height =
> +               clamp(fmt->format.height,
> +                     sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE],
> +                     sensor->limits[SMIAPP_LIMIT_MAX_Y_OUTPUT_SIZE]);
> +
> +       crops[ssd->sink_pad]->left = 0;
> +       crops[ssd->sink_pad]->top = 0;
> +       crops[ssd->sink_pad]->width = fmt->format.width;
> +       crops[ssd->sink_pad]->height = fmt->format.height;
> +       if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +               ssd->sink_fmt = *crops[ssd->sink_pad];
> +       smiapp_propagate(subdev, fh, fmt->which,
> +                        V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL);
> +
> +       mutex_unlock(&sensor->mutex);
> +
> +       return 0;
> +}

-- 
Regards,

Laurent Pinchart

