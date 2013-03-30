Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3295 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3C3Jru (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Mar 2013 05:47:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] xawtv: release buffer if it can't be displayed
Date: Sat, 30 Mar 2013 10:47:41 +0100
Cc: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303301047.41952.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch for xawtv3 releases the buffer if it can't be displayed because
the resolution of the current format is larger than the size of the window.

This will happen if the hardware cannot scale down to the initially quite
small xawtv window. For example the au0828 driver has a fixed size of 720x480,
so it will not display anything until the window is large enough for that
resolution.

The problem is that xawtv never releases (== calls QBUF) the buffer in that
case, and it will of course run out of buffers and stall. The only way to
kill it is to issue a 'kill -9' since ctrl-C won't work either.

By releasing the buffer xawtv at least remains responsive and a picture will
appear after resizing the window. Ideally of course xawtv should resize itself
to the minimum supported resolution, but that's left as an exercise for the
reader...

Hans, the xawtv issues I reported off-list are all caused by this bug and by
by the scaling bug introduced recently in em28xx. They had nothing to do with
the alsa streaming, that was a red herring.

Regards,

	Hans

diff --git a/x11/x11.c b/x11/x11.c
index 5324521..b203d84 100644
--- a/x11/x11.c
+++ b/x11/x11.c
@@ -152,8 +152,10 @@ int
 video_gd_blitframe(struct video_handle *h, struct ng_video_buf *buf)
 {
     if (buf->fmt.width  > cur_tv_width ||
-	buf->fmt.height > cur_tv_height)
+	buf->fmt.height > cur_tv_height) {
+	ng_release_video_buf(buf);
 	return -1;
+    }
 
     if (cur_filter)
 	buf = video_gd_filter(h,buf);
