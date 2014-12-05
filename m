Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37215 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaLEUEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 15:04:06 -0500
Date: Fri, 5 Dec 2014 21:03:57 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Felipe Balbi <balbi@ti.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] usb: hcd: get/put device and hcd for hcd_buffers()
Message-ID: <20141205200357.GA1586@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Consider the following scenario:
- plugin a webcam
- play the stream via gst-launch-0.10 v4l2src device=/dev/video0…
- remove the USB-HCD during playback via "rmmod $HCD"

and now wait for the crash

|musb-hdrc musb-hdrc.2.auto: remove, state 1
|usb usb2: USB disconnect, device number 1
|usb 2-1: USB disconnect, device number 3
|uvcvideo: Failed to resubmit video URB (-19).
|musb-hdrc musb-hdrc.2.auto: USB bus 2 deregistered
|musb-hdrc musb-hdrc.1.auto: remove, state 4
|usb usb1: USB disconnect, device number 1
|musb-hdrc musb-hdrc.1.auto: USB bus 1 deregistered
|Unable to handle kernel paging request at virtual address 6b6b6b6f
|pgd = c0004000
|[6b6b6b6f] *pgd=00000000
|Internal error: Oops: 5 [#1] ARM
|Modules linked in: uvcvideo]
|CPU: 0 PID: 2613 Comm: gst-launch-0.10 Tainted: G        W    3.14.25+ #40
|task: ec2b8100 ti: ec38e000 task.ti: ec38e000
|PC is at hcd_buffer_free+0x64/0xc0
|LR is at uvc_free_urb_buffers+0x34/0x50 [uvcvideo]
|Process gst-launch-0.10 (pid: 2613, stack limit = 0xec38e240)
|[<c03a07e8>] (hcd_buffer_free)
|[<bf2f0c78>] (uvc_free_urb_buffers [uvcvideo])
|[<bf2f33dc>] (uvc_video_enable [uvcvideo])
|[<bf2ef150>] (uvc_v4l2_release [uvcvideo])
|[<bf2ac318>] (v4l2_release [videodev])
|[<c0103334>] (__fput)
|[<c005b618>] (task_work_run)
|[<c00417a0>] (do_exit)
|[<c0041ebc>] (do_group_exit)

as part of the device-removal the HCD removes its dma-buffers, the HCD
structure itself and even the struct device is gone. That means if UVC
removes its URBs after its last user (/dev/videoX) is gone and not from
the ->disconnect() callback then it is too late because the HCD might
gone.

First, I fixed by in the UVC driver by ignoring the UVC_SC_VIDEOSTREAMING
in its ->disconnect callback and calling uvc_video_enable(, 0) in
uvc_unregister_video(). But then I though that it might not be clever to
release that memory if there is userspace using it.

So instead, I hold the device struct in the HCD and the HCD struct on
every USB-buf-alloc. That means after a disconnect we still have a
refcount on usb_hcd and device and it will be cleaned "later" once the
last USB-buffer is released.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
With this applied, I only see this three times (which is not new)

