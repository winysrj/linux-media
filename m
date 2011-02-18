Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:51963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1BRINf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 03:13:35 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id BB48A189B7F
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 09:13:33 +0100 (CET)
Date: Fri, 18 Feb 2011 09:13:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] V4L: soc-camera: add helper functions for videobuf queue
 handling
In-Reply-To: <Pine.LNX.4.64.1102180857360.1851@axis700.grange>
Message-ID: <Pine.LNX.4.64.1102180905220.1851@axis700.grange>
References: <Pine.LNX.4.64.1102180857360.1851@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add two helper inline functions to retrieve soc-camera device context
from videobuf and videobuf2 queue pointers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This patch shall go in before sh-mobile-ceu conversion to vb2. It is 
already in my vb2 branch on git.linuxtv.org.

 include/media/soc_camera.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 9f10921..8aec72d 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -305,6 +305,16 @@ static inline struct video_device *soc_camera_i2c_to_vdev(struct i2c_client *cli
 	return icd->vdev;
 }
 
+static inline struct soc_camera_device *soc_camera_from_vb2q(struct vb2_queue *vq)
+{
+	return container_of(vq, struct soc_camera_device, vb2_vidq);
+}
+
+static inline struct soc_camera_device *soc_camera_from_vbq(struct videobuf_queue *vq)
+{
+	return container_of(vq, struct soc_camera_device, vb_vidq);
+}
+
 void soc_camera_lock(struct vb2_queue *vq);
 void soc_camera_unlock(struct vb2_queue *vq);
 
-- 
1.7.2.3

