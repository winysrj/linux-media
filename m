Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37048 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2BNN1S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 08:27:18 -0500
Received: by eaah12 with SMTP id h12so2165716eaa.19
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 05:27:16 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: dheitmueller@kernellabs.com, snjw23@gmail.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] as102: map URB DMA addresses in the driver
Date: Tue, 14 Feb 2012 14:25:00 +0100
Message-Id: <1329225900-20890-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On a set-top-box based on the Broadcom 7405 SoC (MIPS), the Abilis as102 driver
causes a kernel oops while trying to map the URB stream buffers DMA addresses:

CPU 0 Unable to handle kernel paging request at virtual address 007b9900,
epc == 80010cc4, ra == 8039d108

Call Trace:
[<80010cc4>] mips_dma_map_page+0x14/0x108
[<8039d108>] usb_hcd_map_urb_for_dma+0x338/0x4a8
[<8039d540>] usb_hcd_submit_urb+0x2c8/0x8cc
[<e13655d8>] as102_submit_urb_stream+0x64/0xc8 [dvb_as102]
[<e1365680>] as102_usb_start_stream+0x44/0x80 [dvb_as102]
[<e1363628>] as102_dvb_dmx_start_feed+0xb4/0x17c [dvb_as102]
[<803e20f4>] dmx_ts_feed_start_filtering+0x5c/0x134
[<803de454>] dvb_dmxdev_start_feed+0xd4/0x158
[<803dff28>] dvb_dmxdev_filter_start+0x2b8/0x448
[<803e07ac>] dvb_demux_do_ioctl+0x2a0/0x654
[<803ddc8c>] dvb_usercopy+0x124/0x204
[<800d5284>] do_vfs_ioctl+0xa0/0x6c0
[<800d58e8>] sys_ioctl+0x44/0xa8
[<8000ecfc>] stack_done+0x20/0x40

On other boxes based on older SoCs (7401) this doesn't happen, so it looks like
a bug in the kernel specific to MIPS SMP. This issue has been reproduced on
several kernel versions from 2.6.18 to 3.1.0.

Since the base DMA address and the offsets are known, it is possible to map
the DMA addresses of the URB buffers directly in the driver. This workaround
fixes the problem and has been tested on both MIPS and x86 CPUs with success.

By the way, with this fix the driver works perfectly fine on the set-top-box:
both UHF and VHF frequencies are tuned without problems, and zapping is quite
fast. SNR and signal strength reports seems to work fine, too.

The only remaining problem (on both the PC and the set-top-box) is that after
a soft reboot the device is not recognized again by the kernel. It requires
a power cycle (or a manual unplug/replug) to be recognized again. So probably
the device state is not reset properly at shut-down.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_usb_drv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index d775be0..8d2c84c 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -270,6 +270,8 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 		}
 
 		urb->transfer_buffer = dev->stream + (i * AS102_USB_BUF_SIZE);
+		urb->transfer_dma = dev->dma_addr + (i * AS102_USB_BUF_SIZE);
+		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_buffer_length = AS102_USB_BUF_SIZE;
 
 		dev->stream_urb[i] = urb;
-- 
1.7.0.4

