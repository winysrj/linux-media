Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44165 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 21/35] [media] s5p_mfc_ctrl: add missing s5p_mfc_ctrl.h header
Date: Tue, 26 Aug 2014 18:54:57 -0300
Message-Id: <1409090111-8290-22-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That gets rid of the following warnings:

drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:119:5: warning: no previous prototype for 's5p_mfc_release_firmware' [-Wmissing-prototypes]
 int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
     ^
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:132:5: warning: no previous prototype for 's5p_mfc_reset' [-Wmissing-prototypes]
 int s5p_mfc_reset(struct s5p_mfc_dev *dev)
     ^
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:214:5: warning: no previous prototype for 's5p_mfc_init_hw' [-Wmissing-prototypes]
 int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
     ^
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:291:6: warning: no previous prototype for 's5p_mfc_deinit_hw' [-Wmissing-prototypes]
 void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev)
      ^
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:301:5: warning: no previous prototype for 's5p_mfc_sleep' [-Wmissing-prototypes]
 int s5p_mfc_sleep(struct s5p_mfc_dev *dev)
     ^
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:330:5: warning: no previous prototype for 's5p_mfc_wakeup' [-Wmissing-prototypes]
 int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
     ^
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:378:5: warning: no previous prototype for 's5p_mfc_open_mfc_inst' [-Wmissing-prototypes]
 int s5p_mfc_open_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
     ^
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:420:6: warning: no previous prototype for 's5p_mfc_close_mfc_inst' [-Wmissing-prototypes]
 void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
      ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index ca9f78922832..5289b8696c1e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -21,6 +21,7 @@
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
+#include "s5p_mfc_ctrl.h"
 
 /* Allocate memory for firmware */
 int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
-- 
1.9.3

