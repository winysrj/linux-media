Return-path: <mchehab@localhost>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1620 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965213Ab1GMJjX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 05:39:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 6/6] vivi: let vb2_poll handle events.
Date: Wed, 13 Jul 2011 11:39:04 +0200
Message-Id: <50a6d38b50c4cf10cd66e3cc3fd2fef4802423fb.1310549521.git.hans.verkuil@cisco.com>
In-Reply-To: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
References: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <bec0b6db54a6b435d219e5ad2d9f010848dd8c2b.1310549521.git.hans.verkuil@cisco.com>
References: <bec0b6db54a6b435d219e5ad2d9f010848dd8c2b.1310549521.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vb2_poll function now tests for events and sets POLLPRI accordingly.
So there it is no longer necessary to test for it in the vivi driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index a848bd2..fc3c88f 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1039,17 +1039,10 @@ static unsigned int
 vivi_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct vivi_dev *dev = video_drvdata(file);
-	struct v4l2_fh *fh = file->private_data;
 	struct vb2_queue *q = &dev->vb_vidq;
-	unsigned int res;
 
 	dprintk(dev, 1, "%s\n", __func__);
-	res = vb2_poll(q, file, wait);
-	if (v4l2_event_pending(fh))
-		res |= POLLPRI;
-	else
-		poll_wait(file, &fh->wait, wait);
-	return res;
+	return vb2_poll(q, file, wait);
 }
 
 static int vivi_close(struct file *file)
-- 
1.7.1

