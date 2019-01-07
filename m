Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC71CC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DA1D2089F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfAGL1u (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:27:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:27439 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbfAGL1u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:27:50 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 03:27:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,450,1539673200"; 
   d="scan'208";a="133595002"
Received: from bachmicx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.57.24])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jan 2019 03:27:47 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 178A321D0B; Mon,  7 Jan 2019 13:27:43 +0200 (EET)
Date:   Mon, 7 Jan 2019 13:27:42 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 09/12] media: mt9m001: register to V4L2 asynchronous
 subdevice framework
Message-ID: <20190107112742.grz2nvaqmcufoblk@kekkonen.localdomain>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-10-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545498774-11754-10-git-send-email-akinobu.mita@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mita-san,

On Sun, Dec 23, 2018 at 02:12:51AM +0900, Akinobu Mita wrote:
> Register a sub-device to the asynchronous subdevice framework, and also
> create subdevice device node.
> 
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/Kconfig   | 2 +-
>  drivers/media/i2c/mt9m001.c | 9 ++++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 5e30ad3..a6d8416 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -845,7 +845,7 @@ config VIDEO_VS6624
>  
>  config VIDEO_MT9M001
>  	tristate "mt9m001 support"
> -	depends on I2C && VIDEO_V4L2
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API

VIDEO_V4L2_SUBDEV_API depends on MEDIA_CONTROLLER, so MEDIA_CONTROLLER
below can be removed.

>  	depends on MEDIA_CAMERA_SUPPORT
>  	depends on MEDIA_CONTROLLER
>  	help
> diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> index e31fb7d..b4deec3 100644
> --- a/drivers/media/i2c/mt9m001.c
> +++ b/drivers/media/i2c/mt9m001.c
> @@ -716,6 +716,7 @@ static int mt9m001_probe(struct i2c_client *client,
>  		return PTR_ERR(mt9m001->reset_gpio);
>  
>  	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
> +	mt9m001->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;

|=

Otherwise you lose flags set by v4l2_i2c_subdev_init().

>  	v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
>  	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
>  			V4L2_CID_VFLIP, 0, 1, 1, 0);
> @@ -765,10 +766,16 @@ static int mt9m001_probe(struct i2c_client *client,
>  	if (ret)
>  		goto error_power_off;
>  
> +	ret = v4l2_async_register_subdev(&mt9m001->subdev);
> +	if (ret)
> +		goto error_entity_cleanup;
> +
>  	pm_runtime_put_sync(&client->dev);
>  
>  	return 0;
>  
> +error_entity_cleanup:
> +	media_entity_cleanup(&mt9m001->subdev.entity);
>  error_power_off:
>  	pm_runtime_disable(&client->dev);
>  	pm_runtime_set_suspended(&client->dev);
> @@ -785,9 +792,9 @@ static int mt9m001_remove(struct i2c_client *client)
>  {
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  
> -	v4l2_device_unregister_subdev(&mt9m001->subdev);
>  	pm_runtime_get_sync(&client->dev);
>  
> +	v4l2_async_unregister_subdev(&mt9m001->subdev);
>  	media_entity_cleanup(&mt9m001->subdev.entity);
>  
>  	pm_runtime_disable(&client->dev);

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
