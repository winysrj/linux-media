Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:55366 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750718AbeARWH5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 17:07:57 -0500
Date: Fri, 19 Jan 2018 00:07:53 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Andy Yeh <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org
Subject: Re: [PATCH v3] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180118220753.6gfkpauxibl3igfc@kekkonen.localdomain>
References: <1516292705-12500-1-git-send-email-andy.yeh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516292705-12500-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Fri, Jan 19, 2018 at 12:25:05AM +0800, Andy Yeh wrote:
> Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
> 
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> ---

Please specify in the future which version the differences are from.

> - Update the streaming function to remove SW_STANDBY in the beginning.
> - Adjust the delay time from 1ms to 12ms before set stream-on register.
> - make clear and fix typo in comments.

I'll apply the patch with the following diff. It wouldn't otherwise compile
on the mainline kernel:

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index 54f1a62e5703..a7e58bd23de7 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -1071,7 +1071,7 @@ static int imx258_probe(struct i2c_client *client)
 	/* Initialize subdev */
 	imx258->sd.internal_ops = &imx258_internal_ops;
 	imx258->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-	imx258->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
+	imx258->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 
 	/* Initialize source pad */
 	imx258->pad.flags = MEDIA_PAD_FL_SOURCE;

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
