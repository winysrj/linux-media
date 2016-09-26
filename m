Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56942 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbcIZQEh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 12:04:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Bin Liu <b-liu@ti.com>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, nh26223@gmail.com
Subject: Re: g_webcam Isoch high bandwidth transfer
Date: Mon, 26 Sep 2016 19:03:53 +0300
Message-ID: <1704939.i3W0dYhSRn@avalon>
In-Reply-To: <87shsr5a3e.fsf@linux.intel.com>
References: <20160920170441.GA10705@uda0271908> <20160922201131.GD31827@uda0271908> <87shsr5a3e.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

On Friday 23 Sep 2016 10:49:57 Felipe Balbi wrote:
> Bin Liu <b-liu@ti.com> writes:
> > +Fengwei Yin per his request.
> > 
> > On Thu, Sep 22, 2016 at 10:48:40PM +0300, Felipe Balbi wrote:
> >> Bin Liu <b-liu@ti.com> writes:
> >> 
> >> [...]
> >> 
> >>>> Here's one that actually compiles, sorry about that.
> >>> 
> >>> No worries, I was sleeping ;-)
> >>> 
> >>> I will test it out early next week. Thanks.
> >> 
> >> meanwhile, how about some instructions on how to test this out myself?
> >> How are you using g_webcam and what are you running on host side? Got a
> >> nice list of commands there I can use? I think I can get to bottom of
> >> this much quicker if I can reproduce it locally ;-)
> > 
> > On device side:
> > - first patch g_webcam as in my first email in this thread to enable
> > 
> >   640x480@30fps;
> > 
> > - # modprobe g_webcam streaming_maxpacket=3072
> > - then run uvc-gadget to feed the YUV frames;
> > 
> > 	http://git.ideasonboard.org/uvc-gadget.git
> 
> as is, g_webcam never enumerates to the host. It's calls to
> usb_function_active() and usb_function_deactivate() are unbalanced. Do
> you have any other changes to g_webcam?
> 
> Also, uvc-gadget.git doesn't compile, had to modify it a bit:
> 
> -#include "../drivers/usb/gadget/uvc.h"
> +#include "../drivers/usb/gadget/function/uvc.h"
> 
> Also fixed a build warning:
> 
> @@ -732,6 +732,8 @@ int main(int argc, char *argv[])
>                 fd_set wfds = fds;
> 
>                 ret = select(dev->fd + 1, NULL, &wfds, &efds, NULL);
> +               if (ret < 0)
> +                       return ret;
>                 if (FD_ISSET(dev->fd, &efds))
>                         uvc_events_process(dev);
>                 if (FD_ISSET(dev->fd, &wfds))
> 
> Laurent, have you tested g_webcam recently? What's the magic to get it
> working?

I'm afraid not, I haven't had time to work on UVC gadget for a few years now.

