Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo13.poczta.onet.pl ([213.180.142.144]:37386 "EHLO
	smtpo13.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1JRT7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 15:59:48 -0400
Date: Tue, 18 Oct 2011 21:59:45 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [RESEND PATCH 9/14] staging/media/as102: Add Elgato EyeTV DTT
 Deluxe
Message-ID: <20111018215945.529b5d86@darkstar>
In-Reply-To: <20111018111243.0cb4e5cf.chmooreck@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111243.0cb4e5cf.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:
# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267318991 18000
# Node ID 4a82558f6df8b957bc623d854a118a5da32dead2
# Parent  89de57601df871f6d951ca13bf52b136f9eadddf
as102: Add Elgato EyeTV DTT Deluxe

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Add support for the Elgato EyeTV DTT Deluxe.  Note that the product
name field has not yet been abstracted out, so it will still identify
itself as a PCTV 74e.  The driver was originally built by the chipset
manufacturer so that the product vendor can specify the deivce name via
a #define, but wasn't setup to support multiple products from the same build of
the driver.

Thanks to Joerg Unglaub for suggesting this change.

Priority: normal

Signed-off-by: Joerg Unglaub <joerg.unglaub@gmail.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>

diff --git linux/drivers/staging/media/as102/as102_usb_drv.c linuxb/drivers/staging/media/as102/as102_usb_drv.c
--- linux/drivers/staging/media/as102/as102_usb_drv.c
+++ linuxb/drivers/staging/media/as102/as102_usb_drv.c
@@ -40,6 +40,7 @@
 static struct usb_device_id as102_usb_id_table[] = {
 	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
 	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
+	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
 	{ } /* Terminating entry */
 };
 
diff --git linux/drivers/staging/media/as102/as102_usb_drv.h linuxb/drivers/staging/media/as102/as102_usb_drv.h
--- linux/drivers/staging/media/as102/as102_usb_drv.h
+++ linuxb/drivers/staging/media/as102/as102_usb_drv.h
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
