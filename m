Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:48908 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751285AbdHaOS2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 10:18:28 -0400
Subject: Re: [RFC 0/2] BCM283x Camera Receiver driver
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <55eba688-5765-72dc-0984-7b642abaf38e@xs4all.nl>
 <CAAoAYcM5E5vsQ0Cn4X4XSJOO6uNuLqjXaBs1bBHwfiQbi5oHXw@mail.gmail.com>
 <154d1076-89b6-2c6b-07c1-f1c45eca3727@xs4all.nl>
 <CAAoAYcP3xqP=QQ4xTfBiiy9oXiJykPMbJrTBM5pa4WNSiPbSUg@mail.gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ed4c7da6-35f1-d5c0-7b6e-e89f73c52dfe@xs4all.nl>
Date: Thu, 31 Aug 2017 16:18:24 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcP3xqP=QQ4xTfBiiy9oXiJykPMbJrTBM5pa4WNSiPbSUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/08/17 13:04, Dave Stevenson wrote:
> On 30 August 2017 at 11:45, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 30/08/17 11:40, Dave Stevenson wrote:
>>> Hi Hans.
>>>
>>> On 28 August 2017 at 15:15, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> Hi Dave,
>>>>
>>>> What is the status of this work? I ask because I tried to use this driver
>>>> plus my tc358743 on my rpi-2b without any luck. Specifically the tc358843
>>>> isn't able to read from the i2c bus.
>>>
>>> I was on other things until last week, but will try to get a V2 sorted
>>> either this week or early next.
>>> The world moved on slightly too, so there are a few more updates
>>> around fwnode stuff that I ought to adopt.
>>>
>>>> This is probably a bug in my dts, if you have a tree somewhere containing
>>>> a working dts for this, then that would be very helpful.
>>>
>>> Almost certainly just pin ctrl on the I2C bus. The default for i2c0 is
>>> normally to GPIOs 0&1 as that is exposed on the 40 pin header
>>> (physical pins 27&28). The camera is on GPIOs 28&29 (alt0) for the
>>> majority of Pi models (not the Pi3, or the early model B).
>>
>> Yep, that was the culprit!
> 
> Great. I like easy ones :-)
> 
>> I now see the tc, but streaming doesn't work yet. I'm not getting any
>> interrupts in the unicam driver.
> 
> What resolution were you streaming at? There are a couple of things
> that come to mind and I don't have solutions for yet.
> Firstly the TC358743 driver assumes that all 4 CSI lanes are
> available, whilst the Pi only has 2 lanes exposed. IIRC 1080P30 RGB
> just trickles over into wanting 3 lanes with the default link
> frequencies and you indeed don't get anything if one or more lane is
> physically not connected.
> Secondly was the FIFOCTL register set via state->pdata.fifo_level that
> we discussed before. The default is 16, which is too small for some of
> the smaller resolutions. 300 seems reasonable. You do get frames in
> that situation, but they're generally corrupt.
> I'm intending to try and make the TC358743 more flexible than just
> accepting >720P, and if I can support multiple link frequencies then
> so much the better as 1080P50 UYVY should be just possible on 2 lane,
> however the lower resolutions are unlikely to work due to FIFO
> underflow.

Found the cause: bcm2835-rpi.dtsi had csi power-domains entries that
I missed. So the csi wasn't powered on :-)

After adding that it now works!

Regards,

	Hans
