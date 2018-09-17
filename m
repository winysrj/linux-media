Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36272 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbeIQTYX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 15:24:23 -0400
Date: Mon, 17 Sep 2018 16:56:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Cc: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] VPU: mediatek: don't pass an unused parameter
Message-ID: <20180917135622.GA23073@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The load_requested_vpu() function returns a freed vpu_fw pointer.  It's
not used so it doesn't cause any problems, but Smatch complains about
it:

    drivers/media/platform/mtk-vpu/mtk_vpu.c:578 vpu_load_firmware()
    warn: passing freed memory 'vpu_fw'

We can clean up the code a bit and silence the static checker warning
by not passing the parameter at all.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index f8d35e3ac1dc..616f78b24a79 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -480,12 +480,12 @@ EXPORT_SYMBOL_GPL(vpu_get_plat_device);
 
 /* load vpu program/data memory */
 static int load_requested_vpu(struct mtk_vpu *vpu,
-			      const struct firmware *vpu_fw,
 			      u8 fw_type)
 {
 	size_t tcm_size = fw_type ? VPU_DTCM_SIZE : VPU_PTCM_SIZE;
 	size_t fw_size = fw_type ? VPU_D_FW_SIZE : VPU_P_FW_SIZE;
 	char *fw_name = fw_type ? VPU_D_FW : VPU_P_FW;
+	const struct firmware *vpu_fw;
 	size_t dl_size = 0;
 	size_t extra_fw_size = 0;
 	void *dest;
@@ -539,7 +539,6 @@ int vpu_load_firmware(struct platform_device *pdev)
 	struct mtk_vpu *vpu;
 	struct device *dev = &pdev->dev;
 	struct vpu_run *run;
-	const struct firmware *vpu_fw = NULL;
 	int ret;
 
 	if (!pdev) {
@@ -568,14 +567,14 @@ int vpu_load_firmware(struct platform_device *pdev)
 	run->signaled = false;
 	dev_dbg(vpu->dev, "firmware request\n");
 	/* Downloading program firmware to device*/
-	ret = load_requested_vpu(vpu, vpu_fw, P_FW);
+	ret = load_requested_vpu(vpu, P_FW);
 	if (ret < 0) {
 		dev_err(dev, "Failed to request %s, %d\n", VPU_P_FW, ret);
 		goto OUT_LOAD_FW;
 	}
 
 	/* Downloading data firmware to device */
-	ret = load_requested_vpu(vpu, vpu_fw, D_FW);
+	ret = load_requested_vpu(vpu, D_FW);
 	if (ret < 0) {
 		dev_err(dev, "Failed to request %s, %d\n", VPU_D_FW, ret);
 		goto OUT_LOAD_FW;
