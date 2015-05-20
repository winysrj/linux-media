Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56325 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754442AbbEUJCu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:02:50 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 11/20] media: soc_camera: Fill std field in enum_input
Date: Wed, 20 May 2015 17:39:31 +0100
Message-Id: <1432139980-12619-12-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
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
index 126d645..5afbf65 100644
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

