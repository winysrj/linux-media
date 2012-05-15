Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:20485 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab2EOPC4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 11:02:56 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [PATCH 1/1] smiapp: Remove smiapp-debug.h in favour of dynamic debug
Date: Tue, 15 May 2012 18:02:48 +0300
Message-Id: <1337094168-19633-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove smiapp-debug.h and let people use CONFIG_DYNAMIC_DEBUG instead. The
option only affected to when debug information was being printed.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp-pll.c          |    2 -
 drivers/media/video/smiapp/Kconfig        |    7 ------
 drivers/media/video/smiapp/smiapp-core.c  |    2 -
 drivers/media/video/smiapp/smiapp-debug.h |   32 -----------------------------
 drivers/media/video/smiapp/smiapp-quirk.c |    2 -
 drivers/media/video/smiapp/smiapp-regs.c  |    2 -
 6 files changed, 0 insertions(+), 47 deletions(-)
 delete mode 100644 drivers/media/video/smiapp/smiapp-debug.h

diff --git a/drivers/media/video/smiapp-pll.c b/drivers/media/video/smiapp-pll.c
index 501da41..a416e27 100644
--- a/drivers/media/video/smiapp-pll.c
+++ b/drivers/media/video/smiapp-pll.c
@@ -22,8 +22,6 @@
  *
  */
 
-#include "smiapp/smiapp-debug.h"
-
 #include <linux/gcd.h>
 #include <linux/lcm.h>
 #include <linux/module.h>
diff --git a/drivers/media/video/smiapp/Kconfig b/drivers/media/video/smiapp/Kconfig
index 9504c43..f7b35ff 100644
--- a/drivers/media/video/smiapp/Kconfig
+++ b/drivers/media/video/smiapp/Kconfig
@@ -4,10 +4,3 @@ config VIDEO_SMIAPP
 	select VIDEO_SMIAPP_PLL
 	---help---
 	  This is a generic driver for SMIA++/SMIA camera modules.
-
-config VIDEO_SMIAPP_DEBUG
-	bool "Enable debugging for the generic SMIA++/SMIA driver"
-	depends on VIDEO_SMIAPP
-	---help---
-	  Enable debugging output in the generic SMIA++/SMIA driver. If you
-	  are developing the driver you might want to enable this.
diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index 3991c45..a8a1db9 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -26,8 +26,6 @@
  *
  */
 
-#include "smiapp-debug.h"
-
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/gpio.h>
diff --git a/drivers/media/video/smiapp/smiapp-debug.h b/drivers/media/video/smiapp/smiapp-debug.h
deleted file mode 100644
index 627809e..0000000
--- a/drivers/media/video/smiapp/smiapp-debug.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * drivers/media/video/smiapp/smiapp-debug.h
- *
- * Generic driver for SMIA/SMIA++ compliant camera modules
- *
- * Copyright (C) 2011--2012 Nokia Corporation
- * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
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
-#ifndef SMIAPP_DEBUG_H
-#define SMIAPP_DEBUG_H
-
-#ifdef CONFIG_VIDEO_SMIAPP_DEBUG
-#define DEBUG
-#endif
-
-#endif
diff --git a/drivers/media/video/smiapp/smiapp-quirk.c b/drivers/media/video/smiapp/smiapp-quirk.c
index dae85a1..fb018de 100644
--- a/drivers/media/video/smiapp/smiapp-quirk.c
+++ b/drivers/media/video/smiapp/smiapp-quirk.c
@@ -22,8 +22,6 @@
  *
  */
 
-#include "smiapp-debug.h"
-
 #include <linux/delay.h>
 
 #include "smiapp.h"
diff --git a/drivers/media/video/smiapp/smiapp-regs.c b/drivers/media/video/smiapp/smiapp-regs.c
index 4851ff7..a5055f1 100644
--- a/drivers/media/video/smiapp/smiapp-regs.c
+++ b/drivers/media/video/smiapp/smiapp-regs.c
@@ -22,8 +22,6 @@
  *
  */
 
-#include "smiapp-debug.h"
-
 #include <linux/delay.h>
 #include <linux/i2c.h>
 
-- 
1.7.2.5

