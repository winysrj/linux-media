Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1KQQfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 11:35:09 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so2230020bke.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 08:35:08 -0800 (PST)
Message-ID: <4EC537B9.7060501@gmail.com>
Date: Thu, 17 Nov 2011 17:35:05 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] staging: as102:  Add support for Sky Italia Digital Key based
 on the same chip.
References: <4EB9304C.5020305@redhat.com> <1320794164-11537-1-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320794164-11537-1-git-send-email-snjw23@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the Sky Italia Digital Key, an USB dongle offered
by Sky Italia to its customers for use with their satellite set-top-boxes.
This is the "green led" model based on the Abilis as102 chip, while the
so called "blue led" model is based on the Avermedia A867 design.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
Signed-off-by: Gianluca Gennari <gennarone@gmail.com>

---
 drivers/staging/media/as102/as102_usb_drv.c |    2 ++
 drivers/staging/media/as102/as102_usb_drv.h |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.c
b/drivers/staging/media/as102/as102_usb_drv.c
index 9faab5b..7bcb28c 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -42,6 +42,7 @@ static struct usb_device_id as102_usb_id_table[] = {
 	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
 	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
 	{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
+	{ USB_DEVICE(SKY_IT_DIGITAL_KEY_USB_VID, SKY_IT_DIGITAL_KEY_USB_PID) },
 	{ } /* Terminating entry */
 };

@@ -52,6 +53,7 @@ static const char * const as102_device_names[] = {
 	AS102_PCTV_74E,
 	AS102_ELGATO_EYETV_DTT_NAME,
 	AS102_NBOX_DVBT_DONGLE_NAME,
+	AS102_SKY_IT_DIGITAL_KEY_NAME,
 	NULL /* Terminating entry */
 };

diff --git a/drivers/staging/media/as102/as102_usb_drv.h
b/drivers/staging/media/as102/as102_usb_drv.h
index 35925b7..fc2884a 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
@@ -47,6 +47,11 @@
 #define NBOX_DVBT_DONGLE_USB_VID	0x0b89
 #define NBOX_DVBT_DONGLE_USB_PID	0x0007

+/* Sky Italia: Digital Key (green led) */
+#define AS102_SKY_IT_DIGITAL_KEY_NAME	"Sky IT Digital Key (green led)"
+#define SKY_IT_DIGITAL_KEY_USB_VID	0x2137
+#define SKY_IT_DIGITAL_KEY_USB_PID	0x0001
+
 void as102_urb_stream_irq(struct urb *urb);

 struct as10x_usb_token_cmd_t {
-- 
1.7.0.4
