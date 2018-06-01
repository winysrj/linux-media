Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:38074 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbeFAAbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 20:31:06 -0400
Received: by mail-pl0-f65.google.com with SMTP id c11-v6so14224007plr.5
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 17:31:06 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 03/10] media: videodev2.h: Add macros V4L2_FIELD_IS_{INTERLACED|SEQUENTIAL}
Date: Thu, 31 May 2018 17:30:42 -0700
Message-Id: <1527813049-3231-4-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds two helper macros:

Add a macro that returns true if the given field type is 'sequential',
that is a full frame is transmitted, or exists in memory, as all top
field lines followed by all bottom field lines, or vice-versa.

Add a macro that returns true if the given field type is 'interlaced',
that is a full frame is transmitted, or exists in memory, as top field
lines interlaced with bottom field lines.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v1:
- add the complement macro V4L2_FIELD_IS_INTERLACED
- remove V4L2_FIELD_ALTERNATE from V4L2_FIELD_IS_SEQUENTIAL macro.
- moved new macros past end of existing V4L2_FIELD_HAS_* macros.
---
 include/uapi/linux/videodev2.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 600877b..d4e12f4 100644
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
2.7.4
