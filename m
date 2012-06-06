Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2FFJ3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 05:29:09 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M56000SIVOCQOH0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jun 2012 18:29:07 +0900 (KST)
Received: from localhost.localdomain ([106.116.37.195])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M56008JQVOAVJ40@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jun 2012 18:29:07 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, jtp.park@samsung.com
Subject: [PATCH] s5p-mfc: Bug fix of timestamp/timecode copy mechanism
Date: Wed, 06 Jun 2012 11:28:53 +0200
Message-id: <1338974933-30962-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed the code copying timecode/timestamp to corresponding
frames between OUTPUT and CAPTURE.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-mfc/regs-mfc.h    |    5 +++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h |    4 +++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/regs-mfc.h b/drivers/media/video/s5p-mfc/regs-mfc.h
index 053a8a8..a19bece 100644
--- a/drivers/media/video/s5p-mfc/regs-mfc.h
+++ b/drivers/media/video/s5p-mfc/regs-mfc.h
@@ -164,10 +164,15 @@
 								decoded pic */
 #define S5P_FIMV_SI_DISPLAY_Y_ADR	0x2010 /* luma addr of displayed pic */
 #define S5P_FIMV_SI_DISPLAY_C_ADR	0x2014 /* chroma addrof displayed pic */
+
 #define S5P_FIMV_SI_CONSUMED_BYTES	0x2018 /* Consumed number of bytes to
 							decode a frame */
 #define S5P_FIMV_SI_DISPLAY_STATUS	0x201c /* status of decoded picture */
 
+#define S5P_FIMV_SI_DECODE_Y_ADR	0x2024 /* luma addr of decoded pic */
+#define S5P_FIMV_SI_DECODE_C_ADR	0x2028 /* chroma addrof decoded pic */
+#define S5P_FIMV_SI_DECODE_STATUS	0x202c /* status of decoded picture */
+
 #define S5P_FIMV_SI_CH0_SB_ST_ADR	0x2044 /* start addr of stream buf */
 #define S5P_FIMV_SI_CH0_SB_FRM_SIZE	0x2048 /* size of stream buf */
 #define S5P_FIMV_SI_CH0_DESC_ADR	0x204c /* addr of descriptor buf */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
index db83836..5932d1c 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
@@ -57,10 +57,12 @@ void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
 					S5P_FIMV_SI_DISPLAY_Y_ADR) << \
 					MFC_OFFSET_SHIFT)
 #define s5p_mfc_get_dec_y_adr()		(readl(dev->regs_base + \
-					S5P_FIMV_SI_DISPLAY_Y_ADR) << \
+					S5P_FIMV_SI_DECODE_Y_ADR) << \
 					MFC_OFFSET_SHIFT)
 #define s5p_mfc_get_dspl_status()	readl(dev->regs_base + \
 						S5P_FIMV_SI_DISPLAY_STATUS)
+#define s5p_mfc_get_dec_status()	readl(dev->regs_base + \
+						S5P_FIMV_SI_DECODE_STATUS)
 #define s5p_mfc_get_frame_type()	(readl(dev->regs_base + \
 						S5P_FIMV_DECODE_FRAME_TYPE) \
 					& S5P_FIMV_DECODE_FRAME_MASK)
-- 
1.7.0.4

