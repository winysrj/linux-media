Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:49191 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab1JRJRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 05:17:22 -0400
Date: Tue, 18 Oct 2011 11:13:45 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 13/14] staging/media/as102: fix compile
Message-Id: <20111018111345.dfdd7a8f.chmooreck@poczta.onet.pl>
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

Replace usb_buffer_free() and usb_buffer_alloc() by usb_free_coherent() and usb_alloc_coherent() making it compile in current tree.
Add driver to parent Makefile and Kconfig

Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>

diff -Nur linux.as102.pulled/drivers/staging/Kconfig linux.as102.compiling/drivers/staging/Kconfig
--- linux.as102.pulled/drivers/staging/Kconfig	2011-10-14 15:26:42.000000000 +0200
+++ linux.as102.compiling/drivers/staging/Kconfig	2011-10-17 22:26:48.000000000 +0200
@@ -150,4 +150,6 @@
 
 source "drivers/staging/nvec/Kconfig"
 
+source "drivers/staging/media/as102/Kconfig"
+
 endif # STAGING
diff -Nur linux.as102.pulled/drivers/staging/Makefile linux.as102.compiling/drivers/staging/Makefile
--- linux.as102.pulled/drivers/staging/Makefile	2011-10-14 15:26:42.000000000 +0200
+++ linux.as102.compiling/drivers/staging/Makefile	2011-10-17 22:17:39.439874425 +0200
@@ -66,3 +66,4 @@
 obj-$(CONFIG_DRM_PSB)		+= gma500/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_MFD_NVEC)		+= nvec/
+obj-$(CONFIG_DVB_AS102)		+= media/as102/
diff -Nur linux.as102.pulled/drivers/staging/media/as102/as102_usb_drv.c linux.as102.compiling/drivers/staging/media/as102/as102_usb_drv.c
--- linux.as102.pulled/drivers/staging/media/as102/as102_usb_drv.c	2011-10-17 22:05:15.996841251 +0200
+++ linux.as102.compiling/drivers/staging/media/as102/as102_usb_drv.c	2011-10-17 22:22:33.317887538 +0200
@@ -238,7 +238,7 @@
 	for (i = 0; i < MAX_STREAM_URB; i++)
 		usb_free_urb(dev->stream_urb[i]);
 
-	usb_buffer_free(dev->bus_adap.usb_dev,
+	usb_free_coherent(dev->bus_adap.usb_dev,
 			MAX_STREAM_URB * AS102_USB_BUF_SIZE,
 			dev->stream,
 			dev->dma_addr);
@@ -251,7 +251,7 @@
 
 	ENTER();
 
-	dev->stream = usb_buffer_alloc(dev->bus_adap.usb_dev,
+	dev->stream = usb_alloc_coherent(dev->bus_adap.usb_dev,
 				       MAX_STREAM_URB * AS102_USB_BUF_SIZE,
 				       GFP_KERNEL,
 				       &dev->dma_addr);
