Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35217 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaIKWnt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 18:43:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] v4l: videobuf2: Fix typos in comments
Date: Fri, 12 Sep 2014 01:43:46 +0300
Message-Id: <1410475426-30019-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The buffer flags are incorrectly referred to as V4L2_BUF_FLAGS_* instead
of V4L2_BUF_FLAG_* in comments. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/videobuf2-core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5a10d8d..5901b24 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -356,8 +356,8 @@ struct v4l2_fh;
  * @buf_struct_size: size of the driver-specific buffer structure;
  *		"0" indicates the driver doesn't want to use a custom buffer
  *		structure type, so sizeof(struct vb2_buffer) will is used
- * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAGS_TIMESTAMP_* and
- *		V4L2_BUF_FLAGS_TSTAMP_SRC_*
+ * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
+ *		V4L2_BUF_FLAG_TSTAMP_SRC_*
  * @gfp_flags:	additional gfp flags used when allocating the buffers.
  *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
  *		to force the buffer allocation to a specific memory zone.
-- 
Regards,

Laurent Pinchart

