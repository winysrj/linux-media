Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway01.websitewelcome.com ([69.56.142.19]:56917 "EHLO
	gateway01.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbaBESmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 13:42:21 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway01.websitewelcome.com (Postfix) with ESMTP id 664F13CA8ABB8
	for <linux-media@vger.kernel.org>; Wed,  5 Feb 2014 12:19:05 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: remove redundant parameter
Date: Wed,  5 Feb 2014 10:18:55 -0800
Message-Id: <1391624335-14963-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removing duplicate fmt from buffer structure.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 1b267b1..517901b 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -290,7 +290,6 @@ struct s2255_fmt {
 struct s2255_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct videobuf_buffer vb;
-	const struct s2255_fmt *fmt;
 };
 
 struct s2255_fh {
@@ -625,13 +624,13 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 	if (last_frame != -1) {
 		tmpbuf =
 		    (const char *)vc->buffer.frame[last_frame].lpvbits;
-		switch (buf->fmt->fourcc) {
+		switch (vc->fmt->fourcc) {
 		case V4L2_PIX_FMT_YUYV:
 		case V4L2_PIX_FMT_UYVY:
 			planar422p_to_yuv_packed((const unsigned char *)tmpbuf,
 						 vbuf, buf->vb.width,
 						 buf->vb.height,
-						 buf->fmt->fourcc);
+						 vc->fmt->fourcc);
 			break;
 		case V4L2_PIX_FMT_GREY:
 			memcpy(vbuf, tmpbuf, buf->vb.width * buf->vb.height);
@@ -711,7 +710,6 @@ static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		return -EINVAL;
 	}
 
-	buf->fmt = vc->fmt;
 	buf->vb.width = w;
 	buf->vb.height = h;
 	buf->vb.field = field;
-- 
1.7.9.5

