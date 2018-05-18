Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47832 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbeERAkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 20:40:52 -0400
Subject: Re: [PATCH 4/4] media: venus: add PIL support
To: Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        acourbot@google.com
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
 <1526556740-25494-5-git-send-email-vgarodia@codeaurora.org>
From: Trilok Soni <tsoni@codeaurora.org>
Message-ID: <e8596e31-42dc-8ac8-16e1-8990d7408bc4@codeaurora.org>
Date: Thu, 17 May 2018 17:40:49 -0700
MIME-Version: 1.0
In-Reply-To: <1526556740-25494-5-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 5/17/2018 4:32 AM, Vikash Garodia wrote:
> This adds support to load the video firmware
> and bring ARM9 out of reset. This is useful
> for platforms which does not have trustzone
> to reset the ARM9.

ARM9 = video core here? May be commit text needs little bit more detail.

>   
> +static int store_firmware_dev(struct device *dev, void *data)
> +{
> +	struct venus_core *core;
> +
> +	core = (struct venus_core *)data;

No need of casting.

> +	if (!core)
> +		return -EINVAL;
> +
> +	if (of_device_is_compatible(dev->of_node, "qcom,venus-pil-no-tz"))
> +		core->fw.dev = dev;
> +
> +	return 0;
> +}
> +


>   
> -	ret = venus_boot(dev, core->res->fwname);
> +	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
> +	if (ret)
> +		goto err_runtime_disable;
> +
> +	/* Attempt to register child devices */
> +	ret = device_for_each_child(dev, core, store_firmware_dev);
> +

and not ret check needed?

> +	ret = venus_boot(core);
>   	if (ret)
>   		goto err_runtime_disable;
>   
>   
>   

-- 
---Trilok Soni
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
