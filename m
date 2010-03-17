Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16693 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab0CQO37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:29:59 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KZF00KFIK9VXA@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:29:56 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZF00HPJK9VAP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:29:55 +0000 (GMT)
Date: Wed, 17 Mar 2010 15:29:49 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH 1/2] v4l: Add a new ERROR flag for DQBUF after recoverable
 streaming errors
In-reply-to: <1268836190-31051-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1268836190-31051-2-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1268836190-31051-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This flag is to be set together with V4L2_BUF_FLAG_DONE. It is intended
to indicate streaming errors that might have resulted in corrupted video
data in the buffer, but the buffer can still be reused and the streaming
may continue.

Setting this flag and returning 0 is different from returning EIO. The
latter should now indicate more serious (unrecoverable) errors.

This patch also solves a problem with the ioctl handling code in
vl42-ioctl.c, which does not copy buffer identification data back to the
userspace when EIO is returned, so there is no way for applications
to discover on which buffer the operation failed.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
---
 include/linux/videodev2.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 3c26560..1ae1568 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -550,6 +550,9 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_KEYFRAME	0x0008	/* Image is a keyframe (I-frame) */
 #define V4L2_BUF_FLAG_PFRAME	0x0010	/* Image is a P-frame */
 #define V4L2_BUF_FLAG_BFRAME	0x0020	/* Image is a B-frame */
+/* Buffer is ready, but the data contained within is corrupted.
+ * Always set together with V4L2_BUF_FLAG_DONE (for backward compatibility). */
+#define V4L2_BUF_FLAG_ERROR	0x0040
 #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
 #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
 
-- 
1.7.0.31.g1df487

