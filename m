Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:33973 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaABCWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jan 2014 21:22:44 -0500
Received: by mail-vb0-f43.google.com with SMTP id p6so6836150vbe.2
        for <linux-media@vger.kernel.org>; Wed, 01 Jan 2014 18:22:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3150357.rYSWurtcIU@avalon>
References: <CAFu4+mW7ja=FR3Csw_svfnSCtivZNACgaTV-J7vD=15vKHzQtg@mail.gmail.com>
	<52C275B9.1030803@samsung.com>
	<CAFu4+mV7D_Ys-tobgtoi92pvuS41mqE71PQf_e0qS_6rOnvV3g@mail.gmail.com>
	<3150357.rYSWurtcIU@avalon>
Date: Thu, 2 Jan 2014 10:22:44 +0800
Message-ID: <CAFu4+mWp7eKpW66XLQmPMoan8Uqf+K8eietsOjJ9R7TaCOV52g@mail.gmail.com>
Subject: Re: DMABUF doesn't work when frame size not equal to the size of GPU bo
From: Chuanbo Weng <strgnm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Tomasz,
       As I said in my previous email, you can download the code from
the github address.
I think you can easily reproduce this issue by running my program
(Especially Laurent) and
get more information from this program.
       Could you please tell me whether you have reproduced this issue?


Thanks,
Chuanbo Weng

2013/12/31 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Chuanbo,
>
> On Tuesday 31 December 2013 19:21:09 Chuanbo Weng wrote:
>> 2013/12/31 Tomasz Stanislawski <t.stanislaws@samsung.com>:
>> > Hi Chuanbo Weng,
>> >
>> > I suspect that the problem might be caused by difference
>> > between size of DMABUF object and buffer size in V4L2.
>>
>> Thanks for your reply! I agree with you because my experiment prove it
>> (Even when the bo is bigget than frame size, not smaller!!!).
>>
>> > What is the content of v4l2_format returned by VIDIOC_G_FMT?
>>
>> The content is V4L2_PIX_FMT_YUYV. (And if the content V4L2_PIX_FMT_MJPEG,
>> this issue doesn't happen.)
>
> Could you please give us the content of all the other fields ?
>
>> > What is the content of V4l2_buffer structure passed by VIDIOC_QBUF?
>
> Same here.
>
>> The fd in v4l2_buffer structure is fd of gem object created by
>> DRM_IOCTL_MODE_CREATE_DUMB.
>>
>> I've upload the program that can reproduce this issue on intel platform. You
>> just need to clone it from
>> https://github.com/strgnm/v4l2-dmabuf-test.git
>> Then build and run as said in README.
>
> --
> Regards,
>
> Laurent Pinchart
>
