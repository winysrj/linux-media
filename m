Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbeISFUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 01:20:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Sep 2018 05:15:38 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
Subject: Re: [PATCH v8 0/5] Venus updates - PIL
In-Reply-To: <1537307954-9729-1-git-send-email-vgarodia@codeaurora.org>
References: <1537307954-9729-1-git-send-email-vgarodia@codeaurora.org>
Message-ID: <72fb5d7d570c7f5520cc304bea800ae6@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ignore the v8 of this series. The code that was modified was added to 
wrong
patchset while handling the git rebase.
Please review the version 9.

On 2018-09-19 03:29, Vikash Garodia wrote:
> This series just fixes the compilation for of_dma_configure.
> Minor #define name improvement and indentations.
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
>  drivers/media/platform/qcom/venus/firmware.c       | 234 
> +++++++++++++++++++--
>  drivers/media/platform/qcom/venus/firmware.h       |  17 +-
>  drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |   8 +
>  7 files changed, 272 insertions(+), 43 deletions(-)
