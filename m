Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40833 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab3DIGdp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 02:33:45 -0400
Received: by mail-pd0-f179.google.com with SMTP id x11so3633924pdj.38
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 23:33:45 -0700 (PDT)
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Tzu-Jung Lee <tjlee@ambarella.com>
Subject: [PATCH] v4l2-ctl: skip precalculate_bars() for compressed formats
Date: Tue,  9 Apr 2013 14:35:19 +0800
Message-Id: <1365489319-29343-1-git-send-email-tjlee@ambarella.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index a6ea8b3..ec18312 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -771,7 +771,10 @@ void streaming_set(int fd)
 		fmt.type = type;
 		doioctl(fd, VIDIOC_G_FMT, &fmt);
 
-		if (!precalculate_bars(fmt.fmt.pix.pixelformat, stream_pat % NUM_PATTERNS)) {
+		if (!(fmt.flags && V4L2_FMT_FLAG_COMPRESSED) &&
+				!precalculate_bars(fmt.fmt.pix.pixelformat,
+					stream_pat % NUM_PATTERNS)) {
+
 			fprintf(stderr, "unsupported pixelformat\n");
 			return;
 		}
-- 
1.8.1.5

