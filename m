Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:39376 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753819AbeGEPAk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 11:00:40 -0400
Received: by mail-io0-f178.google.com with SMTP id e13-v6so8013629iof.6
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 08:00:39 -0700 (PDT)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com. [209.85.214.52])
        by smtp.gmail.com with ESMTPSA id l82-v6sm3305553itl.25.2018.07.05.08.00.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jul 2018 08:00:37 -0700 (PDT)
Received: by mail-it0-f52.google.com with SMTP id o5-v6so12402920itc.1
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 08:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
 <CAAFQd5CQCF=QvTgq8v6K6W6C0Cy27CzHsMxQn+FnML97w9xnCw@mail.gmail.com>
 <150eb3b4-8b64-6050-6a4e-e06cfaf113cc@xs4all.nl> <6abf8da2-b2e1-1b4f-2727-f9d074081c30@linaro.org>
In-Reply-To: <6abf8da2-b2e1-1b4f-2727-f9d074081c30@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 6 Jul 2018 00:00:24 +0900
Message-ID: <CAPBb6MWoysaL_i8i7HaegRCsfF29bnOy2L5ZHgEwDuSJ7HVO2w@mail.gmail.com>
Subject: Re: [PATCH v5 00/27] Venus updates
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 5, 2018 at 11:52 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi,
>
> On 07/05/2018 05:08 PM, Hans Verkuil wrote:
> > On 05/07/18 16:07, Tomasz Figa wrote:
> >> Hi Stanimir,
> >>
> >> On Thu, Jul 5, 2018 at 10:05 PM Stanimir Varbanov
> >> <stanimir.varbanov@linaro.org> wrote:
> >>>
> >>> Hi,
> >>>
> >>> Changes since v4:
> >>>  * 02/27 re-write intbufs_alloc as suggested by Alex, and
> >>>    moved new structures in 03/27 where they are used
> >>>  * 11/27 exit early if error occur in vdec_runtime_suspend
> >>>    venc_runtime_suspend and avoid ORing ret variable
> >>>  * 12/27 fixed typo in patch description
> >>>  * added a const when declare ptype variable
> >>>
> >>> Previous v4 can be found at https://lkml.org/lkml/2018/6/27/404
> >>
> >> Thanks for the patches!
> >>
> >> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
>
> Thanks Tomasz!
>
> >
> > Are we waiting for anything else? Otherwise I plan to make a pull request for
> > this tomorrow.
>
> I think we are done.

I would just like to give this one last test - will be done by tomorrow JST.
