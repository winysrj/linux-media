Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61780 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941023AbcIHLRQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 07:17:16 -0400
Subject: Re: [PATCH 1/4] exynos4-is: Clear isp-i2c adapter
 power.ignore_children flag
To: Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>
References: <1472729956-17475-1-git-send-email-s.nawrocki@samsung.com>
 <20160901114711.GF2893@katana>
 <CACRpkdaFj58kMqniVHxC87K0XmHoPy3x-GHs=JrK-t2osKCZ1w@mail.gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <92b9deab-1a2d-eb76-e9dc-63ab4576b299@samsung.com>
Date: Thu, 08 Sep 2016 13:16:43 +0200
MIME-version: 1.0
In-reply-to: <CACRpkdaFj58kMqniVHxC87K0XmHoPy3x-GHs=JrK-t2osKCZ1w@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2016 10:38 PM, Linus Walleij wrote:
> On Thu, Sep 1, 2016 at 1:47 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> On Thu, Sep 01, 2016 at 01:39:16PM +0200, Sylwester Nawrocki wrote:
> 
>>> Since commit 04f59143b571161d25315dd52d7a2ecc022cb71a
>>> ("i2c: let I2C masters ignore their children for PM")
>>> the power.ignore_children flag is set when registering an I2C
>>> adapter. Since I2C transfers are not managed by the fimc-isp-i2c
>>> driver its clients use pm_runtime_* calls directly to communicate
>>> required power state of the bus controller.
>>> However when the power.ignore_children flag is set that doesn't
>>> work, so clear that flag back after registering the adapter.
>>> While at it drop pm_runtime_enable() call on the i2c_adapter
>>> as it is already done by the I2C subsystem when registering
>>> I2C adapter.
>>>
>>> Cc: <stable@vger.kernel.org> # 4.7+
>>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> I understand what the patch is doing but not this commit message.
> 
> What does it mean when you say "Since I2C transfers are not
> managed by the fimc-isp-i2c driver its clients use pm_runtime_*
> calls directly to communicate required power state of the bus
> controller."?
> 
> I find it very hard to understand.

When a video device node is opened the I2C client (v4l2 subdevice)
in its s_power() handler makes pm_runtime_get/pm_runtime_put calls
on its corresponding i2c_client.  It's true we use an imitation of
I2C bus adapter just to make things work with standard DT bindings
and except of device instantiation this adapter's task is just
to control the clock.
I admit that it's all an odd use case, it comes from the fact that
the image sensor devices are handled in the ISP's firmware, where
normally we have an I2C client driver for each sensor in V4L2.

Now, I don't like those pm_runtime_* calls in the sensor drivers
as that's a non standard thing.  The other option to fix the
regression which I have been considering is to remove the whole
PM runtime dependency and make the driver of the I2C controller's
parent device [1] handle the clocks, as it's done with clocks of
some other IP blocks in that whole camera subsystem.  Probably
it's the lesser of two evils.

> The intent of the commit is to decouple I2C slave devices'
> runtime PM state from their parents, so say a gyroscope on an
> I2C bus does not have to bring up it's host controller to be
> active, for example it usually has an IRQ line to wake up
> the driver and that will talk using I2C and the I2C traffic will
> wake up the I2C master.
> 
> When I look at the driver it appears it is not even used for
> I2C traffic, just to take the clocks up and down and make it
> possible to manage a clock using runtime PM and interface
> with the DT logic... so I guess since it's likely and odd one-off
> and the driver is sufficiently weird anyways, it's fine to merge
> this patch making it even weirder.

Yeah, it's an odd one-off, there is no other drivers in mainline
with such a "non standard" split of hardware control responsibility
between main CPU and the ISP's MCU.

I'd merge the $subject patch as a regression fix for 4.7 and 4.8
and then think about a little larger patch moving the clock handling
responsibility the the ISP_I2C controller's parent driver.

> Maybe a sort of mock adapter type should actually be
> created in the I2C core for these things so it can be handled
> there but who am I to say.

Not sure if we need it right now, probably if there is more such
use cases we could think about something like this.

[1] http://lxr.linux.no/#linux+v4.7.3/arch/arm/boot/dts/exynos4x12.dtsi#L148

-- 
Thanks,
Sylwester
