Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:52841 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2KEIyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 03:54:44 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MD000EJ7BE41JV0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Nov 2012 17:54:43 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MD00050FBDGGJD0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Nov 2012 17:54:43 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, jtp.park@samsung.com,
	sunilm@samsung.com, arun.kk@samsung.com, joshi@samsung.com
Subject: [PATCH] [media] s5p-mfc: Bug fix of timestamp/timecode copy mechanism
Date: Mon, 05 Nov 2012 14:44:03 +0530
Message-id: <1352106843-1765-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modified the function s5p_mfc_get_dec_y_adr_v6 to access the
decode Y address register instead of display Y address.

Signed-off-by: Sunil Mazhavanchery <sunilm@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 50b5bee..3a8cfd9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1762,7 +1762,7 @@ int s5p_mfc_get_dspl_y_adr_v6(struct s5p_mfc_dev *dev)
 
 int s5p_mfc_get_dec_y_adr_v6(struct s5p_mfc_dev *dev)
 {
-	return mfc_read(dev, S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6);
+	return mfc_read(dev, S5P_FIMV_D_DECODED_LUMA_ADDR_V6);
 }
 
 int s5p_mfc_get_dspl_status_v6(struct s5p_mfc_dev *dev)
-- 
1.7.0.4

