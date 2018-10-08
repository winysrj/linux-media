Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48628 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbeJHUq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 16:46:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Oct 2018 19:04:41 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v10 0/5] Venus updates - PIL
In-Reply-To: <1539004982-32555-1-git-send-email-vgarodia@codeaurora.org>
References: <1539004982-32555-1-git-send-email-vgarodia@codeaurora.org>
Message-ID: <20bef432f5c7c98e6fc623efdded8c94@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please ignore this version. Forgot to update the documentation.
Updated the same in v11 and posted it.

On 2018-10-08 18:52, Vikash Garodia wrote:
> This version of the series
> * extends the description of firmware subnode in documentation.
> * renames the flag suggesting the presence of tz and update code
>   accordingly.
> 
> Stanimir Varbanov (1):
>   venus: firmware: register separate platform_device for firmware 
> loader
> 
> Vikash Garodia (4):
>   venus: firmware: add routine to reset ARM9
>   venus: firmware: move load firmware in a separate function
>   venus: firmware: add no TZ boot and shutdown routine
>   dt-bindings: media: Document bindings for venus firmware device
> 
>  .../devicetree/bindings/media/qcom,venus.txt       |  13 +-
>  drivers/media/platform/qcom/venus/core.c           |  24 ++-
>  drivers/media/platform/qcom/venus/core.h           |   6 +
>  drivers/media/platform/qcom/venus/firmware.c       | 235 
> +++++++++++++++++++--
>  drivers/media/platform/qcom/venus/firmware.h       |  17 +-
>  drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |   8 +
>  7 files changed, 273 insertions(+), 43 deletions(-)

Thanks,
Vikash
