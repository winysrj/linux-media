Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35004 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbeJHSaY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 14:30:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Oct 2018 16:49:09 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH] venus: vdec: fix decoded data size
In-Reply-To: <68f15b8b-3121-3412-2ad1-6647e9afc264@linaro.org>
References: <1538566221-21369-1-git-send-email-vgarodia@codeaurora.org>
 <68f15b8b-3121-3412-2ad1-6647e9afc264@linaro.org>
Message-ID: <a0758f3e3c214f8d6659cf85d6fbe67e@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On 2018-10-05 20:56, Stanimir Varbanov wrote:
> Hi Vikash,
> 
> please, increment the version of the patch next time. This one must be 
> v2.
> 
> On 10/03/2018 02:30 PM, Vikash Garodia wrote:
>> Exisiting code returns the max of the decoded size and buffer size.
> 
> s/Exisiting/Existing
> 

Posted v2 with above comments.

Thanks,
Vikash
