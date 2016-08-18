Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33641 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754416AbcHSDiR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:38:17 -0400
From: Colin King <colin.king@canonical.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] pxa_camera: fix spelling mistake: "dequeud" -> "dequeued"
Date: Thu, 18 Aug 2016 16:54:57 +0100
Message-Id: <1471535697-15780-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in pr_debug message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 2aaf4a8..82c7be4 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -636,7 +636,7 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 	v4l2_get_timestamp(&vb->ts);
 	vb->field_count++;
 	wake_up(&vb->done);
-	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s dequeud buffer (vb=0x%p)\n",
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s dequeued buffer (vb=0x%p)\n",
 		__func__, vb);
 
 	if (list_empty(&pcdev->capture)) {
-- 
2.8.1

