Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:54299 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbeITLgp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 07:36:45 -0400
Received: by mail-it0-f67.google.com with SMTP id f14-v6so11597437ita.4
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 22:55:05 -0700 (PDT)
Subject: Re: [PATCH] media: qcom: remove duplicated include file
To: zhong jiang <zhongjiang@huawei.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1537419595-29990-1-git-send-email-zhongjiang@huawei.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <43b41757-18ea-cbb3-1578-ba4068b13ab1@linaro.org>
Date: Wed, 19 Sep 2018 22:55:03 -0700
MIME-Version: 1.0
In-Reply-To: <1537419595-29990-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for spotting that!

On 19.09.2018 21:59, zhong jiang wrote:
> device.h have duplicated include. hence just remove
> redundant include file.

I think it will be better to remove the second occurrence because
it will keep the alphabetical order of the includes.

Best regards,
Todor Tomov

> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/media/platform/qcom/camss/camss.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/qcom/camss/camss.h b/drivers/media/platform/qcom/camss/camss.h
> index 418996d..0823a71 100644
> --- a/drivers/media/platform/qcom/camss/camss.h
> +++ b/drivers/media/platform/qcom/camss/camss.h
> @@ -10,7 +10,6 @@
>  #ifndef QC_MSM_CAMSS_H
>  #define QC_MSM_CAMSS_H
>  
> -#include <linux/device.h>
>  #include <linux/types.h>
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-device.h>
> 