| ------------[ cut here ]------------
| WARNING: CPU: 0 PID: 1755 at fs/sysfs/group.c:219 sysfs_remove_group+0x88/0x98()
| sysfs group c08a70d4 not found for kobject 'event4'
| Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev ipv6 musb_hdrc udc_core us]
| CPU: 0 PID: 1755 Comm: gst-launch-0.10 Not tainted 3.18.0-rc7-00065-gabcefb342fbf-dirty #1813
| [<c00152a8>] (unwind_backtrace) from [<c0011a48>] (show_stack+0x10/0x14)
| [<c0011a48>] (show_stack) from [<c056450c>] (dump_stack+0x80/0x9c)
| [<c056450c>] (dump_stack) from [<c00401a0>] (warn_slowpath_common+0x68/0x8c)
| [<c00401a0>] (warn_slowpath_common) from [<c0040258>] (warn_slowpath_fmt+0x30/0x40)
| [<c0040258>] (warn_slowpath_fmt) from [<c01af2a4>] (sysfs_remove_group+0x88/0x98)
| [<c01af2a4>] (sysfs_remove_group) from [<c039420c>] (device_del+0x34/0x198)
| [<c039420c>] (device_del) from [<c0428208>] (evdev_disconnect+0x18/0x44)
| [<c0428208>] (evdev_disconnect) from [<c04258c8>] (__input_unregister_device+0xa4/0x148)
| [<c04258c8>] (__input_unregister_device) from [<c04259ac>] (input_unregister_device+0x40/0x74)
| [<c04259ac>] (input_unregister_device) from [<bf0c6294>] (uvc_delete+0x20/0x10c [uvcvideo])
| [<bf0c6294>] (uvc_delete [uvcvideo]) from [<bf08a68c>] (v4l2_device_release+0x9c/0xc4 [videodev])
| [<bf08a68c>] (v4l2_device_release [videodev]) from [<c03934f0>] (device_release+0x2c/0x90)
| [<c03934f0>] (device_release) from [<c030f7bc>] (kobject_release+0x48/0x7c)
| [<c030f7bc>] (kobject_release) from [<bf089330>] (v4l2_release+0x50/0x78 [videodev])
| [<bf089330>] (v4l2_release [videodev]) from [<c0147e34>] (__fput+0x80/0x1c4)
| [<c0147e34>] (__fput) from [<c0058a18>] (task_work_run+0xb4/0xe4)
| [<c0058a18>] (task_work_run) from [<c00425ec>] (do_exit+0x2dc/0x92c)
| [<c00425ec>] (do_exit) from [<c0042ca4>] (do_group_exit+0x3c/0xb0)
| [<c0042ca4>] (do_group_exit) from [<c0042d28>] (__wake_up_parent+0x0/0x18)
| ---[ end trace b54a8f3c8129180e ]---
anyone an idea?

 drivers/usb/core/buffer.c | 30 +++++++++++++++++++++++++-----
 drivers/usb/core/hcd.c    |  2 ++
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index 506b969ea7fd..01e080a61519 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -107,7 +107,7 @@ void hcd_buffer_destroy(struct usb_hcd *hcd)
  * better sharing and to leverage mm/slab.c intelligence.
  */
 
-void *hcd_buffer_alloc(
+static void *_hcd_buffer_alloc(
 	struct usb_bus		*bus,
 	size_t			size,
 	gfp_t			mem_flags,
@@ -131,7 +131,19 @@ void *hcd_buffer_alloc(
 	return dma_alloc_coherent(hcd->self.controller, size, dma, mem_flags);
 }
 
-void hcd_buffer_free(
+void *hcd_buffer_alloc(struct usb_bus *bus, size_t size, gfp_t mem_flags,
+		       dma_addr_t *dma)
+{
+	struct usb_hcd *hcd = bus_to_hcd(bus);
+	void *ret;
+
+	ret = _hcd_buffer_alloc(bus, size, mem_flags, dma);
+	if (ret)
+		usb_get_hcd(hcd);
+	return ret;
+}
+
+static void _hcd_buffer_free(
 	struct usb_bus		*bus,
 	size_t			size,
 	void			*addr,
@@ -141,9 +153,6 @@ void hcd_buffer_free(
 	struct usb_hcd		*hcd = bus_to_hcd(bus);
 	int			i;
 
-	if (!addr)
-		return;
-
 	if (!bus->controller->dma_mask &&
 	    !(hcd->driver->flags & HCD_LOCAL_MEM)) {
 		kfree(addr);
@@ -158,3 +167,14 @@ void hcd_buffer_free(
 	}
 	dma_free_coherent(hcd->self.controller, size, addr, dma);
 }
+
+void hcd_buffer_free(struct usb_bus *bus, size_t size, void *addr,
+		     dma_addr_t dma)
+{
+	struct usb_hcd		*hcd = bus_to_hcd(bus);
+
+	if (!addr)
+		return;
+	_hcd_buffer_free(bus, size, addr, dma);
+	usb_put_hcd(hcd);
+}
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index a6efb4184f2b..536da1639ac5 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2469,6 +2469,7 @@ struct usb_hcd *usb_create_shared_hcd(const struct hc_driver *driver,
 	kref_init(&hcd->kref);
 
 	usb_bus_init(&hcd->self);
+	get_device(dev);
 	hcd->self.controller = dev;
 	hcd->self.bus_name = bus_name;
 	hcd->self.uses_dma = (dev->dma_mask != NULL);
@@ -2534,6 +2535,7 @@ static void hcd_release(struct kref *kref)
 			peer->primary_hcd = NULL;
 	}
 	mutex_unlock(&usb_port_peer_mutex);
+	put_device(hcd->self.controller);
 	kfree(hcd);
 }
 
-- 
2.1.3

