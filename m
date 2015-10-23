Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:32852 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbJWV51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2015 17:57:27 -0400
Received: by igbkq10 with SMTP id kq10so43262305igb.0
        for <linux-media@vger.kernel.org>; Fri, 23 Oct 2015 14:57:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5625DDCA.2040203@xs4all.nl>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
	<5625DDCA.2040203@xs4all.nl>
Date: Sat, 24 Oct 2015 00:57:25 +0300
Message-ID: <CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
Subject: Re: PCIe capture driver
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 20, 2015 at 9:23 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 10/19/2015 10:26 PM, Ran Shalit wrote:
>> Hello,
>>
>> When writing a device driver for  capturing video coming from PCIe,
>> does it need to be used as v4l device (video for linux) , ?
>
> Yes. If you don't then 1) you will never be able to upstream the driver,
> 2) any application that wants to use your driver will need custom code to
> talk to your driver, 3) it will be a lot more work to write the driver
> since you can't use the V4L2 kernel frameworks it provides or ask for
> help.
>
> Basically, by deciding to reinvent the wheel you're screwing over your
> customers and yourself.
>
> Here is a nice PCI(e) template driver that you can use as your starting
> point: Documentation/video4linux/v4l2-pci-skeleton.c
>
> Regards,
>
>         Hans

Hi Hans,

I now understand, that I will be using media sdk (Intel) which is
based on DRM framework, and does not use v4l.
So I probably need to do some custom driver for delivering video with PCIe.

Regards,
Ran
