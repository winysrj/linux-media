Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35076 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbcLEMVB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 07:21:01 -0500
Received: by mail-wm0-f51.google.com with SMTP id a197so94308694wmd.0
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2016 04:21:00 -0800 (PST)
Subject: Re: [PATCH v4 8/9] media: venus: hfi: add Venus HFI files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1480583001-32236-1-git-send-email-stanimir.varbanov@linaro.org>
 <1480583001-32236-9-git-send-email-stanimir.varbanov@linaro.org>
 <c5a89070-1c24-6cdd-5116-83a15f480285@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <9a2cf9a6-ad80-0c50-3897-6e48fbb9073c@linaro.org>
Date: Mon, 5 Dec 2016 14:20:57 +0200
MIME-Version: 1.0
In-Reply-To: <c5a89070-1c24-6cdd-5116-83a15f480285@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 12/05/2016 02:05 PM, Hans Verkuil wrote:
> On 12/01/2016 10:03 AM, Stanimir Varbanov wrote:
>> Here is the implementation of Venus video accelerator low-level
>> functionality. It contanins code which setup the registers and
>> startup uthe processor, allocate and manipulates with the shared
>> memory used for sending commands and receiving messages.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/hfi_venus.c    | 1508 ++++++++++++++++++++++
>>  drivers/media/platform/qcom/venus/hfi_venus.h    |   23 +
>>  drivers/media/platform/qcom/venus/hfi_venus_io.h |   98 ++
>>  3 files changed, 1629 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.c
>>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.h
>>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus_io.h
>>
>> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
>> new file mode 100644
>> index 000000000000..f004a9a80d85
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
>> @@ -0,0 +1,1508 @@
>> +static int venus_tzbsp_set_video_state(enum tzbsp_video_state state)
>> +{
>> +	return qcom_scm_video_set_state(state, 0);
> 
> This functions doesn't seem to exist. Is there a prerequisite patch series that
> introduces this function?

yes, the patchset [1] is under review.

-- 
regards,
Stan

[1] https://lkml.org/lkml/2016/11/7/533
