Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:56776 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab0E3MVJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 08:21:09 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 2/3] tm6000: move debug info print from header into c file
Date: Sun, 30 May 2010 14:19:03 +0200
Message-Id: <1275221944-27887-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1275221944-27887-1-git-send-email-stefan.ringel@arcor.de>
References: <1275221944-27887-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

move debug info print from header into c file

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-core.c  |    6 ++++++
 drivers/staging/tm6000/tm6000-dvb.c   |    8 ++++++++
 drivers/staging/tm6000/tm6000-video.c |    6 ++++++
 drivers/staging/tm6000/tm6000.h       |    7 -------
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 624c276..b5965a8 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -29,6 +29,12 @@
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 
+#define dprintk(dev, level, fmt, arg...) do {			\
+	if (tm6000_debug & level)				\
+		printk(KERN_INFO "(%lu) %s %s :"fmt, jiffies,	\
+			dev->name, __FUNCTION__, ##arg);	\
+	} while (0)
+
 #define USB_TIMEOUT	5*HZ /* ms */
 
 int tm6000_read_write_usb (struct tm6000_core *dev, u8 req_type, u8 req,
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index 714b384..b9e9ef1 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -30,6 +30,14 @@
 #include "tuner-xc2028.h"
 #include "xc5000.h"
 
+#undef dprintk
+
+#define dprintk(dev, level, fmt, arg...) do {			\
+	if (debug >= level)					\
+		printk(KERN_INFO "(%lu) %s %s :"fmt, jiffies,	\
+			dev->name, __FUNCTION__, ##arg);	\
+	} while (0)
+
 static void inline print_err_status (struct tm6000_core *dev,
 				     int packet, int status)
 {
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 9746fe7..98af4a5 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -42,6 +42,12 @@
 #include "tm6000-regs.h"
 #include "tm6000.h"
 
+#define dprintk(dev, level, fmt, arg...) do {			\
+	if (tm6000_debug & level)				\
+		printk(KERN_INFO "(%lu) %s %s :"fmt, jiffies,	\
+			dev->name, __FUNCTION__, ##arg);	\
+	} while (0)
+
 #define BUFFER_TIMEOUT     msecs_to_jiffies(2000)  /* 2 seconds */
 
 /* Limits minimum and default number of buffers */
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 231e2be..fd94ed6 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -316,13 +316,6 @@ int tm6000_queue_init(struct tm6000_core *dev);
 
 /* Debug stuff */
 
-extern int tm6000_debug;
-
-#define dprintk(dev, level, fmt, arg...) do {\
-	if (tm6000_debug & level) \
-		printk(KERN_INFO "(%lu) %s %s :"fmt, jiffies, 		\
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
-
 #define V4L2_DEBUG_REG		0x0004
 #define V4L2_DEBUG_I2C		0x0008
 #define V4L2_DEBUG_QUEUE	0x0010
-- 
1.7.0.3

