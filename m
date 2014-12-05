Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45544 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751046AbaLEVVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 16:21:04 -0500
Date: Fri, 5 Dec 2014 16:21:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: linux-usb@vger.kernel.org, <linux-media@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felipe Balbi <balbi@ti.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] usb: hcd: get/put device and hcd for hcd_buffers()
In-Reply-To: <20141205200357.GA1586@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1412051543510.1032-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Dec 2014, Sebastian Andrzej Siewior wrote:

> Consider the following scenario:
> - plugin a webcam
> - play the stream via gst-launch-0.10 v4l2src device=/dev/video0…
> - remove the USB-HCD during playback via "rmmod $HCD"
> 
> and now wait for the crash
> 
> |musb-hdrc musb-hdrc.2.auto: remove, state 1
> |usb usb2: USB disconnect, device number 1
> |usb 2-1: USB disconnect, device number 3
> |uvcvideo: Failed to resubmit video URB (-19).
> |musb-hdrc musb-hdrc.2.auto: USB bus 2 deregistered
> |musb-hdrc musb-hdrc.1.auto: remove, state 4
> |usb usb1: USB disconnect, device number 1
> |musb-hdrc musb-hdrc.1.auto: USB bus 1 deregistered
> |Unable to handle kernel paging request at virtual address 6b6b6b6f
> |pgd = c0004000
> |[6b6b6b6f] *pgd=00000000
> |Internal error: Oops: 5 [#1] ARM
> |Modules linked in: uvcvideo]
> |CPU: 0 PID: 2613 Comm: gst-launch-0.10 Tainted: G        W    3.14.25+ #40
> |task: ec2b8100 ti: ec38e000 task.ti: ec38e000
> |PC is at hcd_buffer_free+0x64/0xc0
> |LR is at uvc_free_urb_buffers+0x34/0x50 [uvcvideo]
> |Process gst-launch-0.10 (pid: 2613, stack limit = 0xec38e240)
> |[<c03a07e8>] (hcd_buffer_free)
> |[<bf2f0c78>] (uvc_free_urb_buffers [uvcvideo])
> |[<bf2f33dc>] (uvc_video_enable [uvcvideo])
> |[<bf2ef150>] (uvc_v4l2_release [uvcvideo])
> |[<bf2ac318>] (v4l2_release [videodev])
> |[<c0103334>] (__fput)
> |[<c005b618>] (task_work_run)
> |[<c00417a0>] (do_exit)
> |[<c0041ebc>] (do_group_exit)
> 
> as part of the device-removal the HCD removes its dma-buffers, the HCD
> structure itself and even the struct device is gone. That means if UVC
> removes its URBs after its last user (/dev/videoX) is gone and not from
> the ->disconnect() callback then it is too late because the HCD might
> gone.
> 
> First, I fixed by in the UVC driver by ignoring the UVC_SC_VIDEOSTREAMING
> in its ->disconnect callback and calling uvc_video_enable(, 0) in
> uvc_unregister_video(). But then I though that it might not be clever to
> release that memory if there is userspace using it.
> 
> So instead, I hold the device struct in the HCD and the HCD struct on
> every USB-buf-alloc. That means after a disconnect we still have a
> refcount on usb_hcd and device and it will be cleaned "later" once the
> last USB-buffer is released.

This is not a valid solution.  Notice that your _hcd_buffer_free still 
dereferences hcd->driver; that will not point to anything useful if you 
rmmod the HCD.

Also, you neglected to move the calls to hcd_buffer_destroy from 
usb_remove_hcd to hcd_release.

On the whole, it would be easier if the UVC driver could release its 
coherent DMA buffers during the disconnect callback.  If that's not 
feasible we'll have to find some other solution.

Alan Stern

