Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab2EWIM3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 04:12:29 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>, stable@kernel.org
Subject: [PATCH] gspca-core: Fix buffers staying in queued state after a stream_off
Date: Wed, 23 May 2012 10:12:30 +0200
Message-Id: <1337760750-2561-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a regression introduced by commit f7059ea and should be
backported to all supported stable kernels which have this commit.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Antonio Ospite <ospite@studenti.unina.it>
CC: stable@kernel.org
---
 drivers/media/video/gspca/gspca.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 137166d..31721ea 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1653,7 +1653,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 				enum v4l2_buf_type buf_type)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int ret;
+	int i, ret;
 
 	if (buf_type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1678,6 +1678,8 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	wake_up_interruptible(&gspca_dev->wq);
 
 	/* empty the transfer queues */
+	for (i = 0; i < gspca_dev->nframes; i++)
+		gspca_dev->frame[i].v4l2_buf.flags &= ~BUF_ALL_FLAGS;
 	atomic_set(&gspca_dev->fr_q, 0);
 	atomic_set(&gspca_dev->fr_i, 0);
 	gspca_dev->fr_o = 0;
-- 
1.7.10

