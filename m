Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5UFdxUa027154
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 11:40:00 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5UFdm7G030946
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 11:39:48 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-uvc-devel@lists.berlios.de
Date: Mon, 30 Jun 2008 17:39:45 +0200
References: <485F7A42.8020605@vidsoft.de>
	<200806240033.41145.laurent.pinchart@skynet.be>
	<20080626194804.GB18818@vidsoft.de>
In-Reply-To: <20080626194804.GB18818@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301739.45386.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com
Subject: Re: [Linux-uvc-devel] Driver hangs at DQBUF ioctl
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Gregor,

On Thursday 26 June 2008, Gregor Jasny wrote:
> Hi all,
>
> this got a somewhat lengthy bugreport.

Thanks for the report.

> Some words to my environment: 
>
> These traces were produced on a Core2Duo (in amd64 mode) with a ASUS P5B
> board and vanilla Linux 2.6.25.8. I observed the same behavior on a 32bit
> QuadCore with a Logitech 9000 and Linux 2.6.25.6.
>
> This is the trace from my app. As you can see, the main thread (17460)
> queues the buffer, starts the grabbing thread right after the STREAMON and
> queries brightness, contrast, hue and saturation.
> The grabbing thread tries to dequeue a buffer and hangs:
>
> -> Thread=17460 ioctl=c058560f          QBUF
> <- Thread=17460 ioctl=c058560f ret=0    QBUF
> -> Thread=17460 ioctl=c058560f          QBUF
> <- Thread=17460 ioctl=c058560f ret=0    QBUF
> -> Thread=17460 ioctl=40045612          STREAMON
> <- Thread=17460 ioctl=40045612 ret=0    STREAMON
> -> Thread=17460 ioctl=c0445624          QUERYCTRL
> -> Thread=17487 ioctl=c0585611          DQBUF
> <- Thread=17460 ioctl=c0445624 ret=0    QUERYCTRL
> -> Thread=17460 ioctl=c008561b          G_CTRL
> <- Thread=17460 ioctl=c008561b ret=0    G_CTRL
> -> Thread=17460 ioctl=c0445624          QUERYCTRL
> <- Thread=17460 ioctl=c0445624 ret=0    QUERYCTRL
> -> Thread=17460 ioctl=c008561b          G_CTRL
> <- Thread=17460 ioctl=c008561b ret=0    G_CTRL
> -> Thread=17460 ioctl=c0445624          QUERYCTRL
> <- Thread=17460 ioctl=c0445624 ret=0    QUERYCTRL
> -> Thread=17460 ioctl=c008561b          G_CTRL
> <- Thread=17460 ioctl=c008561b ret=0    G_CTRL
> -> Thread=17460 ioctl=c0445624          QUERYCTRL
> <- Thread=17460 ioctl=c0445624 ret=0    QUERYCTRL
> -> Thread=17460 ioctl=c008561b          G_CTRL
> <- Thread=17460 ioctl=c008561b ret=0    G_CTRL

This looks valid to me. I'm not aware of a specific code path that would fail 
on that.

[snip]

> One maybe interesting observation: If I reload the module after a
> deadlock and let the camera plugged in, the following trace is produced:
> A now started luvcview blocks during dqbuf, too (See next trace).
> The only way to get a working camera again is to replug the camera.

This suggests a device issue, but let's not rule out driver issues too fast.

[snip]

> Every time the driver is loaded, the driver prints the following line:
> uvcvideo: Failed to query (135) UVC control 1 (unit 0) : -32 (exp. 26).
>
> Would it be possible to suppress this query by a camera specific quirk?

Probably, although the query shouldn't hurt. The driver issues a GET_DEF query 
on the video control, and falls back to GET_CUR when GET_DEF fails.

> Where in the driver should I add what traces?

uvc_video_complete() and uvc_video_decode_start() are good candidates. Print a 
message for each incoming isochronous packet with its status, its length and 
the first few bytes of the header. I would like to know if the driver 
receives any data at all from the camera.

> Is it possible to let a dqbuf ioctl have a time out?

You could replace wait_event_interruptible() with 
wait_event_interruptible_timeout() in uvc_queue_waiton(). I'm not sure if 
V4L2 allows that behaviour though. You can already turn DQBUF into a 
non-blocking operation by setting the O_NONBLOCK flag when you open the 
device.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
