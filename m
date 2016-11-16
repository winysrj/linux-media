Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52408 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbcKPTRF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 14:17:05 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] VPU: mediatek: fix dereference of pdev before checking it is null
Date: Wed, 16 Nov 2016 19:16:50 +0000
Message-Id: <20161116191650.11486-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

pdev is dereferenced using platform_get_drvdata before a check to
see if it is null, hence there could be a potential null pointer
dereference issue. Instead, first check if pdev is null and only then
deference pdev when initializing vpu.

Found with static analysis by CoverityScan, CID 1357797

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index c9bf58c..41f31b2 100644
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
 
@@ -533,6 +533,8 @@ int vpu_load_firmware(struct platform_device *pdev)
 		dev_err(dev, "VPU platform device is invalid\n");
 		return -EINVAL;
 	}
+	vpu = platform_get_drvdata(pdev);
+	run = &vpu->run;
 
 	mutex_lock(&vpu->vpu_mutex);
 	if (vpu->fw_loaded) {
-- 
2.10.2

