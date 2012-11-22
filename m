Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:28872 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab2KVUKs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 15:10:48 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDW00HHP6WVSPW0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 23:00:37 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDW001S06WVPK50@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 23:00:37 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-mfc: Context handling in open() bugfix
Date: Thu, 22 Nov 2012 15:00:28 +0100
Message-id: <1353592828-13597-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d5182d6..31eeb03 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -856,16 +856,16 @@ err_queue_init:
 		s5p_mfc_deinit_hw(dev);
 err_init_hw:
 err_load_fw:
-	dev->ctx[ctx->num] = NULL;
-	del_timer_sync(&dev->watchdog_timer);
 err_pwr_enable:
 	if (dev->num_inst == 1) {
 		if (s5p_mfc_power_off() < 0)
 			mfc_err("power off failed\n");
+		del_timer_sync(&dev->watchdog_timer);
 	}
 err_ctrls_setup:
 	s5p_mfc_dec_ctrls_delete(ctx);
 err_bad_node:
+	dev->ctx[ctx->num] = NULL;
 err_no_ctx:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-- 
1.7.9.5

