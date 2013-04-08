Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4893 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3DHK7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:59:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 01/12] videodev2.h: fix incorrect V4L2_DV_FL_HALF_LINE bitmask.
Date: Mon,  8 Apr 2013 12:58:30 +0200
Message-Id: <1365418721-23859-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This was set to 1 << 0 which is the same as V4L2_DV_FL_REDUCED_BLANKING.
It should be 1 << 3 instead. Luckily interlaced formats are rarely used,
which is why this bug wasn't seen until now.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e9c49c5..8453c50 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1074,7 +1074,7 @@ struct v4l2_bt_timings {
    longer and field 2 is really one half-line shorter, so each field has
    exactly the same number of half-lines. Whether half-lines can be detected
    or used depends on the hardware. */
-#define V4L2_DV_FL_HALF_LINE			(1 << 0)
+#define V4L2_DV_FL_HALF_LINE			(1 << 3)
 
 
 /** struct v4l2_dv_timings - DV timings
-- 
1.7.10.4

