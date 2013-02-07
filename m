Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:48220 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945900Ab3BGWgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 17:36:23 -0500
Received: by mail-ea0-f171.google.com with SMTP id c13so1404857eaa.2
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 14:36:22 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH RFC] s3c-camif: Fail on insufficient number of allocated buffers
Date: Thu,  7 Feb 2013 23:36:12 +0100
Message-Id: <1360276572-10890-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the driver gets always at least its minimum required
number of buffers allocated by checking actual number of
allocated buffers in vb2_reqbufs(). And free any partially
allocated buffer queue with signaling an error to user space.

Without this patch applications may wait forever to dequeue
a filled buffer, because the hardware didn't even start after
VIDIOC_STREAMON, VIDIOC_QBUF calls, due to insufficient number
of empty buffers.

Reported-by: Alexander Nestorov <alexandernst@gmail.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/s3c-camif/camif-capture.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index a55793c..b8466f3 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -934,12 +934,19 @@ static int s3c_camif_reqbufs(struct file *file, void *priv,
 		vp->owner = NULL;

 	ret = vb2_reqbufs(&vp->vb_queue, rb);
-	if (!ret) {
-		vp->reqbufs_count = rb->count;
-		if (vp->owner == NULL && rb->count > 0)
-			vp->owner = priv;
+	if (ret < 0)
+		return ret;
+
+	if (rb->count && rb->count < CAMIF_REQ_BUFS_MIN) {
+		rb->count = 0;
+		vb2_reqbufs(&vp->vb_queue, rb);
+		ret = -ENOMEM;
 	}

+	vp->reqbufs_count = rb->count;
+	if (vp->owner == NULL && rb->count > 0)
+		vp->owner = priv;
+
 	return ret;
 }

--
1.7.4.1

