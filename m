Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:51545 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751914AbcISIAj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 04:00:39 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] mtk-mdp: fix double mutex_unlock
Message-ID: <5125bca3-0dfa-2e56-d44f-d771af0b9ca8@xs4all.nl>
Date: Mon, 19 Sep 2016 10:00:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix smatch error:

media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:100 mtk_mdp_vpu_send_msg() error: double unlock 'mutex:&ctx->mdp_dev->vpulock'

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
index 39188e5..4893825 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
@@ -92,11 +92,9 @@ static int mtk_mdp_vpu_send_msg(void *msg, int len, struct mtk_mdp_vpu *vpu,

 	mutex_lock(&ctx->mdp_dev->vpulock);
 	err = vpu_ipi_send(vpu->pdev, (enum ipi_id)id, msg, len);
-	if (err) {
-		mutex_unlock(&ctx->mdp_dev->vpulock);
+	if (err)
 		dev_err(&ctx->mdp_dev->pdev->dev,
 			"vpu_ipi_send fail status %d\n", err);
-	}
 	mutex_unlock(&ctx->mdp_dev->vpulock);

 	return err;

