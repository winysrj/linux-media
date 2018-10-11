Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35112 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbeJKPwX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 11:52:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id w5-v6so8631007wrt.2
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2018 01:26:10 -0700 (PDT)
Subject: Re: [PATCH] media: venus: support VB2_USERPTR IO mode
To: Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20181011064608.37435-1-acourbot@chromium.org>
 <CAPBb6MXXwCOP6w7WdAFXdbmBLWKFp9gVDUW=uE=UFGiq_jPakg@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <93410466-ae47-b3ef-98ed-7cfe24a91776@linaro.org>
Date: Thu, 11 Oct 2018 11:26:06 +0300
MIME-Version: 1.0
In-Reply-To: <CAPBb6MXXwCOP6w7WdAFXdbmBLWKFp9gVDUW=uE=UFGiq_jPakg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On 10/11/2018 09:50 AM, Alexandre Courbot wrote:
> Please ignore this patch - I did not notice that a similar one has
> been sent before. 

The difference is that you made it for decoder as well. Do you need
userptr for decoder?


-- 
regards,
Stan
