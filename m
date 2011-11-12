Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:57365 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab1KLPGQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:06:16 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH RESEND] davinci: dm646x: move vpif related code to driver core header from platform
Date: Sat, 12 Nov 2011 20:36:02 +0530
Message-ID: <1321110362-6699-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

move vpif related code for capture and display drivers
from dm646x platform header file to vpif_types.h as these definitions
are related to driver code more than the platform or board.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/include/mach/dm646x.h |   53 +-------------------
 drivers/media/video/davinci/vpif.h          |    1 +
 drivers/media/video/davinci/vpif_capture.h  |    2 +-
 drivers/media/video/davinci/vpif_display.h  |    1 +
 include/media/davinci/vpif_types.h          |   71 +++++++++++++++++++++++++++
 5 files changed, 75 insertions(+), 53 deletions(-)
 create mode 100644 include/media/davinci/vpif_types.h

diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
index 2a00fe5..a8ee6c9 100644
--- a/arch/arm/mach-davinci/include/mach/dm646x.h
+++ b/arch/arm/mach-davinci/include/mach/dm646x.h
@@ -16,6 +16,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/davinci_emac.h>
+#include <media/davinci/vpif_types.h>
 
 #define DM646X_EMAC_BASE		(0x01C80000)
 #define DM646X_EMAC_MDIO_BASE		(DM646X_EMAC_BASE + 0x4000)
@@ -34,58 +35,6 @@ int __init dm646x_init_edma(struct edma_rsv_info *rsv);
 
 void dm646x_video_init(void);
 
-enum vpif_if_type {
-	VPIF_IF_BT656,
-	VPIF_IF_BT1120,
-	VPIF_IF_RAW_BAYER
-};
-
-struct vpif_interface {
-	enum vpif_if_type if_type;
-	unsigned hd_pol:1;
-	unsigned vd_pol:1;
-	unsigned fid_pol:1;
-};
-
-struct vpif_subdev_info {
-	const char *name;
-	struct i2c_board_info board_info;
-	u32 input;
-	u32 output;
-	unsigned can_route:1;
-	struct vpif_interface vpif_if;
-};
-
-struct vpif_display_config {
-	int (*set_clock)(int, int);
-	struct vpif_subdev_info *subdevinfo;
-	int subdev_count;
-	const char **output;
-	int output_count;
-	const char *card_name;
-};
-
-struct vpif_input {
-	struct v4l2_input input;
-	const char *subdev_name;
-};
-
-#define VPIF_CAPTURE_MAX_CHANNELS	2
-
-struct vpif_capture_chan_config {
-	const struct vpif_input *inputs;
-	int input_count;
-};
-
-struct vpif_capture_config {
-	int (*setup_input_channel_mode)(int);
-	int (*setup_input_path)(int, const char *);
-	struct vpif_capture_chan_config chan_config[VPIF_CAPTURE_MAX_CHANNELS];
-	struct vpif_subdev_info *subdev_info;
-	int subdev_count;
-	const char *card_name;
-};
-
 void dm646x_setup_vpif(struct vpif_display_config *,
 		       struct vpif_capture_config *);
 
diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 10550bd..25036cb 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -20,6 +20,7 @@
 #include <linux/videodev2.h>
 #include <mach/hardware.h>
 #include <mach/dm646x.h>
+#include <media/davinci/vpif_types.h>
 
 /* Maximum channel allowed */
 #define VPIF_NUM_CHANNELS		(4)
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index 064550f..a693d4e 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -27,7 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
 #include <media/videobuf-dma-contig.h>
-#include <mach/dm646x.h>
+#include <media/davinci/vpif_types.h>
 
 #include "vpif.h"
 
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index 5d1936d..56879d1 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -22,6 +22,7 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
 #include <media/videobuf-dma-contig.h>
+#include <media/davinci/vpif_types.h>
 
 #include "vpif.h"
 
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
new file mode 100644
index 0000000..9929b05
--- /dev/null
+++ b/include/media/davinci/vpif_types.h
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef _VPIF_TYPES_H
+#define _VPIF_TYPES_H
+
+#define VPIF_CAPTURE_MAX_CHANNELS	2
+
+enum vpif_if_type {
+	VPIF_IF_BT656,
+	VPIF_IF_BT1120,
+	VPIF_IF_RAW_BAYER
+};
+
+struct vpif_interface {
+	enum vpif_if_type if_type;
+	unsigned hd_pol:1;
+	unsigned vd_pol:1;
+	unsigned fid_pol:1;
+};
+
+struct vpif_subdev_info {
+	const char *name;
+	struct i2c_board_info board_info;
+	u32 input;
+	u32 output;
+	unsigned can_route:1;
+	struct vpif_interface vpif_if;
+};
+
+struct vpif_display_config {
+	int (*set_clock)(int, int);
+	struct vpif_subdev_info *subdevinfo;
+	int subdev_count;
+	const char **output;
+	int output_count;
+	const char *card_name;
+};
+
+struct vpif_input {
+	struct v4l2_input input;
+	const char *subdev_name;
+};
+
+struct vpif_capture_chan_config {
+	const struct vpif_input *inputs;
+	int input_count;
+};
+
+struct vpif_capture_config {
+	int (*setup_input_channel_mode)(int);
+	int (*setup_input_path)(int, const char *);
+	struct vpif_capture_chan_config chan_config[VPIF_CAPTURE_MAX_CHANNELS];
+	struct vpif_subdev_info *subdev_info;
+	int subdev_count;
+	const char *card_name;
+};
+#endif /* _VPIF_TYPES_H */
-- 
1.6.2.4

