Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44259 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752341AbeGBPZM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 11:25:12 -0400
Received: by mail-wr0-f193.google.com with SMTP id p12-v6so15951971wrn.11
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 08:25:11 -0700 (PDT)
Subject: Re: [PATCH v4 00/27] Venus updates
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        Tomasz Figa <tfiga@chromium.org>
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
 <CAPBb6MXH7BpOXW++TxgsdRBr5C7PsHLO8jZtysGiNwUbkNW+BQ@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <6172d0e7-5557-7e2d-6ee7-e3d84050279b@linaro.org>
Date: Mon, 2 Jul 2018 18:25:09 +0300
MIME-Version: 1.0
In-Reply-To: <CAPBb6MXH7BpOXW++TxgsdRBr5C7PsHLO8jZtysGiNwUbkNW+BQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

Thanks for review comments!

On 07/02/2018 11:45 AM, Alexandre Courbot wrote:
> Hi Stanimir,
> 
> Thanks for this very well organized series and sorry for not giving
> feedback earlier.
> 
> I have tested this version against the 4.14 Chrome OS kernel tree (+ a
> few extra changes to comply with the codec API) and it was working
> flawlessly.
> 
> Therefore,
> 
> Tested-by: Alexandre Courbot <acourbot@chromium.org>

Thanks for testing!

> 
> For the whole series.
> 
> I have a few comments/questions on some patches, would be great if you
> could take a look. Also wondering what is your plan regarding codec
> API compliance? Do you plan to integrate it into the current series,
> or work on it after merging this initial work? Both ways would be ok
> as far as I am concerned.

Unfortunately I'm not ready with codec API compliance (at least for
Venus v1 & v3). I'm working on that intensively these days and I'd say
with a good progress but I still have few issues/details which needs
more attention and time.

So I guess the plan minimum is to merge this series first.

-- 
regards,
Stan
