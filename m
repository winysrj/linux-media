Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37753 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1DCXva (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 19:51:30 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so5256601iwn.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 16:51:29 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, s.nawrocki@samsung.com,
	g.liakhovetski@gmx.de, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 5/5] [media] mx3_camera: remove stop_streaming() callback return
Date: Sun,  3 Apr 2011 16:51:10 -0700
Message-Id: <1301874670-14833-6-git-send-email-pawel@osciak.com>
In-Reply-To: <1301874670-14833-1-git-send-email-pawel@osciak.com>
References: <1301874670-14833-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The stop_streaming() callback does not return a value anymore.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/mx3_camera.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 8630c0c..1703b93 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -400,7 +400,7 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int mx3_stop_streaming(struct vb2_queue *q)
+static void mx3_stop_streaming(struct vb2_queue *q)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
@@ -425,8 +425,6 @@ static int mx3_stop_streaming(struct vb2_queue *q)
 	}
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
-
-	return 0;
 }
 
 static struct vb2_ops mx3_videobuf_ops = {
-- 
1.7.4.2

