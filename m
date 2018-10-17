Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39070 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbeJQVRY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 17:17:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Oct 2018 18:51:42 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v11 0/5] Venus updates - PIL
In-Reply-To: <a31e499a-fa88-67b8-1853-8ea0d9297aa9@linaro.org>
References: <1539005572-803-1-git-send-email-vgarodia@codeaurora.org>
 <a31e499a-fa88-67b8-1853-8ea0d9297aa9@linaro.org>
Message-ID: <5c098025f136c25f5b0bb14d79866cf8@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

Thanks for the review and approvals.
I have just posted v12 with the below comments addressed.

Please check and provide your blessings :)

On 2018-10-17 14:40, Stanimir Varbanov wrote:
> Hi Vikash,
> 
> Thanks for the patches and patience!
> 
> On 10/08/2018 04:32 PM, Vikash Garodia wrote:
>> This version of the series
>> * extends the description of firmware subnode in documentation.
>> * renames the flag suggesting the presence of tz and update code
>>   accordingly.
>> 
>> Stanimir Varbanov (1):
>>   venus: firmware: register separate platform_device for firmware 
>> loader
>> 
>> Vikash Garodia (4):
>>   venus: firmware: add routine to reset ARM9
>>   venus: firmware: move load firmware in a separate function
>>   venus: firmware: add no TZ boot and shutdown routine
>>   dt-bindings: media: Document bindings for venus firmware device
>> 
>>  .../devicetree/bindings/media/qcom,venus.txt       |  14 +-
>>  drivers/media/platform/qcom/venus/core.c           |  24 ++-
>>  drivers/media/platform/qcom/venus/core.h           |   6 +
>>  drivers/media/platform/qcom/venus/firmware.c       | 235 
>> +++++++++++++++++++--
>>  drivers/media/platform/qcom/venus/firmware.h       |  17 +-
>>  drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
>>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |   8 +
>>  7 files changed, 274 insertions(+), 43 deletions(-)
>> 
> 
> Tested-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> 
> With the comment addressed in 1/5:
> 
> Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
