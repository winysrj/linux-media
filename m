Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33888 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3L0Bzl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Dec 2013 20:55:41 -0500
Received: by mail-vc0-f171.google.com with SMTP id ik5so4604273vcb.30
        for <linux-media@vger.kernel.org>; Thu, 26 Dec 2013 17:55:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFu4+mW7ja=FR3Csw_svfnSCtivZNACgaTV-J7vD=15vKHzQtg@mail.gmail.com>
References: <CAFu4+mW7ja=FR3Csw_svfnSCtivZNACgaTV-J7vD=15vKHzQtg@mail.gmail.com>
Date: Fri, 27 Dec 2013 09:55:40 +0800
Message-ID: <CAFu4+mWAaw9jqpqiw_SiuaQs-y=VEZxPYmdv+W-mkdEckXTQ5Q@mail.gmail.com>
Subject: Re: DMABUF doesn't work when frame size not equal to the size of GPU bo
From: Chuanbo Weng <strgnm@gmail.com>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping for reply!

2013/12/25 Chuanbo Weng <strgnm@gmail.com>:
> Hi all,
>
>        (My environment is intel platform, HD4000 GPU, kernel 3.10.19,
> logitech 270 webcam)
>        As title said, I discover this issue when I run the program
> shown by Laurent Pinchart:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg54806.html
>
> If the frame is (width, height) = (640, 480), DMABUF works well.
> If the frame is (width, height) = (160, 120), v4lfd receives no event.
>
>
> And I dig into drm kernel code, find that: i915_gem_create will create
> a GPU buffer object on intel platform. The size of GPU bo will be
> bigger than frame size, for the reason that i915_gem_create will
> roundup the bo size to multiple of PAGE_SIZE when the frame is (width,
> height) = (160, 120).
> For (width, height) = (640, 480), the frame size is already multiple
> of PAGE_SIZE, so GPU bo is exactly equal to frame size.
>
> I also dump the uvc driver infomation, there is some infomation i
> think maybe important:
> uvcvideo: Stream 1 error event 07 01 len 4
>
> Looking forward to the discussion!
>
> Thanks,
> Chuanbo Weng
