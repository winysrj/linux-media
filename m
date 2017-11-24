Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38863 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753450AbdKXMxa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 07:53:30 -0500
Received: by mail-wm0-f67.google.com with SMTP id 128so22369891wmo.3
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 04:53:30 -0800 (PST)
Subject: Re: [PATCH 2/2] media: venus: venc: Apply inloop deblocking filter
To: Loic Poulain <loic.poulain@linaro.org>,
        stanimir.varbanov@linaro.org, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1511516042-11415-1-git-send-email-loic.poulain@linaro.org>
 <1511516042-11415-2-git-send-email-loic.poulain@linaro.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <efc2292d-a963-94ef-8f33-cb286e1d903f@linaro.org>
Date: Fri, 24 Nov 2017 14:53:27 +0200
MIME-Version: 1.0
In-Reply-To: <1511516042-11415-2-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Loic,

Thanks for the patch!

On 11/24/2017 11:34 AM, Loic Poulain wrote:
> Deblocking filter allows to reduce blocking artifacts and improve
> visual quality. This is configurable via the V4L2 API but eventually
> not applied to the encoder.
> 
> Note that alpha and beta deblocking values are 32-bit signed (-6;+6).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/core.h       |  4 ++--
>  drivers/media/platform/qcom/venus/hfi_helper.h |  4 ++--
>  drivers/media/platform/qcom/venus/venc.c       | 22 ++++++++++++++++++++++
>  3 files changed, 26 insertions(+), 4 deletions(-)

Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
