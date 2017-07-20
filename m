Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52301 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965203AbdGTXrk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 19:47:40 -0400
To: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Cc: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
Subject: [PATCH -next] media: ov5670: add depends to fix build errors
Message-ID: <7b6d824a-2574-d33f-7bc9-308809b15b70@infradead.org>
Date: Thu, 20 Jul 2017 16:47:38 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors by adding dependency on VIDEO_V4L2_SUBDEV_API:

../drivers/media/i2c/ov5670.c: In function 'ov5670_open':
../drivers/media/i2c/ov5670.c:1917:5: error: implicit declaration of function 'v4l2_subdev_get_try_format' [-Werror=implicit-function-declaration]
     v4l2_subdev_get_try_format(sd, fh->pad, 0);
../drivers/media/i2c/ov5670.c:1917:38: error: 'struct v4l2_subdev_fh' has no member named 'pad'
     v4l2_subdev_get_try_format(sd, fh->pad, 0);
../drivers/media/i2c/ov5670.c: In function 'ov5670_do_get_pad_format':
../drivers/media/i2c/ov5670.c:2198:17: error: invalid type argument of unary '*' (have 'int')
   fmt->format = *v4l2_subdev_get_try_format(&ov5670->sd, cfg,
../drivers/media/i2c/ov5670.c: In function 'ov5670_set_pad_format':
../drivers/media/i2c/ov5670.c:2236:3: error: invalid type argument of unary '*' (have 'int')
   *v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
../drivers/media/i2c/ov5670.c: At top level:
../drivers/media/i2c/ov5670.c:2444:19: error: 'v4l2_subdev_link_validate' undeclared here (not in a function)
  .link_validate = v4l2_subdev_link_validate,
../drivers/media/i2c/ov5670.c: In function 'ov5670_probe':
../drivers/media/i2c/ov5670.c:2492:12: error: 'struct v4l2_subdev' has no member named 'entity'
  ov5670->sd.entity.ops = &ov5670_subdev_entity_ops;
../drivers/media/i2c/ov5670.c:2493:12: error: 'struct v4l2_subdev' has no member named 'entity'
  ov5670->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
../drivers/media/i2c/ov5670.c:2497:42: error: 'struct v4l2_subdev' has no member named 'entity'
  ret = media_entity_pads_init(&ov5670->sd.entity, 1, &ov5670->pad);
../drivers/media/i2c/ov5670.c:2524:34: error: 'struct v4l2_subdev' has no member named 'entity'
  media_entity_cleanup(&ov5670->sd.entity);
../drivers/media/i2c/ov5670.c: In function 'ov5670_remove':
../drivers/media/i2c/ov5670.c:2544:26: error: 'struct v4l2_subdev' has no member named 'entity'
  media_entity_cleanup(&sd->entity);

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
Cc: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
---
 drivers/media/i2c/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20170720.orig/drivers/media/i2c/Kconfig
+++ linux-next-20170720/drivers/media/i2c/Kconfig
@@ -618,7 +618,7 @@ config VIDEO_OV6650
 
 config VIDEO_OV5670
 	tristate "OmniVision OV5670 sensor support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
