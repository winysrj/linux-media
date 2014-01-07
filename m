Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:48738 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaAGKuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 05:50:05 -0500
Received: by mail-vb0-f48.google.com with SMTP id q12so1630182vbe.35
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 02:50:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52CBB661.9080509@samsung.com>
References: <CAFu4+mW7ja=FR3Csw_svfnSCtivZNACgaTV-J7vD=15vKHzQtg@mail.gmail.com>
	<52C275B9.1030803@samsung.com>
	<CAFu4+mV7D_Ys-tobgtoi92pvuS41mqE71PQf_e0qS_6rOnvV3g@mail.gmail.com>
	<3150357.rYSWurtcIU@avalon>
	<CAFu4+mWp7eKpW66XLQmPMoan8Uqf+K8eietsOjJ9R7TaCOV52g@mail.gmail.com>
	<52CBB661.9080509@samsung.com>
Date: Tue, 7 Jan 2014 18:50:04 +0800
Message-ID: <CAFu4+mU+yHZtfaOG9xFcOT54+ZcDgdkqJjP+iU3koDd4HkXb6Q@mail.gmail.com>
Subject: Re: DMABUF doesn't work when frame size not equal to the size of GPU bo
From: Chuanbo Weng <strgnm@gmail.com>
To: sw0312.kim@samsung.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Seung-Woo Kim,
       Thanks for your reply!
       I've check VIDIOC_QBUF in my program, and this ioctl returns 0,
which indicate that VIDIOC_QBUF is ok. My issue is that the v4lfd receive
no event when beginning to read frame. (Seems not the same issue as yours)
I suggest you to run my program on your machine, as I said in previous
mail. :)

      The issue happens even when the GPU bo size is bigger than frame size.
This is strange!

       Actually I'm just a user of v4l2, not the driver implementer, so I hope
the guys in mailing-list can help to solve this v4l2 implementation issue.

Thanks,
Chuanbo Weng

2014/1/7 Seung-Woo Kim <sw0312.kim@samsung.com>:
> Hello,
>
> On 2014년 01월 02일 11:22, Chuanbo Weng wrote:
>> Hi Laurent and Tomasz,
>>        As I said in my previous email, you can download the code from
>> the github address.
>> I think you can easily reproduce this issue by running my program
>> (Especially Laurent) and
>> get more information from this program.
>>        Could you please tell me whether you have reproduced this issue?
>>
>>
>> Thanks,
>> Chuanbo Weng
>>
>> 2013/12/31 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>>> Hi Chuanbo,
>>>
>>> On Tuesday 31 December 2013 19:21:09 Chuanbo Weng wrote:
>>>> 2013/12/31 Tomasz Stanislawski <t.stanislaws@samsung.com>:
>>>>> Hi Chuanbo Weng,
>>>>>
>>>>> I suspect that the problem might be caused by difference
>>>>> between size of DMABUF object and buffer size in V4L2.
>>>>
>>>> Thanks for your reply! I agree with you because my experiment prove it
>>>> (Even when the bo is bigget than frame size, not smaller!!!).
>>>>
>>>>> What is the content of v4l2_format returned by VIDIOC_G_FMT?
>>>>
>>>> The content is V4L2_PIX_FMT_YUYV. (And if the content V4L2_PIX_FMT_MJPEG,
>>>> this issue doesn't happen.)
>>>
>>> Could you please give us the content of all the other fields ?
>>>
>>>>> What is the content of V4l2_buffer structure passed by VIDIOC_QBUF?
>>>
>>> Same here.
>>>
>
> Did you check the result of VIDIOC_QBUF? I have similar issue on my
> environment, so I added debug log for failure of QBUF as "[media]
> videobuf2: Add log for size checking error in __qbuf_dmabuf" to clarify.
>
> As your comment, DRM_IOCTL_MODE_CREATE_DUMB creates buffers aligned with
> PAGE_SIZE, and size of DMABUF exported from GEM with PRIME ioctl is same
> with the GEM, so the size is aligned with PAGE_SIZE.
>
> In Videobuf2 of V4L2, __qbuf_dmabuf() checks passed buffer size, or
> DMABUF size if passed size is 0, with size assigned by queue_setup
> callback of the v4l2 driver. The v4l2 driver assigns the size calculated
> from resolution and format, and usually *it is not aligned with
> PAGE_SIZE* even though internal allocation is aligned. So the check
> routine of size in __qbuf_dmabuf() returns failure.
>
> I am not sure about queue_setup of UVC driver, but it seems same issue.
>
> Maybe we can add PAGE_ALIGN for size from queue_setup in the
> __qbuf_dmabuf() like __vb2_buf_mem_alloc() or vb2_mmap().
>
> Regards,
> - Seung-Woo Kim
>
>>>> The fd in v4l2_buffer structure is fd of gem object created by
>>>> DRM_IOCTL_MODE_CREATE_DUMB.
>>>>
>>>> I've upload the program that can reproduce this issue on intel platform. You
>>>> just need to clone it from
>>>> https://github.com/strgnm/v4l2-dmabuf-test.git
>>>> Then build and run as said in README.
>>>
>>> --
>>> Regards,
>>>
>>> Laurent Pinchart
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> Seung-Woo Kim
> Samsung Software R&D Center
> --
>
