Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:44475 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753123AbeGEXgo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 19:36:44 -0400
Date: Thu, 5 Jul 2018 17:36:42 -0600
From: Rob Herring <robh@kernel.org>
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, mark.rutland@arm.com, andy.gross@linaro.org,
        arnd@arndb.de, bjorn.andersson@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
Subject: Re: [PATCH v3 4/4] venus: firmware: register separate driver for
 firmware device
Message-ID: <20180705233642.GA27823@rob-hp-laptop>
References: <1530731212-30474-1-git-send-email-vgarodia@codeaurora.org>
 <1530731212-30474-5-git-send-email-vgarodia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530731212-30474-5-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 05, 2018 at 12:36:52AM +0530, Vikash Garodia wrote:
> A separate child device is added for video firmware.
> This is needed to
> [1] configure the firmware context bank with the desired SID.
> [2] ensure that the iova for firmware region is from 0x0.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  .../devicetree/bindings/media/qcom,venus.txt       | 17 +++++++-

Reviewed-by: Rob Herring <robh@kernel.org>

>  drivers/media/platform/qcom/venus/core.c           | 49 +++++++++++++++++++---
>  drivers/media/platform/qcom/venus/firmware.c       | 18 ++++++++
>  drivers/media/platform/qcom/venus/firmware.h       |  2 +
>  4 files changed, 80 insertions(+), 6 deletions(-)
