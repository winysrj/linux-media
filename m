Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:37961 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbeJKQCK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 12:02:10 -0400
Received: by mail-io1-f68.google.com with SMTP id n5-v6so5970003ioh.5
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2018 01:35:56 -0700 (PDT)
Received: from mail-it1-f176.google.com (mail-it1-f176.google.com. [209.85.166.176])
        by smtp.gmail.com with ESMTPSA id u1-v6sm16045746itu.42.2018.10.11.01.35.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Oct 2018 01:35:54 -0700 (PDT)
Received: by mail-it1-f176.google.com with SMTP id i191-v6so12011622iti.5
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2018 01:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20181011064608.37435-1-acourbot@chromium.org> <CAPBb6MXXwCOP6w7WdAFXdbmBLWKFp9gVDUW=uE=UFGiq_jPakg@mail.gmail.com>
 <93410466-ae47-b3ef-98ed-7cfe24a91776@linaro.org>
In-Reply-To: <93410466-ae47-b3ef-98ed-7cfe24a91776@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Thu, 11 Oct 2018 17:35:42 +0900
Message-ID: <CAPBb6MVP84xSRrM9tuoG7zhUS1tGSJSNBCjwWBCyqWJ4D8jHRA@mail.gmail.com>
Subject: Re: [PATCH] media: venus: support VB2_USERPTR IO mode
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 11, 2018 at 5:26 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Alex,
>
> On 10/11/2018 09:50 AM, Alexandre Courbot wrote:
> > Please ignore this patch - I did not notice that a similar one has
> > been sent before.
>
> The difference is that you made it for decoder as well. Do you need
> userptr for decoder?

Not at the moment, so this part has not been tested. Better to take
Malathi's patch.
