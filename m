Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:33992 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3BZNIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 08:08:09 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MIT00E96WH5RO70@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Feb 2013 22:08:08 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	arun.kk@samsung.com, arun.m@samsung.com
Subject: [PATCH] [media] s5p-mfc: Fix frame skip bug
Date: Wed, 27 Feb 2013 03:32:11 +0530
Message-id: <1361916131-1717-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The issue was seen in VP8 decoding where the last frame was
skipped by the driver. This patch gets the correct frame_type value
to fix this bug.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index ac69e9b..64c55cf 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -276,7 +276,7 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 	unsigned int frame_type;
 
 	dspl_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_y_adr, dev);
-	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_dec_frame_type, dev);
+	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_disp_frame_type, ctx);
 
 	/* If frame is same as previous then skip and do not dequeue */
 	if (frame_type == S5P_FIMV_DECODE_FRAME_SKIPPED) {
-- 
1.7.9.5

