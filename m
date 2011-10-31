Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58562 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1JaQ0A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:26:00 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444327eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:59 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 15/17] staging: as102: Add nBox Tuner Dongle support
Date: Mon, 31 Oct 2011 17:24:53 +0100
Message-Id: <1320078295-3379-16-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Piotr Chmura <chmooreck@poczta.onet.pl>

Add support for nBox Tuner Dongle based on the same chip.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_usb_drv.c |    2 ++
 drivers/staging/media/as102/as102_usb_drv.h |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 2586d55..70b21f3 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -41,6 +41,7 @@ static struct usb_device_id as102_usb_id_table[] = {
 	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
 	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
 	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
+	{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
 	{ } /* Terminating entry */
 };
 
@@ -50,6 +51,7 @@ static const char *as102_device_names[] = {
 	AS102_REFERENCE_DESIGN,
 	AS102_PCTV_74E,
 	AS102_ELGATO_EYETV_DTT_NAME,
+	AS102_NBOX_DVBT_DONGLE_NAME,
 	NULL /* Terminating entry */
 };
 
diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
index a741462..da34d32 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
@@ -42,6 +42,11 @@
 #define ELGATO_EYETV_DTT_USB_VID	0x0fd9
 #define ELGATO_EYETV_DTT_USB_PID	0x002c
 
+/* nBox: nBox DVB-T Dongle */
+#define AS102_NBOX_DVBT_DONGLE_NAME	"nBox DVB-T Dongle"
+#define NBOX_DVBT_DONGLE_USB_VID	0x0b89
+#define NBOX_DVBT_DONGLE_USB_PID	0x0007
+
 #if (LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 18))
 void as102_urb_stream_irq(struct urb *urb, struct pt_regs *regs);
 #else
-- 
1.7.4.1

