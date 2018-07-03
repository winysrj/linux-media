Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37585 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754218AbeGCIt3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 04:49:29 -0400
Received: by mail-it0-f54.google.com with SMTP id p17-v6so2033969itc.2
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 01:49:29 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com. [209.85.223.171])
        by smtp.gmail.com with ESMTPSA id l126-v6sm412331itb.5.2018.07.03.01.49.27
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Jul 2018 01:49:28 -0700 (PDT)
Received: by mail-io0-f171.google.com with SMTP id t135-v6so1012528iof.7
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 01:49:27 -0700 (PDT)
MIME-Version: 1.0
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
 <CAPBb6MXH7BpOXW++TxgsdRBr5C7PsHLO8jZtysGiNwUbkNW+BQ@mail.gmail.com> <6172d0e7-5557-7e2d-6ee7-e3d84050279b@linaro.org>
In-Reply-To: <6172d0e7-5557-7e2d-6ee7-e3d84050279b@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 3 Jul 2018 17:49:16 +0900
Message-ID: <CAPBb6MV6ApT_B1A3LKZuXG4Q2Y_M6fgH2hQ55qVWdZBuKFdBMQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/27] Venus updates
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 3, 2018 at 12:25 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Alex,
>
> Thanks for review comments!
>
> On 07/02/2018 11:45 AM, Alexandre Courbot wrote:
> > Hi Stanimir,
> >
> > Thanks for this very well organized series and sorry for not giving
> > feedback earlier.
> >
> > I have tested this version against the 4.14 Chrome OS kernel tree (+ a
> > few extra changes to comply with the codec API) and it was working
> > flawlessly.
> >
> > Therefore,
> >
> > Tested-by: Alexandre Courbot <acourbot@chromium.org>
>
> Thanks for testing!
>
> >
> > For the whole series.
> >
> > I have a few comments/questions on some patches, would be great if you
> > could take a look. Also wondering what is your plan regarding codec
> > API compliance? Do you plan to integrate it into the current series,
> > or work on it after merging this initial work? Both ways would be ok
> > as far as I am concerned.
>
> Unfortunately I'm not ready with codec API compliance (at least for
> Venus v1 & v3). I'm working on that intensively these days and I'd say
> with a good progress but I still have few issues/details which needs
> more attention and time.
>
> So I guess the plan minimum is to merge this series first.

I'm fine with that. That will also allow us to tune the Codec API spec
using this driver as reference.
