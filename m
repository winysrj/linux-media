Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1DCXv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 19:51:28 -0400
Received: by iyb14 with SMTP id 14so5394290iyb.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 16:51:28 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, s.nawrocki@samsung.com,
	g.liakhovetski@gmx.de, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 4/5] [media] sh_mobile_ceu_camera: remove stop_streaming() callback return
Date: Sun,  3 Apr 2011 16:51:09 -0700
Message-Id: <1301874670-14833-5-git-send-email-pawel@osciak.com>
In-Reply-To: <1301874670-14833-1-git-send-email-pawel@osciak.com>
References: <1301874670-14833-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The stop_streaming() callback does not return a value anymore.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 3fb8f4c..28df50d 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -427,7 +427,7 @@ static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
+static void sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
 {
 	struct soc_camera_device *icd = container_of(q, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
@@ -444,7 +444,7 @@ static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
 
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 
-	return sh_mobile_ceu_soft_reset(pcdev);
+	sh_mobile_ceu_soft_reset(pcdev);
 }
 
 static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
-- 
1.7.4.2

