Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36894 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbeJQRF1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 13:05:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id 185-v6so1336128wmt.2
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 02:10:41 -0700 (PDT)
Subject: Re: [PATCH v11 0/5] Venus updates - PIL
To: Vikash Garodia <vgarodia@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org
References: <1539005572-803-1-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <a31e499a-fa88-67b8-1853-8ea0d9297aa9@linaro.org>
Date: Wed, 17 Oct 2018 12:10:38 +0300
MIME-Version: 1.0
In-Reply-To: <1539005572-803-1-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

Thanks for the patches and patience!

On 10/08/2018 04:32 PM, Vikash Garodia wrote:
> This version of the series
> * extends the description of firmware subnode in documentation.
> * renames the flag suggesting the presence of tz and update code
>   accordingly.
> 
> Stanimir Varbanov (1):
>   venus: firmware: register separate platform_device for firmware loader
> 
> Vikash Garodia (4):
>   venus: firmware: add routine to reset ARM9
>   venus: firmware: move load firmware in a separate function
>   venus: firmware: add no TZ boot and shutdown routine
>   dt-bindings: media: Document bindings for venus firmware device
> 
>  .../devicetree/bindings/media/qcom,venus.txt       |  14 +-
>  drivers/media/platform/qcom/venus/core.c           |  24 ++-
>  drivers/media/platform/qcom/venus/core.h           |   6 +
>  drivers/media/platform/qcom/venus/firmware.c       | 235 +++++++++++++++++++--
>  drivers/media/platform/qcom/venus/firmware.h       |  17 +-
>  drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |   8 +
>  7 files changed, 274 insertions(+), 43 deletions(-)
> 

Tested-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

With the comment addressed in 1/5:

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
