Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44443 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbeHNPch (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 11:32:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id r16-v6so17074113wrt.11
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2018 05:45:35 -0700 (PDT)
Subject: Re: [PATCH] [v2] media: camss: add missing includes
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180814091636.1960071-1-arnd@arndb.de>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <565437f4-e01a-4558-ccc1-4f312e26cf35@linaro.org>
Date: Tue, 14 Aug 2018 15:45:32 +0300
MIME-Version: 1.0
In-Reply-To: <20180814091636.1960071-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On 14.08.2018 12:13, Arnd Bergmann wrote:
> Multiple files in this driver fail to build because of missing
> header inclusions:
> 
> drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c: In function 'csiphy_hw_version_read':
> drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c:31:18: error: implicit declaration of function 'readl_relaxed'; did you mean 'xchg_relaxed'? [-Werror=implicit-function-declaration]
> drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c: In function 'csiphy_hw_version_read':
> drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c:52:2: error: implicit declaration of function 'writel' [-Werror=implicit-function-declaration]

Thank you for noticing this and preparing a patch.
I build for arm64 and x86_64 with compile test enabled and I don't see these errors. Do you have a guess what is different that I don't have them?

> drivers/media/platform/qcom/camss/camss-ispif.c: In function 'msm_ispif_subdev_init':
> drivers/media/platform/qcom/camss/camss-ispif.c:1079:16: error: implicit declaration of function 'kcalloc'; did you mean 'kvcalloc'? [-Werror=implicit-function-declaration]

Maybe we have to use devm_kcalloc instead of kcalloc here, I will check this.

Best regards,
Todor

> 
> Add the ones that I observed, plus linux/io.h in all other files that
> call readl/writel and related interfaces.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: actually add the linux/io.h instances for files that did not show
> the error but might still be affected because of the readl/writel usage
> ---
>  drivers/media/platform/qcom/camss/camss-csid.c           | 1 +
>  drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c | 1 +
>  drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c | 1 +
>  drivers/media/platform/qcom/camss/camss-csiphy.c         | 1 +
>  drivers/media/platform/qcom/camss/camss-ispif.c          | 2 ++
>  drivers/media/platform/qcom/camss/camss-vfe-4-1.c        | 1 +
>  drivers/media/platform/qcom/camss/camss-vfe-4-7.c        | 1 +
>  7 files changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
> index 729b31891466..a5ae85674ffb 100644
> --- a/drivers/media/platform/qcom/camss/camss-csid.c
> +++ b/drivers/media/platform/qcom/camss/camss-csid.c
> @@ -10,6 +10,7 @@
>  #include <linux/clk.h>
>  #include <linux/completion.h>
>  #include <linux/interrupt.h>
> +#include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
> index c832539397d7..12bce391d71f 100644
> --- a/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
> +++ b/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
> +#include <linux/io.h>
>  
>  #define CAMSS_CSI_PHY_LNn_CFG2(n)		(0x004 + 0x40 * (n))
>  #define CAMSS_CSI_PHY_LNn_CFG3(n)		(0x008 + 0x40 * (n))
> diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
> index bcd0dfd33618..2e65caf1ecae 100644
> --- a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
> +++ b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
> +#include <linux/io.h>
>  
>  #define CSIPHY_3PH_LNn_CFG1(n)			(0x000 + 0x100 * (n))
>  #define CSIPHY_3PH_LNn_CFG1_SWI_REC_DLY_PRG	(BIT(7) | BIT(6))
> diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
> index 4559f3b1b38c..008afb85023b 100644
> --- a/drivers/media/platform/qcom/camss/camss-csiphy.c
> +++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
> @@ -10,6 +10,7 @@
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
> +#include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> diff --git a/drivers/media/platform/qcom/camss/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
> index 7f269021d08c..d824c4958c07 100644
> --- a/drivers/media/platform/qcom/camss/camss-ispif.c
> +++ b/drivers/media/platform/qcom/camss/camss-ispif.c
> @@ -10,11 +10,13 @@
>  #include <linux/clk.h>
>  #include <linux/completion.h>
>  #include <linux/interrupt.h>
> +#include <linux/io.h>
>  #include <linux/iopoll.h>
>  #include <linux/kernel.h>
>  #include <linux/mutex.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/slab.h>
>  #include <media/media-entity.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
> diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
> index da3a9fed9f2d..174a36be6f5d 100644
> --- a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
> +++ b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/interrupt.h>
> +#include <linux/io.h>
>  #include <linux/iopoll.h>
>  
>  #include "camss-vfe.h"
> diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
> index 4c584bffd179..0dca8bf9281e 100644
> --- a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
> +++ b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/interrupt.h>
> +#include <linux/io.h>
>  #include <linux/iopoll.h>
>  
>  #include "camss-vfe.h"
> 

-- 
Best regards,
Todor Tomov
