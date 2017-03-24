Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35476 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935684AbdCXPaw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 11:30:52 -0400
Received: by mail-wm0-f46.google.com with SMTP id u132so15954807wmg.0
        for <linux-media@vger.kernel.org>; Fri, 24 Mar 2017 08:30:51 -0700 (PDT)
Subject: Re: [PATCH v7 9/9] media: venus: enable building of Venus video
 driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
 <1489423058-12492-10-git-send-email-stanimir.varbanov@linaro.org>
 <e45a12c6-ec90-383b-e499-d16907244132@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <acf5cd40-ed07-349e-543f-fbc10d1917aa@linaro.org>
Date: Fri, 24 Mar 2017 17:30:43 +0200
MIME-Version: 1.0
In-Reply-To: <e45a12c6-ec90-383b-e499-d16907244132@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the comments!

On 03/24/2017 04:49 PM, Hans Verkuil wrote:
> On 03/13/17 17:37, Stanimir Varbanov wrote:
>> This adds Venus driver Makefile and changes v4l2 platform
>> Makefile/Kconfig in order to enable building of the driver.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/Kconfig             | 14 ++++++++++++++
>>  drivers/media/platform/Makefile            |  2 ++
>>  drivers/media/platform/qcom/venus/Makefile | 11 +++++++++++
>>  3 files changed, 27 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/venus/Makefile
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 53f6f12bff0d..8a6c3d664307 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -447,6 +447,20 @@ config VIDEO_TI_VPE_DEBUG
>>  	---help---
>>  	  Enable debug messages on VPE driver.
>>  
>> +config VIDEO_QCOM_VENUS
>> +	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
>> +	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> 
> Can this also depend on COMPILE_TEST? And if so, please make sure it compile on both
> a 32 and 64 bit environment to shake out any compiler warnings.
> 

yes I can add COMPILE_TEST, at least on -next it should be fine.

-- 
regards,
Stan
