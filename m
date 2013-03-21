Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51959 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3CUMkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 08:40:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	linux-media@vger.kernel.org
Subject: Re: uvcvideo USERPTR mode busted?
Date: Thu, 21 Mar 2013 13:41:25 +0100
Message-ID: <151543510.hNXiaIfEAr@avalon>
In-Reply-To: <CAGoCfixOsn4eTp7NYmJSK-LJTqF677LXf8fgTzrz4KFgPN7znw@mail.gmail.com>
References: <201303031137.44917@leon.remlab.net> <CAGoCfixOsn4eTp7NYmJSK-LJTqF677LXf8fgTzrz4KFgPN7znw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 03 March 2013 09:57:14 Devin Heitmueller wrote:
> On Sun, Mar 3, 2013 at 4:37 AM, Rémi Denis-Courmont <remi@remlab.net> wrote:
> >         Hello,
> > 
> > Trying to use USERPTR buffers with UVC, user space gets stuck either in
> > poll(POLLIN) or in ioctl(VIDIOC_DQBUF). It seems the UVC driver never ever
> > returns a frame in USERPTR mode. The symptoms are identical with kernel
> > versions 3.6, 3.7 and 3.8. I also tested 3.2, but it did not support
> > USERPTR.
> > 
> > Tested hardware was Logitech HD Pro Webcam C920 with YUY2 pixel format.
> > The same hardware and the same driver work fine with MMAP buffers.
> > The same USERPTR userspace code works fine with the vivi test device...
> > 
> > Did any have any better luck?

I've just tested USERPTR with a Logitech C905 on a 3.7.10 kernel using yavta 
without any issue.

> Hi Remi,
> 
> I've used userptr mode with the C920 on an ARM platform (with YUYV mode and
> not MPEG).  It's worth noting that there is actually a bug I hit where if
> the memory you pass is not aligned on a page boundary then you will get
> garbage video.  I have a fix or this but haven't submitted it upstream yet.

Please submit it at some point :-)

Is it a uvcvideo issue or a videobuf2 issue ?

> So it should work, aside from the bug I found.
> 
> Have you tried testing with v42l-ctl's streaming command?  That would help
> identify whether it's something special about your code or whether it's the
> driver.  Don't get me wrong, it's almost certainly a driver issue in either
> case, but it would help narrow down the issue if you're using v4l2-ctl as
> that app is really simple and readily available to the driver developers.

-- 
Regards,

Laurent Pinchart

