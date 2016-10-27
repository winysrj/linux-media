Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpoutz27.laposte.net ([194.117.213.102]:49099 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S942325AbcJ0Up1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 16:45:27 -0400
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout015 (Postfix) with ESMTP id A22FC1C8B99
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 22:23:44 +0200 (CEST)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout015 (Postfix) with ESMTP id 941601C8BE8
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 22:23:44 +0200 (CEST)
Received: from lpn-prd-vrin001 (lpn-prd-vrin001.laposte [10.128.63.2])
        by lpn-prd-vrout015 (Postfix) with ESMTP id 8E9651C8B99
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 22:23:44 +0200 (CEST)
Received: from lpn-prd-vrin001 (localhost [127.0.0.1])
        by lpn-prd-vrin001 (Postfix) with ESMTP id 79AFE366DBA
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 22:23:44 +0200 (CEST)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH next 2/2] media: mtk-mdp: NULL-terminate mtk_mdp_comp_dt_ids
Date: Thu, 27 Oct 2016 22:23:25 +0200
Message-Id: <20161027202325.20680-2-vincent.stehle@laposte.net>
In-Reply-To: <20161027202325.20680-1-vincent.stehle@laposte.net>
References: <1473340146-6598-4-git-send-email-minghsiu.tsai@mediatek.com>
 <20161027202325.20680-1-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mtk_mdp_comp_dt_ids[] array should be NULL-terminated; add therefore an
empty entry in the end.

Fixes: c8eb2d7e8202fd9c ("[media] media: Add Mediatek MDP Driver")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
index 40a229d..53296e2 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
@@ -50,7 +50,8 @@ static const struct of_device_id mtk_mdp_comp_dt_ids[] = {
 	}, {
 		.compatible = "mediatek,mt8173-mdp-wrot",
 		.data = (void *)MTK_MDP_WROT
-	}
+	},
+	{ },
 };
 
 static const struct of_device_id mtk_mdp_of_ids[] = {
-- 
2.9.3

