Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:40802 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030721AbeEYXxu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 19:53:50 -0400
Received: by mail-pf0-f193.google.com with SMTP id f189-v6so3263683pfa.7
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 16:53:50 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 3/6] media: videodev2.h: Add macro V4L2_FIELD_IS_SEQUENTIAL
Date: Fri, 25 May 2018 16:53:33 -0700
Message-Id: <1527292416-26187-4-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a macro that returns true if the given field type is 'sequential',
that is, the data is transmitted, or exists in memory, as all top field
lines followed by all bottom field lines, or vice-versa.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 include/uapi/linux/videodev2.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 600877b..408ee96 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -126,6 +126,10 @@ enum v4l2_field {
 	 (field) == V4L2_FIELD_INTERLACED_BT ||\
 	 (field) == V4L2_FIELD_SEQ_TB ||\
 	 (field) == V4L2_FIELD_SEQ_BT)
+#define V4L2_FIELD_IS_SEQUENTIAL(field) \
+	((field) == V4L2_FIELD_SEQ_TB ||\
+	 (field) == V4L2_FIELD_SEQ_BT ||\
+	 (field) == V4L2_FIELD_ALTERNATE)
 #define V4L2_FIELD_HAS_T_OR_B(field)	\
 	((field) == V4L2_FIELD_BOTTOM ||\
 	 (field) == V4L2_FIELD_TOP ||\
-- 
2.7.4
