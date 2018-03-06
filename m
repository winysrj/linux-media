Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:34114 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752795AbeCFJwk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 04:52:40 -0500
Received: by mail-ua0-f172.google.com with SMTP id m43so12581477uah.1
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2018 01:52:39 -0800 (PST)
Received: from mail-vk0-f48.google.com (mail-vk0-f48.google.com. [209.85.213.48])
        by smtp.gmail.com with ESMTPSA id u16sm3431030vke.44.2018.03.06.01.52.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Mar 2018 01:52:37 -0800 (PST)
Received: by mail-vk0-f48.google.com with SMTP id y127so11879286vky.9
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2018 01:52:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180306094617.2jjy3fxg64757evh@paasikivi.fi.intel.com>
References: <1520002549-6564-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5D1a1Wd0ns85rkg8cJwK+y9uYzaS=c46efOniuGhvFk+w@mail.gmail.com>
 <20180306084045.gabhdrsjks5m7htq@paasikivi.fi.intel.com> <CAAFQd5AhfZRKM3sjO3vtbmfOV4RHSEL_AM8AS3FLZdYySiZhPg@mail.gmail.com>
 <20180306091814.rd3coopexzlmrhhf@paasikivi.fi.intel.com> <CAAFQd5A20nP16kFZSfZ5T2pONA2D80VXhoR0pEwy=Ev1B+gH6Q@mail.gmail.com>
 <20180306094617.2jjy3fxg64757evh@paasikivi.fi.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 6 Mar 2018 18:52:16 +0900
Message-ID: <CAAFQd5CECWFvn9GfZV526m_Bt3FgEiyA9To-_-y8cN4-dvWjFg@mail.gmail.com>
Subject: Re: [PATCH v6] media: imx258: Add imx258 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Yeh <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 6, 2018 at 6:46 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> On Tue, Mar 06, 2018 at 06:28:43PM +0900, Tomasz Figa wrote:
>> On Tue, Mar 6, 2018 at 6:18 PM, Sakari Ailus
>> <sakari.ailus@linux.intel.com> wrote:
>> > On Tue, Mar 06, 2018 at 05:51:36PM +0900, Tomasz Figa wrote:
>> >> On Tue, Mar 6, 2018 at 5:40 PM, Sakari Ailus
>> >> <sakari.ailus@linux.intel.com> wrote:
>> >> > Hi Tomasz and Andy,
>> >> >
>> >> > On Sat, Mar 03, 2018 at 12:43:59AM +0900, Tomasz Figa wrote:
>> >> > ...
>> >> >> > +static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
>> >> >> > +{
>> >> >> > +       struct imx258 *imx258 =
>> >> >> > +               container_of(ctrl->handler, struct imx258, ctrl_handler);
>> >> >> > +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
>> >> >> > +       int ret = 0;
>> >> >> > +       /*
>> >> >> > +        * Applying V4L2 control value only happens
>> >> >> > +        * when power is up for streaming
>> >> >> > +        */
>> >> >> > +       if (pm_runtime_get_if_in_use(&client->dev) <= 0)
>> >> >> > +               return 0;
>> >> >>
>> >> >> I thought we decided to fix this to handle disabled runtime PM properly.
>> >> >
>> >> > Good point. I bet this is a problem in a few other drivers, too. How would
>> >> > you fix that? Check for zero only?
>> >> >
>> >>
>> >> bool need_runtime_put;
>> >>
>> >> ret = pm_runtime_get_if_in_use(&client->dev);
>> >> if (ret <= 0 && ret != -EINVAL)
>> >>         return ret;
>> >> need_runtime_put = ret > 0;
>> >>
>> >> // Do stuff ...
>> >>
>> >> if (need_runtime_put)
>> >>        pm_runtime_put(&client->dev);
>> >>
>> >> I don't like how ugly it is, but it appears to be the only way to
>> >> handle this correctly.
>> >
>> > The driver enables runtime PM so if runtime PM is enabled in kernel
>> > configuration, it is enabled here. In that case pm_runtime_get_if_in_use()
>> > will return either 0 or 1. So as far as I can see, changing the lines to:
>> >
>> >         if (!pm_runtime_get_if_in_use(&client->dev))
>> >                 return 0;
>> >
>> > is enough.
>>
>> Right, my bad. Somehow I was convinced that enable status can change at
>> runtime.
>
> Good point. I guess in principle this could happen although I can't see a
> reason to do so, other than to break things --- quoting
> Documentation/power/runtime_pm.txt:
>
>         The user space can effectively disallow the driver of the device to
>         power manage it at run time by changing the value of its
>         /sys/devices/.../power/control attribute to "on", which causes
>         pm_runtime_forbid() to be called. In principle, this mechanism may
>         also be used by the driver to effectively turn off the runtime
>         power management of the device until the user space turns it on.
>         Namely, during the initialization the driver can make sure that the
>         runtime PM status of the device is 'active' and call
>         pm_runtime_forbid(). It should be noted, however, that if the user
>         space has already intentionally changed the value of
>         /sys/devices/.../power/control to "auto" to allow the driver to
>         power manage the device at run time, the driver may confuse it by
>         using pm_runtime_forbid() this way.
>
> So that comes with a warning that things might not work well after doing
> so.
>
> What comes to the driver code, I still wouldn't complicate it by attempting
> to make a driver work in such a case.

I think pm_runtime_forbid() and pm_runtime_enable() operate on
complete different data. That was exactly the source of my confusion
earlier. Looking at the code [1], even if runtime PM is "forbidden",
it is still "enabled" and just the usage count is incremented.

https://elixir.bootlin.com/linux/latest/source/drivers/base/power/runtime.c#L1314

Best regards,
Tomasz
