Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36267 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932077AbdBGXjt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 18:39:49 -0500
Received: by mail-pg0-f48.google.com with SMTP id v184so42737125pgv.3
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 15:39:49 -0800 (PST)
Date: Tue, 7 Feb 2017 15:32:02 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v6 4/9] media: venus: adding core part and helper
 functions
Message-ID: <20170207233202.GI27837@minitux>
References: <1486473024-21705-1-git-send-email-stanimir.varbanov@linaro.org>
 <1486473024-21705-5-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486473024-21705-5-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 07 Feb 05:10 PST 2017, Stanimir Varbanov wrote:

>  * firmware loader
> 

I like the way this turns out, just some style comments below.

[..]
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> new file mode 100644
> index 000000000000..4057696abaf5
> --- /dev/null
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -0,0 +1,151 @@
> +/*
> + * Copyright (C) 2017 Linaro Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/firmware.h>
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +#include <linux/of_reserved_mem.h>
> +#include <linux/slab.h>
> +#include <linux/qcom_scm.h>
> +#include <linux/soc/qcom/mdt_loader.h>
> +
> +#define VENUS_FIRMWARE_NAME		"venus.mdt"
> +#define VENUS_PAS_ID			9
> +#define VENUS_FW_MEM_SIZE		SZ_8M
> +
> +struct firmware_mem {
> +	struct device dev;
> +	void *mem_va;
> +	phys_addr_t mem_phys;
> +	size_t mem_size;
> +};
> +
> +static struct firmware_mem fw;

Rather than operating on a global variable I think you should either
return your firmware_mem pointer or the device pointer to the caller of
venus_boot() and have the core pass that back into venus_shutdown().

> +
> +static void device_release_dummy(struct device *dev)
> +{
> +}
> +
> +static int firmware_alloc_mem(struct device *parent, struct firmware_mem *fw)
> +{
> +	struct device_node *np;
> +	struct device *dev = &fw->dev;
> +	int ret;
> +
> +	np = of_get_child_by_name(parent->of_node, "video-firmware");
> +	if (!np)
> +		return -ENODEV;
> +
> +	memset(fw, 0, sizeof(*fw));

This should not be necessary.

Further more, if it's already initialized it's safe to assume that the
allocation below will fail - regardless of you clearing it or not.

> +
> +	dev->of_node = np;
> +	dev->parent = parent;
> +	dev->release = device_release_dummy;
> +
> +	ret = dev_set_name(dev, "venus-fw");
> +	if (ret)
> +		return ret;
> +
> +	ret = device_register(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = of_reserved_mem_device_init(dev);
> +	if (ret)
> +		goto err_unreg_device;
> +
> +	fw->mem_size = VENUS_FW_MEM_SIZE;
> +
> +	fw->mem_va = dma_alloc_coherent(dev, fw->mem_size, &fw->mem_phys,
> +					GFP_KERNEL);

As this should follow the life of dev you can use dmam_alloc_coherent()
to reduce the clean up paths.

> +	if (!fw->mem_va) {
> +		ret = -ENOMEM;
> +		goto err_mem_device_release;
> +	}
> +
> +	return 0;
> +
> +err_mem_device_release:
> +	of_reserved_mem_device_release(dev);
> +err_unreg_device:
> +	device_unregister(dev);
> +	return ret;
> +}
> +
> +static void firmware_free_mem(struct firmware_mem *fw)
> +{
> +	dma_free_coherent(&fw->dev, fw->mem_size, fw->mem_va, fw->mem_phys);

If you use dmam_alloc_coherent() this goes.

> +	of_reserved_mem_device_release(&fw->dev);

And I would suggest that as this is related to the device you should
release it in the dev->release function; turning this function into
device_unregister(&fw->dev).


(The devres allocation will be freed right before the release function
is called)

> +	device_unregister(&fw->dev);
> +	memset(fw, 0, sizeof(*fw));

This should not be necessary.

> +}
> +
> +static int firmware_load(struct firmware_mem *fw)
> +{
> +	struct device *dev = &fw->dev;
> +	const struct firmware *mdt;
> +	ssize_t fw_size;
> +	int ret;
> +
> +	ret = request_firmware(&mdt, VENUS_FIRMWARE_NAME, dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	fw_size = qcom_mdt_get_size(mdt);
> +	if (fw_size < 0) {
> +		ret = fw_size;
> +		goto err_release_fw;
> +	} else if (fw_size > VENUS_FW_MEM_SIZE) {

You can skip this this check, as qcom_mdt_load() will fail if any part
of the firmware doesn't fit - and we would benefit from making that
error message more verbose.

> +		ret = -ENOMEM;
> +		goto err_release_fw;
> +	}
> +
> +	ret = qcom_mdt_load(&fw->dev, mdt, VENUS_FIRMWARE_NAME, VENUS_PAS_ID,
> +			    fw->mem_va, fw->mem_phys, fw->mem_size);
> +
> +err_release_fw:

This is not only the error path, so "release_fw" would be better.

> +	release_firmware(mdt);
> +
> +	return ret;
> +}
> +
> +int venus_boot(struct device *parent)
> +{
> +	int ret;
> +
> +	if (!qcom_scm_is_available())
> +		return -EPROBE_DEFER;
> +
> +	ret = firmware_alloc_mem(parent, &fw);
> +	if (ret)
> +		return ret;
> +
> +	ret = firmware_load(&fw);
> +	if (ret) {
> +		firmware_free_mem(&fw);
> +		return ret;
> +	}
> +
> +	return qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> +}
> +
> +int venus_shutdown(void)
> +{
> +	int ret;
> +
> +	ret = qcom_scm_pas_shutdown(VENUS_PAS_ID);
> +	firmware_free_mem(&fw);
> +	return ret;
> +}

Regards,
Bjorn
