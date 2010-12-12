Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4544 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab0LLRcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:11 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MQ002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:10 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 18/19] em28xx: fix incorrect s_ctrl error code and wrong call to res_free
Date: Sun, 12 Dec 2010 18:32:00 +0100
Message-Id: <83cffe4772bddbe7231ebc5ffcc56132b9a44463.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Calling subdevs to handle s_ctrl returned a non-zero return code even if
everything went fine.

Calling STREAMOFF if no STREAMON happened earlier would hit a BUG_ON
in res_free.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/em28xx/em28xx-video.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 908e3bc..37d6f16 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1434,7 +1434,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 	/* It isn't an AC97 control. Sends it to the v4l2 dev interface */
 	if (rc == 1) {
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
+		rc = v4l2_device_call_until_err(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
 
 		/*
 		 * In the case of non-AC97 volume controls, we still need
@@ -1708,11 +1708,15 @@ static int vidioc_streamoff(struct file *file, void *priv,
 			fh, type, fh->resources, dev->resources);
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		videobuf_streamoff(&fh->vb_vidq);
-		res_free(fh, EM28XX_RESOURCE_VIDEO);
+		if (res_check(fh, EM28XX_RESOURCE_VIDEO)) {
+			videobuf_streamoff(&fh->vb_vidq);
+			res_free(fh, EM28XX_RESOURCE_VIDEO);
+		}
 	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-		videobuf_streamoff(&fh->vb_vbiq);
-		res_free(fh, EM28XX_RESOURCE_VBI);
+		if (res_check(fh, EM28XX_RESOURCE_VBI)) {
+			videobuf_streamoff(&fh->vb_vbiq);
+			res_free(fh, EM28XX_RESOURCE_VBI);
+		}
 	}
 
 	return 0;
-- 
1.7.0.4

