Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:39246 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753381AbeGEKQT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 06:16:19 -0400
Received: by mail-yw0-f169.google.com with SMTP id 81-v6so2768170ywb.6
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 03:16:18 -0700 (PDT)
Received: from mail-yb0-f174.google.com (mail-yb0-f174.google.com. [209.85.213.174])
        by smtp.gmail.com with ESMTPSA id k8-v6sm2198566ywa.96.2018.07.05.03.16.17
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jul 2018 03:16:17 -0700 (PDT)
Received: by mail-yb0-f174.google.com with SMTP id c10-v6so1271891ybf.9
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 03:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 5 Jul 2018 19:16:05 +0900
Message-ID: <CAAFQd5D9e8Skiwbdz5y7WU_BNddVKgFTErmcbb_E2yQ0+RAsCg@mail.gmail.com>
Subject: Re: [PATCH v4 00/27] Venus updates
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On Thu, Jun 28, 2018 at 12:27 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi,
>
> Here is v4 with following changes:
>
> - fixed kbuild test robot in 12/27.
> - fixed destination of memcpy in fill_xxx functions.
>
> v3 can be found at https://lkml.org/lkml/2018/6/13/464
>

With the comments posted by Alex fixed, please feel free to add:

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
