Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:49650 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751969AbbFYJbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:31:14 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 12/15] media: soc_camera: Fill std field in enum_input
Date: Thu, 25 Jun 2015 10:31:06 +0100
Message-Id: <1435224669-23672-13-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
References: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fill in the std field from the video_device tvnorms field in
enum_input.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_camera.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 8d4d20c..7971388 100644
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
1.7.10.4

