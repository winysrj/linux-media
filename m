Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40475 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728405AbeHVPy1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 11:54:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id n2-v6so1456149wrw.7
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2018 05:29:42 -0700 (PDT)
Subject: Re: [PATCH v4 2/4] venus: firmware: move load firmware in a separate
 function
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org, arnd@arndb.de,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        acourbot@chromium.org, linux-media-owner@vger.kernel.org
References: <1533562085-8773-1-git-send-email-vgarodia@codeaurora.org>
 <1533562085-8773-3-git-send-email-vgarodia@codeaurora.org>
 <8ffd63d9-ba9f-44b2-e1c0-7edce167fd9c@linaro.org>
 <4ad5d921a54256bccfd7030a3f0893d8@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <a065f811-d0ea-41d8-822b-92d5f9d0a8f3@linaro.org>
Date: Wed, 22 Aug 2018 15:29:38 +0300
MIME-Version: 1.0
In-Reply-To: <4ad5d921a54256bccfd7030a3f0893d8@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 08/21/2018 08:29 PM, Vikash Garodia wrote:
> Hi Stanimir,
> 
> On 2018-08-21 17:38, Stanimir Varbanov wrote:
>> Hi Vikash,
>>
>> On 08/06/2018 04:28 PM, Vikash Garodia wrote:
> 
> <snip>
> 
>>> -int venus_boot(struct device *dev, const char *fwname)
>>> +static int venus_load_fw(struct venus_core *core, const char *fwname,
>>> +            phys_addr_t *mem_phys, size_t *mem_size)
>>
>> fix indentation
> Please let me know which indentation rule is missed out here. As per last
> discussion, the parameters on next line should start from open parenthesis.
> I see the same being followed above.
> Also i have been running checkpatch script and it does not show up any
> issue.

run checkpatch with --strict option please.

> Any other script which can be executed to ensure the coding guidelines ?
> 
> <snip>
> 


-- 
regards,
Stan
