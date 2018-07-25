Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:50424 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbeGYKqv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 06:46:51 -0400
Received: by mail-wm0-f67.google.com with SMTP id s12-v6so2046591wmc.0
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2018 02:35:59 -0700 (PDT)
Subject: Re: [PATCH v3 2/4] venus: firmware: move load firmware in a separate
 function
To: Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
References: <1530731212-30474-1-git-send-email-vgarodia@codeaurora.org>
 <1530731212-30474-3-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <b5ecaa26-2f3b-9a2e-d496-7f9b35e3f761@linaro.org>
Date: Wed, 25 Jul 2018 12:35:56 +0300
MIME-Version: 1.0
In-Reply-To: <1530731212-30474-3-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 07/04/2018 10:06 PM, Vikash Garodia wrote:
> Separate firmware loading part into a new function.

I cannot apply this patch in order to test the series.

> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.c     |  4 +-
>  drivers/media/platform/qcom/venus/firmware.c | 58 +++++++++++++++++-----------
>  drivers/media/platform/qcom/venus/firmware.h |  2 +-
>  3 files changed, 39 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> index bb6add9..75b9785 100644
> --- a/drivers/media/platform/qcom/venus/core.c
> +++ b/drivers/media/platform/qcom/venus/core.c
> @@ -84,7 +84,7 @@ static void venus_sys_error_handler(struct work_struct *work)
>  
>  	pm_runtime_get_sync(core->dev);
>  
> -	ret |= venus_boot(core->dev, core->res->fwname);
> +	ret |= venus_boot(core);
>  
>  	ret |= hfi_core_resume(core, true);
>  
> @@ -284,7 +284,7 @@ static int venus_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto err_runtime_disable;
>  
> -	ret = venus_boot(dev, core->res->fwname);
> +	ret = venus_boot(core);
>  	if (ret)
>  		goto err_runtime_disable;
>  
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 3968553d..6d6cca4 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -63,40 +63,37 @@ int venus_set_hw_state(struct venus_core *core, bool resume)
>  }
>  EXPORT_SYMBOL_GPL(venus_set_hw_state);
>  
> -int venus_boot(struct device *dev, const char *fwname)
> +static int venus_load_fw(struct venus_core *core, const char *fwname,
> +		phys_addr_t *mem_phys, size_t *mem_size)

the next function argument on new line should be just below open brace

>  {
>  	const struct firmware *mdt;
>  	struct device_node *node;
> -	phys_addr_t mem_phys;
> +	struct device *dev;
>  	struct resource r;
>  	ssize_t fw_size;
> -	size_t mem_size;
>  	void *mem_va;
>  	int ret;
>  
> -	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) || !qcom_scm_is_available())
> -		return -EPROBE_DEFER;
> -
> +	dev = core->dev;
>  	node = of_parse_phandle(dev->of_node, "memory-region", 0);
>  	if (!node) {
>  		dev_err(dev, "no memory-region specified\n");
>  		return -EINVAL;
>  	}
> -

please don't delete above blank line

>  	ret = of_address_to_resource(node, 0, &r);
>  	if (ret)
>  		return ret;
>  
> -	mem_phys = r.start;
> -	mem_size = resource_size(&r);
> +	*mem_phys = r.start;
> +	*mem_size = resource_size(&r);
>  
> -	if (mem_size < VENUS_FW_MEM_SIZE)
> +	if (*mem_size < VENUS_FW_MEM_SIZE)
>  		return -EINVAL;
>  
> -	mem_va = memremap(r.start, mem_size, MEMREMAP_WC);
> +	mem_va = memremap(r.start, *mem_size, MEMREMAP_WC);
>  	if (!mem_va) {
>  		dev_err(dev, "unable to map memory region: %pa+%zx\n",
> -			&r.start, mem_size);
> +			&r.start, *mem_size);
>  		return -ENOMEM;
>  	}
>  
> @@ -110,24 +107,41 @@ int venus_boot(struct device *dev, const char *fwname)
>  		release_firmware(mdt);
>  		goto err_unmap;
>  	}
> -
> -	ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
> -			    mem_size);
> +	if (core->no_tz)
> +		ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
> +				mem_va, *mem_phys, *mem_size, NULL);

indentation is wrong see the original code

> +	else
> +		ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va,
> +				*mem_phys, *mem_size);

indentation again

>  
>  	release_firmware(mdt);
>  
> -	if (ret)
> -		goto err_unmap;
> -
> -	ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> -	if (ret)
> -		goto err_unmap;
> -
>  err_unmap:
>  	memunmap(mem_va);
>  	return ret;
>  }
>  
> +int venus_boot(struct venus_core *core)
> +{
> +	phys_addr_t mem_phys;
> +	size_t mem_size;
> +	int ret;
> +	struct device *dev;

please order declarations from longer to shorter.

> +
> +	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER))
> +		return -EPROBE_DEFER;

the original venus_boot was checking for || !qcom_scm_is_available() why
is that removed? It was done on purpose.

> +
> +	dev = core->dev;

this could be done when dev is declared.

> +
> +	ret = venus_load_fw(core, core->res->fwname, &mem_phys, &mem_size);
> +	if (ret) {
> +		dev_err(dev, "fail to load video firmware\n");
> +		return -EINVAL;
> +	}
> +
> +	return qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> +}
> +
>  int venus_shutdown(struct device *dev)
>  {
>  	return qcom_scm_pas_shutdown(VENUS_PAS_ID);
> diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
> index ff2e70e..36a5fc2 100644
> --- a/drivers/media/platform/qcom/venus/firmware.h
> +++ b/drivers/media/platform/qcom/venus/firmware.h
> @@ -16,7 +16,7 @@
>  
>  struct device;
>  
> -int venus_boot(struct device *dev, const char *fwname);
> +int venus_boot(struct venus_core *core);
>  int venus_shutdown(struct device *dev);
>  int venus_set_hw_state(struct venus_core *core, bool suspend);
>  
> 

-- 
regards,
Stan
