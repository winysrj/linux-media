Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36868 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933265AbdC3KqL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:46:11 -0400
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
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH v2 22/22] usb: document that URB transfer_buffer should be aligned
Date: Thu, 30 Mar 2017 07:45:56 -0300
Message-Id: <0627ecd69dba49d704f61ff20b1ecbd873a10275.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several host controllers, commonly found on ARM, like dwc2,
require buffers that are CPU-word aligned for they to work.

Failing to do that will cause random troubles at the caller
drivers, causing them to fail.

Document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/driver-api/usb/URB.rst | 12 ++++++++++++
 drivers/usb/core/message.c           | 15 +++++++++++++++
 include/linux/usb.h                  | 12 ++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/Documentation/driver-api/usb/URB.rst b/Documentation/driver-api/usb/URB.rst
index 810ceb0e71bb..2f3db660e613 100644
--- a/Documentation/driver-api/usb/URB.rst
+++ b/Documentation/driver-api/usb/URB.rst
@@ -271,6 +271,18 @@ If you specify your own start frame, make sure it's several frames in advance
 of the current frame.  You might want this model if you're synchronizing
 ISO data with some other event stream.
 
+ .. warning::
+
+   Several host drivers have a 32-bits or 64-bits DMA transfer word size,
+   with usually matches the CPU word. Due to such restriction, you should
+   warrant that the @transfer_buffer is DWORD aligned, on 32 bits system, or
+   QDWORD aligned, on 64 bits system. You should also ensure that the
+   buffer has enough space for PAD bits.
+
+   This condition is satisfied if you pass a buffer directly allocated by
+   kmalloc(), but this may not be the case if the driver allocates a bigger
+   buffer and point to a random place inside it.
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
index 7e68259360de..5739d4422343 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1373,6 +1373,18 @@ typedef void (*usb_complete_t)(struct urb *);
  * capable, assign NULL to it, so that usbmon knows not to use the value.
  * The setup_packet must always be set, so it cannot be located in highmem.
  *
+ * .. warning::
+ *
+ *   Several host drivers have a 32-bits or 64-bits DMA transfer word size,
+ *   with usually matches the CPU word. Due to such restriction, you should
+ *   warrant that the @transfer_buffer is DWORD aligned, on 32 bits system, or
+ *   QDWORD aligned, on 64 bits system. You should also ensure that the
+ *   buffer has enough space for PAD bits.
+ *
+ *   This condition is satisfied if you pass a buffer directly allocated by
+ *   kmalloc(), but this may not be the case if the driver allocates a bigger
+ *   buffer and point to a random place inside it.
+ *
  * Initialization:
  *
  * All URBs submitted must initialize the dev, pipe, transfer_flags (may be
-- 
2.9.3
