Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52814 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753339AbeGDJlv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 05:41:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Jul 2018 15:11:49 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Tomasz Figa <tfiga@chromium.org>
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
Subject: Re: [PATCH v2 2/5] media: venus: add a routine to set venus state
In-Reply-To: <CAAFQd5BvTNhafus4WcoPLiBTN8X3Ls+YA0OgpfnyadDayvVQxA@mail.gmail.com>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-3-git-send-email-vgarodia@codeaurora.org>
 <20180601212117.GD11565@jcrouse-lnx.qualcomm.com>
 <CAAFQd5DH2i+8ZJ+s2XUnmFHwxXKLF6z_=w0Z-RFs=W9oVvrJgw@mail.gmail.com>
 <ca7567c1df773f1223d919fab28f1460@codeaurora.org>
 <CAAFQd5BvTNhafus4WcoPLiBTN8X3Ls+YA0OgpfnyadDayvVQxA@mail.gmail.com>
Message-ID: <5560573ed426b03ad7676ac14a291e70@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-07-04 14:30, Tomasz Figa wrote:
> On Wed, Jul 4, 2018 at 4:59 PM Vikash Garodia <vgarodia@codeaurora.org> 
> wrote:
>> On 2018-06-04 18:24, Tomasz Figa wrote:
>> > On Sat, Jun 2, 2018 at 6:21 AM Jordan Crouse <jcrouse@codeaurora.org>
>> > wrote:
>> >> On Sat, Jun 02, 2018 at 01:56:05AM +0530, Vikash Garodia wrote:
>> > Given that this function is supposed to substitute existing calls into
>> > qcom_scm_set_remote_state(), why not just do something like this:
>> >
>> >         if (qcom_scm_is_available())
>> >                 return qcom_scm_set_remote_state(state, 0);
>> >
>> >         switch (state) {
>> >         case TZBSP_VIDEO_SUSPEND:
>> >                 writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);
>> >                 break;
>> >         case TZBSP_VIDEO_RESUME:
>> >                 venus_reset_hw(core);
>> >                 break;
>> >         }
>> >
>> >         return 0;
>> This will not work as driver will write on the register irrespective 
>> of
>> scm
>> availability.
> 
> I'm sorry, where would it do so? The second line returns from the
> function inf SCM is available, so the rest of the function wouldn't be
> executed.

Ah!! you are right. That would work as well.
I am ok with either way, but would recommend to keep it the existing way
as it makes it little more readable.

> Best regards,
> Tomasz
