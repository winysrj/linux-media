Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3249 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1HYOIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/12] saa7146: fix compiler warning
Date: Thu, 25 Aug 2011 16:08:27 +0200
Message-Id: <6d87d7fae9166b16990c5db200e61e3c4e82a9e6.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/common/saa7146_video.c: In function 'video_close':
v4l-dvb-git/drivers/media/common/saa7146_video.c:1350:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_video.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 9aafa4e..77e232f 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -1347,18 +1347,14 @@ static void video_close(struct saa7146_dev *dev, struct file *file)
 	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_vv *vv = dev->vv_data;
 	struct videobuf_queue *q = &fh->video_q;
-	int err;
 
-	if (IS_CAPTURE_ACTIVE(fh) != 0) {
-		err = video_end(fh, file);
-	} else if (IS_OVERLAY_ACTIVE(fh) != 0) {
-		err = saa7146_stop_preview(fh);
-	}
+	if (IS_CAPTURE_ACTIVE(fh) != 0)
+		video_end(fh, file);
+	else if (IS_OVERLAY_ACTIVE(fh) != 0)
+		saa7146_stop_preview(fh);
 
 	videobuf_stop(q);
-
 	/* hmm, why is this function declared void? */
-	/* return err */
 }
 
 
-- 
1.7.5.4

