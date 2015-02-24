Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:45143 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131AbbBXSxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 13:53:49 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: em28xx replace printk in dprintk macros
Date: Tue, 24 Feb 2015 11:53:47 -0700
Message-Id: <1424804027-7790-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printk macro in dprintk macros in em28xx audio, dvb,
and input files with pr_* equivalent routines.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 3 +--
 drivers/media/usb/em28xx/em28xx-dvb.c   | 2 +-
 drivers/media/usb/em28xx/em28xx-input.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 49a5f95..93d89f2 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -55,8 +55,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
 
 #define dprintk(fmt, arg...) do {					\
 	    if (debug)							\
-		printk(KERN_INFO "em28xx-audio %s: " fmt,		\
-				  __func__, ##arg);		\
+		pr_info("em28xx-audio %s: " fmt, __func__, ##arg);	\
 	} while (0)
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index aee70d4..8826054 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -71,7 +71,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define dprintk(level, fmt, arg...) do {			\
 if (debug >= level)						\
-	printk(KERN_DEBUG "%s/2-dvb: " fmt, dev->name, ## arg);	\
+	pr_debug("%s/2-dvb: " fmt, dev->name, ## arg);		\
 } while (0)
 
 struct em28xx_dvb {
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 4007356..e99108b 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -43,7 +43,7 @@ MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 
 #define dprintk(fmt, arg...) \
 	if (ir_debug) { \
-		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
+		pr_debug("%s/ir: " fmt, ir->name, ## arg); \
 	}
 
 /**********************************************************
-- 
2.1.0

