Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34488 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753185AbcIGRMD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 13:12:03 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] VPU: mediatek: fix null pointer dereference on pdev
Date: Wed,  7 Sep 2016 18:10:27 +0100
Message-Id: <20160907171027.16424-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

pdev is being null checked, however, prior to that it is being
dereferenced by platform_get_drvdata.  Move the assignments of
vpu and run to after the pdev null check to avoid a potential
null pointer dereference.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index c9bf58c..43907a3 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -523,9 +523,9 @@ static int load_requested_vpu(struct mtk_vpu *vpu,
 
 int vpu_load_firmware(struct platform_device *pdev)
 {
-	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+	struct mtk_vpu *vpu;
 	struct device *dev = &pdev->dev;
-	struct vpu_run *run = &vpu->run;
+	struct vpu_run *run;
 	const struct firmware *vpu_fw = NULL;
 	int ret;
 
@@ -534,6 +534,9 @@ int vpu_load_firmware(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	vpu = platform_get_drvdata(pdev);
+	run = &vpu->run;
+
 	mutex_lock(&vpu->vpu_mutex);
 	if (vpu->fw_loaded) {
 		mutex_unlock(&vpu->vpu_mutex);
-- 
2.9.3

