Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43401 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbeIZOCv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 10:02:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id z14-v6so8412478wrs.10
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2018 00:51:12 -0700 (PDT)
Subject: Re: [PATCH v9 3/5] venus: firmware: register separate platform_device
 for firmware loader
To: Vikash Garodia <vgarodia@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
References: <1537314192-26892-1-git-send-email-vgarodia@codeaurora.org>
 <1537314192-26892-4-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <b1753857-70d9-c909-26b6-2b5ff3468bd9@linaro.org>
Date: Wed, 26 Sep 2018 10:51:08 +0300
MIME-Version: 1.0
In-Reply-To: <1537314192-26892-4-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 09/19/2018 02:43 AM, Vikash Garodia wrote:
> From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> 
> This registers a firmware platform_device and associate it with
> video-firmware DT subnode. Then calls dma configure to initialize
> dma and iommu.

Please replace the description with something like this:

This registers a firmware platform_device and associates it with
video-firmware DT subnode, by that way we are able to parse iommu
configuration.

> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/core.c     | 14 +++++---
>  drivers/media/platform/qcom/venus/core.h     |  3 ++
>  drivers/media/platform/qcom/venus/firmware.c | 54 ++++++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/firmware.h |  2 ++
>  4 files changed, 69 insertions(+), 4 deletions(-)
> 

-- 
regards,
Stan
