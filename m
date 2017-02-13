Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52818 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752353AbdBMQQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 11:16:32 -0500
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B8A05600AC
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 18:16:27 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] smiapp: Remove smiapp.h header under include
Date: Mon, 13 Feb 2017 18:16:23 +0200
Message-Id: <1487002586-1480-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1487002586-1480-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1487002586-1480-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As platform data isn't supported anymore, there's no reason to maintain a
separate header under include/. Merge its contents to the one under
drivers/media/i2c/smiapp.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 MAINTAINERS                       |  1 -
 drivers/media/i2c/smiapp/smiapp.h | 49 +++++++++++++++++++++++-
 include/media/i2c/smiapp.h        | 78 ---------------------------------------
 3 files changed, 48 insertions(+), 80 deletions(-)
 delete mode 100644 include/media/i2c/smiapp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index cfff2c9..869196d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11416,7 +11416,6 @@ M:	Sakari Ailus <sakari.ailus@iki.fi>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/i2c/smiapp/
-F:	include/media/i2c/smiapp.h
 F:	drivers/media/i2c/smiapp-pll.c
 F:	drivers/media/i2c/smiapp-pll.h
 F:	include/uapi/linux/smiapp.h
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index f74d695..5ed37af 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -22,13 +22,21 @@
 #include <linux/mutex.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
-#include <media/i2c/smiapp.h>
 
 #include "smiapp-pll.h"
 #include "smiapp-reg.h"
 #include "smiapp-regs.h"
 #include "smiapp-quirk.h"
 
+#define SMIAPP_NAME		"smiapp"
+
+#define SMIAPP_DFL_I2C_ADDR	(0x20 >> 1) /* Default I2C Address */
+#define SMIAPP_ALT_I2C_ADDR	(0x6e >> 1) /* Alternate I2C Address */
+
+#define SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK	0
+#define SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE	1
+#define SMIAPP_CSI_SIGNALLING_MODE_CSI2			2
+
 /*
  * Standard SMIA++ constants
  */
@@ -54,6 +62,45 @@
 
 struct smiapp_quirk;
 
+/*
+ * Sometimes due to board layout considerations the camera module can be
+ * mounted rotated. The typical rotation used is 180 degrees which can be
+ * corrected by giving a default H-FLIP and V-FLIP in the sensor readout.
+ * FIXME: rotation also changes the bayer pattern.
+ */
+enum smiapp_module_board_orient {
+	SMIAPP_MODULE_BOARD_ORIENT_0 = 0,
+	SMIAPP_MODULE_BOARD_ORIENT_180,
+};
+
+struct smiapp_flash_strobe_parms {
+	u8 mode;
+	u32 strobe_width_high_us;
+	u16 strobe_delay;
+	u16 stobe_start_point;
+	u8 trigger;
+};
+
+struct smiapp_hwconfig {
+	/*
+	 * Change the cci address if i2c_addr_alt is set.
+	 * Both default and alternate cci addr need to be present
+	 */
+	unsigned short i2c_addr_dfl;	/* Default i2c addr */
+	unsigned short i2c_addr_alt;	/* Alternate i2c addr */
+
+	uint32_t nvm_size;		/* bytes */
+	uint32_t ext_clk;		/* sensor external clk */
+
+	unsigned int lanes;		/* Number of CSI-2 lanes */
+	uint32_t csi_signalling_mode;	/* SMIAPP_CSI_SIGNALLING_MODE_* */
+	uint64_t *op_sys_clock;
+
+	enum smiapp_module_board_orient module_board_orient;
+
+	struct smiapp_flash_strobe_parms *strobe_setup;
+};
+
 #define SMIAPP_MODULE_IDENT_FLAG_REV_LE		(1 << 0)
 
 struct smiapp_module_ident {
diff --git a/include/media/i2c/smiapp.h b/include/media/i2c/smiapp.h
deleted file mode 100644
index 635007e..0000000
--- a/include/media/i2c/smiapp.h
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * include/media/i2c/smiapp.h
- *
- * Generic driver for SMIA/SMIA++ compliant camera modules
- *
- * Copyright (C) 2011--2012 Nokia Corporation
- * Contact: Sakari Ailus <sakari.ailus@iki.fi>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __SMIAPP_H_
-#define __SMIAPP_H_
-
-#include <media/v4l2-subdev.h>
-
-#define SMIAPP_NAME		"smiapp"
-
-#define SMIAPP_DFL_I2C_ADDR	(0x20 >> 1) /* Default I2C Address */
-#define SMIAPP_ALT_I2C_ADDR	(0x6e >> 1) /* Alternate I2C Address */
-
-#define SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK	0
-#define SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE	1
-#define SMIAPP_CSI_SIGNALLING_MODE_CSI2			2
-
-/*
- * Sometimes due to board layout considerations the camera module can be
- * mounted rotated. The typical rotation used is 180 degrees which can be
- * corrected by giving a default H-FLIP and V-FLIP in the sensor readout.
- * FIXME: rotation also changes the bayer pattern.
- */
-enum smiapp_module_board_orient {
-	SMIAPP_MODULE_BOARD_ORIENT_0 = 0,
-	SMIAPP_MODULE_BOARD_ORIENT_180,
-};
-
-struct smiapp_flash_strobe_parms {
-	u8 mode;
-	u32 strobe_width_high_us;
-	u16 strobe_delay;
-	u16 stobe_start_point;
-	u8 trigger;
-};
-
-struct smiapp_hwconfig {
-	/*
-	 * Change the cci address if i2c_addr_alt is set.
-	 * Both default and alternate cci addr need to be present
-	 */
-	unsigned short i2c_addr_dfl;	/* Default i2c addr */
-	unsigned short i2c_addr_alt;	/* Alternate i2c addr */
-
-	uint32_t nvm_size;		/* bytes */
-	uint32_t ext_clk;		/* sensor external clk */
-
-	unsigned int lanes;		/* Number of CSI-2 lanes */
-	uint32_t csi_signalling_mode;	/* SMIAPP_CSI_SIGNALLING_MODE_* */
-	uint64_t *op_sys_clock;
-
-	enum smiapp_module_board_orient module_board_orient;
-
-	struct smiapp_flash_strobe_parms *strobe_setup;
-};
-
-#endif /* __SMIAPP_H_  */
-- 
2.1.4
