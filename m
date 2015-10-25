Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36731 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbbJYUQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2015 16:16:38 -0400
Received: by igdg1 with SMTP id g1so46304693igd.1
        for <linux-media@vger.kernel.org>; Sun, 25 Oct 2015 13:16:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <562B5178.5040303@xs4all.nl>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
	<5625DDCA.2040203@xs4all.nl>
	<CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
	<562B5178.5040303@xs4all.nl>
Date: Sun, 25 Oct 2015 22:16:37 +0200
Message-ID: <CAJ2oMhJ1FhMqm_P0h+dzmTUJuvfK=DawPAO-R3duS6-XncsrMQ@mail.gmail.com>
Subject: Re: PCIe capture driver
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 24, 2015 at 11:38 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>
> On 10/23/2015 23:57, Ran Shalit wrote:
>> On Tue, Oct 20, 2015 at 9:23 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 10/19/2015 10:26 PM, Ran Shalit wrote:
>>>> Hello,
>>>>
>>>> When writing a device driver for  capturing video coming from PCIe,
>>>> does it need to be used as v4l device (video for linux) , ?
>>>
>>> Yes. If you don't then 1) you will never be able to upstream the driver,
>>> 2) any application that wants to use your driver will need custom code to
>>> talk to your driver, 3) it will be a lot more work to write the driver
>>> since you can't use the V4L2 kernel frameworks it provides or ask for
>>> help.
>>>
>>> Basically, by deciding to reinvent the wheel you're screwing over your
>>> customers and yourself.
>>>
>>> Here is a nice PCI(e) template driver that you can use as your starting
>>> point: Documentation/video4linux/v4l2-pci-skeleton.c
>>>
>>> Regards,
>>>
>>>         Hans
>>
>> Hi Hans,
>>
>> I now understand, that I will be using media sdk (Intel) which is
>> based on DRM framework, and does not use v4l.
>
> DRM is for video output, not video capture. So this seems irrelevant.
>
>> So I probably need to do some custom driver for delivering video with PCIe.
>
> There is only one linux API for video capture: V4L2. What PCIe card are we
> talking about here? What are you trying to achieve?
>

I need to capture video from PCIe . The video stream will be delivered
from PC through PCIe to a custom board with Intel cpu using media sdk.
The purpose is to encode the raw video and save the encoded stream to
a file.
I guess I can build some custom driver which waits for frames and
deliver the received frames to the media sdk encoder.
Since media sdk does not use v4l anyway, so I guess such custom driver
is the best under this conditions, Right ?
Regards,
Ran
