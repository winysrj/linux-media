Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425865AbdD1WCt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 18:02:49 -0400
Date: Fri, 28 Apr 2017 16:02:45 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 05/10] media: venus: adding core part and helper
 functions
Message-ID: <20170428220245.GA3283@jcrouse-lnx.qualcomm.com>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <1493370837-19793-6-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493370837-19793-6-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 28, 2017 at 12:13:52PM +0300, Stanimir Varbanov wrote:
> +int venus_boot(struct device *parent, struct device *fw_dev)
> +{
> +	const struct firmware *mdt;
> +	phys_addr_t mem_phys;
> +	ssize_t fw_size;
> +	size_t mem_size;
> +	void *mem_va;
> +	int ret;
> +
> +	if (!qcom_scm_is_available())
> +		return -EPROBE_DEFER;
> +
> +	fw_dev->parent = parent;
> +	fw_dev->release = device_release_dummy;
> +
> +	ret = dev_set_name(fw_dev, "%s:%s", dev_name(parent), "firmware");
> +	if (ret)
> +		return ret;
> +
> +	ret = device_register(fw_dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = of_reserved_mem_device_init_by_idx(fw_dev, parent->of_node, 0);
> +	if (ret)
> +		goto err_unreg_device;
> +
> +	mem_size = VENUS_FW_MEM_SIZE;
> +
> +	mem_va = dmam_alloc_coherent(fw_dev, mem_size, &mem_phys, GFP_KERNEL);
> +	if (!mem_va) {
> +		ret = -ENOMEM;
> +		goto err_unreg_device;
> +	}
> +
> +	ret = request_firmware(&mdt, VENUS_FIRMWARE_NAME, fw_dev);
> +	if (ret < 0)
> +		goto err_unreg_device;
> +
> +	fw_size = qcom_mdt_get_size(mdt);
> +	if (fw_size < 0) {
> +		ret = fw_size;
> +		release_firmware(mdt);
> +		goto err_unreg_device;
> +	}
> +
> +	ret = qcom_mdt_load(fw_dev, mdt, VENUS_FIRMWARE_NAME, VENUS_PAS_ID,
> +			    mem_va, mem_phys, mem_size);
> +
> +	release_firmware(mdt);
> +
> +	if (ret)
> +		goto err_unreg_device;
> +
> +	ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> +	if (ret)
> +		goto err_unreg_device;
> +
> +	return 0;
> +
> +err_unreg_device:
> +	device_unregister(fw_dev);
> +	return ret;
> +}

Hey, this looks familiar - almost line for line identical to what we'll need to
do for GPU.

Bjorn - Is this enough to qualify for generic status in the mdt_loader code?
I know its just two consumers, but it would save 50 or 60 lines of code between
the two drivers and be easier to maintain.

Jordan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
