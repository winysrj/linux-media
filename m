Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeFAVal (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 17:30:41 -0400
Date: Fri, 1 Jun 2018 15:30:36 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
Subject: Re: [PATCH v2 4/5] media: venus: add no TZ boot and shutdown routine
Message-ID: <20180601213035.GF11565@jcrouse-lnx.qualcomm.com>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-5-git-send-email-vgarodia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527884768-22392-5-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 02, 2018 at 01:56:07AM +0530, Vikash Garodia wrote:
> Video hardware is mainly comprised of vcodec subsystem
> and video control subsystem. Video control has ARM9 which
> executes the video firmware instructions whereas vcodec
> does the video frame processing.
> This change adds support to load the video firmware and
> bring ARM9 out of reset for platforms which does not
> have trustzone.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.c     |  6 +-
>  drivers/media/platform/qcom/venus/core.h     |  5 ++
>  drivers/media/platform/qcom/venus/firmware.c | 86 ++++++++++++++++++++++++++--
>  drivers/media/platform/qcom/venus/firmware.h |  7 ++-
>  4 files changed, 94 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> index 9a95f9a..101612b 100644
> --- a/drivers/media/platform/qcom/venus/core.c
> +++ b/drivers/media/platform/qcom/venus/core.c
> @@ -76,7 +76,7 @@ static void venus_sys_error_handler(struct work_struct *work)
>  	hfi_core_deinit(core, true);
>  	hfi_destroy(core);
>  	mutex_lock(&core->lock);
> -	venus_shutdown(core->dev);
> +	venus_shutdown(core);
>  
>  	pm_runtime_put_sync(core->dev);
>  
> @@ -318,7 +318,7 @@ static int venus_probe(struct platform_device *pdev)
>  err_core_deinit:
>  	hfi_core_deinit(core, false);
>  err_venus_shutdown:
> -	venus_shutdown(dev);
> +	venus_shutdown(core);
>  err_runtime_disable:
>  	pm_runtime_set_suspended(dev);
>  	pm_runtime_disable(dev);
> @@ -339,7 +339,7 @@ static int venus_remove(struct platform_device *pdev)
>  	WARN_ON(ret);
>  
>  	hfi_destroy(core);
> -	venus_shutdown(dev);
> +	venus_shutdown(core);
>  	of_platform_depopulate(dev);
>  
>  	pm_runtime_put_sync(dev);
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index e7bfb63..f04e25e 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -85,6 +85,10 @@ struct venus_caps {
>  	bool valid;
>  };
>  
> +struct video_firmware {
> +	struct device *dev;
> +	struct iommu_domain *iommu_domain;
> +};
>  /**
>   * struct venus_core - holds core parameters valid for all instances
>   *
> @@ -129,6 +133,7 @@ struct venus_core {
>  	struct device *dev;
>  	struct device *dev_dec;
>  	struct device *dev_enc;
> +	struct video_firmware fw;
>  	struct mutex lock;
>  	struct list_head instances;
>  	atomic_t insts_count;
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index cb7f48ef..058d544 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -12,8 +12,10 @@
>   *
>   */
>  
> +#include <linux/platform_device.h>
>  #include <linux/device.h>
>  #include <linux/firmware.h>
> +#include <linux/iommu.h>
>  #include <linux/delay.h>
>  #include <linux/kernel.h>
>  #include <linux/io.h>
> @@ -27,9 +29,6 @@
>  #include "firmware.h"
>  #include "hfi_venus_io.h"
>  
> -#define VENUS_PAS_ID			9
> -#define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
> -
>  static void venus_reset_hw(struct venus_core *core)
>  {
>  	void __iomem *reg_base = core->base;
> @@ -125,7 +124,7 @@ static int venus_load_fw(struct device *dev, const char *fwname,
>  	}
>  	if (qcom_scm_is_available())
>  		ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va,
> -				*mem_phys, *mem_size, NULL);
> +				*mem_phys, *mem_size);
>  	else
>  		ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
>  				mem_va, *mem_phys, *mem_size, NULL);
> @@ -136,6 +135,77 @@ static int venus_load_fw(struct device *dev, const char *fwname,
>  	memunmap(mem_va);
>  	return ret;
>  }
> +
> +int venus_boot_noTZ(struct venus_core *core, phys_addr_t mem_phys,

I'm not super enthusiastic about the capital letters, but I know what you're
going for so if everybody else is cool with it, I can be too.

> +							size_t mem_size)
> +{
> +	struct iommu_domain *iommu;
> +	struct device *dev;
> +	int ret;
> +
> +	if (!core->fw.dev)
> +		return -EPROBE_DEFER;
> +
> +	dev = core->fw.dev;
> +
> +	iommu = iommu_domain_alloc(&platform_bus_type);
> +	if (!iommu) {
> +		dev_err(dev, "Failed to allocate iommu domain\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = iommu_attach_device(iommu, dev);
> +	if (ret) {
> +		dev_err(dev, "could not attach device\n");

Should be "could not attach device to iommu", so you know what part of the code you
are in.

> +		goto err_attach;
> +	}
> +
> +	ret = iommu_map(iommu, VENUS_FW_START_ADDR, mem_phys, mem_size,
> +			IOMMU_READ|IOMMU_WRITE|IOMMU_PRIV);

Do you really want to be mapping your firmware memory as IOMMU_WRITE?

> +	if (ret) {
> +		dev_err(dev, "could not map video firmware region\n");
> +		goto err_map;
> +	}
> +	core->fw.iommu_domain = iommu;
> +	venus_reset_hw(core);
> +
> +	return 0;
> +
> +err_map:
> +	iommu_detach_device(iommu, dev);
> +err_attach:
> +	iommu_domain_free(iommu);
> +	return ret;
> +}
> +
> +int venus_shutdown_noTZ(struct venus_core *core)
> +{
> +	struct iommu_domain *iommu;
> +	size_t unmapped = 0;
> +	u32 reg;
> +	struct device *dev = core->fw.dev;
> +	void __iomem *reg_base = core->base;
> +
> +	/* Assert the reset to ARM9 */
> +	reg = readl_relaxed(reg_base + WRAPPER_A9SS_SW_RESET);
> +	reg |= BIT(4);
> +	writel_relaxed(reg, reg_base + WRAPPER_A9SS_SW_RESET);

You could just use core->base directly in both these cases and not bother with
the local variable.

> +
> +	/* Make sure reset is asserted before the mapping is removed */
> +	mb();
> +
> +	iommu = core->fw.iommu_domain;
> +
> +	unmapped = iommu_unmap(iommu, VENUS_FW_START_ADDR, VENUS_FW_MEM_SIZE);
> +	if (unmapped != VENUS_FW_MEM_SIZE)
> +		dev_err(dev, "failed to unmap firmware\n");
> +
> +	iommu_detach_device(iommu, dev);
> +	iommu_domain_free(iommu);
> +
> +	return 0;
> +}
> +
>  int venus_boot(struct venus_core *core)
>  {
>  	phys_addr_t mem_phys;
> @@ -156,16 +226,20 @@ int venus_boot(struct venus_core *core)
>  
>  	if (qcom_scm_is_available())
>  		ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> +	else
> +		ret = venus_boot_noTZ(core, mem_phys, mem_size);
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(venus_boot);
>  
> -int venus_shutdown(struct device *dev)
> +int venus_shutdown(struct venus_core *core)
>  {
>  	int ret = 0;
>  
>  	if (qcom_scm_is_available())
>  		ret = qcom_scm_pas_shutdown(VENUS_PAS_ID);
> +	else
> +		ret = venus_shutdown_noTZ(core);
> +
>  	return ret;
>  }
> diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
> index 0916826..67fdd89 100644
> --- a/drivers/media/platform/qcom/venus/firmware.h
> +++ b/drivers/media/platform/qcom/venus/firmware.h
> @@ -14,10 +14,15 @@
>  #ifndef __VENUS_FIRMWARE_H__
>  #define __VENUS_FIRMWARE_H__
>  
> +#define VENUS_PAS_ID			9
> +#define VENUS_FW_START_ADDR		0x0
> +#define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
> +#define VENUS_MAX_MEM_REGION	0xE0000000
> +
>  struct device;
>  
>  int venus_boot(struct venus_core *core);
> -int venus_shutdown(struct device *dev);
> +int venus_shutdown(struct venus_core *core);
>  int venus_set_hw_state(enum tzbsp_video_state, struct venus_core *core);
>  
>  #endif

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
