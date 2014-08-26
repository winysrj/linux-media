Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 13/35] [media] dm644x_ccdc: use unsigned long for fpc_table_addr
Date: Tue, 26 Aug 2014 18:54:49 -0300
Message-Id: <1409090111-8290-14-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fpc_table_addr is used as an unsigned integer that stores
an address. At the Kernel, the proper type for such integers
is unsigned long.

This generates lots of warnings when compiling on 64 bits.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/davinci/dm644x_ccdc.c | 4 ++--
 include/media/davinci/dm644x_ccdc.h          | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index b0b9cd54e9e9..62a0ebb01056 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -291,7 +291,7 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
 		dev_dbg(ccdc_cfg.dev, "\n copy_from_user failed");
 		return -EFAULT;
 	}
-	config_params->fault_pxl.fpc_table_addr = (unsigned int)fpc_physaddr;
+	config_params->fault_pxl.fpc_table_addr = (unsigned long)fpc_physaddr;
 	return 0;
 }
 
@@ -506,7 +506,7 @@ static void ccdc_config_fpc(struct ccdc_fault_pixel *fpc)
 
 	/* Configure Fault pixel if needed */
 	regw(fpc->fpc_table_addr, CCDC_FPC_ADDR);
-	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to FPC_ADDR...\n",
+	dev_dbg(ccdc_cfg.dev, "\nWriting 0x%lx to FPC_ADDR...\n",
 		       (fpc->fpc_table_addr));
 	/* Write the FPC params with FPC disable */
 	val = fpc->fp_num & CCDC_FPC_FPC_NUM_MASK;
diff --git a/include/media/davinci/dm644x_ccdc.h b/include/media/davinci/dm644x_ccdc.h
index 852e96c4bb46..984fb79031de 100644
--- a/include/media/davinci/dm644x_ccdc.h
+++ b/include/media/davinci/dm644x_ccdc.h
@@ -114,7 +114,7 @@ struct ccdc_fault_pixel {
 	/* Number of fault pixel */
 	unsigned short fp_num;
 	/* Address of fault pixel table */
-	unsigned int fpc_table_addr;
+	unsigned long fpc_table_addr;
 };
 
 /* Structure for CCDC configuration parameters for raw capture mode passed
-- 
1.9.3

