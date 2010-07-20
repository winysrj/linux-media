Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38329 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932068Ab0GTBRB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:17:01 -0400
Subject: [PATCH 07/17] v4l2_subdev: Add s_io_pin_config to
 v4l2_subdev_core_ops
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>,
	Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M.Liplianin" <liplianin@me.by>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:16:17 -0400
Message-ID: <1279588577.31145.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a method to v4l2_sudev_core_ops to allow bridge drivers to
manage what signal pads/functions are routed out to multiplexed IO pins on a
pin by pin basis.  The interface also allows specifying initial output settings
for pins and disabling an IO pin altogether.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 include/media/v4l2-subdev.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 02c6f4d..9195ad4 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -90,10 +90,31 @@ struct v4l2_decode_vbi_line {
    not yet implemented) since ops provide proper type-checking.
  */
 
+/* Subdevice external IO pin configuration */
+#define V4L2_SUBDEV_IO_PIN_DISABLE	(1 << 0) /* ENABLE assumed */
+#define V4L2_SUBDEV_IO_PIN_OUTPUT	(1 << 1)
+#define V4L2_SUBDEV_IO_PIN_INPUT	(1 << 2)
+#define V4L2_SUBDEV_IO_PIN_SET_VALUE	(1 << 3) /* Set output value */
+#define V4L2_SUBDEV_IO_PIN_ACTIVE_LOW	(1 << 4) /* ACTIVE HIGH assumed */
+
+struct v4l2_subdev_io_pin_config {
+	u32 flags;	/* V4L2_SUBDEV_IO_PIN_* flags for this pin's config */
+	u8 pin;		/* Chip external IO pin to configure */
+	u8 function;	/* Internal signal pad/function to route to IO pin */
+	u8 value;	/* Initial value for pin - e.g. GPIO output value */
+	u8 strength;	/* Pin drive strength */
+};
+
 /* s_config: if set, then it is always called by the v4l2_i2c_new_subdev*
 	functions after the v4l2_subdev was registered. It is used to pass
 	platform data to the subdev which can be used during initialization.
 
+   s_io_pin_config: configure one or more chip I/O pins for chips that
+	multiplex different internal signal pads out to IO pins.  This function
+	takes a pointer to an array of 'n' pin configuration entries, one for
+	each pin being configured.  This function could be called at times
+	other than just subdevice initialization.
+
    init: initialize the sensor registors to some sort of reasonable default
 	values. Do not use for new drivers and should be removed in existing
 	drivers.
@@ -115,6 +136,8 @@ struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
 	int (*s_config)(struct v4l2_subdev *sd, int irq, void *platform_data);
+	int (*s_io_pin_config)(struct v4l2_subdev *sd, size_t n,
+				      struct v4l2_subdev_io_pin_config *pincfg);
 	int (*init)(struct v4l2_subdev *sd, u32 val);
 	int (*load_fw)(struct v4l2_subdev *sd);
 	int (*reset)(struct v4l2_subdev *sd, u32 val);
-- 
1.7.1.1



