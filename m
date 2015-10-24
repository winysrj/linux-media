Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:43069 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbbJXJiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2015 05:38:07 -0400
Subject: Re: PCIe capture driver
To: Ran Shalit <ranshalit@gmail.com>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
 <5625DDCA.2040203@xs4all.nl>
 <CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <562B5178.5040303@xs4all.nl>
Date: Sat, 24 Oct 2015 11:38:00 +0200
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/23/2015 23:57, Ran Shalit wrote:
> On Tue, Oct 20, 2015 at 9:23 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 10/19/2015 10:26 PM, Ran Shalit wrote:
>>> Hello,
>>>
>>> When writing a device driver for  capturing video coming from PCIe,
>>> does it need to be used as v4l device (video for linux) , ?
>>
>> Yes. If you don't then 1) you will never be able to upstream the driver,
>> 2) any application that wants to use your driver will need custom code to
>> talk to your driver, 3) it will be a lot more work to write the driver
>> since you can't use the V4L2 kernel frameworks it provides or ask for
>> help.
>>
>> Basically, by deciding to reinvent the wheel you're screwing over your
>> customers and yourself.
>>
>> Here is a nice PCI(e) template driver that you can use as your starting
>> point: Documentation/video4linux/v4l2-pci-skeleton.c
>>
>> Regards,
>>
>>         Hans
> 
> Hi Hans,
> 
> I now understand, that I will be using media sdk (Intel) which is
> based on DRM framework, and does not use v4l.

DRM is for video output, not video capture. So this seems irrelevant.

> So I probably need to do some custom driver for delivering video with PCIe.

There is only one linux API for video capture: V4L2. What PCIe card are we
talking about here? What are you trying to achieve?

Regards,

	Hans
