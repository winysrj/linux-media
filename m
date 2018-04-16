Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48051 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752058AbeDPQhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 12:37:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        "Guillermo O. Freschi" <kedrot@gmail.com>,
        Aishwarya Pant <aishpant@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH 4/9] media: staging: atomisp-gc2235: don't fill an unused var
Date: Mon, 16 Apr 2018 12:37:07 -0400
Message-Id: <3adf2de3ce8958229a1322c01e180351086d06b1.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code with uses the dummy var is commented out. So,
coment out its definition/initialization.

Fix this warning:

  drivers/staging/media/atomisp/i2c/atomisp-gc2235.c: In function 'gc2235_get_intg_factor':
  drivers/staging/media/atomisp/i2c/atomisp-gc2235.c:249:26: warning: variable 'dummy' set but not used [-Wunused-but-set-variable]
    u16 reg_val, reg_val_h, dummy;
                            ^~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
index 93f9c618f3d8..4b6b6568b3cf 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
@@ -246,7 +246,7 @@ static int gc2235_get_intg_factor(struct i2c_client *client,
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
 	struct atomisp_sensor_mode_data *buf = &info->data;
-	u16 reg_val, reg_val_h, dummy;
+	u16 reg_val, reg_val_h;
 	int ret;
 
 	if (!info)
@@ -316,7 +316,9 @@ static int gc2235_get_intg_factor(struct i2c_client *client,
 	if (ret)
 		return ret;
 
-	dummy = (reg_val_h << 8) | reg_val;
+#if 0
+	u16 dummy = (reg_val_h << 8) | reg_val;
+#endif
 
 	ret = gc2235_read_reg(client, GC2235_8BIT,
 					GC2235_SH_DELAY_H, &reg_val_h);
-- 
2.14.3
