Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:34561 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753130AbeC1Nuj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 09:50:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv9 PATCH 05/29] media-request: add request ioctls
Date: Wed, 28 Mar 2018 15:50:06 +0200
Message-Id: <20180328135030.7116-6-hverkuil@xs4all.nl>
In-Reply-To: <20180328135030.7116-1-hverkuil@xs4all.nl>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement the MEDIA_REQUEST_IOC_QUEUE and MEDIA_REQUEST_IOC_REINIT
ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-request.c | 80 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 8135d9d32af9..3ee3b27fd644 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -105,10 +105,86 @@ static unsigned int media_request_poll(struct file *filp,
 	return 0;
 }
 
+static long media_request_ioctl_queue(struct media_request *req)
+{
+	struct media_device *mdev = req->mdev;
+	unsigned long flags;
+	int ret = 0;
+
+	dev_dbg(mdev->dev, "request: queue %s\n", req->debug_str);
+
+	spin_lock_irqsave(&req->lock, flags);
+	if (req->state != MEDIA_REQUEST_STATE_IDLE) {
+		dev_dbg(mdev->dev,
+			"request: unable to queue %s, request in state %s\n",
+			req->debug_str, media_request_state_str(req->state));
+		spin_unlock_irqrestore(&req->lock, flags);
+		return -EINVAL;
+	}
+	req->state = MEDIA_REQUEST_STATE_QUEUEING;
+
+	spin_unlock_irqrestore(&req->lock, flags);
+
+	/*
+	 * Ensure the request that is validated will be the one that gets queued
+	 * next by serialising the queueing process.
+	 */
+	mutex_lock(&mdev->req_queue_mutex);
+
+	ret = mdev->ops->req_queue(req);
+	spin_lock_irqsave(&req->lock, flags);
+	req->state = ret ? MEDIA_REQUEST_STATE_IDLE : MEDIA_REQUEST_STATE_QUEUED;
+	spin_unlock_irqrestore(&req->lock, flags);
+	mutex_unlock(&mdev->req_queue_mutex);
+
+	if (ret) {
+		dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
+			req->debug_str, ret);
+	} else {
+		media_request_get(req);
+	}
+
+	return ret;
+}
+
+static long media_request_ioctl_reinit(struct media_request *req)
+{
+	struct media_device *mdev = req->mdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&req->lock, flags);
+	if (req->state != MEDIA_REQUEST_STATE_IDLE &&
+	    req->state != MEDIA_REQUEST_STATE_COMPLETE) {
+		dev_dbg(mdev->dev,
+			"request: %s not in idle or complete state, cannot reinit\n",
+			req->debug_str);
+		spin_unlock_irqrestore(&req->lock, flags);
+		return -EINVAL;
+	}
+	req->state = MEDIA_REQUEST_STATE_CLEANING;
+	spin_unlock_irqrestore(&req->lock, flags);
+
+	media_request_clean(req);
+
+	spin_lock_irqsave(&req->lock, flags);
+	req->state = MEDIA_REQUEST_STATE_IDLE;
+	spin_unlock_irqrestore(&req->lock, flags);
+	return 0;
+}
+
 static long media_request_ioctl(struct file *filp, unsigned int cmd,
-				unsigned long __arg)
+				unsigned long arg)
 {
-	return -ENOIOCTLCMD;
+	struct media_request *req = filp->private_data;
+
+	switch (cmd) {
+	case MEDIA_REQUEST_IOC_QUEUE:
+		return media_request_ioctl_queue(req);
+	case MEDIA_REQUEST_IOC_REINIT:
+		return media_request_ioctl_reinit(req);
+	default:
+		return -ENOIOCTLCMD;
+	}
 }
 
 static const struct file_operations request_fops = {
-- 
2.16.1
