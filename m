Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56500 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933862AbeGDH7f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 03:59:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Jul 2018 13:29:33 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, andy.gross@linaro.org,
        bjorn.andersson@linaro.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [PATCH v2 2/5] media: venus: add a routine to set venus state
In-Reply-To: <CAAFQd5DH2i+8ZJ+s2XUnmFHwxXKLF6z_=w0Z-RFs=W9oVvrJgw@mail.gmail.com>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-3-git-send-email-vgarodia@codeaurora.org>
 <20180601212117.GD11565@jcrouse-lnx.qualcomm.com>
 <CAAFQd5DH2i+8ZJ+s2XUnmFHwxXKLF6z_=w0Z-RFs=W9oVvrJgw@mail.gmail.com>
Message-ID: <ca7567c1df773f1223d919fab28f1460@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jordan, Tomasz,

Thanks for your valuable review comments.

On 2018-06-04 18:24, Tomasz Figa wrote:
> Hi Jordan, Vikash,
> 
> On Sat, Jun 2, 2018 at 6:21 AM Jordan Crouse <jcrouse@codeaurora.org> 
> wrote:
>> 
>> On Sat, Jun 02, 2018 at 01:56:05AM +0530, Vikash Garodia wrote:
> [snip]
>> > +int venus_set_hw_state(enum tzbsp_video_state state, struct venus_core *core)
>> > +{
>> > +     int ret;
>> > +     struct device *dev = core->dev;
>> 
>> If you get rid of the log message as you should, you don't need this.

Would prefer to keep the log for cases when enum is expanded while the 
switch does
not handle it.

>> > +     void __iomem *reg_base = core->base;
>> > +
>> > +     switch (state) {
>> > +     case TZBSP_VIDEO_SUSPEND:
>> > +             if (qcom_scm_is_available())
>> > +                     ret = qcom_scm_set_remote_state(TZBSP_VIDEO_SUSPEND, 0);
>> > +             else
>> > +                     writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);
>> 
>> You can just use core->base here and not bother making a local 
>> variable for it.
Ok.

>> > +             break;
>> > +     case TZBSP_VIDEO_RESUME:
>> > +             if (qcom_scm_is_available())
>> > +                     ret = qcom_scm_set_remote_state(TZBSP_VIDEO_RESUME, 0);
>> > +             else
>> > +                     venus_reset_hw(core);
>> > +             break;
>> > +     default:
>> > +             dev_err(dev, "invalid state\n");
>> 
>> state is a enum - you are highly unlikely to be calling it in your own 
>> code with
>> a random value.  It is smart to have the default, but you don't need 
>> the log
>> message - that is just wasted space in the binary.

Incase enum is expanded while the switch does not handle it, default 
will be useful.

>> > +             break;
>> > +     }
>> 
>> There are three paths in the switch statement that could end up with 
>> 'ret' being
>> uninitialized here.  Set it to 0 when you declare it.

> Does this actually compile? The compiler should detect that ret is
> used uninitialized. Setting it to 0 at declaration time actually
> prevents compiler from doing that and makes it impossible to catch
> cases when the ret should actually be non-zero, e.g. the invalid enum
> value case.

It does compile while it gave me failure while doing the functional 
validation.
I have fixed it in next series of patch.

> Given that this function is supposed to substitute existing calls into
> qcom_scm_set_remote_state(), why not just do something like this:
> 
>         if (qcom_scm_is_available())
>                 return qcom_scm_set_remote_state(state, 0);
> 
>         switch (state) {
>         case TZBSP_VIDEO_SUSPEND:
>                 writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);
>                 break;
>         case TZBSP_VIDEO_RESUME:
>                 venus_reset_hw(core);
>                 break;
>         }
> 
>         return 0;
This will not work as driver will write on the register irrespective of 
scm
availability.

> Best regards,
> Tomasz
