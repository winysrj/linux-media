Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24086 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0C2IQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 04:16:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L010017RAZQHV70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Mar 2010 09:16:38 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L01003K6AZQU8@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Mar 2010 09:16:38 +0100 (BST)
Date: Mon, 29 Mar 2010 10:16:31 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v2] v4l: videobuf: make poll() report proper flags for output
 video devices
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Message-id: <1269850591-9590-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the V4L2 specification, poll() should set POLLOUT | POLLWRNORM
flags for output devices after the frame has been displayed.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf-core.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 63d7043..921277f 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -1075,8 +1075,18 @@ unsigned int videobuf_poll_stream(struct file *file,
 	if (0 == rc) {
 		poll_wait(file, &buf->done, wait);
 		if (buf->state == VIDEOBUF_DONE ||
-		    buf->state == VIDEOBUF_ERROR)
-			rc = POLLIN|POLLRDNORM;
+		    buf->state == VIDEOBUF_ERROR) {
+			switch (q->type) {
+			case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+			case V4L2_BUF_TYPE_VBI_OUTPUT:
+			case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+				rc = POLLOUT | POLLWRNORM;
+				break;
+			default:
+				rc = POLLIN | POLLRDNORM;
+				break;
+			}
+		}
 	}
 	mutex_unlock(&q->vb_lock);
 	return rc;
-- 
1.7.0.31.g1df487

