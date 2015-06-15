Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59091 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbbFOLlD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:41:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/14] soc_camera: always release queue for queue owner
Date: Mon, 15 Jun 2015 13:33:40 +0200
Message-Id: <1434368021-7467-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Always release the queue if the owner closes its filehandle and not when
it is the last open filehandle.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 0b09281..9087fed 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -788,20 +788,21 @@ static int soc_camera_close(struct file *file)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	mutex_lock(&ici->host_lock);
+	if (icd->streamer == file) {
+		if (ici->ops->init_videobuf2)
+			vb2_queue_release(&icd->vb2_vidq);
+		icd->streamer = NULL;
+	}
 	icd->use_count--;
 	if (!icd->use_count) {
 		pm_runtime_suspend(&icd->vdev->dev);
 		pm_runtime_disable(&icd->vdev->dev);
 
-		if (ici->ops->init_videobuf2)
-			vb2_queue_release(&icd->vb2_vidq);
 		__soc_camera_power_off(icd);
 
 		soc_camera_remove_device(icd);
 	}
 
-	if (icd->streamer == file)
-		icd->streamer = NULL;
 	mutex_unlock(&ici->host_lock);
 
 	module_put(ici->ops->owner);
-- 
2.1.4

