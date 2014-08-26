Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 11/35] [media] s5p_mfc: don't use an external symbol called 'debug'
Date: Tue, 26 Aug 2014 18:54:47 -0300
Message-Id: <1409090111-8290-12-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'debug' name is known to cause conflicts with allyesconfig
on several archs. So, localize its name.

>> drivers/built-in.o:(.bss+0xc7ee2c): multiple definition of `debug'
   arch/x86/built-in.o:(.entry.text+0xf78): first defined here
   ld: Warning: size of symbol `debug' changed from 86 in arch/x86/built-in.o to 4 in drivers/built-in.o

While here, fix a wrong file name reference

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c       | 4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d35b0418ab37..89b5b4ad34d3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -37,8 +37,8 @@
 #define S5P_MFC_DEC_NAME	"s5p-mfc-dec"
 #define S5P_MFC_ENC_NAME	"s5p-mfc-enc"
 
-int debug;
-module_param(debug, int, S_IRUGO | S_IWUSR);
+int mfc_debug_level;
+module_param_named(debug, mfc_debug_level, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug level - higher value produces more verbose messages");
 
 /* Helper functions for interrupt processing */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h b/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
index 8e608f5aa0d7..5936923c631c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/platform/samsung/mfc5/s5p_mfc_debug.h
+ * drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
  *
  * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
  * This file contains debug macros
@@ -18,11 +18,11 @@
 #define DEBUG
 
 #ifdef DEBUG
-extern int debug;
+extern int mfc_debug_level;
 
 #define mfc_debug(level, fmt, args...)				\
 	do {							\
-		if (debug >= level)				\
+		if (mfc_debug_level >= level)			\
 			printk(KERN_DEBUG "%s:%d: " fmt,	\
 				__func__, __LINE__, ##args);	\
 	} while (0)
-- 
1.9.3

