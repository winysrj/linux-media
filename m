Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57528 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751894AbdJIKTn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 13/24] media: v4l2-subdev: better document IO pin configuration flags
Date: Mon,  9 Oct 2017 07:19:19 -0300
Message-Id: <10e5d09f9d51835527b290a03a972d473c44b941.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert V4L2_SUBDEV_IO_PIN_* to enums, use BIT() and document
via kernel-doc.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index c43e3d650fe6..249604bbd3cb 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -109,22 +109,31 @@ struct v4l2_decode_vbi_line {
  * not yet implemented) since ops provide proper type-checking.
  */
 
-/* Subdevice external IO pin configuration */
-#define V4L2_SUBDEV_IO_PIN_DISABLE	(1 << 0) /* ENABLE assumed */
-#define V4L2_SUBDEV_IO_PIN_OUTPUT	(1 << 1)
-#define V4L2_SUBDEV_IO_PIN_INPUT	(1 << 2)
-#define V4L2_SUBDEV_IO_PIN_SET_VALUE	(1 << 3) /* Set output value */
-#define V4L2_SUBDEV_IO_PIN_ACTIVE_LOW	(1 << 4) /* ACTIVE HIGH assumed */
+/**
+ * enum v4l2_subdev_io_pin_flags - Subdevice external IO pin configuration
+ *	flags
+ *
+ * @V4L2_SUBDEV_IO_PIN_DISABLE: disables a pin config. ENABLE assumed.
+ * @V4L2_SUBDEV_IO_PIN_OUTPUT: set it if pin is an output.
+ * @V4L2_SUBDEV_IO_PIN_INPUT: set it if pin is an input.
+ * @V4L2_SUBDEV_IO_PIN_SET_VALUE: to set the output value via
+ * 				  &struct v4l2_subdev_io_pin_config->value.
+ * @V4L2_SUBDEV_IO_PIN_ACTIVE_LOW: pin active is bit 0.
+ *				   Otherwise, ACTIVE HIGH is assumed.
+ */
+enum v4l2_subdev_io_pin_flags {
+	V4L2_SUBDEV_IO_PIN_DISABLE	= BIT(0),
+	V4L2_SUBDEV_IO_PIN_OUTPUT	= BIT(1),
+	V4L2_SUBDEV_IO_PIN_INPUT	= BIT(2),
+	V4L2_SUBDEV_IO_PIN_SET_VALUE	= BIT(3),
+	V4L2_SUBDEV_IO_PIN_ACTIVE_LOW	= BIT(4),
+};
 
 /**
  * struct v4l2_subdev_io_pin_config - Subdevice external IO pin configuration
  *
- * @flags: bitmask with flags for this pin's config:
- *	   %V4L2_SUBDEV_IO_PIN_DISABLE - disables a pin config,
- *	   %V4L2_SUBDEV_IO_PIN_OUTPUT - if pin is an output,
- *	   %V4L2_SUBDEV_IO_PIN_INPUT - if pin is an input,
- *	   %V4L2_SUBDEV_IO_PIN_SET_VALUE - to set the output value via @value
- *	   and %V4L2_SUBDEV_IO_PIN_ACTIVE_LOW - if active is 0.
+ * @flags: bitmask with flags for this pin's config, as defined by
+ *	   &enum v4l2_subdev_io_pin_flags.
  * @pin: Chip external IO pin to configure
  * @function: Internal signal pad/function to route to IO pin
  * @value: Initial value for pin - e.g. GPIO output value
-- 
2.13.6
