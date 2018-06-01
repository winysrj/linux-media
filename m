Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39104 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeFAVXA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 17:23:00 -0400
Date: Fri, 1 Jun 2018 15:22:53 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
Subject: Re: [PATCH v2 3/5] venus: add check to make scm calls
Message-ID: <20180601212253.GE11565@jcrouse-lnx.qualcomm.com>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-4-git-send-email-vgarodia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527884768-22392-4-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 02, 2018 at 01:56:06AM +0530, Vikash Garodia wrote:
> Split the boot api into firmware load and hardware
> boot. Also add the checks to invoke scm calls only
> if the platform has the required support.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.c     |  4 +-
>  drivers/media/platform/qcom/venus/firmware.c | 65 ++++++++++++++++++----------
>  drivers/media/platform/qcom/venus/firmware.h |  2 +-
>  3 files changed, 45 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> index 1308488..9a95f9a 100644
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
> @@ -279,7 +279,7 @@ static int venus_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto err_runtime_disable;
>  
> -	ret = venus_boot(dev, core->res->fwname);
> +	ret = venus_boot(core);
>  	if (ret)
>  		goto err_runtime_disable;
>  
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index b4664ed..cb7f48ef 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -81,40 +81,35 @@ int venus_set_hw_state(enum tzbsp_video_state state, struct venus_core *core)
>  }
>  EXPORT_SYMBOL_GPL(venus_set_hw_state);
>  
> -int venus_boot(struct device *dev, const char *fwname)
> +static int venus_load_fw(struct device *dev, const char *fwname,
> +		phys_addr_t *mem_phys, size_t *mem_size)
>  {
>  	const struct firmware *mdt;
>  	struct device_node *node;
> -	phys_addr_t mem_phys;
>  	struct resource r;
>  	ssize_t fw_size;
> -	size_t mem_size;
>  	void *mem_va;
>  	int ret;
>  
> -	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) || !qcom_scm_is_available())
> -		return -EPROBE_DEFER;
> -
>  	node = of_parse_phandle(dev->of_node, "memory-region", 0);
>  	if (!node) {
>  		dev_err(dev, "no memory-region specified\n");
>  		return -EINVAL;
>  	}
> -

Unrelated whitespace change.  Not needed.
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
> @@ -128,25 +123,49 @@ int venus_boot(struct device *dev, const char *fwname)
>  		release_firmware(mdt);
>  		goto err_unmap;
>  	}
> -
> -	ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
> -			    mem_size);
> +	if (qcom_scm_is_available())
> +		ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va,
> +				*mem_phys, *mem_size, NULL);
> +	else
> +		ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
> +				mem_va, *mem_phys, *mem_size, NULL);
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
> +int venus_boot(struct venus_core *core)
> +{
> +	phys_addr_t mem_phys;
> +	size_t mem_size;
> +	int ret;
> +	struct device *dev;
> +
> +	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER))
> +		return -EPROBE_DEFER;
> +
> +	dev = core->dev;
> +
> +	ret = venus_load_fw(dev, core->res->fwname, &mem_phys, &mem_size);
> +	if (ret) {
> +		dev_err(dev, "fail to load video firmware\n");
> +		return -EINVAL;
> +	}
> +
> +	if (qcom_scm_is_available())
> +		ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(venus_boot);
>  
>  int venus_shutdown(struct device *dev)
>  {
> -	return qcom_scm_pas_shutdown(VENUS_PAS_ID);
> +	int ret = 0;
> +
> +	if (qcom_scm_is_available())
> +		ret = qcom_scm_pas_shutdown(VENUS_PAS_ID);
> +	return ret;
>  }
> diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
> index 1336729..0916826 100644
> --- a/drivers/media/platform/qcom/venus/firmware.h
> +++ b/drivers/media/platform/qcom/venus/firmware.h
> @@ -16,7 +16,7 @@
>  
>  struct device;
>  
> -int venus_boot(struct device *dev, const char *fwname);
> +int venus_boot(struct venus_core *core);
>  int venus_shutdown(struct device *dev);
>  int venus_set_hw_state(enum tzbsp_video_state, struct venus_core *core);

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
