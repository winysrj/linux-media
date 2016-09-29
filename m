Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36594 "EHLO
        mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753963AbcI2A4C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 20:56:02 -0400
Received: by mail-pa0-f44.google.com with SMTP id qn7so21726665pac.3
        for <linux-media@vger.kernel.org>; Wed, 28 Sep 2016 17:56:01 -0700 (PDT)
Subject: Re: [PATCH v2 7/8] media: vidc: add Makefiles and Kconfig files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
 <1473248229-5540-8-git-send-email-stanimir.varbanov@linaro.org>
 <a07f0a70-1500-c6aa-b42d-dd97fe8d06cb@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <202c234c-fe72-458e-80ef-4438e0b184d9@linaro.org>
Date: Thu, 29 Sep 2016 03:55:51 +0300
MIME-Version: 1.0
In-Reply-To: <a07f0a70-1500-c6aa-b42d-dd97fe8d06cb@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09/19/2016 01:35 PM, Hans Verkuil wrote:
> On 09/07/2016 01:37 PM, Stanimir Varbanov wrote:
>> Makefile and Kconfig files to build the video codec driver.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/Kconfig       |  8 ++++++++
>>  drivers/media/platform/qcom/Makefile      |  6 ++++++
>>  drivers/media/platform/qcom/vidc/Makefile | 15 +++++++++++++++
>>  3 files changed, 29 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/Kconfig
>>  create mode 100644 drivers/media/platform/qcom/Makefile
>>  create mode 100644 drivers/media/platform/qcom/vidc/Makefile
>>
>> diff --git a/drivers/media/platform/qcom/Kconfig b/drivers/media/platform/qcom/Kconfig
>> new file mode 100644
>> index 000000000000..4bad5c0f68e4
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/Kconfig
>> @@ -0,0 +1,8 @@
>> +comment "Qualcomm V4L2 drivers"
>> +
>> +menuconfig QCOM_VIDC
>> +        tristate "Qualcomm V4L2 encoder/decoder driver"
>> +        depends on ARCH_QCOM && VIDEO_V4L2
>> +        depends on IOMMU_DMA
>> +        depends on QCOM_VENUS_PIL
>> +        select VIDEOBUF2_DMA_SG
> 
> If at all possible, please depend on COMPILE_TEST as well!

OK, I will add it.

> 
> Also missing: a patch adding an entry to the MAINTAINERS file.

I will add such a patch in next submission.

-- 
regards,
Stan
