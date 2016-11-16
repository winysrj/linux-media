Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49713 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753838AbcKPQnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:17 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 15/35] [media] ttpci: cleanup debug macros and remove dead code
Date: Wed, 16 Nov 2016 14:42:47 -0200
Message-Id: <6960ccf1d0692be24212ce3c96aed4dcd522bf3e.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Continuation lines without KERN_CONT won't work anymore.
However, the way dprintk() was defined leads to the usage
of continuation lines, with should be avoided when possible.

So, redefine those macros.

While hre, remove some dead code at av7110.c with also
relies on continuation lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ttpci/av7110.c | 15 ---------------
 drivers/media/pci/ttpci/av7110.h |  7 +++++--
 drivers/media/pci/ttpci/budget.h |  8 ++++++--
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index fbcc2e5c9414..b16858dadc49 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -443,21 +443,6 @@ static void debiirq(unsigned long cookie)
 
 	case DATA_COMMON_INTERFACE:
 		CI_handle(av7110, (u8 *)av7110->debi_virt, av7110->debilen);
-#if 0
-	{
-		int i;
-
-		printk("av7110%d: ", av7110->num);
-		printk("%02x ", *(u8 *)av7110->debi_virt);
-		printk("%02x ", *(1+(u8 *)av7110->debi_virt));
-		for (i = 2; i < av7110->debilen; i++)
-			printk("%02x ", (*(i+(unsigned char *)av7110->debi_virt)));
-		for (i = 2; i < av7110->debilen; i++)
-			printk("%c", chtrans(*(i+(unsigned char *)av7110->debi_virt)));
-
-		printk("\n");
-	}
-#endif
 		xfer = RX_BUFF;
 		break;
 
diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
index 3707ccd02732..b656397a5b44 100644
--- a/drivers/media/pci/ttpci/av7110.h
+++ b/drivers/media/pci/ttpci/av7110.h
@@ -40,8 +40,11 @@
 
 extern int av7110_debug;
 
-#define dprintk(level,args...) \
-	    do { if ((av7110_debug & level)) { printk("dvb-ttpci: %s(): ", __func__); printk(args); } } while (0)
+#define dprintk(level, fmt, arg...) do {				\
+	if (level & av7110_debug)					\
+		printk(KERN_DEBUG KBUILD_MODNAME ": %s(): " fmt,	\
+		       __func__ , ##arg);				\
+} while(0)
 
 #define MAXFILT 32
 
diff --git a/drivers/media/pci/ttpci/budget.h b/drivers/media/pci/ttpci/budget.h
index 655eef5236ca..299ca2489c6a 100644
--- a/drivers/media/pci/ttpci/budget.h
+++ b/drivers/media/pci/ttpci/budget.h
@@ -21,8 +21,12 @@ extern int budget_debug;
 #undef dprintk
 #endif
 
-#define dprintk(level,args...) \
-	    do { if ((budget_debug & level)) { printk("%s: %s(): ", KBUILD_MODNAME, __func__); printk(args); } } while (0)
+#define dprintk(level, fmt, arg...) do {				\
+	if (level & budget_debug)					\
+		printk(KERN_DEBUG KBUILD_MODNAME ": %s(): " fmt,	\
+		       __func__ , ##arg);				\
+} while(0)
+
 
 struct budget_info {
 	char *name;
-- 
2.7.4


