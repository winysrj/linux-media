Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40718 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753306AbeDIQsA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:00 -0400
Received: by mail-wr0-f196.google.com with SMTP id n2so10253935wrj.7
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:47:59 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 03/19] [media] ddbridge: move modparams to ddbridge-core.c
Date: Mon,  9 Apr 2018 18:47:36 +0200
Message-Id: <20180409164752.641-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Besides the 'msi' module option, all options are used from within
ddbridge-core only, so move them over from ddbridge-main, and declare the
associated variables static. Since the prototypes in ddbridge.h aren't
necessary anymore now, remove them. As a side effect, this has the benefit
of aligning things more with the dddvb upstream.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 28 ++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-main.c | 28 ----------------------------
 drivers/media/pci/ddbridge/ddbridge.h      |  6 ------
 3 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 90687eff5909..933046d03db5 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -68,6 +68,34 @@ module_param(adapter_alloc, int, 0444);
 MODULE_PARM_DESC(adapter_alloc,
 		 "0-one adapter per io, 1-one per tab with io, 2-one per tab, 3-one for all");
 
+static int ci_bitrate = 70000;
+module_param(ci_bitrate, int, 0444);
+MODULE_PARM_DESC(ci_bitrate, " Bitrate in KHz for output to CI.");
+
+static int ts_loop = -1;
+module_param(ts_loop, int, 0444);
+MODULE_PARM_DESC(ts_loop, "TS in/out test loop on port ts_loop");
+
+static int xo2_speed = 2;
+module_param(xo2_speed, int, 0444);
+MODULE_PARM_DESC(xo2_speed, "default transfer speed for xo2 based duoflex, 0=55,1=75,2=90,3=104 MBit/s, default=2, use attribute to change for individual cards");
+
+#ifdef __arm__
+static int alt_dma = 1;
+#else
+static int alt_dma;
+#endif
+module_param(alt_dma, int, 0444);
+MODULE_PARM_DESC(alt_dma, "use alternative DMA buffer handling");
+
+static int no_init;
+module_param(no_init, int, 0444);
+MODULE_PARM_DESC(no_init, "do not initialize most devices");
+
+static int stv0910_single;
+module_param(stv0910_single, int, 0444);
+MODULE_PARM_DESC(stv0910_single, "use stv0910 cards as single demods");
+
 /****************************************************************************/
 
 static DEFINE_MUTEX(redirect_lock);
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 26497d6b1395..bde04dc39080 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -55,34 +55,6 @@ MODULE_PARM_DESC(msi, "Control MSI interrupts: 0-disable (default), 1-enable");
 #endif
 #endif
 
-int ci_bitrate = 70000;
-module_param(ci_bitrate, int, 0444);
-MODULE_PARM_DESC(ci_bitrate, " Bitrate in KHz for output to CI.");
-
-int ts_loop = -1;
-module_param(ts_loop, int, 0444);
-MODULE_PARM_DESC(ts_loop, "TS in/out test loop on port ts_loop");
-
-int xo2_speed = 2;
-module_param(xo2_speed, int, 0444);
-MODULE_PARM_DESC(xo2_speed, "default transfer speed for xo2 based duoflex, 0=55,1=75,2=90,3=104 MBit/s, default=2, use attribute to change for individual cards");
-
-#ifdef __arm__
-int alt_dma = 1;
-#else
-int alt_dma;
-#endif
-module_param(alt_dma, int, 0444);
-MODULE_PARM_DESC(alt_dma, "use alternative DMA buffer handling");
-
-int no_init;
-module_param(no_init, int, 0444);
-MODULE_PARM_DESC(no_init, "do not initialize most devices");
-
-int stv0910_single;
-module_param(stv0910_single, int, 0444);
-MODULE_PARM_DESC(stv0910_single, "use stv0910 cards as single demods");
-
 /****************************************************************************/
 /****************************************************************************/
 /****************************************************************************/
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index f223dc6c9963..e22e67d7e0fe 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -369,12 +369,6 @@ int ddbridge_flashread(struct ddb *dev, u32 link, u8 *buf, u32 addr, u32 len);
 /****************************************************************************/
 
 /* ddbridge-main.c (modparams) */
-extern int ci_bitrate;
-extern int ts_loop;
-extern int xo2_speed;
-extern int alt_dma;
-extern int no_init;
-extern int stv0910_single;
 extern struct workqueue_struct *ddb_wq;
 
 /* ddbridge-core.c */
-- 
2.16.1
