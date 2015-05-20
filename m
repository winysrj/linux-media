Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56770 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932194AbbEUJDi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:38 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 12/20] media: soc_camera: Fix error reporting in expbuf
Date: Wed, 20 May 2015 17:39:32 +0100
Message-Id: <1432139980-12619-13-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
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
index 5afbf65..fd7497e 100644
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

