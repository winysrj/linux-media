Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58924
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751262AbdCQKqb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 06:46:31 -0400
Received: from localhost (localhost [127.0.0.1])
        by osg.samsung.com (Postfix) with ESMTP id 99E09A1493
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 10:36:44 +0000 (UTC)
Received: from osg.samsung.com ([127.0.0.1])
        by localhost (s-opensource.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PKXfgv7NJClg for <linux-media@vger.kernel.org>;
        Fri, 17 Mar 2017 10:36:43 +0000 (UTC)
Received: from vento.lan (unknown [186.213.245.81])
        by osg.samsung.com (Postfix) with ESMTPSA id 2821EA1492
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 10:36:42 +0000 (UTC)
From: Mauro Carvalho Chehab <mchehab@s-opensource.com> (by way of Mauro
        Carvalho Chehab <mchehab@s-opensource.com>)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Date: Thu, 16 Mar 2017 21:08:40 -0300
Message-Id: <5c313be6d2f3c786d1f159a74758263a2ae0ad66.1489709097.git.mchehab@s-opensource.com>
Subject: [PATCH RFC] dwc2: Don't assume URB transfer_buffer are
 dword-aligned
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dwc2 hardware doesn't like to do DMA transfers without
aligning data in DWORD. The driver also assumes that, even
when there's no DMA, at dwc2_read_packet().

That cause buffer overflows, preventing some drivers to work.

In the specific case of uvc_driver, it uses an array where
it caches the content of video controls, passing it to the
USB stack via usb_control_msg(). Typical controls use 1 or 2
bytes. The net result is that other values of the buffer
gets overriden when this function is called.

Fix it by changing the logic at dwc2_alloc_dma_aligned_buffer()
to ensure that the buffer used for DMA will be DWORD-aligned.

Detected with uvc driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

On Raspberry Pi 3, I was unable to test  dwc2_read_packet(), as this was
never called there. However, the change at the second hunk, e. g. at
dwc2_alloc_dma_aligned_buffer() made UVC to answer the same way
as on x86, while reading the values for the device controls.

 drivers/usb/dwc2/hcd.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index a73722e27d07..c53d3c24d5b5 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -572,20 +572,26 @@ u32 dwc2_calc_frame_interval(struct dwc2_hsotg *hsotg)
 void dwc2_read_packet(struct dwc2_hsotg *hsotg, u8 *dest, u16 bytes)
 {
 	u32 __iomem *fifo = hsotg->regs + HCFIFO(0);
-	u32 *data_buf = (u32 *)dest;
-	int word_count = (bytes + 3) / 4;
-	int i;
-
-	/*
-	 * Todo: Account for the case where dest is not dword aligned. This
-	 * requires reading data from the FIFO into a u32 temp buffer, then
-	 * moving it into the data buffer.
-	 */
+	u32 *data_buf = (u32 *)dest, tmp;
+	int word_count = bytes >> 2;
+	int i, j;
 
 	dev_vdbg(hsotg->dev, "%s(%p,%p,%d)\n", __func__, hsotg, dest, bytes);
 
 	for (i = 0; i < word_count; i++, data_buf++)
 		*data_buf = dwc2_readl(fifo);
+
+	/* Handle the case where the buffer is not dword-aligned */
+	if (bytes & 0x3) {
+		u8 *buf = (u8 *)data_buf;
+
+		tmp = dwc2_readl(fifo);
+
+		i <<= 2;
+		for (j = 0; i < bytes; j++, i++, dest++)
+			*buf = tmp >> (8 * j);
+	}
+
 }
 
 /**
@@ -2594,8 +2600,9 @@ static int dwc2_alloc_dma_aligned_buffer(struct urb *urb, gfp_t mem_flags)
 	size_t kmalloc_size;
 
 	if (urb->num_sgs || urb->sg ||
-	    urb->transfer_buffer_length == 0 ||
-	    !((uintptr_t)urb->transfer_buffer & (DWC2_USB_DMA_ALIGN - 1)))
+	    urb->transfer_buffer_length == 0 || (
+	    !((uintptr_t)urb->transfer_buffer & (DWC2_USB_DMA_ALIGN - 1)) &&
+	    !((uintptr_t)(urb->transfer_buffer + urb->transfer_buffer_length) & (DWC2_USB_DMA_ALIGN - 1))))
 		return 0;
 
 	/* Allocate a buffer with enough padding for alignment */
-- 
2.9.3
