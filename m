Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40877 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbeJQPBk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 11:01:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id z204-v6so932469wmc.5
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 00:07:23 -0700 (PDT)
Subject: Re: [PATCH v11 0/5] Venus updates - PIL
To: Vikash Garodia <vgarodia@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org
References: <1539005572-803-1-git-send-email-vgarodia@codeaurora.org>
 <fb81c8b7946898bc61e9b8c793c74184@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <62411a58-f23a-6215-3b9e-cf3b6b08ffdc@linaro.org>
Date: Wed, 17 Oct 2018 10:07:20 +0300
MIME-Version: 1.0
In-Reply-To: <fb81c8b7946898bc61e9b8c793c74184@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 10/16/2018 06:55 PM, Vikash Garodia wrote:
> <A Friendly reminder for review>

I have no review comments. I'll need some time to test this version on
v1 and v3.

> 
> On 2018-10-08 19:02, Vikash Garodia wrote:
>> This version of the series
>> * extends the description of firmware subnode in documentation.
>> * renames the flag suggesting the presence of tz and update code
>>   accordingly.
>>
>> Stanimir Varbanov (1):
>>   venus: firmware: register separate platform_device for firmware loader
>>
>> Vikash Garodia (4):
>>   venus: firmware: add routine to reset ARM9
>>   venus: firmware: move load firmware in a separate function
>>   venus: firmware: add no TZ boot and shutdown routine
>>   dt-bindings: media: Document bindings for venus firmware device
>>
>>  .../devicetree/bindings/media/qcom,venus.txt       |  14 +-
>>  drivers/media/platform/qcom/venus/core.c           |  24 ++-
>>  drivers/media/platform/qcom/venus/core.h           |   6 +
>>  drivers/media/platform/qcom/venus/firmware.c       | 235
>> +++++++++++++++++++--
>>  drivers/media/platform/qcom/venus/firmware.h       |  17 +-
>>  drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
>>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |   8 +
>>  7 files changed, 274 insertions(+), 43 deletions(-)

-- 
regards,
Stan
