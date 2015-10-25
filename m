Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:39386 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbbJYWzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2015 18:55:42 -0400
Subject: Re: PCIe capture driver
To: Ran Shalit <ranshalit@gmail.com>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
 <5625DDCA.2040203@xs4all.nl>
 <CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
 <562B5178.5040303@xs4all.nl>
 <CAJ2oMhJ1FhMqm_P0h+dzmTUJuvfK=DawPAO-R3duS6-XncsrMQ@mail.gmail.com>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <562D5DE2.5020406@xs4all.nl>
Date: Sun, 25 Oct 2015 23:55:30 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhJ1FhMqm_P0h+dzmTUJuvfK=DawPAO-R3duS6-XncsrMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/25/2015 21:16, Ran Shalit wrote:
> On Sat, Oct 24, 2015 at 11:38 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>
>> On 10/23/2015 23:57, Ran Shalit wrote:
>>> On Tue, Oct 20, 2015 at 9:23 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 10/19/2015 10:26 PM, Ran Shalit wrote:
>>>>> Hello,
>>>>>
>>>>> When writing a device driver for  capturing video coming from PCIe,
>>>>> does it need to be used as v4l device (video for linux) , ?
>>>>
>>>> Yes. If you don't then 1) you will never be able to upstream the driver,
>>>> 2) any application that wants to use your driver will need custom code to
>>>> talk to your driver, 3) it will be a lot more work to write the driver
>>>> since you can't use the V4L2 kernel frameworks it provides or ask for
>>>> help.
>>>>
>>>> Basically, by deciding to reinvent the wheel you're screwing over your
>>>> customers and yourself.
>>>>
>>>> Here is a nice PCI(e) template driver that you can use as your starting
>>>> point: Documentation/video4linux/v4l2-pci-skeleton.c
>>>>
>>>> Regards,
>>>>
>>>>         Hans
>>>
>>> Hi Hans,
>>>
>>> I now understand, that I will be using media sdk (Intel) which is
>>> based on DRM framework, and does not use v4l.
>>
>> DRM is for video output, not video capture. So this seems irrelevant.
>>
>>> So I probably need to do some custom driver for delivering video with PCIe.
>>
>> There is only one linux API for video capture: V4L2. What PCIe card are we
>> talking about here? What are you trying to achieve?
>>
> 
> I need to capture video from PCIe . The video stream will be delivered
> from PC through PCIe to a custom board with Intel cpu using media sdk.
> The purpose is to encode the raw video and save the encoded stream to
> a file.
> I guess I can build some custom driver which waits for frames and
> deliver the received frames to the media sdk encoder.

So the capture driver captures the video to memory and passes it on to
the media sdk for encoding? That's V4L2: that API capures video into
memory.

So don't reinvent the wheel but use V4L2 for your PCIe driver.

> Since media sdk does not use v4l anyway, so I guess such custom driver
> is the best under this conditions, Right ?

No, use V4L2. What you do with the frame after it has been captured
into memory has no relevance to the API you use to capture into memory.

Regards,

	Hans
