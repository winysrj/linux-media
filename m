Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0F8C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 08:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F11B52083B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 08:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbfBEIzq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 03:55:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:55025 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbfBEIzq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 03:55:46 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2019 00:55:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="131189544"
Received: from ekorotko-mobl1.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.43.22])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Feb 2019 00:55:41 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 0A62721D81; Tue,  5 Feb 2019 10:55:39 +0200 (EET)
Date:   Tue, 5 Feb 2019 10:55:39 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 6/6] media: ov5640: Consolidate JPEG compression mode
 setting
Message-ID: <20190205085539.6nh7rzialcvztuqo@kekkonen.localdomain>
References: <20190118085206.2598-1-wens@csie.org>
 <20190118085206.2598-7-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118085206.2598-7-wens@csie.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Chen-Yu,

On Fri, Jan 18, 2019 at 04:52:06PM +0800, Chen-Yu Tsai wrote:
> The register value lists for all the supported resolution settings all
> include a register address/value pair for setting the JPEG compression
> mode. With the exception of 1080p (which sets mode 2), all resolutions
> use mode 3.
> 
> The only difference between mode 2 and mode 3 is that mode 2 may have
> padding data on the last line, while mode 3 does not add padding data.
> 
> As these register values were from dumps of running systems, and the
> difference between the modes is quite small, using mode 3 for all
> configurations should be OK.
> 
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  drivers/media/i2c/ov5640.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 1c1dc401c678..3d2c5de73283 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -85,6 +85,7 @@
>  #define OV5640_REG_FORMAT_CONTROL00	0x4300
>  #define OV5640_REG_VFIFO_HSIZE		0x4602
>  #define OV5640_REG_VFIFO_VSIZE		0x4604
> +#define OV5640_REG_JPG_MODE_SELECT	0x4713

How has this been tested?

The register is referred to as "OV5640_REG_JPEG_MODE_SELECT" below. I can
fix it if it's just a typo, but please confirm.

Thanks.

>  #define OV5640_REG_POLARITY_CTRL00	0x4740
>  #define OV5640_REG_MIPI_CTRL00		0x4800
>  #define OV5640_REG_DEBUG_MODE		0x4814
> @@ -303,7 +304,7 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
>  	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x3000, 0x00, 0, 0},
>  	{0x3002, 0x1c, 0, 0}, {0x3004, 0xff, 0, 0}, {0x3006, 0xc3, 0, 0},
>  	{0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
> -	{0x501f, 0x00, 0, 0}, {0x4713, 0x03, 0, 0}, {0x4407, 0x04, 0, 0},
> +	{0x501f, 0x00, 0, 0}, {0x4407, 0x04, 0, 0},
>  	{0x440e, 0x00, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>  	{0x4837, 0x0a, 0, 0}, {0x3824, 0x02, 0, 0},
>  	{0x5000, 0xa7, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x5180, 0xff, 0, 0},
> @@ -372,7 +373,7 @@ static const struct reg_value ov5640_setting_VGA_640_480[] = {
>  	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
>  	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
>  	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> -	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
>  	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>  	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
>  };
> @@ -391,7 +392,7 @@ static const struct reg_value ov5640_setting_XGA_1024_768[] = {
>  	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
>  	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
>  	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> -	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
>  	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>  	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
>  };
> @@ -410,7 +411,7 @@ static const struct reg_value ov5640_setting_QVGA_320_240[] = {
>  	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
>  	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
>  	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> -	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
>  	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>  	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
>  };
> @@ -429,7 +430,7 @@ static const struct reg_value ov5640_setting_QCIF_176_144[] = {
>  	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
>  	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
>  	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> -	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
>  	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>  	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
>  };
> @@ -448,7 +449,7 @@ static const struct reg_value ov5640_setting_NTSC_720_480[] = {
>  	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
>  	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
>  	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> -	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
>  	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>  	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
>  };
> @@ -467,7 +468,7 @@ static const struct reg_value ov5640_setting_PAL_720_576[] = {
>  	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
>  	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
>  	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> -	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
>  	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>  	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
>  };
> @@ -486,7 +487,7 @@ static const struct reg_value ov5640_setting_720P_1280_720[] = {
>  	{0x3a03, 0xe4, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0xbc, 0, 0},
>  	{0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x72, 0, 0}, {0x3a0e, 0x01, 0, 0},
>  	{0x3a0d, 0x02, 0, 0}, {0x3a14, 0x02, 0, 0}, {0x3a15, 0xe4, 0, 0},
> -	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
>  	{0x4407, 0x04, 0, 0}, {0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0},
>  	{0x3824, 0x04, 0, 0}, {0x5001, 0x83, 0, 0},
>  };
> @@ -506,7 +507,7 @@ static const struct reg_value ov5640_setting_1080P_1920_1080[] = {
>  	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
>  	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
>  	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> -	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0},
>  	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>  	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
>  	{0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
> @@ -518,7 +519,7 @@ static const struct reg_value ov5640_setting_1080P_1920_1080[] = {
>  	{0x3a02, 0x04, 0, 0}, {0x3a03, 0x60, 0, 0}, {0x3a08, 0x01, 0, 0},
>  	{0x3a09, 0x50, 0, 0}, {0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x18, 0, 0},
>  	{0x3a0e, 0x03, 0, 0}, {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x04, 0, 0},
> -	{0x3a15, 0x60, 0, 0}, {0x4713, 0x02, 0, 0}, {0x4407, 0x04, 0, 0},
> +	{0x3a15, 0x60, 0, 0}, {0x4407, 0x04, 0, 0},
>  	{0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0}, {0x3824, 0x04, 0, 0},
>  	{0x4005, 0x1a, 0, 0}, {0x3008, 0x02, 0, 0},
>  };
> @@ -537,7 +538,7 @@ static const struct reg_value ov5640_setting_QSXGA_2592_1944[] = {
>  	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
>  	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
>  	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> -	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0},
>  	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
>  	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 70},
>  };
> @@ -1051,6 +1052,17 @@ static int ov5640_set_jpeg_timings(struct ov5640_dev *sensor,
>  {
>  	int ret;
>  
> +	/*
> +	 * compression mode 3 timing
> +	 *
> +	 * Data is transmitted with programmable width (VFIFO_HSIZE).
> +	 * No padding done. Last line may have less data. Varying
> +	 * number of lines per frame, depending on amount of data.
> +	 */
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_JPEG_MODE_SELECT, 0x7, 0x3);
> +	if (ret < 0)
> +		return ret;
> +
>  	ret = ov5640_write_reg16(sensor, OV5640_REG_VFIFO_HSIZE, mode->hact);
>  	if (ret < 0)
>  		return ret;

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
