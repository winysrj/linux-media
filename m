Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33479 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754324AbeEaJzU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 05:55:20 -0400
Received: by mail-vk0-f67.google.com with SMTP id 200-v6so10893905vkc.0
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 02:55:20 -0700 (PDT)
Received: from mail-vk0-f50.google.com (mail-vk0-f50.google.com. [209.85.213.50])
        by smtp.gmail.com with ESMTPSA id j18-v6sm10051147uag.20.2018.05.31.02.55.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 May 2018 02:55:18 -0700 (PDT)
Received: by mail-vk0-f50.google.com with SMTP id 200-v6so10893867vkc.0
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 02:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 31 May 2018 18:55:06 +0900
Message-ID: <CAAFQd5C7zB5r3S85vbUWyaUHinMREmk2=2osWpU9AQihYMPhRw@mail.gmail.com>
Subject: Re: [PATCH v2 00/29] Venus updates
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

On Tue, May 15, 2018 at 5:14 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hello,
>
> Here is v2 with following comments addressed:
>
> * reworked venus suspend 3xx and reuse it for 4xx.
> * drop 10/28 patch from v1, i.e. call of session_continue when
>   buffer requirements are not sufficient.
> * fixed kbuild test robot warning in 11/28 by allocating instance
>   variable from heap.
> * spelling typo in 15/28.
> * added Reviewed-by for DT changes.
> * extended 28/28 HEVC support for encoder, now the profile and
>   level are selected properly.
>
> Comments are welcome!

Thanks a lot for the series. I finally managed to finish reviewing it.
Sorry for taking so long.

For the patches I didn't send any comments for, please feel free to
add my Reviewed-by.

Best regards,
Tomasz
