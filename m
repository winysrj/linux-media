Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43750 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754492AbcKKJpM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 04:45:12 -0500
MIME-Version: 1.0
In-Reply-To: <75434223-9473-94f4-d721-fcd675c234de@linaro.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-9-git-send-email-stanimir.varbanov@linaro.org>
 <CAFp+6iGPo0aC0Nf+Y5O7bAqSpjGGzwBUZWupgf=bwnicDD04Lg@mail.gmail.com> <75434223-9473-94f4-d721-fcd675c234de@linaro.org>
From: Vivek Gautam <vivek.gautam@codeaurora.org>
Date: Fri, 11 Nov 2016 15:15:09 +0530
Message-ID: <CAFp+6iGcKX78PurPc4e6R8WP5tWa=SUO9WcjekFLhD_=-NP=pA@mail.gmail.com>
Subject: Re: [PATCH v3 8/9] media: venus: add Makefiles and Kconfig files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stan,

On Fri, Nov 11, 2016 at 2:37 PM, Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
> Hi Vivek,
>
> On 11/11/2016 08:12 AM, Vivek Gautam wrote:
>> On Mon, Nov 7, 2016 at 11:04 PM, Stanimir Varbanov
>> <stanimir.varbanov@linaro.org> wrote:
>>> Makefile and Kconfig files to build the Venus video codec driver.
>>>
>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>> ---
>>>  drivers/media/platform/qcom/Kconfig        |  7 +++++++
>>>  drivers/media/platform/qcom/Makefile       |  1 +
>>>  drivers/media/platform/qcom/venus/Makefile | 15 +++++++++++++++
>>>  3 files changed, 23 insertions(+)
>>>  create mode 100644 drivers/media/platform/qcom/Kconfig
>>>  create mode 100644 drivers/media/platform/qcom/Makefile
>>>  create mode 100644 drivers/media/platform/qcom/venus/Makefile
>>>
>>> diff --git a/drivers/media/platform/qcom/Kconfig b/drivers/media/platform/qcom/Kconfig
>>> new file mode 100644
>>> index 000000000000..bf4d2fcce924
>>> --- /dev/null
>>> +++ b/drivers/media/platform/qcom/Kconfig
>>> @@ -0,0 +1,7 @@
>>> +
>>> +menuconfig VIDEO_QCOM_VENUS
>>> +        tristate "Qualcomm Venus V4L2 encoder/decoder driver"
>>> +        depends on ARCH_QCOM && VIDEO_V4L2
>>
>> Let's also enable this for COMPILE_TEST.
>
> I agree, but it needs changes in other dependency drivers like qcom_scm
> one. I will try to come out with something in the next version.

Sure, let's see if there's a possibility. Else, we may have to revisit
this at a later point.
Thanks.


Regards
Vivek

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
