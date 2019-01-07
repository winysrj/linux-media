Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99CDC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8487921736
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfAGLam (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:30:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:8577 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfAGLam (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:30:42 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 03:30:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,450,1539673200"; 
   d="scan'208";a="112718816"
Received: from bachmicx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.57.24])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jan 2019 03:30:39 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 9E11221D0B; Mon,  7 Jan 2019 13:30:35 +0200 (EET)
Date:   Mon, 7 Jan 2019 13:30:35 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 11/12] media: mt9m001: make VIDIOC_SUBDEV_G_FMT ioctl
 work with V4L2_SUBDEV_FORMAT_TRY
Message-ID: <20190107113034.4zpxdqoc5xbkvkt7@kekkonen.localdomain>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-12-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545498774-11754-12-git-send-email-akinobu.mita@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mita-san,

On Sun, Dec 23, 2018 at 02:12:53AM +0900, Akinobu Mita wrote:
> The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
> is specified.
> 
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/mt9m001.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> index a5b94d7..f4afbc9 100644
> --- a/drivers/media/i2c/mt9m001.c
> +++ b/drivers/media/i2c/mt9m001.c
> @@ -331,6 +331,12 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
>  	if (format->pad)
>  		return -EINVAL;
>  
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
> +		format->format = *mf;
> +		return 0;
> +	}
> +
>  	mf->width	= mt9m001->rect.width;
>  	mf->height	= mt9m001->rect.height;
>  	mf->code	= mt9m001->fmt->code;
> @@ -638,6 +644,26 @@ static const struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
>  #endif
>  };
>  
> +static int mt9m001_init_cfg(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct mt9m001 *mt9m001 = to_mt9m001(client);
> +	struct v4l2_mbus_framefmt *try_fmt =
> +		v4l2_subdev_get_try_format(sd, cfg, 0);
> +
> +	try_fmt->width		= mt9m001->rect.width;
> +	try_fmt->height		= mt9m001->rect.height;
> +	try_fmt->code		= mt9m001->fmt->code;
> +	try_fmt->colorspace	= mt9m001->fmt->colorspace;

The initial configuration set here should reflect the default, not current
configuration. This appears to refer to the current one.

> +	try_fmt->field		= V4L2_FIELD_NONE;
> +	try_fmt->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
> +	try_fmt->quantization	= V4L2_QUANTIZATION_DEFAULT;
> +	try_fmt->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
> +
> +	return 0;
> +}
> +
>  static int mt9m001_enum_mbus_code(struct v4l2_subdev *sd,
>  		struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_mbus_code_enum *code)
> @@ -674,6 +700,7 @@ static const struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
>  };
>  
>  static const struct v4l2_subdev_pad_ops mt9m001_subdev_pad_ops = {
> +	.init_cfg	= mt9m001_init_cfg,
>  	.enum_mbus_code = mt9m001_enum_mbus_code,
>  	.get_selection	= mt9m001_get_selection,
>  	.set_selection	= mt9m001_set_selection,
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
