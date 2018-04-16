Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63299 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751398AbeDPRa4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 13:30:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Aishwarya Pant <aishpant@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH 8/9] media: atomisp-mt9m114: remove dead data
Date: Mon, 16 Apr 2018 12:37:11 -0400
Message-Id: <875091fd30e1db325d2a2ecaacd5a15b64d69b52.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that, originally, the logic would allow selecting between
fine and coarse integration. However, only coarse seems to be
implemented.

Get rid of this warning:

  drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c: In function 'mt9m114_s_exposure':
  drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:1003:6: warning: variable 'exposure_local' set but not used [-Wunused-but-set-variable]
    u16 exposure_local[3];
        ^~~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
index 44db9f9f1fc5..454a5c31a206 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
@@ -995,12 +995,10 @@ static long mt9m114_s_exposure(struct v4l2_subdev *sd,
 	struct mt9m114_device *dev = to_mt9m114_sensor(sd);
 	int ret = 0;
 	unsigned int coarse_integration = 0;
-	unsigned int fine_integration = 0;
 	unsigned int FLines = 0;
 	unsigned int FrameLengthLines = 0; /* ExposureTime.FrameLengthLines; */
 	unsigned int AnalogGain, DigitalGain;
 	u32 AnalogGainToWrite = 0;
-	u16 exposure_local[3];
 
 	dev_dbg(&client->dev, "%s(0x%X 0x%X 0x%X)\n", __func__,
 		    exposure->integration_time[0], exposure->gain[0],
@@ -1032,10 +1030,7 @@ static long mt9m114_s_exposure(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 
-	/* set coarse/fine integration */
-	exposure_local[0] = REG_EXPO_COARSE;
-	exposure_local[1] = (u16)coarse_integration;
-	exposure_local[2] = (u16)fine_integration;
+	/* set coarse integration */
 	/* 3A provide real exposure time.
 		should not translate to any value here. */
 	ret = mt9m114_write_reg(client, MISENSOR_16BIT,
-- 
2.14.3
