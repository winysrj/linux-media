Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48564 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729381AbeHWSCW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 14:02:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Aug 2018 20:02:25 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH 4/4] venus: firmware: register separate platform_device
 for firmware loader
In-Reply-To: <2bdb4da9-fac5-acf7-f4a0-4a5193c92d66@linaro.org>
References: <1534871974-32269-5-git-send-email-vgarodia@codeaurora.org>
 <20180822123442.10810-1-stanimir.varbanov@linaro.org>
 <2bdb4da9-fac5-acf7-f4a0-4a5193c92d66@linaro.org>
Message-ID: <9f9f4f4350a6dc9141ac0ab92ba2f583@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On 2018-08-22 18:07, Stanimir Varbanov wrote:
> Hi Vikash,
> 
> Could you give a try below patch on your environment? You should keep
> your 1/4 to 3/4 patches and replace your 4/4 with the below one.
> 
> You have to drop the compatible string in firmware DT subnode (keep 
> only
> iommus).

I have successfully tested this patch on my environment without tz. I 
have
post a new series by including below patch. Thank you Stanimir for your
review and below patch.

> On 08/22/2018 03:34 PM, Stanimir Varbanov wrote:
>> This registers a firmware platform_device and associate it with
>> video-firmware DT subnode. Then calls dma configure to initialize
>> dma and iommu.
>> 
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  .../devicetree/bindings/media/qcom,venus.txt       | 13 +++++-
>>  drivers/media/platform/qcom/venus/core.c           | 14 +++++--
>>  drivers/media/platform/qcom/venus/firmware.c       | 49 
>> ++++++++++++++++++++++
>>  drivers/media/platform/qcom/venus/firmware.h       |  2 +
>>  4 files changed, 73 insertions(+), 5 deletions(-)
>> 
<snip>
