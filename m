Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966243AbeEYMEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 08:04:43 -0400
Received: from mail-qt0-f176.google.com (mail-qt0-f176.google.com [209.85.216.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46B5620857
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 12:04:42 +0000 (UTC)
Received: by mail-qt0-f176.google.com with SMTP id f1-v6so6186972qtj.6
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 05:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <1527246209-26685-1-git-send-email-vgarodia@codeaurora.org> <1527246209-26685-2-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1527246209-26685-2-git-send-email-vgarodia@codeaurora.org>
From: Josh Boyer <jwboyer@kernel.org>
Date: Fri, 25 May 2018 08:04:28 -0400
Message-ID: <CA+5PVA67tow+prVC55XF4=CbRGXJvPi2SuCMyhRyuw5qt8T6_Q@mail.gmail.com>
Subject: Re: qcom: add firmware file for Venus on SDM845
To: vgarodia@codeaurora.org
Cc: Linux Firmware <linux-firmware@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        stanimir.varbanov@linaro.org, acourbot@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 7:03 AM Vikash Garodia <vgarodia@codeaurora.org>
wrote:

> This pull request adds firmware files for Venus h/w codec found on the
Qualcomm SDM845 chipset.

> The following changes since commit
2a9b2cf50fb32e36e4fc1586c2f6f1421913b553:

>    Merge branch 'for-upstreaming-v1.7.2' of
https://github.com/felix-cavium/linux-firmware (2018-05-18 08:35:22 -0400)

> are available in the git repository at:


>    https://github.com/vgarodia/linux-firmware master

> for you to fetch changes up to d6088b9c9d7f49d3c6c43681190889eca0abdcce:

>    qcom: add venus firmware files for v5.2 (2018-05-25 15:16:43 +0530)

> ----------------------------------------------------------------
> Vikash Garodia (1):
>        qcom: add venus firmware files for v5.2

>   WHENCE                   |   9 +++++++++
>   qcom/venus-5.2/venus.b00 | Bin 0 -> 212 bytes
>   qcom/venus-5.2/venus.b01 | Bin 0 -> 6600 bytes
>   qcom/venus-5.2/venus.b02 | Bin 0 -> 819552 bytes
>   qcom/venus-5.2/venus.b03 | Bin 0 -> 33536 bytes
>   qcom/venus-5.2/venus.b04 |   1 +
>   qcom/venus-5.2/venus.mbn | Bin 0 -> 865408 bytes
>   qcom/venus-5.2/venus.mdt | Bin 0 -> 6812 bytes
>   8 files changed, 10 insertions(+)
>   create mode 100644 qcom/venus-5.2/venus.b00
>   create mode 100644 qcom/venus-5.2/venus.b01
>   create mode 100644 qcom/venus-5.2/venus.b02
>   create mode 100644 qcom/venus-5.2/venus.b03
>   create mode 100644 qcom/venus-5.2/venus.b04
>   create mode 100644 qcom/venus-5.2/venus.mbn
>   create mode 100644 qcom/venus-5.2/venus.mdt

The venus.mbn file isn't mentioned in WHENCE:

[jwboyer@vader linux-firmware]$ ./check_whence.py
E: qcom/venus-5.2/venus.mbn not listed in WHENCE
[jwboyer@vader linux-firmware]$

Can you fix that up and let me know when to re-pull?

josh
