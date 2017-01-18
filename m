Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:60674 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbdARJmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 04:42:15 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [PATCH] [media] s5p-mfc: Align stream buffer and CPB buffer to 512
Date: Wed, 18 Jan 2017 15:07:03 +0530
Message-id: <1484732223-24670-1-git-send-email-smitha.t@samsung.com>
References: <CGME20170118094212epcas5p22e588016d2b330dcd0b99b6e1012c744@epcas5p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From MFCv6 onwards encoder stream buffer and decoder CPB buffer
need to be aligned with 512.

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    9 +++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |    3 +++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index d6f207e..57da798 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -408,8 +408,15 @@ static int s5p_mfc_set_dec_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 	struct s5p_mfc_dev *dev = ctx->dev;
 	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	struct s5p_mfc_buf_size *buf_size = dev->variant->buf_size;
+	size_t cpb_buf_size;
 
 	mfc_debug_enter();
+	cpb_buf_size = ALIGN(buf_size->cpb, CPB_ALIGN);
+	if (strm_size >= set_strm_size_max(cpb_buf_size)) {
+		mfc_debug(2, "Decrease strm_size : %u -> %zu, gap : %d\n",
+			strm_size, set_strm_size_max(cpb_buf_size), CPB_ALIGN);
+		strm_size = set_strm_size_max(cpb_buf_size);
+	}
 	mfc_debug(2, "inst_no: %d, buf_addr: 0x%08x,\n"
 		"buf_size: 0x%08x (%d)\n",
 		ctx->inst_no, buf_addr, strm_size, strm_size);
@@ -519,6 +526,8 @@ static int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 	struct s5p_mfc_dev *dev = ctx->dev;
 	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
+	size = ALIGN(size, 512);
+
 	writel(addr, mfc_regs->e_stream_buffer_addr); /* 16B align */
 	writel(size, mfc_regs->e_stream_buffer_size);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
index 8055848..16a7b1d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
@@ -40,6 +40,9 @@
 #define FRAME_DELTA_H264_H263		1
 #define TIGHT_CBR_MAX			10
 
+#define CPB_ALIGN			512
+#define set_strm_size_max(cpb_max)	((cpb_max) - CPB_ALIGN)
+
 struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v6(void);
 const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev);
 #endif /* S5P_MFC_OPR_V6_H_ */
-- 
1.7.2.3

