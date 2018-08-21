Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53988 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbeHUJKh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 05:10:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Aug 2018 11:21:56 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Venus updates - PIL
In-Reply-To: <1533562085-8773-1-git-send-email-vgarodia@codeaurora.org>
References: <1533562085-8773-1-git-send-email-vgarodia@codeaurora.org>
Message-ID: <1cf867118f803a359b258dcc823e1442@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<Friendly reminder for review>

On 2018-08-06 18:58, Vikash Garodia wrote:
> Hello,
> 
> Here is v4 with following comments addressed:
> 
> * inline function for setting suspend and resume.
> * keep firmware size as 6 MB.
> * comments related to indentation, cleanup, etc.
> 
> As per comments from Bjorn, qcom_mdt_load_no_init is being used in this
> patch series to align with 
> https://patchwork.kernel.org/patch/10397889/.
> 
> Comments are welcome!
> 
> Vikash Garodia (4):
>   venus: firmware: add routine to reset ARM9
>   venus: firmware: move load firmware in a separate function
>   venus: firmware: add no TZ boot and shutdown routine
>   venus: firmware: register separate driver for firmware device
> 
>  .../devicetree/bindings/media/qcom,venus.txt       |  17 +-
>  drivers/media/platform/qcom/venus/core.c           |  60 +++++--
>  drivers/media/platform/qcom/venus/core.h           |   7 +
>  drivers/media/platform/qcom/venus/firmware.c       | 192 
> ++++++++++++++++++---
>  drivers/media/platform/qcom/venus/firmware.h       |  17 +-
>  drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |   6 +
>  7 files changed, 268 insertions(+), 44 deletions(-)
