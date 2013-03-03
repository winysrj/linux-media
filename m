Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:41635 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3CCO5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 09:57:18 -0500
Received: by mail-qe0-f48.google.com with SMTP id 9so3286410qea.21
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 06:57:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201303031137.44917@leon.remlab.net>
References: <201303031137.44917@leon.remlab.net>
Date: Sun, 3 Mar 2013 09:57:14 -0500
Message-ID: <CAGoCfixOsn4eTp7NYmJSK-LJTqF677LXf8fgTzrz4KFgPN7znw@mail.gmail.com>
Subject: Re: uvcvideo USERPTR mode busted?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 3, 2013 at 4:37 AM, Rémi Denis-Courmont <remi@remlab.net> wrote:
>         Hello,
>
> Trying to use USERPTR buffers with UVC, user space gets stuck either in
> poll(POLLIN) or in ioctl(VIDIOC_DQBUF). It seems the UVC driver never ever
> returns a frame in USERPTR mode. The symptoms are identical with kernel
> versions 3.6, 3.7 and 3.8. I also tested 3.2, but it did not support USERPTR.
>
> Tested hardware was Logitech HD Pro Webcam C920 with YUY2 pixel format. The
> same hardware and the same driver work fine with MMAP buffers.
> The same USERPTR userspace code works fine with the vivi test device...
>
> Did any have any better luck?

Hi Remi,

I've used userptr mode with the C920 on an ARM platform (with YUYV
mode and not MPEG).  It's worth noting that there is actually a bug I
hit where if the memory you pass is not aligned on a page boundary
then you will get garbage video.  I have a fix or this but haven't
submitted it upstream yet.

So it should work, aside from the bug I found.

Have you tried testing with v42l-ctl's streaming command?  That would
help identify whether it's something special about your code or
whether it's the driver.  Don't get me wrong, it's almost certainly a
driver issue in either case, but it would help narrow down the issue
if you're using v4l2-ctl as that app is really simple and readily
available to the driver developers.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
