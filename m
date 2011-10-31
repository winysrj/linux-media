Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab1JaQZ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:57 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444413eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:57 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 14/17] staging: as102: Enable compilation
Date: Mon, 31 Oct 2011 17:24:52 +0100
Message-Id: <1320078295-3379-15-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Piotr Chmura <chmooreck@poczta.onet.pl>

Fix compilation errors in the USB driver by replacing usb_buffer_free(),
usb_buffer_alloc() with usb_free_coherent() and usb_alloc_coherent().
Add entries for the driver in parent Makefile and Kconfig.

[snjw23@gmail.com: minor edit to changelog]
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/Kconfig                     |    2 ++
 drivers/staging/Makefile                    |    1 +
 drivers/staging/media/as102/as102_usb_drv.c |    4 ++--
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index a329613..19bd99f 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -148,4 +148,6 @@ source "drivers/staging/mei/Kconfig"
 
 source "drivers/staging/nvec/Kconfig"
 
+source "drivers/staging/media/as102/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index d7a5a04..0baceb6 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -65,3 +65,4 @@ obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
 obj-$(CONFIG_DRM_PSB)		+= gma500/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_MFD_NVEC)		+= nvec/
+obj-$(CONFIG_DVB_AS102)		+= media/as102/
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 3a3dd77..2586d55 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -238,7 +238,7 @@ static void as102_free_usb_stream_buffer(struct as102_dev_t *dev)
 	for (i = 0; i < MAX_STREAM_URB; i++)
 		usb_free_urb(dev->stream_urb[i]);
 
-	usb_buffer_free(dev->bus_adap.usb_dev,
+	usb_free_coherent(dev->bus_adap.usb_dev,
 			MAX_STREAM_URB * AS102_USB_BUF_SIZE,
 			dev->stream,
 			dev->dma_addr);
@@ -251,7 +251,7 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 
 	ENTER();
 
-	dev->stream = usb_buffer_alloc(dev->bus_adap.usb_dev,
+	dev->stream = usb_alloc_coherent(dev->bus_adap.usb_dev,
 				       MAX_STREAM_URB * AS102_USB_BUF_SIZE,
 				       GFP_KERNEL,
 				       &dev->dma_addr);
-- 
1.7.4.1

