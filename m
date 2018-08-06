Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbeHFPr1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 11:47:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Aug 2018 19:08:17 +0530
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
Message-ID: <9960617f02a0df8935175651408ce2d3@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On 2018-07-25 15:05, Stanimir Varbanov wrote:
> Hi Vikash,
> 
> On 07/04/2018 10:06 PM, Vikash Garodia wrote:
>> Separate firmware loading part into a new function.
> 
> I cannot apply this patch in order to test the series.
Sorry about the inconvenience. Most probably this PIL patch series
was based on previous version of the venus update series from you.
I have posted a new series which is based on the latest venus driver.

>> 
>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>> ---
<snip>
