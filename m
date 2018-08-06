Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41558 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbeHFKct (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 06:32:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Aug 2018 13:54:52 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org, arnd@arndb.de,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        acourbot@chromium.org, linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v3 2/4] venus: firmware: move load firmware in a separate
 function
In-Reply-To: <b5ecaa26-2f3b-9a2e-d496-7f9b35e3f761@linaro.org>
References: <1530731212-30474-1-git-send-email-vgarodia@codeaurora.org>
 <1530731212-30474-3-git-send-email-vgarodia@codeaurora.org>
 <b5ecaa26-2f3b-9a2e-d496-7f9b35e3f761@linaro.org>
Message-ID: <6c8c4e7b27000903073ac85a867b0454@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On 2018-07-25 15:05, Stanimir Varbanov wrote:
> Hi Vikash,
> 
> On 07/04/2018 10:06 PM, Vikash Garodia wrote:

<snip>

>> +
>> +	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER))
>> +		return -EPROBE_DEFER;
> 
> the original venus_boot was checking for || !qcom_scm_is_available() 
> why
> is that removed? It was done on purpose.

For booting venus without tz, scm calls are not needed. Does it look 
good to
keep the check for "!core->no_tz" case alone ?

if (!core->no_tz && !qcom_scm_is_available())
     return -EPROBE_DEFER;

Thanks,
Vikash
