Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35823 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753450AbdKXMxg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 07:53:36 -0500
Received: by mail-wm0-f68.google.com with SMTP id y80so22385022wmd.0
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 04:53:35 -0800 (PST)
Subject: Re: [PATCH 1/2] media: venus: venc: configure entropy mode
To: Loic Poulain <loic.poulain@linaro.org>,
        stanimir.varbanov@linaro.org, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1511516042-11415-1-git-send-email-loic.poulain@linaro.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <52e7d38d-645b-0bef-86df-4d7bd707a2da@linaro.org>
Date: Fri, 24 Nov 2017 14:53:33 +0200
MIME-Version: 1.0
In-Reply-To: <1511516042-11415-1-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Loic,

Thanks for the patch!

On 11/24/2017 11:34 AM, Loic Poulain wrote:
> H264 entropy mode can be selected via V4L2 API but is eventually not
> applied. Configure encoder with selected mode, CALVC (def) or CABAC.
> 
> Note that hw/firmware also expects a CABAC model configuration which
> currently doesn't have existing V4L2 API control. For now, use model_0
> which seems always supported and so the default one.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
