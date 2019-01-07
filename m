Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD91C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A70D021736
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfAGL3T (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:29:19 -0500
Received: from mga17.intel.com ([192.55.52.151]:49451 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfAGL3T (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:29:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 03:29:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,450,1539673200"; 
   d="scan'208";a="309606990"
Received: from bachmicx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.57.24])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jan 2019 03:29:15 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id EDF1721D0B; Mon,  7 Jan 2019 13:29:10 +0200 (EET)
Date:   Mon, 7 Jan 2019 13:29:10 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 07/12] media: mt9m001: remove remaining soc_camera
 specific code
Message-ID: <20190107112910.waj5sbjje7vobrof@kekkonen.localdomain>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-8-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545498774-11754-8-git-send-email-akinobu.mita@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mita-san,

On Sun, Dec 23, 2018 at 02:12:49AM +0900, Akinobu Mita wrote:
> Remove remaining soc_camera specific code and drop soc_camera dependency
> from this driver.
> 
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/Kconfig   |  2 +-
>  drivers/media/i2c/mt9m001.c | 84 ++++++++-------------------------------------
>  2 files changed, 15 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 0efc038..4bdf043 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -845,7 +845,7 @@ config VIDEO_VS6624
>  
>  config VIDEO_MT9M001
>  	tristate "mt9m001 support"
> -	depends on SOC_CAMERA && I2C
> +	depends on I2C && VIDEO_V4L2
>  	help
>  	  This driver supports MT9M001 cameras from Micron, monochrome
>  	  and colour models.
> diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> index f20188a..eb5c4ed 100644
> --- a/drivers/media/i2c/mt9m001.c
> +++ b/drivers/media/i2c/mt9m001.c
> @@ -15,15 +15,12 @@
>  #include <linux/log2.h>
>  #include <linux/module.h>
>  
> -#include <media/soc_camera.h>
> -#include <media/drv-intf/soc_mediabus.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-ctrls.h>

While at it, could you order the list alphabetically? The same applies to
further patches changing included files.

