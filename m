Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50796 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751629AbdIUPKf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:10:35 -0400
Subject: [PATCH 4/4] [media] usbvision-core: Replace four printk() calls by
 dev_err()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
Message-ID: <0c53a18c-eba1-524b-8825-7454bb8e58a4@users.sourceforge.net>
Date: Thu, 21 Sep 2017 17:09:40 +0200
MIME-Version: 1.0
In-Reply-To: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 21 Sep 2017 16:47:28 +0200

* Replace the local variable "proc" by the identifier "__func__".

* Use the interface "dev_err" instead of "printk" in these functions.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/usbvision/usbvision-core.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 54db35b03106..2c98805244df 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1619,7 +1619,6 @@ static int usbvision_init_webcam(struct usb_usbvision *usbvision)
  */
 static int usbvision_set_video_format(struct usb_usbvision *usbvision, int format)
 {
-	static const char proc[] = "usbvision_set_video_format";
 	unsigned char *value = usbvision->ctrl_urb_buffer;
 	int rc;
 
@@ -1631,8 +1630,9 @@ static int usbvision_set_video_format(struct usb_usbvision *usbvision, int forma
 	if ((format != ISOC_MODE_YUV422)
 	    && (format != ISOC_MODE_YUV420)
 	    && (format != ISOC_MODE_COMPRESS)) {
-		printk(KERN_ERR "usbvision: unknown video format %02x, using default YUV420",
-		       format);
+		dev_err(&usbvision->dev->dev,
+			"%s: unknown video format %02x, using default YUV420\n",
+			__func__, format);
 		format = ISOC_MODE_YUV420;
 	}
 	value[0] = 0x0A;  /* TODO: See the effect of the filter */
@@ -1643,8 +1643,9 @@ static int usbvision_set_video_format(struct usb_usbvision *usbvision, int forma
 			     USB_RECIP_ENDPOINT, 0,
 			     (__u16) USBVISION_FILT_CONT, value, 2, HZ);
 	if (rc < 0)
-		printk(KERN_ERR "%s: ERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
-		       proc, rc);
+		dev_err(&usbvision->dev->dev,
+			"%s: ERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
+			__func__, rc);
 
 	usbvision->isoc_mode = format;
 	return rc;
@@ -2180,7 +2181,8 @@ int usbvision_restart_isoc(struct usb_usbvision *usbvision)
 int usbvision_audio_off(struct usb_usbvision *usbvision)
 {
 	if (usbvision_write_reg(usbvision, USBVISION_IOPIN_REG, USBVISION_AUDIO_MUTE) < 0) {
-		printk(KERN_ERR "usbvision_audio_off: can't write reg\n");
+		dev_err(&usbvision->dev->dev,
+			"%s: can't write reg\n", __func__);
 		return -1;
 	}
 	usbvision->audio_mute = 0;
@@ -2192,7 +2194,9 @@ int usbvision_set_audio(struct usb_usbvision *usbvision, int audio_channel)
 {
 	if (!usbvision->audio_mute) {
 		if (usbvision_write_reg(usbvision, USBVISION_IOPIN_REG, audio_channel) < 0) {
-			printk(KERN_ERR "usbvision_set_audio: can't write iopin register for audio switching\n");
+			dev_err(&usbvision->dev->dev,
+				"%s: can't write iopin register for audio switching\n",
+				__func__);
 			return -1;
 		}
 	}
-- 
2.14.1
