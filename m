Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D050C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 15:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B749217D4
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 15:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfAWPRx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 10:17:53 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51049 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfAWPRx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 10:17:53 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gmKHo-0005Rq-5u; Wed, 23 Jan 2019 16:17:52 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gmKHm-0008Ds-Iv; Wed, 23 Jan 2019 16:17:50 +0100
Date:   Wed, 23 Jan 2019 16:17:50 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v3 1/3] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl
 work with V4L2_SUBDEV_FORMAT_TRY
Message-ID: <20190123151750.5s5efpear43pq2uj@pengutronix.de>
References: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
 <1547561141-13504-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547561141-13504-2-git-send-email-akinobu.mita@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:07:47 up 4 days, 19:49, 20 users,  load average: 0.00, 0.01, 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Akinobu,

sorry for the delayed response.

On 19-01-15 23:05, Akinobu Mita wrote:
> The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
> is specified.
> 
> Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Cc: Marco Felsch <m.felsch@pengutronix.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v3
> - Set initial try format with default configuration instead of
>   current one.
> 
>  drivers/media/i2c/mt9m111.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> index d639b9b..63a5253 100644
> --- a/drivers/media/i2c/mt9m111.c
> +++ b/drivers/media/i2c/mt9m111.c
> @@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
>  	if (format->pad)
>  		return -EINVAL;
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> +		mf = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +		format->format = *mf;
> +		return 0;
> +#else
> +		return -ENOTTY;
> +#endif

If've checked this again and found the ov* devices do this too. IMO it's
not good for other developers to check the upper layer if the '#else'
path is reachable. There are also some code analyzer tools which will
report this as issue/warning.

As I said, I checked the v4l2_subdev_get_try_format() usage again and
found the solution made by the mt9v111.c better. Why do you don't add a
dependency in the Kconfig, so we can drop this ifdef?

Regards,
Marco

> +	}
> +
>  	mf->width	= mt9m111->width;
>  	mf->height	= mt9m111->height;
>  	mf->code	= mt9m111->fmt->code;
> @@ -1089,6 +1099,25 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
>  	return 0;
>  }
>  
> +static int mt9m111_init_cfg(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg)
> +{
> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> +	struct v4l2_mbus_framefmt *format =
> +		v4l2_subdev_get_try_format(sd, cfg, 0);
> +
> +	format->width	= MT9M111_MAX_WIDTH;
> +	format->height	= MT9M111_MAX_HEIGHT;
> +	format->code	= mt9m111_colour_fmts[0].code;
> +	format->colorspace	= mt9m111_colour_fmts[0].colorspace;
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
> @@ -1114,6 +1143,7 @@ static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
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
