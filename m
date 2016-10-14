Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59136 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757029AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Insu Yun <wuninsu@gmail.com>,
        Geliang Tang <geliangtang@163.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 48/57] [media] usbvision: don't break long lines
Date: Fri, 14 Oct 2016 17:20:36 -0300
Message-Id: <7beaef595646ec4d57339654c1d7be273ba25ee0.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/usbvision/usbvision-core.c  | 15 +++++----------
 drivers/media/usb/usbvision/usbvision-video.c |  3 +--
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index c23bf73a68ea..4aed365da61d 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1656,8 +1656,7 @@ static int usbvision_set_video_format(struct usb_usbvision *usbvision, int forma
 			     (__u16) USBVISION_FILT_CONT, value, 2, HZ);
 
 	if (rc < 0) {
-		printk(KERN_ERR "%s: ERROR=%d. USBVISION stopped - "
-		       "reconnect or reload driver.\n", proc, rc);
+		printk(KERN_ERR "%s: ERROR=%d. USBVISION stopped - reconnect or reload driver.\n", proc, rc);
 	}
 	usbvision->isoc_mode = format;
 	return rc;
@@ -1890,8 +1889,7 @@ static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
 			     (__u16) USBVISION_INTRA_CYC, value, 5, HZ);
 
 	if (rc < 0) {
-		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - "
-		       "reconnect or reload driver.\n", proc, rc);
+		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - reconnect or reload driver.\n", proc, rc);
 		return rc;
 	}
 
@@ -1921,8 +1919,7 @@ static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
 			     (__u16) USBVISION_PCM_THR1, value, 6, HZ);
 
 	if (rc < 0) {
-		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - "
-		       "reconnect or reload driver.\n", proc, rc);
+		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - reconnect or reload driver.\n", proc, rc);
 	}
 	return rc;
 }
@@ -1960,8 +1957,7 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 
 	rc = usbvision_write_reg(usbvision, USBVISION_VIN_REG1, value[0]);
 	if (rc < 0) {
-		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - "
-		       "reconnect or reload driver.\n", proc, rc);
+		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - reconnect or reload driver.\n", proc, rc);
 		return rc;
 	}
 
@@ -2026,8 +2022,7 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_ENDPOINT, 0,
 			     (__u16) USBVISION_LXSIZE_I, value, 8, HZ);
 	if (rc < 0) {
-		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - "
-		       "reconnect or reload driver.\n", proc, rc);
+		printk(KERN_ERR "%sERROR=%d. USBVISION stopped - reconnect or reload driver.\n", proc, rc);
 		return rc;
 	}
 
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index c8b4eb2ee7a2..74d3fb6a48ba 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1456,8 +1456,7 @@ static int usbvision_probe(struct usb_interface *intf,
 	}
 
 	if (interface->desc.bNumEndpoints < 2) {
-		dev_err(&intf->dev, "interface %d has %d endpoints, but must"
-		    " have minimum 2\n", ifnum, interface->desc.bNumEndpoints);
+		dev_err(&intf->dev, "interface %d has %d endpoints, but must have minimum 2\n", ifnum, interface->desc.bNumEndpoints);
 		ret = -ENODEV;
 		goto err_usb;
 	}
-- 
2.7.4


