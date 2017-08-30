Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:48321 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751263AbdH3Kpq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 06:45:46 -0400
Subject: Re: [RFC 0/2] BCM283x Camera Receiver driver
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <55eba688-5765-72dc-0984-7b642abaf38e@xs4all.nl>
 <CAAoAYcM5E5vsQ0Cn4X4XSJOO6uNuLqjXaBs1bBHwfiQbi5oHXw@mail.gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <154d1076-89b6-2c6b-07c1-f1c45eca3727@xs4all.nl>
Date: Wed, 30 Aug 2017 12:45:41 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcM5E5vsQ0Cn4X4XSJOO6uNuLqjXaBs1bBHwfiQbi5oHXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/08/17 11:40, Dave Stevenson wrote:
> Hi Hans.
> 
> On 28 August 2017 at 15:15, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Dave,
>>
>> What is the status of this work? I ask because I tried to use this driver
>> plus my tc358743 on my rpi-2b without any luck. Specifically the tc358843
>> isn't able to read from the i2c bus.
> 
> I was on other things until last week, but will try to get a V2 sorted
> either this week or early next.
> The world moved on slightly too, so there are a few more updates
> around fwnode stuff that I ought to adopt.
> 
>> This is probably a bug in my dts, if you have a tree somewhere containing
>> a working dts for this, then that would be very helpful.
> 
> Almost certainly just pin ctrl on the I2C bus. The default for i2c0 is
> normally to GPIOs 0&1 as that is exposed on the 40 pin header
> (physical pins 27&28). The camera is on GPIOs 28&29 (alt0) for the
> majority of Pi models (not the Pi3, or the early model B).

Yep, that was the culprit!

I now see the tc, but streaming doesn't work yet. I'm not getting any
interrupts in the unicam driver.

BTW, when s_dv_timings is called, then you need to update the v4l2_format
as well to the new width and height. I noticed that that didn't happen.

Anyway, this is good enough for me for now since I want to add CEC support
to the tc driver, and I do not need streaming for that...

Regards,

	Hans
