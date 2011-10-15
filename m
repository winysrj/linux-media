Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:39498 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1JOUy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 16:54:28 -0400
Message-ID: <4E99F302.8050205@poczta.onet.pl>
Date: Sat, 15 Oct 2011 22:54:26 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 2/7] staging/as102: add new device nBox DVB-T Dongle
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E9992F9.7000101@poczta.onet.pl>
In-Reply-To: <4E9992F9.7000101@poczta.onet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

staging/as102: add new device nBox DVB-T Dongle

Add nBox DVB-T Dongle tuner based on 74e chip.

Tested by me on amd64.

Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
Cc: Greg HK<gregkh@suse.de>

diff -Nur linux.as102.01-initial/drivers/staging/as102/as102_usb_drv.c linux.as102.02-nbox/drivers/staging/as102/as102_usb_drv.c
--- linux.as102.01-initial/drivers/staging/as102/as102_usb_drv.c	2011-10-14 18:00:19.000000000 +0200
+++ linux.as102.02-nbox/drivers/staging/as102/as102_usb_drv.c	2011-10-14 18:21:36.000000000 +0200
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
--- linux.as102.01-initial/drivers/staging/as102/as102_usb_drv.h	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.02-nbox/drivers/staging/as102/as102_usb_drv.h	2011-10-14 18:20:32.000000000 +0200
@@ -42,6 +42,11 @@
  #define ELGATO_EYETV_DTT_USB_VID	0x0fd9
  #define ELGATO_EYETV_DTT_USB_PID	0x002c

+/* nBox: nBox DVB-T Dongle */
+#define AS102_NBOX_DVBT_DONGLE_NAME	"nBox DVB-T Dongle"
+#define NBOX_DVBT_DONGLE_USB_VID	0x0b89
+#define NBOX_DVBT_DONGLE_USB_PID	0x0007
+
  #if (LINUX_VERSION_CODE<= KERNEL_VERSION(2, 6, 18))
  void as102_urb_stream_irq(struct urb *urb, struct pt_regs *regs);
  #else




