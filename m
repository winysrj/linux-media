Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36178 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752574AbeFFBe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 21:34:59 -0400
Received: by mail-io0-f196.google.com with SMTP id d73-v6so5753567iog.3
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 18:34:59 -0700 (PDT)
Received: from mail-it0-f47.google.com (mail-it0-f47.google.com. [209.85.214.47])
        by smtp.gmail.com with ESMTPSA id c90-v6sm1401218itd.13.2018.06.05.18.34.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Jun 2018 18:34:57 -0700 (PDT)
Received: by mail-it0-f47.google.com with SMTP id j186-v6so5930468ita.5
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 18:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-2-git-send-email-vgarodia@codeaurora.org>
 <894ab678-bc1d-da04-b552-d53301bd3980@linaro.org> <20180605105716.GT16230@vkoul-mobl>
In-Reply-To: <20180605105716.GT16230@vkoul-mobl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 6 Jun 2018 10:34:45 +0900
Message-ID: <CAPBb6MWSOFQT0ZuV_MJhjPzTYUhoPgRXUhT_dawTqDCtVXEmBA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] media: venus: add a routine to reset ARM9
To: vkoul@kernel.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        vgarodia@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 5, 2018 at 7:57 PM Vinod <vkoul@kernel.org> wrote:
>
> On 02-06-18, 01:15, Stanimir Varbanov wrote:
> > Hi Vikash,
> >
> > On  1.06.2018 23:26, Vikash Garodia wrote:
> > > Add a new routine to reset the ARM9 and brings it
> > > out of reset. This is in preparation to add PIL
> > > functionality in venus driver.
> >
> > please squash this patch with 4/5. I don't see a reason to add a function
> > which is not used. Shouldn't this produce gcc warnings?
>
> Yes this would but in a multi patch series that is okay as subsequent
> patches would use that and end result in no warning.

Except during bisect.

>
> Splitting logically is good and typical practice in kernel to add the
> routine followed by usages..

Is it in this case though? If this code was shared across multiple
users I could understand but this function is only used locally (and
only in one place IIUC). Also the patch is not so big that the code
would become confusing if this was squashed into 4/5. I don't see any
reason to keep this separate.
