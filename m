Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbeERHSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 03:18:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 18 May 2018 12:48:44 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, andy.gross@linaro.org,
        stanimir.varbanov@linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, acourbot@google.com,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH 1/4] soc: qcom: mdt_loader: Add check to make scm calls
In-Reply-To: <20180518052844.GP14924@minitux>
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
 <1526556740-25494-2-git-send-email-vgarodia@codeaurora.org>
 <20180518052844.GP14924@minitux>
Message-ID: <5c3934858f7e48b0de13f12d40d126f1@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bjorn,

On 2018-05-18 10:58, Bjorn Andersson wrote:
> On Thu 17 May 04:32 PDT 2018, Vikash Garodia wrote:
> 
>> In order to invoke scm calls, ensure that the platform
>> has the required support to invoke the scm calls in
>> secure world.
>> 
>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>> ---
>>  drivers/soc/qcom/mdt_loader.c | 21 +++++++++++++--------
>>  1 file changed, 13 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/soc/qcom/mdt_loader.c 
>> b/drivers/soc/qcom/mdt_loader.c
>> index 17b314d..db55d53 100644
>> --- a/drivers/soc/qcom/mdt_loader.c
>> +++ b/drivers/soc/qcom/mdt_loader.c
>> @@ -121,10 +121,12 @@ int qcom_mdt_load(struct device *dev, const 
>> struct firmware *fw,
>>  	if (!fw_name)
>>  		return -ENOMEM;
>> 
>> -	ret = qcom_scm_pas_init_image(pas_id, fw->data, fw->size);
>> -	if (ret) {
>> -		dev_err(dev, "invalid firmware metadata\n");
>> -		goto out;
>> +	if (qcom_scm_is_available()) {
> 
> qcom_scm_is_available() tells you if the qcom_scm driver has been
> probed, not if your platform implements PAS.
> 
> Please add a DT property to tell the driver if it should require PAS or
> not (the absence of such property should indicate PAS is required, for
> backwards compatibility purposes). For the MDT loader we need to merge
> the following patch to make this work:
> 
> https://patchwork.kernel.org/patch/10397889/

Thanks for your inputs. I have already added a child node in video DT 
node
to tell the driver if PAS is not needed.
I will drop this patch as use 
https://patchwork.kernel.org/patch/10397889
and update the driver to call new api qcom_mdt_load_no_init.

> Regards,
> Bjorn
