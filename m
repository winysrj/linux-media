Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38913 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755755AbeFOILv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 04:11:51 -0400
Received: by mail-wm0-f68.google.com with SMTP id p11-v6so2260221wmc.4
        for <linux-media@vger.kernel.org>; Fri, 15 Jun 2018 01:11:50 -0700 (PDT)
Subject: Re: [PATCH] media: venus: keep resolution when adjusting format
To: Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180605045046.200011-1-acourbot@chromium.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <b8ccddbe-7ff8-8098-2406-db8447c998f9@linaro.org>
Date: Fri, 15 Jun 2018 11:11:48 +0300
MIME-Version: 1.0
In-Reply-To: <20180605045046.200011-1-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

Thanks for the patch!

On 06/05/2018 07:50 AM, Alexandre Courbot wrote:
> When checking a format for validity, the resolution is reset to 1280x720
> whenever the pixel format is not supported. This behavior can mislead
> user-space into believing that this is the only resolution supported,
> and looks strange considering that if we try/set the same format with
> just the pixel format changed to a valid one, the call will this time
> succeed without altering the resolution.
> 
> Resolution is managed independently of the pixel format, so remove this
> reset.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 2 --
>  drivers/media/platform/qcom/venus/venc.c | 2 --
>  2 files changed, 4 deletions(-)

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
