Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14242 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab0CQOAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:00:11 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KZF005EEIW915@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:00:09 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZF00E0PIW8BZ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:00:09 +0000 (GMT)
Date: Wed, 17 Mar 2010 15:00:02 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH] v4l: videobuf: make poll() report proper flags for output
 video devices
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, m-karicheri2@ti.com, chaithrika@ti.com
Message-id: <1268834402-31355-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the V4L2 specification, poll() should set POLLOUT | POLLWRNORM
flags for output devices after the frame has been displayed.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf-core.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 37afb4e..e93672a 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -1075,8 +1075,14 @@ unsigned int videobuf_poll_stream(struct file *file,
 	if (0 == rc) {
 		poll_wait(file, &buf->done, wait);
 		if (buf->state == VIDEOBUF_DONE ||
-		    buf->state == VIDEOBUF_ERROR)
-			rc = POLLIN|POLLRDNORM;
+		    buf->state == VIDEOBUF_ERROR) {
+			if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+				rc = POLLIN | POLLRDNORM;
+			else if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+				rc = POLLOUT | POLLWRNORM;
+			else
+				BUG();
+		}
 	}
 	mutex_unlock(&q->vb_lock);
 	return rc;
-- 
1.7.0.31.g1df487

