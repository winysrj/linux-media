Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37262 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbeJQWGx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 18:06:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id 185-v6so2375632wmt.2
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 07:11:00 -0700 (PDT)
Subject: Re: [PATCH v12 0/5] Venus updates - PIL
To: Vikash Garodia <vgarodia@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org
References: <1539782303-4091-1-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <5a6bf95a-da0f-2304-3f42-68aedd6f88c8@linaro.org>
Date: Wed, 17 Oct 2018 17:10:56 +0300
MIME-Version: 1.0
In-Reply-To: <1539782303-4091-1-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vikash, thanks for the patches!

On 10/17/2018 04:18 PM, Vikash Garodia wrote:
> This version of the series
> * updates the tz flag to unsigned
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

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
