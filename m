Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:23545 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751572AbcGVIdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 04:33:17 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: <srv_heupstream@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>,
	Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: [PATCH v2 1/4] VPU: mediatek: Add mdp support
Date: Fri, 22 Jul 2016 16:33:00 +0800
Message-ID: <1469176383-35210-2-git-send-email-minghsiu.tsai@mediatek.com>
In-Reply-To: <1469176383-35210-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1469176383-35210-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VPU driver add mdp support

Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.h b/drivers/media/platform/mtk-vpu/mtk_vpu.h
index f457479..291ae46 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.h
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.h
@@ -53,6 +53,8 @@ typedef void (*ipi_handler_t) (void *data,
 			 handle H264 video encoder job, and vice versa.
  * @IPI_VENC_VP8:	 The interrupt fro vpu is to notify kernel to
 			 handle VP8 video encoder job,, and vice versa.
+ * @IPI_MDP:		 The interrupt from vpu is to notify kernel to
+			 handle MDP (Media Data Path) job, and vice versa.
  * @IPI_MAX:		 The maximum IPI number
  */
 
@@ -63,6 +65,7 @@ enum ipi_id {
 	IPI_VDEC_VP9,
 	IPI_VENC_H264,
 	IPI_VENC_VP8,
+	IPI_MDP,
 	IPI_MAX,
 };
 
@@ -71,11 +74,13 @@ enum ipi_id {
  *
  * @VPU_RST_ENC: encoder reset id
  * @VPU_RST_DEC: decoder reset id
+ * @VPU_RST_MDP: MDP (Media Data Path) reset id
  * @VPU_RST_MAX: maximum reset id
  */
 enum rst_id {
 	VPU_RST_ENC,
 	VPU_RST_DEC,
+	VPU_RST_MDP,
 	VPU_RST_MAX,
 };
 
-- 
1.7.9.5

