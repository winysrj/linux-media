Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37923 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab2BPGaQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 01:30:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: Division by zero in UVC driver
Date: Thu, 16 Feb 2012 07:30:17 +0100
Message-ID: <12311511.XtqQ6s9rAx@avalon>
In-Reply-To: <201202151827.29929.hselasky@c2i.net>
References: <201202151827.29929.hselasky@c2i.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 15 February 2012 18:27:29 Hans Petter Selasky wrote:
> Hi,
> 
> After getting through the compilation issues regarding the uvc_debugfs, I am
> now facing another problem, which I think is more generic.
> 
> The FreeBSD port of the Linux UVC driver, webcamd, gives a division by zero
> inside the UVC driver, because it does not properly check if the returned
> SOF counter is the same like the previous one. This can also happen on
> Linux if the UVC capable device is plugged exactly when the EHCI/OHCI/UHCI
> SOF counter is equal to zero!

It's a know bug (at least to me :-)). Does 
http://git.linuxtv.org/pinchartl/uvcvideo.git/commit/5c97eb2eb9c45dad8825de7754ceb33699451978 
fix your problem ? I've queued that patch in my tree for v3.4.

> Also please note that the SOF counter will only be updated after the each
> completed ISOCHRONOUS transfer on FreeBSD, due to limitations in LibUSB.
> 
> Debug info:
> 
> (gdb) list
> 651		else if (sof > mean + (1024 << 16))
> 652			sof -= 2048 << 16;
> 653
> 654		y = (u64)(y2 - y1) * (u64)sof + (u64)y1 * (u64)x2
> 655		  - (u64)y2 * (u64)x1;
> 656		y = div_u64(y, x2 - x1);
> 657
> 658		div = div_u64_rem(y, NSEC_PER_SEC, &rem);
> 659		ts.tv_sec = first->host_ts.tv_sec - 1 + div;
> 660		ts.tv_nsec = first->host_ts.tv_nsec + rem;
> (gdb)
> 
> Program received signal SIGFPE, Arithmetic exception.
> [Switching to Thread 80100a3c0 (LWP 100096/webcamd)]
> 0x00000000005e9337 in div_u64 (rem=71210779720321120, div=0)
>     at kernel/linux_func.c:1649
> 1649	{
> (gdb) bt
> #0  0x00000000005e9337 in div_u64 (rem=71210779720321120, div=0)
>     at kernel/linux_func.c:1649
> #1  0x00000000005169f7 in uvc_video_clock_update (stream=0x8010bf500,
>     v4l2_buf=0x801138a00, buf=0x801138a00)
>     at media_tree/drivers/media/video/uvc/uvc_video.c:656
> #2  0x00000000005125c3 in uvc_buffer_finish (vb=Variable "vb" is not
> available.
> )
>     at media_tree/drivers/media/video/uvc/uvc_queue.c:114
> #3  0x00000000004ae76a in vb2_dqbuf (q=0x8010bf5b8, b=0x7fffff1f9d30,
>     nonblocking=0 '\0') at media_tree/drivers/media/video/videobuf2-
> core.c:1334
> #4  0x000000000051236f in uvc_dequeue_buffer (queue=0x8010bf5b8,
>     buf=0x7fffff1f9d30, nonblocking=0)
>     at media_tree/drivers/media/video/uvc/uvc_queue.c:193
> #5  0x0000000000513c50 in uvc_v4l2_do_ioctl (file=0x80111d418,
> cmd=3227014673, arg=0x7fffff1f9d30) at
> media_tree/drivers/media/video/uvc/uvc_v4l2.c:958 #6  0x0000000000444780 in
> video_usercopy (file=0x80111d418, cmd=3227014673, arg=65536, func=0x513050
> <uvc_v4l2_do_ioctl>)
>     at media_tree/drivers/media/video/v4l2-ioctl.c:2456
> #7  0x0000000000443b40 in v4l2_ioctl (filp=0x80111d418, cmd=3227014673,
>     arg=65536) at media_tree/drivers/media/video/v4l2-dev.c:339
> #8  0x00000000005ea4aa in linux_ioctl (handle=0x80111d400, fflags=0,
>     cmd=3227014673, arg=0x10000) at kernel/linux_file.c:120
> #9  0x00000000005ef01a in v4b_ioctl (cdev=Variable "cdev" is not available.
> ) at webcamd.c:261
> #10 0x0000000800a249e6 in cuse_wait_and_process ()

-- 
Regards,

Laurent Pinchart
