Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40302 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbeHQOfg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 10:35:36 -0400
Received: by mail-wm0-f67.google.com with SMTP id y9-v6so7131626wma.5
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2018 04:32:28 -0700 (PDT)
Subject: Re: [PATCH] media: camss: mark PM functions as __maybe_unused
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180817095425.2630974-1-arnd@arndb.de>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <080262bf-d354-1ec4-761c-a086a7e268fb@linaro.org>
Date: Fri, 17 Aug 2018 14:32:25 +0300
MIME-Version: 1.0
In-Reply-To: <20180817095425.2630974-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you Arnd.

On 17.08.2018 12:53, Arnd Bergmann wrote:
> The empty suspend/resume functions cause a build warning
> when they are unused:
> 
> drivers/media/platform/qcom/camss/camss.c:1001:12: error: 'camss_runtime_resume' defined but not used [-Werror=unused-function]
> drivers/media/platform/qcom/camss/camss.c:996:12: error: 'camss_runtime_suspend' defined but not used [-Werror=unused-function]
> 
> Mark them as __maybe_unused so the compiler can silently drop them.
> 
> Fixes: 02afa816dbbf ("media: camss: Add basic runtime PM support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Todor Tomov <todor.tomov@linaro.org>

> ---
>  drivers/media/platform/qcom/camss/camss.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
> index dcc0c30ef1b1..9f19d5f5966b 100644
> --- a/drivers/media/platform/qcom/camss/camss.c
> +++ b/drivers/media/platform/qcom/camss/camss.c
> @@ -993,12 +993,12 @@ static const struct of_device_id camss_dt_match[] = {
>  
>  MODULE_DEVICE_TABLE(of, camss_dt_match);
>  
> -static int camss_runtime_suspend(struct device *dev)
> +static int __maybe_unused camss_runtime_suspend(struct device *dev)
>  {
>  	return 0;
>  }
>  
> -static int camss_runtime_resume(struct device *dev)
> +static int __maybe_unused camss_runtime_resume(struct device *dev)
>  {
>  	return 0;
>  }
> 

-- 
Best regards,
Todor Tomov
