Return-path: <mchehab@pedra>
Received: from mail.windriver.com ([147.11.1.11]:63650 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0ICJyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Sep 2010 05:54:11 -0400
From: Jason Wang <jason77.wang@gmail.com>
To: mchehab@redhat.com, moinejf@free.fr
Cc: linux-media@vger.kernel.org
Subject: [PATCH] V4L/DVB: gspca - main: add urb buffer flags
Date: Fri,  3 Sep 2010 17:57:19 +0800
Message-Id: <1283507839-4162-1-git-send-email-jason77.wang@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

When i plug a ZC3xx usb webcam to the host port of fsl_imx51pdk(arm),
the system crashes like this:

usb 1-1: new full speed USB device using fsl-ehci and address 2
gspca: probing 0ac8:301b
zc3xx: probe sensor -> 000a
zc3xx: Find Sensor PB0330. Chip revision 0
input: zc3xx as /devices/platform/fsl-ehci.0/usb1/1-1/input/input0
gspca: video1 created
gspca: found int in endpoint: 0x82, buffer_len=8, interval=10
kernel BUG at /home/hwang4/work/build/51/build/linux/arch/arm/mm/\
dma-mapping.c:411!
Unable to handle kernel NULL pointer dereference at virtual address \
00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1] PREEMPT

This is because we alloc buffer for an urb through usb_buffer_alloc,
the alloced buffer is already in DMA coherent region, so we should
set the flag of this urb to URB_NO_TRANSFER_DMA_MAP, otherwise when
we submit this urb, the hcd core will handle this address as an
non-DMA address and call dma_map_single/sg to map it. On arm
architecture, dma_map_single a DMA coherent address will be catched
by a BUG_ON().

Signed-off-by: Jason Wang <jason77.wang@gmail.com>
---
 drivers/media/video/gspca/gspca.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index b984610..78abc1c 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -223,6 +223,7 @@ static int alloc_and_submit_int_urb(struct gspca_dev *gspca_dev,
 		usb_rcvintpipe(dev, ep->bEndpointAddress),
 		buffer, buffer_len,
 		int_irq, (void *)gspca_dev, interval);
+	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	gspca_dev->int_urb = urb;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {
-- 
1.5.6.5

