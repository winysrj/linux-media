Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44685 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbeJEBsr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 21:48:47 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 01/11] media: videodev2.h: Add more field helper macros
Date: Thu,  4 Oct 2018 11:53:51 -0700
Message-Id: <20181004185401.15751-2-slongerbeam@gmail.com>
In-Reply-To: <20181004185401.15751-1-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds two helper macros:

V4L2_FIELD_IS_SEQUENTIAL: returns true if the given field type is
'sequential', that is a full frame is transmitted, or exists in
memory, as all top field lines followed by all bottom field lines,
or vice-versa.

V4L2_FIELD_IS_INTERLACED: returns true if the given field type is
'interlaced', that is a full frame is transmitted, or exists in
memory, as top field lines interlaced with bottom field lines.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes since v3:
- none
Changes since v2:
- none
Changes since v1:
- add the complement macro V4L2_FIELD_IS_INTERLACED
- remove V4L2_FIELD_ALTERNATE from V4L2_FIELD_IS_SEQUENTIAL macro.
- moved new macros past end of existing V4L2_FIELD_HAS_* macros.
---
 include/uapi/linux/videodev2.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 29729d580452..f7f031736d91 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -130,6 +130,13 @@ enum v4l2_field {
 	((field) == V4L2_FIELD_BOTTOM ||\
 	 (field) == V4L2_FIELD_TOP ||\
 	 (field) == V4L2_FIELD_ALTERNATE)
+#define V4L2_FIELD_IS_INTERLACED(field) \
+	((field) == V4L2_FIELD_INTERLACED ||\
+	 (field) == V4L2_FIELD_INTERLACED_TB ||\
+	 (field) == V4L2_FIELD_INTERLACED_BT)
+#define V4L2_FIELD_IS_SEQUENTIAL(field) \
+	((field) == V4L2_FIELD_SEQ_TB ||\
+	 (field) == V4L2_FIELD_SEQ_BT)
 
 enum v4l2_buf_type {
 	V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
-- 
2.17.1
