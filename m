Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63909 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060Ab0CaJcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 05:32:47 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L0500K7F3UJWP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Mar 2010 10:32:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L05002VR3UJVU@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Mar 2010 10:32:43 +0100 (BST)
Date: Wed, 31 Mar 2010 11:32:25 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v2 1/3] v4l: Add a new ERROR flag for DQBUF after recoverable
 streaming errors
In-reply-to: <1270027947-28327-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1270027947-28327-2-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1270027947-28327-1-git-send-email-p.osciak@samsung.com>
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
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/videodev2.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 418dacf..e9222e8 100644
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

