Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33638 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbJTGir (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 02:38:47 -0400
Received: by igbkq10 with SMTP id kq10so65717402igb.0
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2015 23:38:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5625DDCA.2040203@xs4all.nl>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
	<5625DDCA.2040203@xs4all.nl>
Date: Tue, 20 Oct 2015 09:38:46 +0300
Message-ID: <CAJ2oMhL7LaKVjxC+fbg87GSY+2GEFth_rDGn7vgnRaKF8hT=-g@mail.gmail.com>
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

Hans,

Many thanks for the detailed answer and the example !

Regards,
Ran
