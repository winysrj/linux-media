Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:21551 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab2FZIBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 04:01:31 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6700MKBSXRS280@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 17:01:21 +0900 (KST)
Received: from localhost.localdomain ([106.116.147.39])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M6700KCESY1W010@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 17:01:20 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com, ch.naveen@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-mfc: Fixed setup of custom controls in decoder and encoder
Date: Tue, 26 Jun 2012 10:01:07 +0200
Message-id: <1340697667-24441-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed bugs in functions that initialize custom controls.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index 4dd32fc..feea867 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -996,6 +996,7 @@ int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx)
 
 	for (i = 0; i < NUM_CTRLS; i++) {
 		if (IS_MFC51_PRIV(controls[i].id)) {
+			memset(&cfg, 0, sizeof(struct v4l2_ctrl_config));
 			cfg.ops = &s5p_mfc_dec_ctrl_ops;
 			cfg.id = controls[i].id;
 			cfg.min = controls[i].minimum;
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index acedb20..8f7bbd1 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1777,6 +1777,7 @@ int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx)
 	}
 	for (i = 0; i < NUM_CTRLS; i++) {
 		if (IS_MFC51_PRIV(controls[i].id)) {
+			memset(&cfg, 0, sizeof(struct v4l2_ctrl_config));
 			cfg.ops = &s5p_mfc_enc_ctrl_ops;
 			cfg.id = controls[i].id;
 			cfg.min = controls[i].minimum;
-- 
1.7.0.4

