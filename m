Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61298 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2BMOkQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 09:40:16 -0500
Received: by wgbdt10 with SMTP id dt10so4969260wgb.1
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 06:40:15 -0800 (PST)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 5/6] media: i.MX27 camera: fix compilation warning.
Date: Mon, 13 Feb 2012 15:40:01 +0100
Message-Id: <1329144001-7902-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index d9028f1..06017a0 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1210,7 +1210,9 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
 static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		int bufnum, bool err)
 {
+#ifdef DEBUG
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
+#endif
 	struct mx2_buffer *buf;
 	struct vb2_buffer *vb;
 	unsigned long phys;
@@ -1232,18 +1234,16 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		if (prp->cfg.channel == 1) {
 			if (readl(pcdev->base_emma + PRP_DEST_RGB1_PTR +
 				4 * bufnum) != phys) {
-				dev_err(pcdev->dev, "%p != %p\n", phys,
-						readl(pcdev->base_emma +
-							PRP_DEST_RGB1_PTR +
-							4 * bufnum));
+				dev_err(pcdev->dev, "%lx != %x\n", phys,
+					readl(pcdev->base_emma +
+					PRP_DEST_RGB1_PTR + 4 * bufnum));
 			}
 		} else {
 			if (readl(pcdev->base_emma + PRP_DEST_Y_PTR -
 				0x14 * bufnum) != phys) {
-				dev_err(pcdev->dev, "%p != %p\n", phys,
-						readl(pcdev->base_emma +
-							PRP_DEST_Y_PTR -
-							0x14 * bufnum));
+				dev_err(pcdev->dev, "%lx != %x\n", phys,
+					readl(pcdev->base_emma +
+					PRP_DEST_Y_PTR - 0x14 * bufnum));
 			}
 		}
 #endif
-- 
1.7.0.4

