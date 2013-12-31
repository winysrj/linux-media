Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35200 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3LaCm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 21:42:58 -0500
Received: by mail-vc0-f179.google.com with SMTP id ie18so6263014vcb.10
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 18:42:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1402873.pE5TYkBor8@avalon>
References: <CAFu4+mW7ja=FR3Csw_svfnSCtivZNACgaTV-J7vD=15vKHzQtg@mail.gmail.com>
	<CAFu4+mWAaw9jqpqiw_SiuaQs-y=VEZxPYmdv+W-mkdEckXTQ5Q@mail.gmail.com>
	<1402873.pE5TYkBor8@avalon>
Date: Tue, 31 Dec 2013 10:42:56 +0800
Message-ID: <CAFu4+mWKGX4EpGYRMCwOfPO7ELhby7sx-DLHSZg=2Wj0v3S_CQ@mail.gmail.com>
Subject: Re: DMABUF doesn't work when frame size not equal to the size of GPU bo
From: Chuanbo Weng <strgnm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, t.stanislaws@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,


2013/12/29 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Chuanbo,
>
> On Friday 27 December 2013 09:55:40 Chuanbo Weng wrote:
>> > Hi all,
>> >
>> > (My environment is intel platform, HD4000 GPU, kernel 3.10.19, logitech
>> > 270 webcam)
>> >
>> > As title said, I discover this issue when I run the program shown by
>> > Laurent Pinchart:
>> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg54806.html
>> >
>> > If the frame is (width, height) = (640, 480), DMABUF works well.
>> > If the frame is (width, height) = (160, 120), v4lfd receives no event.
>> >
>> > And I dig into drm kernel code, find that: i915_gem_create will create a
>> > GPU buffer object on intel platform. The size of GPU bo will be bigger
>> > than frame size, for the reason that i915_gem_create will roundup the bo
>> > size to multiple of PAGE_SIZE when the frame is (width, height) = (160,
>> > 120). For (width, height) = (640, 480), the frame size is already multiple
>> > of PAGE_SIZE, so GPU bo is exactly equal to frame size.
>
> That should in theory not be an issue). This might be a stupid question, but
> have you tried to capture 160x120 images directly (with yavta for instance)
> without using DMABUF ?

Thanks for your reply! Please forgive me if it's a stupid question
because I'm new in camera
and v4l2 region. Yes, of course, I have tried to capture 160x120
images using yavta and v4l-utils
without using DMABUF (using MMAP), it works well. So it proves the
camera support this width
and height.I strongly recommend you to tried 160x120 images using
DMABUF on your machine,
because I have tried 3 cameras (two logiteh, one microsoft) and all of
them don't work.
>
>> > I also dump the uvc driver infomation, there is some infomation i
>> > think maybe important:
>> > uvcvideo: Stream 1 error event 07 01 len 4
>> >
>> > Looking forward to the discussion!
>
> --
> Regards,
>
> Laurent Pinchart
>

Thanks,
Chuanbo Weng