> +#include <media/v4l2-device.h>
>  
>  /*
>   * mt9m001 i2c address 0x5d
> - * The platform has to define struct i2c_board_info objects and link to them
> - * from struct soc_camera_host_desc
>   */
>  
>  /* mt9m001 selected register addresses */
> @@ -278,11 +275,15 @@ static int mt9m001_set_selection(struct v4l2_subdev *sd,
>  	rect.width = ALIGN(rect.width, 2);
>  	rect.left = ALIGN(rect.left, 2);
>  
> -	soc_camera_limit_side(&rect.left, &rect.width,
> -		     MT9M001_COLUMN_SKIP, MT9M001_MIN_WIDTH, MT9M001_MAX_WIDTH);
> +	rect.width = clamp_t(u32, rect.width, MT9M001_MIN_WIDTH,
> +			MT9M001_MAX_WIDTH);
> +	rect.left = clamp_t(u32, rect.left, MT9M001_COLUMN_SKIP,
> +			MT9M001_COLUMN_SKIP + MT9M001_MAX_WIDTH - rect.width);
>  
> -	soc_camera_limit_side(&rect.top, &rect.height,
> -		     MT9M001_ROW_SKIP, MT9M001_MIN_HEIGHT, MT9M001_MAX_HEIGHT);
> +	rect.height = clamp_t(u32, rect.height, MT9M001_MIN_HEIGHT,
> +			MT9M001_MAX_HEIGHT);
> +	rect.top = clamp_t(u32, rect.top, MT9M001_ROW_SKIP,
> +			MT9M001_ROW_SKIP + MT9M001_MAX_HEIGHT - rect.width);
>  
>  	mt9m001->total_h = rect.height + mt9m001->y_skip_top +
>  			   MT9M001_DEFAULT_VBLANK;
> @@ -561,12 +562,10 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
>   * Interface active, can use i2c. If it fails, it can indeed mean, that
>   * this wasn't our capture interface, so, we wait for the right one
>   */
> -static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
> -			       struct i2c_client *client)
> +static int mt9m001_video_probe(struct i2c_client *client)
>  {
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  	s32 data;
> -	unsigned long flags;
>  	int ret;
>  
>  	/* Enable the chip */
> @@ -581,9 +580,11 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
>  	case 0x8411:
>  	case 0x8421:
>  		mt9m001->fmts = mt9m001_colour_fmts;
> +		mt9m001->num_fmts = ARRAY_SIZE(mt9m001_colour_fmts);
>  		break;
>  	case 0x8431:
>  		mt9m001->fmts = mt9m001_monochrome_fmts;
> +		mt9m001->num_fmts = ARRAY_SIZE(mt9m001_monochrome_fmts);
>  		break;
>  	default:
>  		dev_err(&client->dev,
> @@ -592,26 +593,6 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
>  		goto done;
>  	}
>  
> -	mt9m001->num_fmts = 0;
> -
> -	/*
> -	 * This is a 10bit sensor, so by default we only allow 10bit.
> -	 * The platform may support different bus widths due to
> -	 * different routing of the data lines.
> -	 */
> -	if (ssdd->query_bus_param)
> -		flags = ssdd->query_bus_param(ssdd);
> -	else
> -		flags = SOCAM_DATAWIDTH_10;
> -
> -	if (flags & SOCAM_DATAWIDTH_10)
> -		mt9m001->num_fmts++;
> -	else
> -		mt9m001->fmts++;
> -
> -	if (flags & SOCAM_DATAWIDTH_8)
> -		mt9m001->num_fmts++;
> -
>  	mt9m001->fmt = &mt9m001->fmts[0];
>  
>  	dev_info(&client->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
> @@ -630,12 +611,6 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
>  	return ret;
>  }
>  
> -static void mt9m001_video_remove(struct soc_camera_subdev_desc *ssdd)
> -{
> -	if (ssdd->free_bus)
> -		ssdd->free_bus(ssdd);
> -}
> -
>  static int mt9m001_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -675,41 +650,18 @@ static int mt9m001_enum_mbus_code(struct v4l2_subdev *sd,
>  static int mt9m001_g_mbus_config(struct v4l2_subdev *sd,
>  				struct v4l2_mbus_config *cfg)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> -
>  	/* MT9M001 has all capture_format parameters fixed */
>  	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_FALLING |
>  		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
>  		V4L2_MBUS_DATA_ACTIVE_HIGH | V4L2_MBUS_MASTER;
>  	cfg->type = V4L2_MBUS_PARALLEL;
> -	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
>  
>  	return 0;
>  }
>  
> -static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
> -				const struct v4l2_mbus_config *cfg)
> -{
> -	const struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> -	struct mt9m001 *mt9m001 = to_mt9m001(client);
> -	unsigned int bps = soc_mbus_get_fmtdesc(mt9m001->fmt->code)->bits_per_sample;
> -
> -	if (ssdd->set_bus_param)
> -		return ssdd->set_bus_param(ssdd, 1 << (bps - 1));
> -
> -	/*
> -	 * Without board specific bus width settings we only support the
> -	 * sensors native bus width
> -	 */
> -	return bps == 10 ? 0 : -EINVAL;
> -}
> -
>  static const struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
>  	.s_stream	= mt9m001_s_stream,
>  	.g_mbus_config	= mt9m001_g_mbus_config,
> -	.s_mbus_config	= mt9m001_s_mbus_config,
>  };
>  
>  static const struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
> @@ -736,21 +688,15 @@ static int mt9m001_probe(struct i2c_client *client,
>  {
>  	struct mt9m001 *mt9m001;
>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	int ret;
>  
> -	if (!ssdd) {
> -		dev_err(&client->dev, "MT9M001 driver needs platform data\n");
> -		return -EINVAL;
> -	}
> -
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
>  		dev_warn(&adapter->dev,
>  			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
>  		return -EIO;
>  	}
>  
> -	mt9m001 = devm_kzalloc(&client->dev, sizeof(struct mt9m001), GFP_KERNEL);
> +	mt9m001 = devm_kzalloc(&client->dev, sizeof(*mt9m001), GFP_KERNEL);
>  	if (!mt9m001)
>  		return -ENOMEM;
>  
> @@ -808,7 +754,7 @@ static int mt9m001_probe(struct i2c_client *client,
>  	pm_runtime_set_active(&client->dev);
>  	pm_runtime_enable(&client->dev);
>  
> -	ret = mt9m001_video_probe(ssdd, client);
> +	ret = mt9m001_video_probe(client);
>  	if (ret)
>  		goto error_power_off;
>  
> @@ -831,7 +777,6 @@ static int mt9m001_probe(struct i2c_client *client,
>  static int mt9m001_remove(struct i2c_client *client)
>  {
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  
>  	v4l2_device_unregister_subdev(&mt9m001->subdev);
>  	pm_runtime_get_sync(&client->dev);
> @@ -842,7 +787,6 @@ static int mt9m001_remove(struct i2c_client *client)
>  	mt9m001_power_off(mt9m001);
>  
>  	v4l2_ctrl_handler_free(&mt9m001->hdl);
> -	mt9m001_video_remove(ssdd);
>  	mutex_destroy(&mt9m001->mutex);
>  
>  	return 0;
> -- 
> 2.7.4
> 

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
