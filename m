Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38952 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbeHUP2o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 11:28:44 -0400
Received: by mail-wm0-f65.google.com with SMTP id q8-v6so2632269wmq.4
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 05:08:49 -0700 (PDT)
Subject: Re: [PATCH v4 2/4] venus: firmware: move load firmware in a separate
 function
To: Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
References: <1533562085-8773-1-git-send-email-vgarodia@codeaurora.org>
 <1533562085-8773-3-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <8ffd63d9-ba9f-44b2-e1c0-7edce167fd9c@linaro.org>
Date: Tue, 21 Aug 2018 15:08:44 +0300
MIME-Version: 1.0
In-Reply-To: <1533562085-8773-3-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 08/06/2018 04:28 PM, Vikash Garodia wrote:
> Separate firmware loading part into a new function.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.c     |  4 +--
>  drivers/media/platform/qcom/venus/firmware.c | 54 +++++++++++++++++-----------
>  drivers/media/platform/qcom/venus/firmware.h |  2 +-
>  3 files changed, 37 insertions(+), 23 deletions(-)
> 

<snip>

> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 3aa6b37..4577043 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -58,20 +58,18 @@ int venus_set_hw_state(struct venus_core *core, bool resume)
>  	return 0;
>  }
>  
> -int venus_boot(struct device *dev, const char *fwname)
> +static int venus_load_fw(struct venus_core *core, const char *fwname,
> +			phys_addr_t *mem_phys, size_t *mem_size)

fix indentation

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
> @@ -82,16 +80,16 @@ int venus_boot(struct device *dev, const char *fwname)
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
> @@ -106,23 +104,39 @@ int venus_boot(struct device *dev, const char *fwname)
>  		goto err_unmap;
>  	}
>  
> -	ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
> -			    mem_size, NULL);
> +	if (core->no_tz)
> +		ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
> +					mem_va, *mem_phys, *mem_size, NULL);
> +	else
> +		ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID,
> +				mem_va, *mem_phys, *mem_size, NULL);

Please fix the indentation issues above.

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
> +	struct device *dev = core->dev;

move this one row upper.

> +	size_t mem_size;
> +	int ret;
> +
> +	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) ||
> +		(!core->no_tz && !qcom_scm_is_available()))
> +		return -EPROBE_DEFER;

fix indentation

> +
> +	ret = venus_load_fw(core, core->res->fwname, &mem_phys, &mem_size);
> +	if (ret) {
> +		dev_err(dev, "fail to load video firmware\n");
> +		return -EINVAL;
> +	}

blank line here

> +	return qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> +}

-- 
regards,
Stan
