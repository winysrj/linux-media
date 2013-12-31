Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:56151 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3LaLVK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Dec 2013 06:21:10 -0500
Received: by mail-ve0-f180.google.com with SMTP id jz11so6545108veb.11
        for <linux-media@vger.kernel.org>; Tue, 31 Dec 2013 03:21:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C275B9.1030803@samsung.com>
References: <CAFu4+mW7ja=FR3Csw_svfnSCtivZNACgaTV-J7vD=15vKHzQtg@mail.gmail.com>
	<CAFu4+mWAaw9jqpqiw_SiuaQs-y=VEZxPYmdv+W-mkdEckXTQ5Q@mail.gmail.com>
	<1402873.pE5TYkBor8@avalon>
	<CAFu4+mWKGX4EpGYRMCwOfPO7ELhby7sx-DLHSZg=2Wj0v3S_CQ@mail.gmail.com>
	<52C275B9.1030803@samsung.com>
Date: Tue, 31 Dec 2013 19:21:09 +0800
Message-ID: <CAFu4+mV7D_Ys-tobgtoi92pvuS41mqE71PQf_e0qS_6rOnvV3g@mail.gmail.com>
Subject: Re: DMABUF doesn't work when frame size not equal to the size of GPU bo
From: Chuanbo Weng <strgnm@gmail.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

2013/12/31 Tomasz Stanislawski <t.stanislaws@samsung.com>:
> Hi Chuanbo Weng,
>
> I suspect that the problem might be caused by difference
> between size of DMABUF object and buffer size in V4L2.
Thanks for your reply! I agree with you because my experiment prove it
(Even when
the bo is bigget than frame size, not smaller!!!).
> What is the content of v4l2_format returned by VIDIOC_G_FMT?
The content is V4L2_PIX_FMT_YUYV. (And if the content V4L2_PIX_FMT_MJPEG, this
issue doesn't happen.)
> What is the content of V4l2_buffer structure passed by VIDIOC_QBUF?
The fd in v4l2_buffer structure is fd of gem object created by
DRM_IOCTL_MODE_CREATE_DUMB.
I've upload the program that can reproduce this issue on intel
platform. You just need to clone it from
https://github.com/strgnm/v4l2-dmabuf-test.git
Then build and run as said in README.
>
> Regards,
> Tomasz Stanislawski
>
> On 12/31/2013 03:42 AM, Chuanbo Weng wrote:
>> Hi Laurent,
>>
>>
>> 2013/12/29 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>>> Hi Chuanbo,
>>>
>>> On Friday 27 December 2013 09:55:40 Chuanbo Weng wrote:
>>>>> Hi all,
>>>>>
>>>>> (My environment is intel platform, HD4000 GPU, kernel 3.10.19, logitech
>>>>> 270 webcam)
>>>>>
>>>>> As title said, I discover this issue when I run the program shown by
>>>>> Laurent Pinchart:
>>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg54806.html
>>>>>
>>>>> If the frame is (width, height) = (640, 480), DMABUF works well.
>>>>> If the frame is (width, height) = (160, 120), v4lfd receives no event.
>>>>>
>>>>> And I dig into drm kernel code, find that: i915_gem_create will create a
>>>>> GPU buffer object on intel platform. The size of GPU bo will be bigger
>>>>> than frame size, for the reason that i915_gem_create will roundup the bo
>>>>> size to multiple of PAGE_SIZE when the frame is (width, height) = (160,
>>>>> 120). For (width, height) = (640, 480), the frame size is already multiple
>>>>> of PAGE_SIZE, so GPU bo is exactly equal to frame size.
>>>
>>> That should in theory not be an issue). This might be a stupid question, but
>>> have you tried to capture 160x120 images directly (with yavta for instance)
>>> without using DMABUF ?
>>
>> Thanks for your reply! Please forgive me if it's a stupid question
>> because I'm new in camera
>> and v4l2 region. Yes, of course, I have tried to capture 160x120
>> images using yavta and v4l-utils
>> without using DMABUF (using MMAP), it works well. So it proves the
>> camera support this width
>> and height.I strongly recommend you to tried 160x120 images using
>> DMABUF on your machine,
>> because I have tried 3 cameras (two logiteh, one microsoft) and all of
>> them don't work.
>>>
>>>>> I also dump the uvc driver infomation, there is some infomation i
>>>>> think maybe important:
>>>>> uvcvideo: Stream 1 error event 07 01 len 4
>>>>>
>>>>> Looking forward to the discussion!
>>>
>>> --
>>> Regards,
>>>
>>> Laurent Pinchart
>>>
>>
>> Thanks,
>> Chuanbo Weng
>>
>
