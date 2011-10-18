Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:53382 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab1JRJR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 05:17:26 -0400
Date: Tue, 18 Oct 2011 11:13:49 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 14/14] staging/media/as102: add nBox Tuner Dongle support
Message-Id: <20111018111349.fb552e9a.chmooreck@poczta.onet.pl>
In-Reply-To: <20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for nBox Tuner Dongle based on the same chip.

Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>


diff -Nur linux.as102.01-initial/drivers/staging/media/as102/as102_usb_drv.c linux.as102.02-nbox/drivers/staging/media/as102/as102_usb_drv.c
--- linux.as102.01-initial/drivers/staging/media/as102/as102_usb_drv.c	2011-10-14 18:00:19.000000000 +0200
+++ linux.as102.02-nbox/drivers/staging/media/as102/as102_usb_drv.c	2011-10-14 18:21:36.000000000 +0200
@@ -41,6 +41,7 @@
 	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
 	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
 	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
+	{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
 	{ } /* Terminating entry */
 };
 
@@ -50,6 +51,7 @@
 	AS102_REFERENCE_DESIGN,
 	AS102_PCTV_74E,
 	AS102_ELGATO_EYETV_DTT_NAME,
+	AS102_NBOX_DVBT_DONGLE_NAME,
 	NULL /* Terminating entry */
 };
 
diff -Nur linux.as102.01-initial/drivers/staging/as102/as102_usb_drv.h linux.as102.02-nbox/drivers/staging/as102/as102_usb_drv.h
--- linux.as102.01-initial/drivers/staging/media/as102/as102_usb_drv.h	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.02-nbox/drivers/staging/media/as102/as102_usb_drv.h	2011-10-14 18:20:32.000000000 +0200
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
