Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34187 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754297AbcIGUio (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 16:38:44 -0400
Received: by mail-oi0-f42.google.com with SMTP id m11so43128721oif.1
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 13:38:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160901114711.GF2893@katana>
References: <1472729956-17475-1-git-send-email-s.nawrocki@samsung.com> <20160901114711.GF2893@katana>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 7 Sep 2016 22:38:34 +0200
Message-ID: <CACRpkdaFj58kMqniVHxC87K0XmHoPy3x-GHs=JrK-t2osKCZ1w@mail.gmail.com>
Subject: Re: [PATCH 1/4] exynos4-is: Clear isp-i2c adapter power.ignore_children
 flag
To: Wolfram Sang <wsa@the-dreams.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 1, 2016 at 1:47 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Thu, Sep 01, 2016 at 01:39:16PM +0200, Sylwester Nawrocki wrote:

>> Since commit 04f59143b571161d25315dd52d7a2ecc022cb71a
>> ("i2c: let I2C masters ignore their children for PM")
>> the power.ignore_children flag is set when registering an I2C
>> adapter. Since I2C transfers are not managed by the fimc-isp-i2c
>> driver its clients use pm_runtime_* calls directly to communicate
>> required power state of the bus controller.
>> However when the power.ignore_children flag is set that doesn't
>> work, so clear that flag back after registering the adapter.
>> While at it drop pm_runtime_enable() call on the i2c_adapter
>> as it is already done by the I2C subsystem when registering
>> I2C adapter.
>>
>> Cc: <stable@vger.kernel.org> # 4.7+
>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

I understand what the patch is doing but not this commit message.

What does it mean when you say "Since I2C transfers are not
managed by the fimc-isp-i2c driver its clients use pm_runtime_*
calls directly to communicate required power state of the bus
controller."?

I find it very hard to understand.

The intent of the commit is to decouple I2C slave devices'
runtime PM state from their parents, so say a gyroscope on an
I2C bus does not have to bring up it's host controller to be
active, for example it usually has an IRQ line to wake up
the driver and that will talk using I2C and the I2C traffic will
wake up the I2C master.

When I look at the driver it appears it is not even used for
I2C traffic, just to take the clocks up and down and make it
possible to manage a clock using runtime PM and interface
with the DT logic... so I guess since it's likely and odd one-off
and the driver is sufficiently weird anyways, it's fine to merge
this patch making it even weirder.

Maybe a sort of mock adapter type should actually be
created in the I2C core for these things so it can be handled
there but who am I to say.

Yours,
Linus Walleij
