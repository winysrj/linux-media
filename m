Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:43542 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965779AbeF0Sjw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 14:39:52 -0400
Received: by mail-pg0-f65.google.com with SMTP id a14-v6so1299672pgw.10
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2018 11:39:51 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH] media: v4l2-ctrls: Fix CID base conflict between MAX217X and IMX
Date: Wed, 27 Jun 2018 11:39:43 -0700
Message-Id: <1530124783-30835-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the imx-media driver was initially merged, there was a conflict
with 8d67ae25 ("media: v4l2-ctrls: Reserve controls for MAX217X") which
was not fixed up correctly, resulting in V4L2_CID_USER_MAX217X_BASE and
V4L2_CID_USER_IMX_BASE taking on the same value. Fix by assigning imx
CID base the next available range at 0x10b0.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 include/uapi/linux/v4l2-controls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 8d473c9..8a75ad7 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -188,7 +188,7 @@ enum v4l2_colorfx {
 
 /* The base for the imx driver controls.
  * We reserve 16 controls for this driver. */
-#define V4L2_CID_USER_IMX_BASE			(V4L2_CID_USER_BASE + 0x1090)
+#define V4L2_CID_USER_IMX_BASE			(V4L2_CID_USER_BASE + 0x10b0)
 
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
-- 
2.7.4
