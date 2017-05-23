Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:12878 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933565AbdEWDYT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 23:24:19 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>
CC: <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: [PATCH v4 3/3] media: mtk-mdp: Fix mdp device tree
Date: Tue, 23 May 2017 11:24:11 +0800
Message-ID: <1495509851-29159-4-git-send-email-minghsiu.tsai@mediatek.com>
In-Reply-To: <1495509851-29159-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1495509851-29159-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Kurtz <djkurtz@chromium.org>

If the mdp_* nodes are under an mdp sub-node, their corresponding
platform device does not automatically get its iommu assigned properly.

Fix this by moving the mdp component nodes up a level such that they are
siblings of mdp and all other SoC subsystems.  This also simplifies the
device tree.

Although it fixes iommu assignment issue, it also break compatibility
with old device tree. So, the patch in driver is needed to iterate over
sibling mdp device nodes, not child ones, to keep driver work properly.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

---
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
index 9e4eb7d..8134755 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
@@ -103,7 +103,7 @@ static int mtk_mdp_probe(struct platform_device *pdev)
 {
 	struct mtk_mdp_dev *mdp;
 	struct device *dev = &pdev->dev;
-	struct device_node *node;
+	struct device_node *node, *parent;
 	int i, ret = 0;
 
 	mdp = devm_kzalloc(dev, sizeof(*mdp), GFP_KERNEL);
@@ -117,8 +117,16 @@ static int mtk_mdp_probe(struct platform_device *pdev)
 	mutex_init(&mdp->lock);
 	mutex_init(&mdp->vpulock);
 
+	/* Old dts had the components as child nodes */
+	if (of_get_next_child(dev->of_node, NULL)) {
+		parent = dev->of_node;
+		dev_warn(dev, "device tree is out of date\n");
+	} else {
+		parent = dev->of_node->parent;
+	}
+
 	/* Iterate over sibling MDP function blocks */
-	for_each_child_of_node(dev->of_node, node) {
+	for_each_child_of_node(parent, node) {
 		const struct of_device_id *of_id;
 		enum mtk_mdp_comp_type comp_type;
 		int comp_id;
-- 
1.9.1
