Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:49652 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751847AbbFYJbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:31:14 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 13/15] media: soc_camera: Fix error reporting in expbuf
Date: Thu, 25 Jun 2015 10:31:07 +0100
Message-Id: <1435224669-23672-14-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
References: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove unnecessary check and fix the error code for vb1 drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_camera.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 7971388..bb181c1 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -470,14 +470,10 @@ static int soc_camera_expbuf(struct file *file, void *priv,
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
+	return vb2_expbuf(&icd->vb2_vidq, p);
 }
 
 /* Always entered with .host_lock held */
-- 
1.7.10.4

