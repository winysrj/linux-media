Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50508 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932094AbbFOLeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/14] soc_camera: compliance fixes
Date: Mon, 15 Jun 2015 13:33:38 +0200
Message-Id: <1434368021-7467-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- REQBUFS(0) will stop streaming, free buffers and release the file ownership.
- Return ENOTTY for create_bufs for a vb1 driver
- Return EBUSY if there is a different streaming owner and set the new owner on
  success.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 5f1e5a8..6ce6576 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -384,9 +384,8 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 		ret = vb2_reqbufs(&icd->vb2_vidq, p);
 	}
 
-	if (!ret && !icd->streamer)
-		icd->streamer = file;
-
+	if (!ret)
+		icd->streamer = p->count ? file : NULL;
 	return ret;
 }
 
@@ -443,12 +442,19 @@ static int soc_camera_create_bufs(struct file *file, void *priv,
 {
 	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	int ret;
 
 	/* videobuf2 only */
 	if (ici->ops->init_videobuf)
-		return -EINVAL;
-	else
-		return vb2_create_bufs(&icd->vb2_vidq, create);
+		return -ENOTTY;
+
+	if (icd->streamer && icd->streamer != file)
+		return -EBUSY;
+
+	ret = vb2_create_bufs(&icd->vb2_vidq, create);
+	if (!ret)
+		icd->streamer = file;
+	return ret;
 }
 
 static int soc_camera_prepare_buf(struct file *file, void *priv,
-- 
2.1.4

