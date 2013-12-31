Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32315 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3LaHoF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Dec 2013 02:44:05 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYN00KYGUTFCO60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Dec 2013 07:44:03 +0000 (GMT)
Message-id: <52C275B9.1030803@samsung.com>
Date: Tue, 31 Dec 2013 08:43:53 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Chuanbo Weng <strgnm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: DMABUF doesn't work when frame size not equal to the size of GPU bo
References: <CAFu4+mW7ja=FR3Csw_svfnSCtivZNACgaTV-J7vD=15vKHzQtg@mail.gmail.com>
 <CAFu4+mWAaw9jqpqiw_SiuaQs-y=VEZxPYmdv+W-mkdEckXTQ5Q@mail.gmail.com>
 <1402873.pE5TYkBor8@avalon>
 <CAFu4+mWKGX4EpGYRMCwOfPO7ELhby7sx-DLHSZg=2Wj0v3S_CQ@mail.gmail.com>
In-reply-to: <CAFu4+mWKGX4EpGYRMCwOfPO7ELhby7sx-DLHSZg=2Wj0v3S_CQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chuanbo Weng,

I suspect that the problem might be caused by difference
between size of DMABUF object and buffer size in V4L2.
What is the content of v4l2_format returned by VIDIOC_G_FMT?
What is the content of V4l2_buffer structure passed by VIDIOC_QBUF?

Regards,
Tomasz Stanislawski

On 12/31/2013 03:42 AM, Chuanbo Weng wrote:
> Hi Laurent,
> 
> 
> 2013/12/29 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> Hi Chuanbo,
>>
>> On Friday 27 December 2013 09:55:40 Chuanbo Weng wrote:
>>>> Hi all,
>>>>
>>>> (My environment is intel platform, HD4000 GPU, kernel 3.10.19, logitech
>>>> 270 webcam)
>>>>
>>>> As title said, I discover this issue when I run the program shown by
>>>> Laurent Pinchart:
>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg54806.html
>>>>
>>>> If the frame is (width, height) = (640, 480), DMABUF works well.
>>>> If the frame is (width, height) = (160, 120), v4lfd receives no event.
>>>>
>>>> And I dig into drm kernel code, find that: i915_gem_create will create a
>>>> GPU buffer object on intel platform. The size of GPU bo will be bigger
>>>> than frame size, for the reason that i915_gem_create will roundup the bo
>>>> size to multiple of PAGE_SIZE when the frame is (width, height) = (160,
>>>> 120). For (width, height) = (640, 480), the frame size is already multiple
>>>> of PAGE_SIZE, so GPU bo is exactly equal to frame size.
>>
>> That should in theory not be an issue). This might be a stupid question, but
>> have you tried to capture 160x120 images directly (with yavta for instance)
>> without using DMABUF ?
> 
> Thanks for your reply! Please forgive me if it's a stupid question
> because I'm new in camera
> and v4l2 region. Yes, of course, I have tried to capture 160x120
> images using yavta and v4l-utils
> without using DMABUF (using MMAP), it works well. So it proves the
> camera support this width
> and height.I strongly recommend you to tried 160x120 images using
> DMABUF on your machine,
> because I have tried 3 cameras (two logiteh, one microsoft) and all of
> them don't work.
>>
>>>> I also dump the uvc driver infomation, there is some infomation i
>>>> think maybe important:
>>>> uvcvideo: Stream 1 error event 07 01 len 4
>>>>
>>>> Looking forward to the discussion!
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
> 
> Thanks,
> Chuanbo Weng
> 

