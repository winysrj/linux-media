Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46964 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJZW1r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 18:27:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] uvc: Fix destruction order in uvc_delete()
Date: Mon, 27 Oct 2014 00:27:50 +0200
Message-ID: <17042633.rRCnbcG55v@avalon>
In-Reply-To: <1414138220-15998-1-git-send-email-tiwai@suse.de>
References: <1414138220-15998-1-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Takashi,

Thank you for the patch.

On Friday 24 October 2014 10:10:20 Takashi Iwai wrote:
> We've got a bug report at disconnecting a Webcam, where the kernel
> spews warnings like below:
>   WARNING: CPU: 0 PID: 8385 at ../fs/sysfs/group.c:219
> sysfs_remove_group+0x87/0x90() sysfs group c0b2350c not found for kobject
> 'event3'
>   CPU: 0 PID: 8385 Comm: queue2:src Not tainted 3.16.2-1.gdcee397-default #1
> Hardware name: ASUSTeK Computer INC. A7N8X-E/A7N8X-E, BIOS ASUS A7N8X-E
> Deluxe ACPI BIOS Rev 1013  11/12/2004 c08d0705 ddc75cbc c0718c5b ddc75ccc
> c024b654 c08c6d44 ddc75ce8 000020c1 c08d0705 000000db c03d1ec7 c03d1ec7
> 00000009 00000000 c0b2350c d62c9064 ddc75cd4 c024b6a3 00000009 ddc75ccc
> c08c6d44 ddc75ce8 ddc75cfc c03d1ec7 Call Trace:
>     [<c0205ba6>] try_stack_unwind+0x156/0x170
>     [<c02046f3>] dump_trace+0x53/0x180
>     [<c0205c06>] show_trace_log_lvl+0x46/0x50
>     [<c0204871>] show_stack_log_lvl+0x51/0xe0
>     [<c0205c67>] show_stack+0x27/0x50
>     [<c0718c5b>] dump_stack+0x3e/0x4e
>     [<c024b654>] warn_slowpath_common+0x84/0xa0
>     [<c024b6a3>] warn_slowpath_fmt+0x33/0x40
>     [<c03d1ec7>] sysfs_remove_group+0x87/0x90
>     [<c05a2c54>] device_del+0x34/0x180
>     [<c05e3989>] evdev_disconnect+0x19/0x50
>     [<c05e06fa>] __input_unregister_device+0x9a/0x140
>     [<c05e0845>] input_unregister_device+0x45/0x80
>     [<f854b1d6>] uvc_delete+0x26/0x110 [uvcvideo]
>     [<f84d66f8>] v4l2_device_release+0x98/0xc0 [videodev]
>     [<c05a25bb>] device_release+0x2b/0x90
>     [<c04ad8bf>] kobject_cleanup+0x6f/0x1a0
>     [<f84d5453>] v4l2_release+0x43/0x70 [videodev]
>     [<c0372f31>] __fput+0xb1/0x1b0
>     [<c02650c1>] task_work_run+0x91/0xb0
>     [<c024d845>] do_exit+0x265/0x910
>     [<c024df64>] do_group_exit+0x34/0xa0
>     [<c025a76f>] get_signal_to_deliver+0x17f/0x590
>     [<c0201b6a>] do_signal+0x3a/0x960
>     [<c02024f7>] do_notify_resume+0x67/0x90
>     [<c071ebb5>] work_notifysig+0x30/0x3b
>     [<b7739e60>] 0xb7739e5f
>    ---[ end trace b1e56095a485b631 ]---
> 
> The cause is that uvc_status_cleanup() is called after usb_put_*() in
> uvc_delete().  usb_put_*() removes the sysfs parent and eventually
> removes the children recursively, so the later device_del() can't find
> its sysfs.  The fix is simply rearrange the call orders in
> uvc_delete() so that the child is removed before the parent.
> 
> Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=897736
> Reported-and-tested-by: Martin Pluskal <mpluskal@suse.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied the patch to my tree and will send a pull request for the next 
kernel version.

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 7c8322d4fc63..3c07af96b30f
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1623,12 +1623,12 @@ static void uvc_delete(struct uvc_device *dev)
>  {
>  	struct list_head *p, *n;
> 
> -	usb_put_intf(dev->intf);
> -	usb_put_dev(dev->udev);
> -
>  	uvc_status_cleanup(dev);
>  	uvc_ctrl_cleanup_device(dev);
> 
> +	usb_put_intf(dev->intf);
> +	usb_put_dev(dev->udev);
> +
>  	if (dev->vdev.dev)
>  		v4l2_device_unregister(&dev->vdev);
>  #ifdef CONFIG_MEDIA_CONTROLLER

-- 
Regards,

Laurent Pinchart

