Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3L2P0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Dec 2013 10:26:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Chuanbo Weng <strgnm@gmail.com>
Cc: linux-media@vger.kernel.org, t.stanislaws@samsung.com
Subject: Re: DMABUF doesn't work when frame size not equal to the size of GPU bo
Date: Sun, 29 Dec 2013 16:27:21 +0100
Message-ID: <1402873.pE5TYkBor8@avalon>
In-Reply-To: <CAFu4+mWAaw9jqpqiw_SiuaQs-y=VEZxPYmdv+W-mkdEckXTQ5Q@mail.gmail.com>
References: <CAFu4+mW7ja=FR3Csw_svfnSCtivZNACgaTV-J7vD=15vKHzQtg@mail.gmail.com> <CAFu4+mWAaw9jqpqiw_SiuaQs-y=VEZxPYmdv+W-mkdEckXTQ5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chuanbo,

On Friday 27 December 2013 09:55:40 Chuanbo Weng wrote:
> > Hi all,
> > 
> > (My environment is intel platform, HD4000 GPU, kernel 3.10.19, logitech
> > 270 webcam)
> > 
> > As title said, I discover this issue when I run the program shown by
> > Laurent Pinchart:
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg54806.html
> > 
> > If the frame is (width, height) = (640, 480), DMABUF works well.
> > If the frame is (width, height) = (160, 120), v4lfd receives no event.
> > 
> > And I dig into drm kernel code, find that: i915_gem_create will create a
> > GPU buffer object on intel platform. The size of GPU bo will be bigger
> > than frame size, for the reason that i915_gem_create will roundup the bo
> > size to multiple of PAGE_SIZE when the frame is (width, height) = (160,
> > 120). For (width, height) = (640, 480), the frame size is already multiple
> > of PAGE_SIZE, so GPU bo is exactly equal to frame size.

That should in theory not be an issue). This might be a stupid question, but 
have you tried to capture 160x120 images directly (with yavta for instance) 
without using DMABUF ?

> > I also dump the uvc driver infomation, there is some infomation i
> > think maybe important:
> > uvcvideo: Stream 1 error event 07 01 len 4
> > 
> > Looking forward to the discussion!

-- 
Regards,

Laurent Pinchart

