Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/39] [media] Docbook: fix comments at v4l2-flash-led-class.h
Date: Sat, 22 Aug 2015 14:27:52 -0300
Message-Id: <11b5f7876ae94a84cbfa97697621bbfc6df31fb6.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/v4l2-flash-led-class.h:51): bad line: 				unique in the system
Warning(.//include/media/v4l2-flash-led-class.h:56): bad line: 				definitions are available in the header file
Warning(.//include/media/v4l2-flash-led-class.h:57): bad line: 				<linux/led-class-flash.h>
Warning(.//include/media/v4l2-flash-led-class.h:122): No description found for parameter 'ops'
Warning(.//include/media/v4l2-flash-led-class.h:122): Excess function parameter 'flash_ops' description in 'v4l2_flash_init'
Warning(.//include/media/v4l2-flash-led-class.h:130): No description found for parameter 'v4l2_flash'
Warning(.//include/media/v4l2-flash-led-class.h:130): Excess function parameter 'flash' description in 'v4l2_flash_release'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
index 098236c083b8..3d184ab52274 100644
--- a/include/media/v4l2-flash-led-class.h
+++ b/include/media/v4l2-flash-led-class.h
@@ -48,13 +48,13 @@ struct v4l2_flash_ops {
 /**
  * struct v4l2_flash_config - V4L2 Flash sub-device initialization data
  * @dev_name:			the name of the media entity,
-				unique in the system
+ *				unique in the system
  * @torch_intensity:		constraints for the LED in torch mode
  * @indicator_intensity:	constraints for the indicator LED
  * @flash_faults:		bitmask of flash faults that the LED flash class
-				device can report; corresponding LED_FAULT* bit
-				definitions are available in the header file
-				<linux/led-class-flash.h>
+ *				device can report; corresponding LED_FAULT* bit
+ *				definitions are available in the header file
+ *				<linux/led-class-flash.h>
  * @has_external_strobe:	external strobe capability
  */
 struct v4l2_flash_config {
@@ -105,7 +105,7 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
  * @fled_cdev:	LED flash class device to wrap
  * @iled_cdev:	LED flash class device representing indicator LED associated
  *		with fled_cdev, may be NULL
- * @flash_ops:	V4L2 Flash device ops
+ * @ops:	V4L2 Flash device ops
  * @config:	initialization data for V4L2 Flash sub-device
  *
  * Create V4L2 Flash sub-device wrapping given LED subsystem device.
@@ -123,7 +123,7 @@ struct v4l2_flash *v4l2_flash_init(
 
 /**
  * v4l2_flash_release - release V4L2 Flash sub-device
- * @flash: the V4L2 Flash sub-device to release
+ * @v4l2_flash: the V4L2 Flash sub-device to release
  *
  * Release V4L2 Flash sub-device.
  */
-- 
2.4.3

