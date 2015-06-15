Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55590 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbbFOLkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:40:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/14] soc_camera: pass on streamoff error
Date: Mon, 15 Jun 2015 13:33:39 +0200
Message-Id: <1434368021-7467-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If streamoff returned an error, then pass that on to the caller.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 6ce6576..0b09281 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1000,6 +1000,7 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	int ret;
 
 	WARN_ON(priv != file->private_data);
 
@@ -1014,13 +1015,13 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	 * remaining buffers. When the last buffer is freed, stop capture
 	 */
 	if (ici->ops->init_videobuf)
-		videobuf_streamoff(&icd->vb_vidq);
+		ret = videobuf_streamoff(&icd->vb_vidq);
 	else
-		vb2_streamoff(&icd->vb2_vidq, i);
+		ret = vb2_streamoff(&icd->vb2_vidq, i);
 
 	v4l2_subdev_call(sd, video, s_stream, 0);
 
-	return 0;
+	return ret;
 }
 
 static int soc_camera_cropcap(struct file *file, void *fh,
-- 
2.1.4