> Here's what I get out of dmesg:
> 
> [   58.568380] usb 1-9: new high-speed USB device number 5 using xhci_hcd
> [   58.738680] usb 1-9: New USB device found, idVendor=1d6b, idProduct=0102
> [   58.738683] usb 1-9: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0 [   58.738685] usb 1-9: Product: Webcam gadget
> [   58.738687] usb 1-9: Manufacturer: Linux Foundation
> [   58.739133] g_webcam gadget: high-speed config #1: Video
> [   58.739138] g_webcam gadget: uvc_function_set_alt(0, 0)
> [   58.739139] g_webcam gadget: reset UVC Control
> [   58.739149] g_webcam gadget: uvc_function_set_alt(1, 0)
> [   58.804369] uvcvideo: Found UVC 1.00 device Webcam gadget (1d6b:0102)
> [   58.804479] g_webcam gadget: uvc_function_set_alt(1, 0)
> [   64.188459] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported.
> Enabling workaround. [   69.307458] uvcvideo: Failed to query (129) UVC
> probe control : -110 (exp. 26). [   69.307459] uvcvideo: Failed to
> initialize the device (-5).
> [   69.307505] usbcore: registered new interface driver uvcvideo
> [   69.307506] USB Video Class driver (1.1.1)
> [  146.646012] ------------[ cut here ]------------
> [  146.646023] WARNING: CPU: 0 PID: 2616 at
> drivers/usb/gadget/composite.c:371 usb_function_activate+0x77/0x80
> [libcomposite] [  146.646024] Modules linked in: uvcvideo g_webcam
> usb_f_uvc videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core
> videodev libcomposite kvm_intel kvm psmouse e1000e input_leds hid_generic
> usbhid atkbd irqbypass evdev [  146.646054] CPU: 0 PID: 2616 Comm:
> gst-launch-1.0 Not tainted
> 4.8.0-rc7-next-20160922-00004-gc71031593917-dirty #20 [  146.646055]
> Hardware name: Intel Corporation Skylake Client platform/Skylake Y LPDDR3
> RVP3, BIOS SKLSE2R1.R00.B097.B02.1509020030 09/02/2015 [  146.646058] 
> ffffc9000769bb70
> [  146.646059]  ffffffff8132d415
> [  146.646060]  0000000000000000
> [  146.646061]  0000000000000000
> 
> [  146.646063]  ffffc9000769bbb0
> [  146.646063]  ffffffff8105ec1b
> [  146.646064]  000001730769bb90
> [  146.646066]  00000000ffffffea
> [  146.646070]  ffff88016c03a150
> [  146.646072]  0000000000000282 ffff88016d793000 ffffc9000769befc
> [  146.646077] Call Trace:
> [  146.646086]  [<ffffffff8132d415>] dump_stack+0x68/0x93
> [  146.646090]  [<ffffffff8105ec1b>] __warn+0xcb/0xf0
> [  146.646095]  [<ffffffff8105ed0d>] warn_slowpath_null+0x1d/0x20
> [  146.646099]  [<ffffffffa03f1ea7>] usb_function_activate+0x77/0x80
> [libcomposite] [  146.646105]  [<ffffffffa044a6de>]
> uvc_function_connect+0x1e/0x40 [usb_f_uvc] [  146.646110] 
> [<ffffffffa044b2ae>] uvc_v4l2_open+0x6e/0x80 [usb_f_uvc] [  146.646116] 
> [<ffffffffa04014f0>] v4l2_open+0xa0/0x100 [videodev] [  146.646121] 
> [<ffffffff811a5431>] chrdev_open+0xa1/0x1d0
> [  146.646125]  [<ffffffff811a5390>] ? cdev_put+0x30/0x30
> [  146.646129]  [<ffffffff8119dd60>] do_dentry_open.isra.17+0x150/0x2e0
> [  146.646133]  [<ffffffff8119f115>] vfs_open+0x45/0x60
> [  146.646137]  [<ffffffff811af1ed>] path_openat+0x62d/0x1370
> [  146.646141]  [<ffffffff811b0094>] ? putname+0x54/0x60
> [  146.646146]  [<ffffffff811b10ce>] do_filp_open+0x7e/0xe0
> [  146.646150]  [<ffffffff81083868>] ? preempt_count_sub+0x48/0x70
> [  146.646154]  [<ffffffff816f07d6>] ? _raw_spin_unlock+0x16/0x30
> [  146.646160]  [<ffffffff811bf009>] ? __alloc_fd+0xc9/0x180
> [  146.646164]  [<ffffffff8119f4e3>] do_sys_open+0x123/0x200
> [  146.646170]  [<ffffffff8119f5de>] SyS_open+0x1e/0x20
> [  146.646174]  [<ffffffff816f0e2a>] entry_SYSCALL_64_fastpath+0x18/0xa8
> [  146.646177] ---[ end trace 1a4f7b9817d19b04 ]---
> [  146.646180] g_webcam gadget: UVC connect failed with -22
> [  146.653808] usb 1-9: USB disconnect, device number 5
> [  146.653986] g_webcam gadget: UVC disconnect failed with -110

[snip]

> uvc-gadget keeps printing this error message:
> 
>  159         if ((ret = ioctl(dev->fd, VIDIOC_DQBUF, &buf)) < 0) {
>  160                 printf("Unable to dequeue buffer: %s (%d).\n",
> strerror(errno), 161                         errno);
>  162                 return ret;
>  163         }
> 
> Any ideas?

The UVC gadget driver uses videobuf2 for buffer management. You can raise the 
debug level of the videobuf2-v4l2 and videobuf2-core modules to get verbose 
error messages in the kernel log.

-- 
Regards,

Laurent Pinchart
