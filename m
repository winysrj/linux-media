Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53546 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754744AbbFOLeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/14] soc_camera: fix enum_input
Date: Mon, 15 Jun 2015 13:33:36 +0200
Message-Id: <1434368021-7467-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fill in the std field from the video_device tvnorms field.

This fixes a v4l2-compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d708df4..f24062d 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -309,11 +309,14 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 static int soc_camera_enum_input(struct file *file, void *priv,
 				 struct v4l2_input *inp)
 {
+	struct soc_camera_device *icd = file->private_data;
+
 	if (inp->index != 0)
 		return -EINVAL;
 
 	/* default is camera */
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->std = icd->vdev->tvnorms;
 	strcpy(inp->name, "Camera");
 
 	return 0;
-- 
2.1.4

