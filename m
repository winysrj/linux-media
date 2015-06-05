Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49113 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbbFEO2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 10/11] [media] usbvision: cleanup the code
Date: Fri,  5 Jun 2015 11:27:43 -0300
Message-Id: <d81430674579026a0539e7603a7e7c2e5c69c778.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a dead code on usbvision that makes it harder to read
and produces a smatch warning about bad identation.

Improve the code readability and add a FIXME to warn about
the current hack there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 12b403e78d52..1c6d31f7c1b9 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1061,13 +1061,24 @@ static ssize_t usbvision_read(struct file *file, char __user *buf,
 	       __func__,
 	       (unsigned long)count, frame->bytes_read);
 
-	/* For now, forget the frame if it has not been read in one shot. */
-/*	if (frame->bytes_read >= frame->scanlength) {*/ /* All data has been read */
+#if 1
+	/*
+	 * FIXME:
+	 * For now, forget the frame if it has not been read in one shot.
+	 */
+	frame->bytes_read = 0;
+
+	/* Mark it as available to be used again. */
+	frame->grabstate = frame_state_unused;
+#else
+	if (frame->bytes_read >= frame->scanlength) {
+		/* All data has been read */
 		frame->bytes_read = 0;
 
 		/* Mark it as available to be used again. */
 		frame->grabstate = frame_state_unused;
-/*	} */
+	}
+#endif
 
 	return count;
 }
-- 
2.4.2

