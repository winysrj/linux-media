Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbeHUUuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 16:50:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Aug 2018 22:59:15 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org, arnd@arndb.de,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        acourbot@chromium.org, linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v4 2/4] venus: firmware: move load firmware in a separate
 function
In-Reply-To: <8ffd63d9-ba9f-44b2-e1c0-7edce167fd9c@linaro.org>
References: <1533562085-8773-1-git-send-email-vgarodia@codeaurora.org>
 <1533562085-8773-3-git-send-email-vgarodia@codeaurora.org>
 <8ffd63d9-ba9f-44b2-e1c0-7edce167fd9c@linaro.org>
Message-ID: <4ad5d921a54256bccfd7030a3f0893d8@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On 2018-08-21 17:38, Stanimir Varbanov wrote:
> Hi Vikash,
> 
> On 08/06/2018 04:28 PM, Vikash Garodia wrote:

<snip>

>> -int venus_boot(struct device *dev, const char *fwname)
>> +static int venus_load_fw(struct venus_core *core, const char *fwname,
>> +			phys_addr_t *mem_phys, size_t *mem_size)
> 
> fix indentation
Please let me know which indentation rule is missed out here. As per 
last
discussion, the parameters on next line should start from open 
parenthesis.
I see the same being followed above.
Also i have been running checkpatch script and it does not show up any 
issue.
Any other script which can be executed to ensure the coding guidelines ?

<snip>

>> 
>> -	ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va, 
>> mem_phys,
>> -			    mem_size, NULL);
>> +	if (core->no_tz)
>> +		ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
>> +					mem_va, *mem_phys, *mem_size, NULL);
>> +	else
>> +		ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID,
>> +				mem_va, *mem_phys, *mem_size, NULL);
> 
> Please fix the indentation issues above.
Please specify here as well.

>> 
>>  	release_firmware(mdt);
>> 
>> -	if (ret)
>> -		goto err_unmap;
>> -
>> -	ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
>> -	if (ret)
>> -		goto err_unmap;
>> -
>>  err_unmap:
>>  	memunmap(mem_va);
>>  	return ret;
>>  }
>> 
>> +int venus_boot(struct venus_core *core)
>> +{
>> +	phys_addr_t mem_phys;
>> +	struct device *dev = core->dev;
> 
> move this one row upper.
> 
>> +	size_t mem_size;
>> +	int ret;
>> +
>> +	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) ||
>> +		(!core->no_tz && !qcom_scm_is_available()))
>> +		return -EPROBE_DEFER;
> 
> fix indentation
Please specify here as well.

Thanks,
Vikash
