Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:49918 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751270AbdEEOa3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 10:30:29 -0400
Subject: Re: [PATCH v8 01/10] firmware: qcom_scm: Fix to allow
 COMPILE_TEST-ing
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <1493370837-19793-2-git-send-email-stanimir.varbanov@linaro.org>
 <bd344b32-77a0-9160-7be8-52b88ccd225e@xs4all.nl>
 <4b4f7977-c934-aba7-1716-ea74d4562baf@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <deaaf850-a981-6d4a-ab24-41c83b1a0e7f@xs4all.nl>
Date: Fri, 5 May 2017 16:30:20 +0200
MIME-Version: 1.0
In-Reply-To: <4b4f7977-c934-aba7-1716-ea74d4562baf@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/05/2017 03:23 PM, Stanimir Varbanov wrote:
> Hi Hans,
> 
> On 05/05/2017 02:34 PM, Hans Verkuil wrote:
>> On 04/28/17 11:13, Stanimir Varbanov wrote:
>>> Unfortunatly previous attempt to allow consumer drivers to
>>> use COMPILE_TEST option in Kconfig is not enough, because in the
>>> past the consumer drivers used 'depends on' Kconfig option but
>>> now they are using 'select' Kconfig option which means on non ARM
>>> arch'es compilation is triggered. Thus we need to move the ifdefery
>>> one level below by touching the private qcom_scm.h header.
>>>
>>> To: Andy Gross <andy.gross@linaro.org>
>>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>>> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>> ---
>>>  drivers/firmware/Kconfig    |  2 +-
>>>  drivers/firmware/qcom_scm.h | 72 ++++++++++++++++++++++++++++++++++++++-------
>>>  include/linux/qcom_scm.h    | 32 --------------------
>>>  3 files changed, 62 insertions(+), 44 deletions(-)
>>>
>>> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
>>> index 6e4ed5a9c6fd..480578c3691a 100644
>>> --- a/drivers/firmware/Kconfig
>>> +++ b/drivers/firmware/Kconfig
>>> @@ -204,7 +204,7 @@ config FW_CFG_SYSFS_CMDLINE
>>>  
>>>  config QCOM_SCM
>>>  	bool
>>> -	depends on ARM || ARM64
>>> +	depends on ARM || ARM64 || COMPILE_TEST
>>>  	select RESET_CONTROLLER
>>>  
>>>  config QCOM_SCM_32
>>> diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
>>> index 9bea691f30fb..d2b5723afb3f 100644
>>> --- a/drivers/firmware/qcom_scm.h
>>> +++ b/drivers/firmware/qcom_scm.h
>>> @@ -12,6 +12,7 @@
>>>  #ifndef __QCOM_SCM_INT_H
>>>  #define __QCOM_SCM_INT_H
>>>  
>>> +#if IS_ENABLED(CONFIG_ARM) || IS_ENABLED(CONFIG_ARM64)
>>
>> This is weird. Shouldn't this be:
>>
>> #if IS_ENABLED(CONFIG_QCOM_SCM)
> 
> I think no, because if you take a look in the above hunk which adding
> COMPILE_TEST in the QCOM_SCM config the CONFIG_QCOM_SCM will be enabled
> if compile testing is selected for example on x86 build target.

My apologies, just ignore my comment. I missed that QCOM_SCM is automatically
configured and not manually.

This patch is fine.

Regards,

	Hans

