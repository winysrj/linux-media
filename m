Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbeJVT37 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 15:29:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Oct 2018 16:41:51 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v12 0/5] Venus updates - PIL
In-Reply-To: <CAPBb6MWxUNyJEkAUATa7BiXgU1JefoxFseXuaLb+_XsLish8Pw@mail.gmail.com>
References: <1539782303-4091-1-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MWxUNyJEkAUATa7BiXgU1JefoxFseXuaLb+_XsLish8Pw@mail.gmail.com>
Message-ID: <213d6ccf6f06d4577187cda121a999d3@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Alex.

On 2018-10-22 11:21, Alexandre Courbot wrote:
> Hi Vikash,
> 
> On Wed, Oct 17, 2018 at 10:18 PM Vikash Garodia 
> <vgarodia@codeaurora.org> wrote:
>> 
>> This version of the series
>> * updates the tz flag to unsigned
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
> 
> The series:
> 
> Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> Tested-by: Alexandre Courbot <acourbot@chromium.org>
