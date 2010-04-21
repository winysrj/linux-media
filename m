Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41255 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0DUJol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 05:44:41 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L18002YT0EEO8@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 10:44:38 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1800J5I0EDXN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 10:44:37 +0100 (BST)
Date: Wed, 21 Apr 2010 11:44:27 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH] v4l: videobuf: qbuf now uses relevant v4l2_buffer fields for
 OUTPUT types
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1271843067-23496-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the V4L2 specification, applications set bytesused, field and
timestamp fields of struct v4l2_buffer when the buffer is intended for
output and memory type is MMAP. This adds proper copying of those values
to videobuf_buffer so drivers can use them.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf-core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 63d7043..e573ca7 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -549,6 +549,13 @@ int videobuf_qbuf(struct videobuf_queue *q, struct v4l2_buffer *b)
 				   "but buffer addr is zero!\n");
 			goto done;
 		}
+		if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT
+		    || q->type == V4L2_BUF_TYPE_VBI_OUTPUT
+		    || q->type == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
+			buf->size = b->bytesused;
+			buf->field = b->field;
+			buf->ts = b->timestamp;
+		}
 		break;
 	case V4L2_MEMORY_USERPTR:
 		if (b->length < buf->bsize) {
-- 
1.7.1.rc1.12.ga601

