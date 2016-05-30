Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:8403 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754782AbcE3M3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2016 08:29:30 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	<Tiffany.lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v3 1/9] VPU: mediatek: Add decode support
Date: Mon, 30 May 2016 20:29:15 +0800
Message-ID: <1464611363-14936-2-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>

VPU driver add decode support

Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c |   12 ++++++++++++
 drivers/media/platform/mtk-vpu/mtk_vpu.h |   27 +++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index b60d02c..ca23b1f 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -134,6 +134,8 @@ struct vpu_wdt {
  *
  * @signaled:		the signal of vpu initialization completed
  * @fw_ver:		VPU firmware version
+ * @dec_capability:	decoder capability which is not used for now and
+ *			the value is reserved for future use
  * @enc_capability:	encoder capability which is not used for now and
  *			the value is reserved for future use
  * @wq:			wait queue for VPU initialization status
@@ -141,6 +143,7 @@ struct vpu_wdt {
 struct vpu_run {
 	u32 signaled;
 	char fw_ver[VPU_FW_VER_LEN];
+	unsigned int	dec_capability;
 	unsigned int	enc_capability;
 	wait_queue_head_t wq;
 };
@@ -415,6 +418,14 @@ int vpu_wdt_reg_handler(struct platform_device *pdev,
 }
 EXPORT_SYMBOL_GPL(vpu_wdt_reg_handler);
 
+unsigned int vpu_get_vdec_hw_capa(struct platform_device *pdev)
+{
+	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+
+	return vpu->run.dec_capability;
+}
+EXPORT_SYMBOL_GPL(vpu_get_vdec_hw_capa);
+
 unsigned int vpu_get_venc_hw_capa(struct platform_device *pdev)
 {
 	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
@@ -600,6 +611,7 @@ static void vpu_init_ipi_handler(void *data, unsigned int len, void *priv)
 
 	vpu->run.signaled = run->signaled;
 	strncpy(vpu->run.fw_ver, run->fw_ver, VPU_FW_VER_LEN);
+	vpu->run.dec_capability = run->dec_capability;
 	vpu->run.enc_capability = run->enc_capability;
 	wake_up_interruptible(&vpu->run.wq);
 }
diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.h b/drivers/media/platform/mtk-vpu/mtk_vpu.h
index 5ab37f0..f457479 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.h
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.h
@@ -37,6 +37,18 @@ typedef void (*ipi_handler_t) (void *data,
 			 command to VPU.
 			 For other IPI below, AP should send the request
 			 to VPU to trigger the interrupt.
+ * @IPI_VDEC_H264:	 The interrupt from vpu is to notify kernel to
+			 handle H264 vidoe decoder job, and vice versa.
+			 Decode output format is always MT21 no matter what
+			 the input format is.
+ * @IPI_VDEC_VP8:	 The interrupt from is to notify kernel to
+			 handle VP8 video decoder job, and vice versa.
+			 Decode output format is always MT21 no matter what
+			 the input format is.
+ * @IPI_VDEC_VP9:	 The interrupt from vpu is to notify kernel to
+			 handle VP9 video decoder job, and vice versa.
+			 Decode output format is always MT21 no matter what
+			 the input format is.
  * @IPI_VENC_H264:	 The interrupt from vpu is to notify kernel to
 			 handle H264 video encoder job, and vice versa.
  * @IPI_VENC_VP8:	 The interrupt fro vpu is to notify kernel to
@@ -46,6 +58,9 @@ typedef void (*ipi_handler_t) (void *data,
 
 enum ipi_id {
 	IPI_VPU_INIT = 0,
+	IPI_VDEC_H264,
+	IPI_VDEC_VP8,
+	IPI_VDEC_VP9,
 	IPI_VENC_H264,
 	IPI_VENC_VP8,
 	IPI_MAX,
@@ -55,10 +70,12 @@ enum ipi_id {
  * enum rst_id - reset id to register reset function for VPU watchdog timeout
  *
  * @VPU_RST_ENC: encoder reset id
+ * @VPU_RST_DEC: decoder reset id
  * @VPU_RST_MAX: maximum reset id
  */
 enum rst_id {
 	VPU_RST_ENC,
+	VPU_RST_DEC,
 	VPU_RST_MAX,
 };
 
@@ -125,6 +142,16 @@ struct platform_device *vpu_get_plat_device(struct platform_device *pdev);
 int vpu_wdt_reg_handler(struct platform_device *pdev,
 			void vpu_wdt_reset_func(void *),
 			void *priv, enum rst_id id);
+
+/**
+ * vpu_get_vdec_hw_capa - get video decoder hardware capability
+ *
+ * @pdev:	VPU platform device
+ *
+ * Return: video decoder hardware capability
+ **/
+unsigned int vpu_get_vdec_hw_capa(struct platform_device *pdev);
+
 /**
  * vpu_get_venc_hw_capa - get video encoder hardware capability
  *
-- 
1.7.9.5

