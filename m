Return-path: <linux-media-owner@vger.kernel.org>
Received: from vpndallas.adeneo-embedded.us ([162.254.209.190]:46200 "EHLO
	mxadeneo.adeneo-embedded.us" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751256AbcA2TFt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 14:05:49 -0500
From: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
To: <linux-media@vger.kernel.org>
CC: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
Subject: [PATCH v2] [media] cx231xx: fix close sequence for VBI + analog
Date: Fri, 29 Jan 2016 11:05:04 -0800
Message-ID: <1454094304-4520-1-git-send-email-jtheou@adeneo-embedded.us>
In-Reply-To: <1454092619-27700-1-git-send-email-jtheou@adeneo-embedded.us>
References: <1454092619-27700-1-git-send-email-jtheou@adeneo-embedded.us>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For tuners with no_alt_vanc=0, and VBI and analog video device
open.
There is two ways to close the devices:

*First way (start with user=2)

VBI first (user=1): URBs for the VBI are killed properly
with cx231xx_uninit_vbi_isoc

Analog second (user=0): URBs for the Analog are killed
properly with cx231xx_uninit_isoc

*Second way (start with user=2)

Analog first (user=1): URBs for the Analog are NOT killed
properly with cx231xx_uninit_isoc, because the exit path
is not called this time.

VBI first (user=0): URBs for the VBI are killed properly with
cx231xx_uninit_vbi_isoc, but we are exiting the function
without killing the URBs for the Analog

This situation lead to various kernel panics, since
the URBs are still processed, without the device been
open.

The patch fix the issue by calling the exit path no matter
what, when user=0, plus remove a duplicate trace.

Signed-off-by: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>

---

 - v2: Avoid duplicate code and ensure that the queue are freed
       properly.
---
 drivers/media/usb/cx231xx/cx231xx-video.c | 44 +++++++++----------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 9b88cd8..a832c83 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1836,10 +1836,21 @@ static int cx231xx_close(struct file *filp)
 
 	cx231xx_videodbg("users=%d\n", dev->users);
 
-	cx231xx_videodbg("users=%d\n", dev->users);
 	if (res_check(fh))
 		res_free(fh);
 
+	videobuf_stop(&fh->vb_vidq);
+	videobuf_mmap_free(&fh->vb_vidq);
+
+	/* the device is already disconnect,
+	 * free the remaining resources
+	 */
+	if (dev->state & DEV_DISCONNECTED) {
+		cx231xx_release_resources(dev);
+		fh->dev = NULL;
+		return 0;
+	}
+
 	/*
 	 * To workaround error number=-71 on EP0 for VideoGrabber,
 	 *	 need exclude following.
@@ -1848,19 +1859,6 @@ static int cx231xx_close(struct file *filp)
 	 */
 	if (!dev->board.no_alt_vanc)
 		if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-			videobuf_stop(&fh->vb_vidq);
-			videobuf_mmap_free(&fh->vb_vidq);
-
-			/* the device is already disconnect,
-			   free the remaining resources */
-			if (dev->state & DEV_DISCONNECTED) {
-				if (atomic_read(&dev->devlist_count) > 0) {
-					cx231xx_release_resources(dev);
-					fh->dev = NULL;
-					return 0;
-				}
-				return 0;
-			}
 
 			/* do this before setting alternate! */
 			cx231xx_uninit_vbi_isoc(dev);
@@ -1870,29 +1868,11 @@ static int cx231xx_close(struct file *filp)
 				cx231xx_set_alt_setting(dev, INDEX_VANC, 0);
 			else
 				cx231xx_set_alt_setting(dev, INDEX_HANC, 0);
-
-			v4l2_fh_del(&fh->fh);
-			v4l2_fh_exit(&fh->fh);
-			kfree(fh);
-			dev->users--;
-			wake_up_interruptible(&dev->open);
-			return 0;
 		}
 
 	v4l2_fh_del(&fh->fh);
 	dev->users--;
 	if (!dev->users) {
-		videobuf_stop(&fh->vb_vidq);
-		videobuf_mmap_free(&fh->vb_vidq);
-
-		/* the device is already disconnect,
-		   free the remaining resources */
-		if (dev->state & DEV_DISCONNECTED) {
-			cx231xx_release_resources(dev);
-			fh->dev = NULL;
-			return 0;
-		}
-
 		/* Save some power by putting tuner to sleep */
 		call_all(dev, core, s_power, 0);
 
-- 
2.7.0

