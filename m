Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:35687 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbdEBTWF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 15:22:05 -0400
Received: by mail-pg0-f49.google.com with SMTP id o3so60820705pgn.2
        for <linux-media@vger.kernel.org>; Tue, 02 May 2017 12:22:05 -0700 (PDT)
Date: Tue, 2 May 2017 12:22:01 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 01/10] firmware: qcom_scm: Fix to allow
 COMPILE_TEST-ing
Message-ID: <20170502192201.GY15143@minitux>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <1493370837-19793-2-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493370837-19793-2-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 28 Apr 02:13 PDT 2017, Stanimir Varbanov wrote:

> Unfortunatly previous attempt to allow consumer drivers to
> use COMPILE_TEST option in Kconfig is not enough, because in the
> past the consumer drivers used 'depends on' Kconfig option but
> now they are using 'select' Kconfig option which means on non ARM
> arch'es compilation is triggered. Thus we need to move the ifdefery
> one level below by touching the private qcom_scm.h header.
> 
> To: Andy Gross <andy.gross@linaro.org>

"To" should not be listed in the commit message and "Cc" means that you
really do expect Stephen and myself to say something - i.e. it's not the
same as To and Cc in the email header.

> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/firmware/Kconfig    |  2 +-
>  drivers/firmware/qcom_scm.h | 72 ++++++++++++++++++++++++++++++++++++++-------
>  include/linux/qcom_scm.h    | 32 --------------------
>  3 files changed, 62 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 6e4ed5a9c6fd..480578c3691a 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -204,7 +204,7 @@ config FW_CFG_SYSFS_CMDLINE
>  
>  config QCOM_SCM
>  	bool
> -	depends on ARM || ARM64
> +	depends on ARM || ARM64 || COMPILE_TEST
>  	select RESET_CONTROLLER
>  
>  config QCOM_SCM_32
> diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
> index 9bea691f30fb..d2b5723afb3f 100644
> --- a/drivers/firmware/qcom_scm.h
> +++ b/drivers/firmware/qcom_scm.h
> @@ -12,6 +12,7 @@
>  #ifndef __QCOM_SCM_INT_H
>  #define __QCOM_SCM_INT_H
>  
> +#if IS_ENABLED(CONFIG_ARM) || IS_ENABLED(CONFIG_ARM64)
>  #define QCOM_SCM_SVC_BOOT		0x1
>  #define QCOM_SCM_BOOT_ADDR		0x1
>  #define QCOM_SCM_BOOT_ADDR_MC		0x11
> @@ -58,6 +59,66 @@ extern int  __qcom_scm_pas_auth_and_reset(struct device *dev, u32 peripheral);
>  extern int  __qcom_scm_pas_shutdown(struct device *dev, u32 peripheral);
>  extern int  __qcom_scm_pas_mss_reset(struct device *dev, bool reset);
>  
> +#define QCOM_SCM_SVC_MP			0xc
> +#define QCOM_SCM_RESTORE_SEC_CFG	2
> +extern int __qcom_scm_restore_sec_cfg(struct device *dev, u32 device_id,
> +				      u32 spare);
> +#define QCOM_SCM_IOMMU_SECURE_PTBL_SIZE	3
> +#define QCOM_SCM_IOMMU_SECURE_PTBL_INIT	4

Don't you need these constants in the COMPILE_TEST case?

> +extern int __qcom_scm_iommu_secure_ptbl_size(struct device *dev, u32 spare,
> +					     size_t *size);
> +extern int __qcom_scm_iommu_secure_ptbl_init(struct device *dev, u64 addr,
> +					     u32 size, u32 spare);
> +#else
> +static inline int __qcom_scm_set_remote_state(struct device *dev, u32 state,
> +					      u32 id)
> +{ return -ENODEV; }

Please space this out over 3 lines with proper indentation.

> +static inline int __qcom_scm_set_warm_boot_addr(struct device *dev, void *entry,
> +						const cpumask_t *cpus)
> +{ return -ENODEV; }
> +static inline int __qcom_scm_set_cold_boot_addr(void *entry,
> +						const cpumask_t *cpus)
> +{ return -ENODEV; }
> +static inline void __qcom_scm_cpu_power_down(u32 flags) {}
> +static inline int __qcom_scm_is_call_available(struct device *dev, u32 svc_id,
> +					       u32 cmd_id)
> +{ return -ENODEV; }
> +#define QCOM_SCM_SVC_HDCP		0x11
> +#define QCOM_SCM_CMD_HDCP		0x01
> +static inline int __qcom_scm_hdcp_req(struct device *dev,
> +				      struct qcom_scm_hdcp_req *req,
> +				      u32 req_cnt, u32 *resp)
> +{ return -ENODEV; }
> +static inline void __qcom_scm_init(void) {}
> +#define QCOM_SCM_SVC_PIL		0x2
> +#define QCOM_SCM_PAS_IS_SUPPORTED_CMD	0x7

Do we only need 4 service-related defines in the COMPILE_TEST case?


I don't think we want to duplicate all the defines, so please prepend a
separate patch grouping them at the top.

Regards,
Bjorn
