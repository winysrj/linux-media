Return-Path: <SRS0=IHcP=PI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15E7C43387
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 10:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 948A621738
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 10:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbeLaKyU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 31 Dec 2018 05:54:20 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56723 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbeLaKyU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Dec 2018 05:54:20 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gdvD8-00021C-Vf; Mon, 31 Dec 2018 11:54:18 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gdvD8-0001ye-6N; Mon, 31 Dec 2018 11:54:18 +0100
Date:   Mon, 31 Dec 2018 11:54:18 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 2/4] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work
 with V4L2_SUBDEV_FORMAT_TRY
Message-ID: <20181231105418.nt4b6abe2tnvsge7@pengutronix.de>
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
 <1546103258-29025-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546103258-29025-3-git-send-email-akinobu.mita@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:42:39 up 101 days, 22:56, 35 users,  load average: 0.00, 0.00,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 18-12-30 02:07, Akinobu Mita wrote:
> The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
> is specified.
> 
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/mt9m111.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> index f0e47fd..acb4dee 100644
> --- a/drivers/media/i2c/mt9m111.c
> +++ b/drivers/media/i2c/mt9m111.c
> @@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
>  	if (format->pad)
>  		return -EINVAL;
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API

This ifdef is made in the include/media/v4l2-subdev.h, so I would drop
it.

> +		mf = v4l2_subdev_get_try_format(sd, cfg, 0);

I would use format->pad instead of the static 0.

> +		format->format = *mf;

Is this correct? I tought v4l2_subdev_get_try_format() will return the
try_pad which we need to fill.

> +		return 0;
> +#else
> +		return -ENOTTY;

Return this error is not specified in the API-Doc.

> +#endif
> +	}
> +

If I understood it right, your patch should look like:

> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
> +		mf = v4l2_subdev_get_try_format(sd, cfg, format->pad);

Sakari please correct me if it's wrong.

>  	mf->width	= mt9m111->width;
>  	mf->height	= mt9m111->height;
>  	mf->code	= mt9m111->fmt->code;
> @@ -1090,6 +1100,26 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
>  	return 0;
>  }
>  
> +static int mt9m111_init_cfg(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg)

Is this related to the patch description? I would split this into a
seperate patch.

> +{
> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> +	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
> +	struct v4l2_mbus_framefmt *format =
> +		v4l2_subdev_get_try_format(sd, cfg, 0);
> +
> +	format->width	= mt9m111->width;
> +	format->height	= mt9m111->height;
> +	format->code	= mt9m111->fmt->code;
> +	format->colorspace	= mt9m111->fmt->colorspace;
> +	format->field	= V4L2_FIELD_NONE;
> +	format->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
> +	format->quantization	= V4L2_QUANTIZATION_DEFAULT;
> +	format->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
> +#endif
> +	return 0;
> +}
> +
>  static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
>  				struct v4l2_mbus_config *cfg)
>  {
> @@ -1115,6 +1145,7 @@ static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
>  };
>  
>  static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
> +	.init_cfg	= mt9m111_init_cfg,
>  	.enum_mbus_code = mt9m111_enum_mbus_code,
>  	.get_selection	= mt9m111_get_selection,
>  	.set_selection	= mt9m111_set_selection,
> -- 
> 2.7.4
> 
> 
