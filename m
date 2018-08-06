Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38040 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbeHFK0s (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 06:26:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Aug 2018 13:48:52 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org, arnd@arndb.de,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        acourbot@chromium.org, linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v3 3/4] venus: firmware: add no TZ boot and shutdown
 routine
In-Reply-To: <4727000d-96ef-2dc5-50df-6bdadcaa156e@linaro.org>
References: <1530731212-30474-1-git-send-email-vgarodia@codeaurora.org>
 <1530731212-30474-4-git-send-email-vgarodia@codeaurora.org>
 <4727000d-96ef-2dc5-50df-6bdadcaa156e@linaro.org>
Message-ID: <e482a9af27288c9e8a8ffb5c1de8a209@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

Thanks for your review.

On 2018-07-25 15:06, Stanimir Varbanov wrote:
> Hi Vikash,
> 
> On 07/04/2018 10:06 PM, Vikash Garodia wrote:
> 
<snip>

>> 
>>  #define VENUS_PAS_ID			9
>> -#define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
>> +#define VENUS_FW_MEM_SIZE		(5 * SZ_1M)
> 
> This change should be subject to a separate patch.
Ok.

> 
<snip>

>> +	writel_relaxed(reg, reg_base + WRAPPER_A9SS_SW_RESET);
>> +
>> +	/* Make sure reset is asserted before the mapping is removed */
>> +	mb();
> 
> mb() is used for compiler barrier as far as I know, isn't better to 
> just
> read the register and keep the comment?

mb() can ensure that the instructions are ordered. This is needed to 
ensure
reset before the mapping is removed.

Thanks,
Vikash
