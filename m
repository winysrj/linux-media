Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4851 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbaGRF6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 01:58:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] videodev.h: add defines for the VBI field start lines
Date: Fri, 18 Jul 2014 07:58:41 +0200
Message-Id: <1405663122-12149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While working with raw and sliced VBI support in several applications
I noticed that you really need to know the start linenumbers for
each video field in order to correctly convert the start line numbers
reported by v4l2_vbi_format to the line numbers used in v4l2_sliced_vbi_format.

This patch adds four defines that specify the start lines for each
field for both 525 and 625 line standards.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1f1a65c..b66148c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1639,6 +1639,12 @@ struct v4l2_vbi_format {
 #define V4L2_VBI_UNSYNC		(1 << 0)
 #define V4L2_VBI_INTERLACED	(1 << 1)
 
+/* ITU-R start lines for each field */
+#define V4L2_VBI_ITU_525_F1_START (1)
+#define V4L2_VBI_ITU_525_F2_START (264)
+#define V4L2_VBI_ITU_625_F1_START (1)
+#define V4L2_VBI_ITU_625_F2_START (314)
+
 /* Sliced VBI
  *
  *    This implements is a proposal V4L2 API to allow SLICED VBI
-- 
2.0.0