> 
>>
>> If the code in the actual source only works for ARM, then that should be
>> handled in that source code, and not in this header IMHO.
> 
> Do you mean adding #ifdef in the source file? IMO this will become a
> bigger mess.
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>  #define QCOM_SCM_SVC_BOOT		0x1
>>>  #define QCOM_SCM_BOOT_ADDR		0x1
>>>  #define QCOM_SCM_BOOT_ADDR_MC		0x11
>>> @@ -58,6 +59,66 @@ extern int  __qcom_scm_pas_auth_and_reset(struct device *dev, u32 peripheral);
>>>  extern int  __qcom_scm_pas_shutdown(struct device *dev, u32 peripheral);
>>>  extern int  __qcom_scm_pas_mss_reset(struct device *dev, bool reset);
>>>  
>>> +#define QCOM_SCM_SVC_MP			0xc
>>> +#define QCOM_SCM_RESTORE_SEC_CFG	2
>>> +extern int __qcom_scm_restore_sec_cfg(struct device *dev, u32 device_id,
>>> +				      u32 spare);
>>> +#define QCOM_SCM_IOMMU_SECURE_PTBL_SIZE	3
>>> +#define QCOM_SCM_IOMMU_SECURE_PTBL_INIT	4
>>> +extern int __qcom_scm_iommu_secure_ptbl_size(struct device *dev, u32 spare,
>>> +					     size_t *size);
>>> +extern int __qcom_scm_iommu_secure_ptbl_init(struct device *dev, u64 addr,
>>> +					     u32 size, u32 spare);
>>> +#else
>>> +static inline int __qcom_scm_set_remote_state(struct device *dev, u32 state,
>>> +					      u32 id)
>>> +{ return -ENODEV; }
>>> +static inline int __qcom_scm_set_warm_boot_addr(struct device *dev, void *entry,
>>> +						const cpumask_t *cpus)
>>> +{ return -ENODEV; }
>>> +static inline int __qcom_scm_set_cold_boot_addr(void *entry,
>>> +						const cpumask_t *cpus)
>>> +{ return -ENODEV; }
>>> +static inline void __qcom_scm_cpu_power_down(u32 flags) {}
>>> +static inline int __qcom_scm_is_call_available(struct device *dev, u32 svc_id,
>>> +					       u32 cmd_id)
>>> +{ return -ENODEV; }
>>> +#define QCOM_SCM_SVC_HDCP		0x11
>>> +#define QCOM_SCM_CMD_HDCP		0x01
>>> +static inline int __qcom_scm_hdcp_req(struct device *dev,
>>> +				      struct qcom_scm_hdcp_req *req,
>>> +				      u32 req_cnt, u32 *resp)
>>> +{ return -ENODEV; }
>>> +static inline void __qcom_scm_init(void) {}
>>> +#define QCOM_SCM_SVC_PIL		0x2
>>> +#define QCOM_SCM_PAS_IS_SUPPORTED_CMD	0x7
>>> +static inline bool __qcom_scm_pas_supported(struct device *dev, u32 peripheral)
>>> +{ return false; }
>>> +static inline int  __qcom_scm_pas_init_image(struct device *dev, u32 peripheral,
>>> +					     dma_addr_t metadata_phys)
>>> +{ return -ENODEV; }
>>> +static inline int  __qcom_scm_pas_mem_setup(struct device *dev, u32 peripheral,
>>> +					    phys_addr_t addr, phys_addr_t size)
>>> +{ return -ENODEV; }
>>> +static inline int  __qcom_scm_pas_auth_and_reset(struct device *dev,
>>> +						 u32 peripheral)
>>> +{ return -ENODEV; }
>>> +static inline int  __qcom_scm_pas_shutdown(struct device *dev, u32 peripheral)
>>> +{ return -ENODEV; }
>>> +static inline int  __qcom_scm_pas_mss_reset(struct device *dev, bool reset)
>>> +{ return -ENODEV; }
>>> +static inline int __qcom_scm_restore_sec_cfg(struct device *dev, u32 device_id,
>>> +					     u32 spare)
>>> +{ return -ENODEV; }
>>> +extern int __qcom_scm_iommu_secure_ptbl_size(struct device *dev, u32 spare,
>>> +					     size_t *size)
>>> +{ return -ENODEV; }
>>> +static inline int __qcom_scm_iommu_secure_ptbl_init(struct device *dev,
>>> +						    u64 addr, u32 size,
>>> +						    u32 spare)
>>> +{ return -ENODEV; }
>>> +#endif
>>> +
>>>  /* common error codes */
>>>  #define QCOM_SCM_V2_EBUSY	-12
>>>  #define QCOM_SCM_ENOMEM		-5
>>> @@ -85,15 +146,4 @@ static inline int qcom_scm_remap_error(int err)
>>>  	return -EINVAL;
>>>  }
>>>  
>>> -#define QCOM_SCM_SVC_MP			0xc
>>> -#define QCOM_SCM_RESTORE_SEC_CFG	2
>>> -extern int __qcom_scm_restore_sec_cfg(struct device *dev, u32 device_id,
>>> -				      u32 spare);
>>> -#define QCOM_SCM_IOMMU_SECURE_PTBL_SIZE	3
>>> -#define QCOM_SCM_IOMMU_SECURE_PTBL_INIT	4
>>> -extern int __qcom_scm_iommu_secure_ptbl_size(struct device *dev, u32 spare,
>>> -					     size_t *size);
>>> -extern int __qcom_scm_iommu_secure_ptbl_init(struct device *dev, u64 addr,
>>> -					     u32 size, u32 spare);
>>> -
>>>  #endif
>>> diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
>>> index e5380471c2cd..b628f735f355 100644
>>> --- a/include/linux/qcom_scm.h
>>> +++ b/include/linux/qcom_scm.h
>>> @@ -23,7 +23,6 @@ struct qcom_scm_hdcp_req {
>>>  	u32 val;
>>>  };
>>>  
>>> -#if IS_ENABLED(CONFIG_QCOM_SCM)
>>>  extern int qcom_scm_set_cold_boot_addr(void *entry, const cpumask_t *cpus);
>>>  extern int qcom_scm_set_warm_boot_addr(void *entry, const cpumask_t *cpus);
>>>  extern bool qcom_scm_is_available(void);
>>> @@ -43,35 +42,4 @@ extern int qcom_scm_set_remote_state(u32 state, u32 id);
>>>  extern int qcom_scm_restore_sec_cfg(u32 device_id, u32 spare);
>>>  extern int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size);
>>>  extern int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare);
>>> -#else
>>> -static inline
>>> -int qcom_scm_set_cold_boot_addr(void *entry, const cpumask_t *cpus)
>>> -{
>>> -	return -ENODEV;
>>> -}
>>> -static inline
>>> -int qcom_scm_set_warm_boot_addr(void *entry, const cpumask_t *cpus)
>>> -{
>>> -	return -ENODEV;
>>> -}
>>> -static inline bool qcom_scm_is_available(void) { return false; }
>>> -static inline bool qcom_scm_hdcp_available(void) { return false; }
>>> -static inline int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
>>> -				    u32 *resp) { return -ENODEV; }
>>> -static inline bool qcom_scm_pas_supported(u32 peripheral) { return false; }
>>> -static inline int qcom_scm_pas_init_image(u32 peripheral, const void *metadata,
>>> -					  size_t size) { return -ENODEV; }
>>> -static inline int qcom_scm_pas_mem_setup(u32 peripheral, phys_addr_t addr,
>>> -					 phys_addr_t size) { return -ENODEV; }
>>> -static inline int
>>> -qcom_scm_pas_auth_and_reset(u32 peripheral) { return -ENODEV; }
>>> -static inline int qcom_scm_pas_shutdown(u32 peripheral) { return -ENODEV; }
>>> -static inline void qcom_scm_cpu_power_down(u32 flags) {}
>>> -static inline u32 qcom_scm_get_version(void) { return 0; }
>>> -static inline u32
>>> -qcom_scm_set_remote_state(u32 state,u32 id) { return -ENODEV; }
>>> -static inline int qcom_scm_restore_sec_cfg(u32 device_id, u32 spare) { return -ENODEV; }
>>> -static inline int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size) { return -ENODEV; }
>>> -static inline int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare) { return -ENODEV; }
>>> -#endif
>>>  #endif
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
