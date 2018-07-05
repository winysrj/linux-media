Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:42253 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753397AbeGEOHW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 10:07:22 -0400
Received: by mail-yb0-f194.google.com with SMTP id c10-v6so1513038ybf.9
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 07:07:22 -0700 (PDT)
Received: from mail-yw0-f170.google.com (mail-yw0-f170.google.com. [209.85.161.170])
        by smtp.gmail.com with ESMTPSA id r132-v6sm2293280ywh.94.2018.07.05.07.07.19
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jul 2018 07:07:20 -0700 (PDT)
Received: by mail-yw0-f170.google.com with SMTP id 139-v6so2988137ywg.12
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 07:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 5 Jul 2018 23:07:07 +0900
Message-ID: <CAAFQd5CQCF=QvTgq8v6K6W6C0Cy27CzHsMxQn+FnML97w9xnCw@mail.gmail.com>
Subject: Re: [PATCH v5 00/27] Venus updates
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org, Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On Thu, Jul 5, 2018 at 10:05 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi,
>
> Changes since v4:
>  * 02/27 re-write intbufs_alloc as suggested by Alex, and
>    moved new structures in 03/27 where they are used
>  * 11/27 exit early if error occur in vdec_runtime_suspend
>    venc_runtime_suspend and avoid ORing ret variable
>  * 12/27 fixed typo in patch description
>  * added a const when declare ptype variable
>
> Previous v4 can be found at https://lkml.org/lkml/2018/6/27/404

Thanks for the patches!

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
