Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:44745 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbeH2CI6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 22:08:58 -0400
Date: Tue, 28 Aug 2018 17:15:14 -0500
From: Rob Herring <robh@kernel.org>
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, mark.rutland@arm.com, andy.gross@linaro.org,
        arnd@arndb.de, bjorn.andersson@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
Subject: Re: [PATCH v6 4/4] venus: firmware: register separate
 platform_device for firmware loader
Message-ID: <20180828221514.GA8820@bogus>
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
 <1535034528-11590-5-git-send-email-vgarodia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535034528-11590-5-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 23, 2018 at 07:58:48PM +0530, Vikash Garodia wrote:
> From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> 
> This registers a firmware platform_device and associate it with
> video-firmware DT subnode. Then calls dma configure to initialize
> dma and iommu.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  .../devicetree/bindings/media/qcom,venus.txt       | 13 +++++-

In the future, please split binding patches.

Reviewed-by: Rob Herring <robh@kernel.org>

>  drivers/media/platform/qcom/venus/core.c           | 14 +++++--
>  drivers/media/platform/qcom/venus/firmware.c       | 49 ++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/firmware.h       |  2 +
>  4 files changed, 73 insertions(+), 5 deletions(-)
