Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:35646 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388875AbeIUMn5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 08:43:57 -0400
Received: by mail-it1-f194.google.com with SMTP id 139-v6so854173itf.0
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2018 23:56:28 -0700 (PDT)
Subject: Re: [PATCHv2] media: qcom: remove duplicated include file
To: zhong jiang <zhongjiang@huawei.com>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1537500620-21069-1-git-send-email-zhongjiang@huawei.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <3d4dda8b-7f9d-9f44-efdc-8fbd79673e9e@linaro.org>
Date: Thu, 20 Sep 2018 23:56:25 -0700
MIME-Version: 1.0
In-Reply-To: <1537500620-21069-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you, Zhong.

On 20.09.2018 20:30, zhong jiang wrote:
> We include device.h twice in camss.h. It's unnecessary.
> hence just remove it.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: Todor Tomov <todor.tomov@linaro.org>

> ---
>  drivers/media/platform/qcom/camss/camss.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/qcom/camss/camss.h b/drivers/media/platform/qcom/camss/camss.h
> index 418996d..f32289c 100644
> --- a/drivers/media/platform/qcom/camss/camss.h
> +++ b/drivers/media/platform/qcom/camss/camss.h
> @@ -17,7 +17,6 @@
>  #include <media/v4l2-subdev.h>
>  #include <media/media-device.h>
>  #include <media/media-entity.h>
> -#include <linux/device.h>
>  
>  #include "camss-csid.h"
>  #include "camss-csiphy.h"
> 
