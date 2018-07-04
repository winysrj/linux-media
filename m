Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:42104 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753262AbeGDKJO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 06:09:14 -0400
Received: by mail-yw0-f196.google.com with SMTP id y203-v6so1749042ywd.9
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 03:09:14 -0700 (PDT)
Received: from mail-yb0-f181.google.com (mail-yb0-f181.google.com. [209.85.213.181])
        by smtp.gmail.com with ESMTPSA id o126-v6sm1171948ywf.102.2018.07.04.03.09.11
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jul 2018 03:09:12 -0700 (PDT)
Received: by mail-yb0-f181.google.com with SMTP id x10-v6so1877682ybl.10
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 03:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-3-git-send-email-vgarodia@codeaurora.org>
 <20180601212117.GD11565@jcrouse-lnx.qualcomm.com> <CAAFQd5DH2i+8ZJ+s2XUnmFHwxXKLF6z_=w0Z-RFs=W9oVvrJgw@mail.gmail.com>
 <ca7567c1df773f1223d919fab28f1460@codeaurora.org> <CAAFQd5BvTNhafus4WcoPLiBTN8X3Ls+YA0OgpfnyadDayvVQxA@mail.gmail.com>
 <5560573ed426b03ad7676ac14a291e70@codeaurora.org>
In-Reply-To: <5560573ed426b03ad7676ac14a291e70@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 4 Jul 2018 19:08:59 +0900
Message-ID: <CAAFQd5Bsh22v7jp8CAO-qQEa6kLk4Qws37DmLZUytAJbUjOCWw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] media: venus: add a routine to set venus state
To: vgarodia@codeaurora.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andy Gross <andy.gross@linaro.org>, bjorn.andersson@linaro.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        linux-media-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 4, 2018 at 6:41 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> On 2018-07-04 14:30, Tomasz Figa wrote:
> > On Wed, Jul 4, 2018 at 4:59 PM Vikash Garodia <vgarodia@codeaurora.org>
> > wrote:
> >> On 2018-06-04 18:24, Tomasz Figa wrote:
> >> > On Sat, Jun 2, 2018 at 6:21 AM Jordan Crouse <jcrouse@codeaurora.org>
> >> > wrote:
> >> >> On Sat, Jun 02, 2018 at 01:56:05AM +0530, Vikash Garodia wrote:
> >> > Given that this function is supposed to substitute existing calls into
> >> > qcom_scm_set_remote_state(), why not just do something like this:
> >> >
> >> >         if (qcom_scm_is_available())
> >> >                 return qcom_scm_set_remote_state(state, 0);
> >> >
> >> >         switch (state) {
> >> >         case TZBSP_VIDEO_SUSPEND:
> >> >                 writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);
> >> >                 break;
> >> >         case TZBSP_VIDEO_RESUME:
> >> >                 venus_reset_hw(core);
> >> >                 break;
> >> >         }
> >> >
> >> >         return 0;
> >> This will not work as driver will write on the register irrespective
> >> of
> >> scm
> >> availability.
> >
> > I'm sorry, where would it do so? The second line returns from the
> > function inf SCM is available, so the rest of the function wouldn't be
> > executed.
>
> Ah!! you are right. That would work as well.
> I am ok with either way, but would recommend to keep it the existing way
> as it makes it little more readable.

I personally think the early exit is more readable, as it clearly
separates the SCM and non-SCM part.

Best regards,
Tomasz
