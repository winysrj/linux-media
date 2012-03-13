Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:45731 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab2CMIaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 04:30:03 -0400
From: Bhupesh Sharma <bhupesh.sharma@st.com>
To: <linux-usb@vger.kernel.org>
Cc: <linux-media@vger.kernel.org>, <spear-devel@list.st.com>,
	Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH 1/1] usb: gadget/uvc: Remove non-required locking from 'uvc_queue_next_buffer' routine
Date: Tue, 13 Mar 2012 13:59:41 +0530
Message-ID: <26e69442f982b1af8c621737ed5c38ca2254a3c1.1331626759.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the non-required spinlock acquire/release calls on
'queue_irqlock' from 'uvc_queue_next_buffer' routine.

This routine is called from 'video->encode' function (which translates to either
'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in 'uvc_video.c'.
As, the 'video->encode' routines are called with 'queue_irqlock' already held,
so acquiring a 'queue_irqlock' again in 'uvc_queue_next_buffer' routine causes
a spin lock recursion.

A sample kernel crash log is given below (as observed on using 'g_webcam'
with DWC designware 2.0 UDC):

Kernel crash log:
-----------------
BUG: spinlock recursion on CPU#0, swapper/0/0
 lock: 8f824f70, .magic: dead4ead, .owner: swapper/0/0, .owner_cpu: 0
Backtrace:
[<80011b04>] (dump_backtrace+0x0/0x10c) from [<8040bc04>] (dump_stack+0x18/0x1c)
 r6:8f8240b4 r5:8f824f70 r4:805a1b80 r3:805b9d00
[<8040bbec>] (dump_stack+0x0/0x1c) from [<8040e178>] (spin_dump+0x80/0x94)
[<8040e0f8>] (spin_dump+0x0/0x94) from [<8040e1b8>] (spin_bug+0x2c/0x30)
 r5:804e88f4 r4:8f824f70
[<8040e18c>] (spin_bug+0x0/0x30) from [<8019e45c>] (do_raw_spin_lock+0x148/0x16c)
 r5:80586000 r4:8f824f70
[<8019e314>] (do_raw_spin_lock+0x0/0x16c) from [<80411e5c>] (_raw_spin_lock_irqsave+0x18/0x20)
 r9:8f81515c r8:8fb30740 r7:8f824f70 r6:8f8240b4 r5:8f8240d0
r4:60000193
[<80411e44>] (_raw_spin_lock_irqsave+0x0/0x20) from [<802d17e0>] (uvc_queue_next_buffer.part.11+0x2
4/0xa4)
 r4:8f824054 r3:00000000
[<802d17bc>] (uvc_queue_next_buffer.part.11+0x0/0xa4) from [<802d1968>] (uvc_video_encode_isoc+0x10
8/0x118)
 r7:00000110 r6:00070800 r5:8f8240d0 r4:8f824054
[<802d1860>] (uvc_video_encode_isoc+0x0/0x118) from [<802cffb8>] (uvc_video_complete+0x6c/0x134)
 r8:60000193 r7:8f815120 r6:8f824f70 r5:8f824054 r4:8fb30740
r3:802d1860
[<802cff4c>] (uvc_video_complete+0x0/0x134) from [<802cc18c>] (req_done+0xd0/0xf4)
 r8:90810400 r7:805dbcd0 r6:00000000 r5:8f815120 r4:8fb30740
r3:802cff4c
[<802cc0bc>] (req_done+0x0/0xf4) from [<802cda84>] (udc_handle_epn_in_int+0xc0/0x1b8)
 r7:00000400 r6:8059efd4 r5:90810060 r4:8f815120
[<802cd9c4>] (udc_handle_epn_in_int+0x0/0x1b8) from [<802ce950>] (dw_udc_irq+0x10c/0x61c)
[<802ce844>] (dw_udc_irq+0x0/0x61c) from [<8006951c>] (handle_irq_event_percpu+0x54/0x188)
[<800694c8>] (handle_irq_event_percpu+0x0/0x188) from [<80069694>] (handle_irq_event+0x44/0x64)
[<80069650>] (handle_irq_event+0x0/0x64) from [<8006c270>] (handle_fasteoi_irq+0xa0/0x148)
 r6:80586000 r5:8058c894 r4:8058c840 r3:00000000
[<8006c1d0>] (handle_fasteoi_irq+0x0/0x148) from [<80068d28>] (generic_handle_irq+0x34/0x48)
 r5:80584b6c r4:8059f8b8
[<80068cf4>] (generic_handle_irq+0x0/0x48) from [<8000efa8>] (handle_IRQ+0x54/0xb4)
[<8000ef54>] (handle_IRQ+0x0/0xb4) from [<8000849c>] (gic_handle_irq+0x2c/0xb0)
 r8:8059eff8 r7:80587f38 r6:fec80100 r5:8059eff8 r4:00000000
r3:0000005e
[<80008470>] (gic_handle_irq+0x0/0xb0) from [<8000dd80>] (__irq_svc+0x40/0x60)
Exception stack(0x80587f38 to 0x80587f80)
7f20:                                                       ffffffed 00000000
7f40: 80587f80 00000000 80586000 805f1988 80413864 805a2bb8 80586000 411fc091
7f60: 00000000 80587f8c 80587f90 80587f80 8000f2a4 8000f2a8 60000013 ffffffff
 r8:80586000 r7:80587f6c r6:ffffffff r5:60000013 r4:8000f2a8
r3:8000f2a4
[<8000f27c>] (default_idle+0x0/0x30) from [<8000f52c>] (cpu_idle+0xd8/0xf4)
[<8000f454>] (cpu_idle+0x0/0xf4) from [<803fd0e0>] (rest_init+0x64/0x7c)
 r8:0000406a r7:805a2bac r6:809778c0 r5:8057b144 r4:8059f690
r3:00000000
[<803fd07c>] (rest_init+0x0/0x7c) from [<805527ec>] (start_kernel+0x294/0x2e8)
[<80552558>] (start_kernel+0x0/0x2e8) from [<00008044>] (0x8044)

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
---
 drivers/usb/gadget/uvc_queue.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index d776adb..7ef5efb 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -543,6 +543,7 @@ done:
 	return ret;
 }
 
+/* called with &queue_irqlock held.. */
 static struct uvc_buffer *
 uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer *buf)
 {
@@ -556,14 +557,12 @@ uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer *buf)
 		return buf;
 	}
 
-	spin_lock_irqsave(&queue->irqlock, flags);
 	list_del(&buf->queue);
 	if (!list_empty(&queue->irqqueue))
 		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
 					   queue);
 	else
 		nextbuf = NULL;
-	spin_unlock_irqrestore(&queue->irqlock, flags);
 
 	buf->buf.sequence = queue->sequence++;
 	do_gettimeofday(&buf->buf.timestamp);
-- 
1.7.2.2

