Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60281 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0DUMMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 08:12:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L18006HP78E1M70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 13:12:19 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1800FQJ77O7T@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 13:11:49 +0100 (BST)
Date: Wed, 21 Apr 2010 13:39:43 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v3 1/3] v4l: Add a new ERROR flag for DQBUF after recoverable
 streaming errors
In-reply-to: <1271849985-368-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1271849985-368-2-git-send-email-p.osciak@samsung.com>
References: <1271849985-368-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This flag is intended to indicate streaming errors, which might have
resulted in corrupted video data in the buffer, but the buffer can still
be reused and streaming may continue.

Setting this flag and returning 0 is different from returning EIO. The
latter should now indicate more serious (unrecoverable) errors.

This patch also solves a problem with the ioctl handling code in
vl42-ioctl.c, which does not copy buffer identification data back to the
userspace when EIO is returned, so there is no way for applications
to discover on which buffer the operation failed in such cases.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/videodev2.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 15d80f7..b417bd5 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -551,6 +551,9 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_KEYFRAME	0x0008	/* Image is a keyframe (I-frame) */
 #define V4L2_BUF_FLAG_PFRAME	0x0010	/* Image is a P-frame */
 #define V4L2_BUF_FLAG_BFRAME	0x0020	/* Image is a B-frame */
+/* Buffer is ready, but the data contained within is corrupted.
+ * Always set together with V4L2_BUF_FLAG_DONE (for backward compatibility). */
+#define V4L2_BUF_FLAG_ERROR	0x0040
 #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
 #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
 
-- 
1.7.1.rc1.12.ga601

