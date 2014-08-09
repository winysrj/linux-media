Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61232 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaHIJgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 05:36:24 -0400
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 2/2] em28xx-v4l: fix video buffer field order reporting in progressive mode
Date: Sat,  9 Aug 2014 11:37:21 +0200
Message-Id: <1407577041-3301-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1407577041-3301-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1407577041-3301-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The correct field order in progressive mode is V4L2_FIELD_NONE, not V4L2_FIELD_INTERLACED.

Cc: <stable@vger.kernel.org>
Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 9db219d..f6cf99f 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -435,7 +435,10 @@ static inline void finish_buffer(struct em28xx *dev,
 	em28xx_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
 
 	buf->vb.v4l2_buf.sequence = dev->v4l2->field_count++;
-	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	if (dev->v4l2->progressive)
+		buf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
+	else
+		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
 	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
-- 
1.8.4.5

