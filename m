Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:65334 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbdIUPGb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:06:31 -0400
Subject: [PATCH 1/4] [media] usbvision-core: Use common error handling code in
 usbvision_set_input()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
Message-ID: <bc54a99d-74af-a4bb-5823-70b075403624@users.sourceforge.net>
Date: Thu, 21 Sep 2017 17:06:02 +0200
MIME-Version: 1.0
In-Reply-To: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 21 Sep 2017 11:50:54 +0200

* Add a jump target so that a bit of exception handling can be better
  reused at the end of this function.

  This issue was detected by using the Coccinelle software.

* Replace the local variable "proc" by the identifier "__func__".

* Use the interface "dev_err" instead of "printk".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/usbvision/usbvision-core.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 3f87fbc80be2..16b76c85eeec 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1931,7 +1931,6 @@ static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
  */
 int usbvision_set_input(struct usb_usbvision *usbvision)
 {
-	static const char proc[] = "usbvision_set_input: ";
 	int rc;
 	unsigned char *value = usbvision->ctrl_urb_buffer;
 	unsigned char dvi_yuv_value;
@@ -1953,12 +1952,8 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 	}
 
 	rc = usbvision_write_reg(usbvision, USBVISION_VIN_REG1, value[0]);
-	if (rc < 0) {
-		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
-		       proc, rc);
-		return rc;
-	}
-
+	if (rc < 0)
+		goto report_failure;
 
 	if (usbvision->tvnorm_id & V4L2_STD_PAL) {
 		value[0] = 0xC0;
@@ -2019,12 +2014,8 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 			     USBVISION_OP_CODE,	/* USBVISION specific code */
 			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_ENDPOINT, 0,
 			     (__u16) USBVISION_LXSIZE_I, value, 8, HZ);
-	if (rc < 0) {
-		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
-		       proc, rc);
-		return rc;
-	}
-
+	if (rc < 0)
+		goto report_failure;
 
 	dvi_yuv_value = 0x00;	/* U comes after V, Ya comes after U/V, Yb comes after Yb */
 
@@ -2036,6 +2027,12 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 	}
 
 	return usbvision_write_reg(usbvision, USBVISION_DVI_YUV, dvi_yuv_value);
+
+report_failure:
+	dev_err(&usbvision->dev->dev,
+		"%s: ERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
+		__func__, rc);
+	return rc;
 }
 
 
-- 
2.14.1
