Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:32955 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbeFDMyj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:54:39 -0400
Received: by mail-vk0-f67.google.com with SMTP id 200-v6so17815134vkc.0
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:54:39 -0700 (PDT)
Received: from mail-ua0-f172.google.com (mail-ua0-f172.google.com. [209.85.217.172])
        by smtp.gmail.com with ESMTPSA id t74-v6sm6132785vkt.48.2018.06.04.05.54.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Jun 2018 05:54:37 -0700 (PDT)
Received: by mail-ua0-f172.google.com with SMTP id c23-v6so15464924uan.3
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-3-git-send-email-vgarodia@codeaurora.org> <20180601212117.GD11565@jcrouse-lnx.qualcomm.com>
In-Reply-To: <20180601212117.GD11565@jcrouse-lnx.qualcomm.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 4 Jun 2018 21:54:25 +0900
Message-ID: <CAAFQd5DH2i+8ZJ+s2XUnmFHwxXKLF6z_=w0Z-RFs=W9oVvrJgw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] media: venus: add a routine to set venus state
To: vgarodia@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jordan, Vikash,

On Sat, Jun 2, 2018 at 6:21 AM Jordan Crouse <jcrouse@codeaurora.org> wrote:
>
> On Sat, Jun 02, 2018 at 01:56:05AM +0530, Vikash Garodia wrote:
[snip]
> > +int venus_set_hw_state(enum tzbsp_video_state state, struct venus_core *core)
> > +{
> > +     int ret;
> > +     struct device *dev = core->dev;
>
> If you get rid of the log message as you should, you don't need this.
>
> > +     void __iomem *reg_base = core->base;
> > +
> > +     switch (state) {
> > +     case TZBSP_VIDEO_SUSPEND:
> > +             if (qcom_scm_is_available())
> > +                     ret = qcom_scm_set_remote_state(TZBSP_VIDEO_SUSPEND, 0);
> > +             else
> > +                     writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);
>
> You can just use core->base here and not bother making a local variable for it.
>
> > +             break;
> > +     case TZBSP_VIDEO_RESUME:
> > +             if (qcom_scm_is_available())
> > +                     ret = qcom_scm_set_remote_state(TZBSP_VIDEO_RESUME, 0);
> > +             else
> > +                     venus_reset_hw(core);
> > +             break;
> > +     default:
> > +             dev_err(dev, "invalid state\n");
>
> state is a enum - you are highly unlikely to be calling it in your own code with
> a random value.  It is smart to have the default, but you don't need the log
> message - that is just wasted space in the binary.
>
> > +             break;
> > +     }
>
> There are three paths in the switch statement that could end up with 'ret' being
> uninitialized here.  Set it to 0 when you declare it.

Does this actually compile? The compiler should detect that ret is
used uninitialized. Setting it to 0 at declaration time actually
prevents compiler from doing that and makes it impossible to catch
cases when the ret should actually be non-zero, e.g. the invalid enum
value case.

Given that this function is supposed to substitute existing calls into
qcom_scm_set_remote_state(), why not just do something like this:

        if (qcom_scm_is_available())
                return qcom_scm_set_remote_state(state, 0);

        switch (state) {
        case TZBSP_VIDEO_SUSPEND:
                writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);
                break;
        case TZBSP_VIDEO_RESUME:
                venus_reset_hw(core);
                break;
        }

        return 0;

Best regards,
Tomasz
