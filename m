Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:57418 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbdIUPHc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:07:32 -0400
Subject: [PATCH 2/4] [media] usbvision-core: Use common error handling code in
 usbvision_set_compress_params()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
Message-ID: <52c09836-83d7-c509-6e85-c7af16160302@users.sourceforge.net>
Date: Thu, 21 Sep 2017 17:07:06 +0200
MIME-Version: 1.0
In-Reply-To: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 21 Sep 2017 12:45:49 +0200

* Add a jump target so that a bit of exception handling can be better
  reused at the end of this function.

* Replace the local variable "proc" by the identifier "__func__".

* Use the interface "dev_err" instead of "printk".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/usbvision/usbvision-core.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 16b76c85eeec..bb6f4f69165f 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1857,7 +1857,6 @@ int usbvision_stream_interrupt(struct usb_usbvision *usbvision)
 
 static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
 {
-	static const char proc[] = "usbvision_set_compresion_params: ";
 	int rc;
 	unsigned char *value = usbvision->ctrl_urb_buffer;
 
@@ -1882,12 +1881,8 @@ static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
 			     USB_DIR_OUT | USB_TYPE_VENDOR |
 			     USB_RECIP_ENDPOINT, 0,
 			     (__u16) USBVISION_INTRA_CYC, value, 5, HZ);
-
-	if (rc < 0) {
-		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
-		       proc, rc);
-		return rc;
-	}
+	if (rc < 0)
+		goto report_failure;
 
 	if (usbvision->bridge_type == BRIDGE_NT1004) {
 		value[0] =  20; /* PCM Threshold 1 */
@@ -1913,11 +1908,12 @@ static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
 			     USB_DIR_OUT | USB_TYPE_VENDOR |
 			     USB_RECIP_ENDPOINT, 0,
 			     (__u16) USBVISION_PCM_THR1, value, 6, HZ);
+	if (rc < 0)
+report_failure:
+		dev_err(&usbvision->dev->dev,
+			"%s: ERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
+			__func__, rc);
 
-	if (rc < 0) {
-		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
-		       proc, rc);
-	}
 	return rc;
 }
 
-- 
2.14.1
