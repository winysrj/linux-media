Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeERMUl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 08:20:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 18 May 2018 17:50:40 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Trilok Soni <tsoni@codeaurora.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        acourbot@google.com, linux-media-owner@vger.kernel.org
Subject: Re: [PATCH 4/4] media: venus: add PIL support
In-Reply-To: <e8596e31-42dc-8ac8-16e1-8990d7408bc4@codeaurora.org>
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
 <1526556740-25494-5-git-send-email-vgarodia@codeaurora.org>
 <e8596e31-42dc-8ac8-16e1-8990d7408bc4@codeaurora.org>
Message-ID: <9085424ea7db9cff46a853eadbd66697@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trilok,

On 2018-05-18 06:10, Trilok Soni wrote:
> Hi Vikash,
> 
> On 5/17/2018 4:32 AM, Vikash Garodia wrote:
>> This adds support to load the video firmware
>> and bring ARM9 out of reset. This is useful
>> for platforms which does not have trustzone
>> to reset the ARM9.
> 
> ARM9 = video core here? May be commit text needs little bit more 
> detail.
Yes, ARM9 here refers to the CPU running the firmware inside video core.
I can add some more detail on the same.

>>   +static int store_firmware_dev(struct device *dev, void *data)
>> +{
>> +	struct venus_core *core;
>> +
>> +	core = (struct venus_core *)data;
> 
> No need of casting.

Ok. Will remove the casting.

> 
>> +	if (!core)
>> +		return -EINVAL;
>> +
>> +	if (of_device_is_compatible(dev->of_node, "qcom,venus-pil-no-tz"))
>> +		core->fw.dev = dev;
>> +
>> +	return 0;
>> +}
>> +
> 
> 
>>   -	ret = venus_boot(dev, core->res->fwname);
>> +	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
>> +	if (ret)
>> +		goto err_runtime_disable;
>> +
>> +	/* Attempt to register child devices */
>> +	ret = device_for_each_child(dev, core, store_firmware_dev);
>> +
> 
> and not ret check needed?

Not needed. The fn (store_firmware_dev) just stores the child device 
pointer.
Later in the driver, if the child device pointer is not populated, probe 
is
deferred. Again, child device for which this populate is added, is an 
optional
child node.

>> +	ret = venus_boot(core);
>>   	if (ret)
>>   		goto err_runtime_disable;
>> 
