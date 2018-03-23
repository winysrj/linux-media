Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59562 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751966AbeCWMZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 08:25:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] media: uvc: to the right check at uvc_ioctl_enum_framesizes()
Date: Fri, 23 Mar 2018 08:25:53 -0400
Message-Id: <8394db595eab2534013f3ca92e953ab34d9d2151.1521807951.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the logic there is correct, it tricks both humans and
machines, a the check if "i" var is not zero is actually to
validate if the "frames" var was initialized when the loop
ran for the first time.

That produces the following warning:
	drivers/media/usb/uvc/uvc_v4l2.c:1192 uvc_ioctl_enum_framesizes() error: potentially dereferencing uninitialized 'frame'.

Change the logic to do the right test instead.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 818a4369a51a..bd32914259ae 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1173,7 +1173,7 @@ static int uvc_ioctl_enum_framesizes(struct file *file, void *fh,
 	struct uvc_fh *handle = fh;
 	struct uvc_streaming *stream = handle->stream;
 	struct uvc_format *format = NULL;
-	struct uvc_frame *frame;
+	struct uvc_frame *frame = NULL;
 	unsigned int index;
 	unsigned int i;
 
@@ -1189,7 +1189,7 @@ static int uvc_ioctl_enum_framesizes(struct file *file, void *fh,
 
 	/* Skip duplicate frame sizes */
 	for (i = 0, index = 0; i < format->nframes; i++) {
-		if (i && frame->wWidth == format->frame[i].wWidth &&
+		if (frame && frame->wWidth == format->frame[i].wWidth &&
 		    frame->wHeight == format->frame[i].wHeight)
 			continue;
 		frame = &format->frame[i];
-- 
2.14.3
