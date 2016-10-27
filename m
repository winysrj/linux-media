Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpoutz25.laposte.net ([194.117.213.100]:59140 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S942040AbcJ0UpX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 16:45:23 -0400
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout013 (Postfix) with ESMTP id CCEBE1046CE
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 22:23:40 +0200 (CEST)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout013 (Postfix) with ESMTP id C02501046D4
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 22:23:40 +0200 (CEST)
Received: from lpn-prd-vrin003 (lpn-prd-vrin003.prosodie [10.128.63.4])
        by lpn-prd-vrout013 (Postfix) with ESMTP id BC6321046CE
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 22:23:40 +0200 (CEST)
Received: from lpn-prd-vrin003 (localhost [127.0.0.1])
        by lpn-prd-vrin003 (Postfix) with ESMTP id A5A5648E0E7
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 22:23:40 +0200 (CEST)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH next 1/2] media: mtk-mdp: fix video_device_release argument
Date: Thu, 27 Oct 2016 22:23:24 +0200
Message-Id: <20161027202325.20680-1-vincent.stehle@laposte.net>
In-Reply-To: <1473340146-6598-4-git-send-email-minghsiu.tsai@mediatek.com>
References: <1473340146-6598-4-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

video_device_release() takes a pointer to struct video_device as argument.
Fix two call sites where the address of the pointer is passed instead.

Fixes: c8eb2d7e8202fd9c ("[media] media: Add Mediatek MDP Driver")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 9a747e7..4a9e3e9d 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -1267,13 +1267,13 @@ int mtk_mdp_register_m2m_device(struct mtk_mdp_dev *mdp)
 err_vdev_register:
 	v4l2_m2m_release(mdp->m2m_dev);
 err_m2m_init:
-	video_device_release(&mdp->vdev);
+	video_device_release(mdp->vdev);
 
 	return ret;
 }
 
 void mtk_mdp_unregister_m2m_device(struct mtk_mdp_dev *mdp)
 {
-	video_device_release(&mdp->vdev);
+	video_device_release(mdp->vdev);
 	v4l2_m2m_release(mdp->m2m_dev);
 }
-- 
2.9.3

