Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:22606 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaHNCPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Aug 2014 22:15:32 -0400
From: Zhaowei Yuan <zhaowei.yuan@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org
Subject: [PATCH] media: s5p-mfc: correct improper logs
Date: Thu, 14 Aug 2014 10:11:47 +0800
Message-id: <1407982307-3132-1-git-send-email-zhaowei.yuan@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch corrects improper logs within the code initializing hardware.

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 6c3f8f7..4976292 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -282,9 +282,9 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 		s5p_mfc_clock_off();
 		return ret;
 	}
-	mfc_debug(2, "Ok, now will write a command to init the system\n");
+	mfc_debug(2, "Ok, now will wait for completion of hardware init\n");
 	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_SYS_INIT_RET)) {
-		mfc_err("Failed to load firmware\n");
+		mfc_err("Failed to init hardware\n");
 		s5p_mfc_reset(dev);
 		s5p_mfc_clock_off();
 		return -EIO;
--
1.7.9.5

