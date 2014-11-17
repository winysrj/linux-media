Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway14.websitewelcome.com ([67.18.68.2]:51676 "EHLO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbaKQXv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 18:51:26 -0500
Received: from cm1.websitewelcome.com (cm.websitewelcome.com [192.185.0.102])
	by gateway14.websitewelcome.com (Postfix) with ESMTP id 24D0FDF90B973
	for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 16:50:51 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, hverkuil@xs4all.nl,
	Dean Anderson <linux-dev@sensoray.com>
Subject: [PATCH] [media] s2255drv: fix payload size for JPG, MJPEG
Date: Mon, 17 Nov 2014 14:50:36 -0800
Message-Id: <1416264636-8620-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index a56a05b..82014bb 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -635,7 +635,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 			break;
 		case V4L2_PIX_FMT_JPEG:
 		case V4L2_PIX_FMT_MJPEG:
-			buf->vb.v4l2_buf.length = jpgsize;
+			vb2_set_plane_payload(&buf->vb, 0, jpgsize);
 			memcpy(vbuf, tmpbuf, jpgsize);
 			break;
 		case V4L2_PIX_FMT_YUV422P:
-- 
1.9.1

