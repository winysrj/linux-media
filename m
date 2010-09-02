Return-path: <mchehab@localhost>
Received: from comal.ext.ti.com ([198.47.26.152]:36640 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab0IBOqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Sep 2010 10:46:32 -0400
From: raja_mani@ti.com
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	mchehab@infradead.org
Cc: matti.j.aaltonen@nokia.com, Raja Mani <raja_mani@ti.com>
Subject: [RFC/PATCH 8/8] drivers:staging:ti-st: Include FM TX module in Makefile
Date: Thu,  2 Sep 2010 11:58:00 -0400
Message-Id: <1283443080-30644-9-git-send-email-raja_mani@ti.com>
In-Reply-To: <1283443080-30644-8-git-send-email-raja_mani@ti.com>
References: <1283443080-30644-1-git-send-email-raja_mani@ti.com>
 <1283443080-30644-2-git-send-email-raja_mani@ti.com>
 <1283443080-30644-3-git-send-email-raja_mani@ti.com>
 <1283443080-30644-4-git-send-email-raja_mani@ti.com>
 <1283443080-30644-5-git-send-email-raja_mani@ti.com>
 <1283443080-30644-6-git-send-email-raja_mani@ti.com>
 <1283443080-30644-7-git-send-email-raja_mani@ti.com>
 <1283443080-30644-8-git-send-email-raja_mani@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

From: Raja Mani <raja_mani@ti.com>

 Update Makefile to include FM TX module (fmdrv_tx) for
 the compilation.

Signed-off-by: Raja Mani <raja_mani@ti.com>
---
 drivers/staging/ti-st/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ti-st/Makefile b/drivers/staging/ti-st/Makefile
index e6af3f1..bd29c83 100644
--- a/drivers/staging/ti-st/Makefile
+++ b/drivers/staging/ti-st/Makefile
@@ -6,4 +6,4 @@ obj-$(CONFIG_TI_ST) 		+= st_drv.o
 st_drv-objs			:= st_core.o st_kim.o st_ll.o
 obj-$(CONFIG_ST_BT) 		+= bt_drv.o
 obj-$(CONFIG_ST_FM) 		+= fm_drv.o
-fm_drv-objs     		:= fmdrv_common.o fmdrv_rx.o fmdrv_v4l2.o
+fm_drv-objs     		:= fmdrv_common.o fmdrv_rx.o fmdrv_tx.o fmdrv_v4l2.o
-- 
1.5.6.3

