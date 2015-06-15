Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53546 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbbFOLeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/14] soc_camera: fix expbuf support
Date: Mon, 15 Jun 2015 13:33:37 +0200
Message-Id: <1434368021-7467-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- For vb1 drivers just return -ENOTTY.
- For vb2 drivers allow vb2_expbuf without there being a stream owner:
  the vb2_expbuf function will return the correct error message in that case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f24062d..5f1e5a8 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -470,14 +470,13 @@ static int soc_camera_expbuf(struct file *file, void *priv,
 	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
-	if (icd->streamer != file)
-		return -EBUSY;
-
 	/* videobuf2 only */
 	if (ici->ops->init_videobuf)
-		return -EINVAL;
-	else
-		return vb2_expbuf(&icd->vb2_vidq, p);
+		return -ENOTTY;
+
+	if (icd->streamer && icd->streamer != file)
+		return -EBUSY;
+	return vb2_expbuf(&icd->vb2_vidq, p);
 }
 
 /* Always entered with .host_lock held */
-- 
2.1.4

