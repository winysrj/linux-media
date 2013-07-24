Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:63328 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3GXM7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 08:59:36 -0400
Received: by mail-we0-f177.google.com with SMTP id m46so1515577wev.8
        for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 05:59:35 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, crope@iki.fi, awalls@md.metrocast.net,
	Luis Alves <ljalvs@gmail.com>
Subject: [PATCH] cx23885[v3]: Fix interrupt storm when enabling IR receiver.
Date: Wed, 24 Jul 2013 13:59:45 +0100
Message-Id: <1374670785-2595-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

New patch for this issue. Changes:
 - Added flatiron readreg and writereg functions prototypes (new header file).
 - Modified the av work handler to preserve all other register bits when dealing
   with the interrupt flag.

Regards,
Luis


Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-av.c    |   13 +++++++++++++
 drivers/media/pci/cx23885/cx23885-video.c |    4 ++--
 drivers/media/pci/cx23885/cx23885-video.h |   28 ++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/pci/cx23885/cx23885-video.h

diff --git a/drivers/media/pci/cx23885/cx23885-av.c b/drivers/media/pci/cx23885/cx23885-av.c
index e958a01..c443b7a 100644
--- a/drivers/media/pci/cx23885/cx23885-av.c
+++ b/drivers/media/pci/cx23885/cx23885-av.c
@@ -23,6 +23,7 @@
 
 #include "cx23885.h"
 #include "cx23885-av.h"
+#include "cx23885-video.h"
 
 void cx23885_av_work_handler(struct work_struct *work)
 {
@@ -32,5 +33,17 @@ void cx23885_av_work_handler(struct work_struct *work)
 
 	v4l2_subdev_call(dev->sd_cx25840, core, interrupt_service_routine,
 			 PCI_MSK_AV_CORE, &handled);
+
+	/* Getting here with the interrupt not handled
+	   then probbaly flatiron does have pending interrupts.
+	*/
+	if (!handled) {
+		/* clear left and right adc channel interrupt request flag */
+		cx23885_flatiron_write(dev, 0x1f,
+			cx23885_flatiron_read(dev, 0x1f) | 0x80);
+		cx23885_flatiron_write(dev, 0x23,
+			cx23885_flatiron_read(dev, 0x23) | 0x80);
+	}
+
 	cx23885_irq_enable(dev, PCI_MSK_AV_CORE);
 }
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index e33d1a7..f4e7cef 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -417,7 +417,7 @@ static void res_free(struct cx23885_dev *dev, struct cx23885_fh *fh,
 	mutex_unlock(&dev->lock);
 }
 
-static int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data)
+int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data)
 {
 	/* 8 bit registers, 8 bit values */
 	u8 buf[] = { reg, data };
@@ -428,7 +428,7 @@ static int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data)
 	return i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
 }
 
-static u8 cx23885_flatiron_read(struct cx23885_dev *dev, u8 reg)
+u8 cx23885_flatiron_read(struct cx23885_dev *dev, u8 reg)
 {
 	/* 8 bit registers, 8 bit values */
 	int ret;
diff --git a/drivers/media/pci/cx23885/cx23885-video.h b/drivers/media/pci/cx23885/cx23885-video.h
new file mode 100644
index 0000000..6e88214
--- /dev/null
+++ b/drivers/media/pci/cx23885/cx23885-video.h
@@ -0,0 +1,28 @@
+/*
+ *  Driver for the Conexant CX23885/7/8 PCIe bridge
+ *
+ *  AV device support routines - non-input, non-vl42_subdev routines
+ *
+ *  Copyright (C) 2010  Andy Walls <awalls@md.metrocast.net>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#ifndef _CX23885_VIDEO_H_
+#define _CX23885_VIDEO_H_
+int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data);
+u8 cx23885_flatiron_read(struct cx23885_dev *dev, u8 reg);
+#endif
-- 
1.7.9.5

