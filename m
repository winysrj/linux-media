Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40974 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752814AbdF0Tl5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 15:41:57 -0400
Subject: Re: [PATCH 1/3] [media] venus: mark PM functions as __maybe_unused
To: Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170627150310.719212-1-arnd@arndb.de>
From: Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <f41a39c6-71e7-2ebf-62e2-6b094e53053d@mm-sol.com>
Date: Tue, 27 Jun 2017 22:41:52 +0300
MIME-Version: 1.0
In-Reply-To: <20170627150310.719212-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thanks for the catch!

On 27.06.2017 18:02, Arnd Bergmann wrote:
> Without PM support, gcc warns about two unused functions:
> 
> platform/qcom/venus/core.c:146:13: error: 'venus_clks_disable' defined but not used [-Werror=unused-function]
> platform/qcom/venus/core.c:126:12: error: 'venus_clks_enable' defined but not used [-Werror=unused-function]
> 
> The problem as usual are incorrect #ifdefs, so the easiest fix
> is to do away with the #ifdef completely and mark the suspend/resume
> handlers as __maybe_unused, which they are.
> 
> Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

> ---
>   drivers/media/platform/qcom/venus/core.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> index d8cbe8549d97..47f79637938c 100644
> --- a/drivers/media/platform/qcom/venus/core.c
> +++ b/drivers/media/platform/qcom/venus/core.c
> @@ -270,8 +270,7 @@ static int venus_remove(struct platform_device *pdev)
>   	return ret;
>   }
>   
> -#ifdef CONFIG_PM
> -static int venus_runtime_suspend(struct device *dev)
> +static __maybe_unused int venus_runtime_suspend(struct device *dev)
>   {
>   	struct venus_core *core = dev_get_drvdata(dev);
>   	int ret;
> @@ -283,7 +282,7 @@ static int venus_runtime_suspend(struct device *dev)
>   	return ret;
>   }
>   
> -static int venus_runtime_resume(struct device *dev)
> +static __maybe_unused int venus_runtime_resume(struct device *dev)
>   {
>   	struct venus_core *core = dev_get_drvdata(dev);
>   	int ret;
> @@ -302,7 +301,6 @@ static int venus_runtime_resume(struct device *dev)
>   	venus_clks_disable(core);
>   	return ret;
>   }
> -#endif
>   
>   static const struct dev_pm_ops venus_pm_ops = {
>   	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
> 
