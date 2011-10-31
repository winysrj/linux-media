Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58562 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1JaQZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:48 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444327eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:47 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 09/17] staging: as102: Add Elgato EyeTV DTT Deluxe
Date: Mon, 31 Oct 2011 17:24:47 +0100
Message-Id: <1320078295-3379-10-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Add support for the Elgato EyeTV DTT Deluxe.  Note that the product name
field has not yet been abstracted out, so it will still identify itself
as a PCTV 74e.  The driver was originally built by the chipset manufacturer
so that the product vendor can specify the device name via a #define, but
wasn't setup to support multiple products from the same build of the driver.

Thanks to Joerg Unglaub for suggesting this change.

Suggested-by: Joerg Unglaub <joerg.unglaub@gmail.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_usb_drv.c |    1 +
 drivers/staging/media/as102/as102_usb_drv.h |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 6e79719..d749e06 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -40,6 +40,7 @@ static int as102_release(struct inode *inode, struct file *file);
 static struct usb_device_id as102_usb_id_table[] = {
 	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
 	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
+	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
 	{ } /* Terminating entry */
 };
 
diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
index 3abab6c..a81a895 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
@@ -36,6 +36,11 @@
 #define PCTV_74E_USB_VID		0x2013
 #define PCTV_74E_USB_PID		0x0246
 
+/* Elgato: EyeTV DTT Deluxe */
+#define ELGATO_EYETV_DTT_NAME		"Elgato EyeTV DTT Deluxe"
+#define ELGATO_EYETV_DTT_USB_VID	0x0fd9
+#define ELGATO_EYETV_DTT_USB_PID	0x002c
+
 #if (LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 18))
 void as102_urb_stream_irq(struct urb *urb, struct pt_regs *regs);
 #else
-- 
1.7.4.1

