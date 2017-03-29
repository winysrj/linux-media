Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44561 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753558AbdC2Syg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:54:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Mosberger <davidm@egauge.net>,
        Oliver Neukum <oneukum@suse.com>,
        Roger Quadros <rogerq@ti.com>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Subject: [PATCH 22/22] usb: document that URB transfer_buffer should be aligned
Date: Wed, 29 Mar 2017 15:54:21 -0300
Message-Id: <ee3ea6944e095fa3b2383697a967f4bc9e2d9631.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several host controllers, commonly found on ARM, like dwc2,
require buffers that are CPU-word aligned for they to work.

Failing to do that will cause random troubles at the caller
drivers, causing them to fail.

Document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/driver-api/usb/URB.rst | 18 ++++++++++++++++++
 drivers/usb/core/message.c           | 15 +++++++++++++++
 include/linux/usb.h                  | 18 ++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/Documentation/driver-api/usb/URB.rst b/Documentation/driver-api/usb/URB.rst
index d9ea6a3996e7..b83b557e9891 100644
--- a/Documentation/driver-api/usb/URB.rst
+++ b/Documentation/driver-api/usb/URB.rst
@@ -274,6 +274,24 @@ If you specify your own start frame, make sure it's several frames in advance
 of the current frame.  You might want this model if you're synchronizing
 ISO data with some other event stream.
 
+.. note::
+
+   Several host drivers require that the ``transfer_buffer`` to be aligned
+   with the CPU word size (e. g. DWORD for 32 bits, QDWORD for 64 bits).
+   It is up to USB drivers should ensure that they'll only pass buffers
+   with such alignments.
+
+   Please also notice that, due to such restriction, the host driver
+   may also override PAD bytes at the end of the ``transfer_buffer``, up to the
+   size of the CPU word.
+
+   Please notice that ancillary routines that transfer URBs, like
+   usb_control_msg() also have such restriction.
+
+   Such word alignment condition is normally ensured if the buffer is
+   allocated with kmalloc(), but this may not be the case if the driver
+   allocates a bigger buffer and point to a random place inside it.
+
 
 How to start interrupt (INT) transfers?
 =======================================
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 4c38ea41ae96..1662a4446475 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -128,6 +128,21 @@ static int usb_internal_control_msg(struct usb_device *usb_dev,
  * make sure your disconnect() method can wait for it to complete. Since you
  * don't have a handle on the URB used, you can't cancel the request.
  *
+ * .. note::
+ *
+ *   Several host drivers require that the @data buffer to be aligned
+ *   with the CPU word size (e. g. DWORD for 32 bits, QDWORD for 64 bits).
+ *   It is up to USB drivers should ensure that they'll only pass buffers
+ *   with such alignments.
+ *
+ *   Please also notice that, due to such restriction, the host driver
+ *   may also override PAD bytes at the end of the @data buffer, up to the
+ *   size of the CPU word.
+ *
+ *   Such word alignment condition is normally ensured if the buffer is
+ *   allocated with kmalloc(), but this may not be the case if the driver
+ *   allocates a bigger buffer and point to a random place inside it.
+ *
  * Return: If successful, the number of bytes transferred. Otherwise, a negative
  * error number.
  */
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 7e68259360de..8b5ad6624708 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1373,6 +1373,24 @@ typedef void (*usb_complete_t)(struct urb *);
  * capable, assign NULL to it, so that usbmon knows not to use the value.
  * The setup_packet must always be set, so it cannot be located in highmem.
  *
+ * .. note::
+ *
+ *   Several host drivers require that the @transfer_buffer to be aligned
+ *   with the CPU word size (e. g. DWORD for 32 bits, QDWORD for 64 bits).
+ *   It is up to USB drivers should ensure that they'll only pass buffers
+ *   with such alignments.
+ *
+ *   Please also notice that, due to such restriction, the host driver
+ *   may also override PAD bytes at the end of the @transfer_buffer, up to the
+ *   size of the CPU word.
+ *
+ *   Please notice that ancillary routines that start URB transfers, like
+ *   usb_control_msg() also have such restriction.
+ *
+ *   Such word alignment condition is normally ensured if the buffer is
+ *   allocated with kmalloc(), but this may not be the case if the driver
+ *   allocates a bigger buffer and point to a random place inside it.
+ *
  * Initialization:
  *
  * All URBs submitted must initialize the dev, pipe, transfer_flags (may be
-- 
2.9.3
