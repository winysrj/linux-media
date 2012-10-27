Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab2J0UmP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:15 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgFte006327
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:15 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 44/68] [media] cx88: get rid of a warning at dprintk() macro
Date: Sat, 27 Oct 2012 18:41:02 -0200
Message-Id: <1351370486-29040-45-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/cx88/cx88-mpeg.c: In function 'cx8802_mpeg_irq':
drivers/media/pci/cx88/cx88-mpeg.c:419:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-mpeg.c: In function 'cx8802_irq':
drivers/media/pci/cx88/cx88-mpeg.c:453:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-alsa.c: In function 'snd_cx88_create':
drivers/media/pci/cx88/cx88-alsa.c:818:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-alsa.c:837:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-alsa.c: In function 'cx88_audio_initdev':
drivers/media/pci/cx88/cx88-alsa.c:912:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c: In function 'blackbird_mbox_func':
drivers/media/pci/cx88/cx88-blackbird.c:327:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:333:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:360:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c: In function 'blackbird_find_mailbox':
drivers/media/pci/cx88/cx88-blackbird.c:421:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c: In function 'blackbird_load_firmware':
drivers/media/pci/cx88/cx88-blackbird.c:444:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:451:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:453:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:459:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:466:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:487:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:492:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:503:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c: In function 'blackbird_initialize_codec':
drivers/media/pci/cx88/cx88-blackbird.c:560:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:566:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/pci/cx88/cx88-blackbird.c:569:3: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx88/cx88-alsa.c      | 14 +++++++++-----
 drivers/media/pci/cx88/cx88-blackbird.c |  7 ++++---
 drivers/media/pci/cx88/cx88-mpeg.c      | 14 +++++++++-----
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 3aa6856..d2de1a9 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -45,11 +45,15 @@
 #include "cx88.h"
 #include "cx88-reg.h"
 
-#define dprintk(level,fmt, arg...)	if (debug >= level) \
-	printk(KERN_INFO "%s/1: " fmt, chip->core->name , ## arg)
-
-#define dprintk_core(level,fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG "%s/1: " fmt, chip->core->name , ## arg)
+#define dprintk(level, fmt, arg...) do {				\
+	if (debug + 1 > level)						\
+		printk(KERN_INFO "%s/1: " fmt, chip->core->name , ## arg);\
+} while(0)
+
+#define dprintk_core(level, fmt, arg...) do {				\
+	if (debug + 1 > level)						\
+		printk(KERN_DEBUG "%s/1: " fmt, chip->core->name , ## arg);\
+} while(0)
 
 /****************************************************************************
 	Data type declarations - Can be moded to a header file later
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 62184eb..a6ff8a6 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -53,9 +53,10 @@ static unsigned int debug;
 module_param(debug,int,0644);
 MODULE_PARM_DESC(debug,"enable debug messages [blackbird]");
 
-#define dprintk(level,fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG "%s/2-bb: " fmt, dev->core->name , ## arg)
-
+#define dprintk(level, fmt, arg...) do {				      \
+	if (debug + 1 > level)						      \
+		printk(KERN_DEBUG "%s/2-bb: " fmt, dev->core->name , ## arg); \
+} while(0)
 
 /* ------------------------------------------------------------------ */
 
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 1b7e979..d46b008 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -45,11 +45,15 @@ static unsigned int debug;
 module_param(debug,int,0644);
 MODULE_PARM_DESC(debug,"enable debug messages [mpeg]");
 
-#define dprintk(level,fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG "%s/2-mpeg: " fmt, dev->core->name, ## arg)
-
-#define mpeg_dbg(level,fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG "%s/2-mpeg: " fmt, core->name, ## arg)
+#define dprintk(level, fmt, arg...) do {				       \
+	if (debug + 1 > level)						       \
+		printk(KERN_DEBUG "%s/2-mpeg: " fmt, dev->core->name, ## arg); \
+} while(0)
+
+#define mpeg_dbg(level, fmt, arg...) do {				  \
+	if (debug + 1 > level)						  \
+		printk(KERN_DEBUG "%s/2-mpeg: " fmt, core->name, ## arg); \
+} while(0)
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
 static void request_module_async(struct work_struct *work)
-- 
1.7.11.7

