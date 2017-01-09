Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:45729 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755133AbdAINE2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 08:04:28 -0500
Subject: Re: [PATCH v4 8/9] media: venus: hfi: add Venus HFI files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1480583001-32236-1-git-send-email-stanimir.varbanov@linaro.org>
 <1480583001-32236-9-git-send-email-stanimir.varbanov@linaro.org>
 <c5a89070-1c24-6cdd-5116-83a15f480285@xs4all.nl>
 <9a2cf9a6-ad80-0c50-3897-6e48fbb9073c@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <41490c02-d87d-5ae1-9004-328e511a5656@xs4all.nl>
Date: Mon, 9 Jan 2017 14:04:21 +0100
MIME-Version: 1.0
In-Reply-To: <9a2cf9a6-ad80-0c50-3897-6e48fbb9073c@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/2016 01:20 PM, Stanimir Varbanov wrote:
> Hi Hans,
> 
> On 12/05/2016 02:05 PM, Hans Verkuil wrote:
>> On 12/01/2016 10:03 AM, Stanimir Varbanov wrote:
>>> Here is the implementation of Venus video accelerator low-level
>>> functionality. It contanins code which setup the registers and
>>> startup uthe processor, allocate and manipulates with the shared
>>> memory used for sending commands and receiving messages.
>>>
>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>> ---
>>>  drivers/media/platform/qcom/venus/hfi_venus.c    | 1508 ++++++++++++++++++++++
>>>  drivers/media/platform/qcom/venus/hfi_venus.h    |   23 +
>>>  drivers/media/platform/qcom/venus/hfi_venus_io.h |   98 ++
>>>  3 files changed, 1629 insertions(+)
>>>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.c
>>>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.h
>>>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus_io.h
>>>
>>> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
>>> new file mode 100644
>>> index 000000000000..f004a9a80d85
>>> --- /dev/null
>>> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
>>> @@ -0,0 +1,1508 @@
>>> +static int venus_tzbsp_set_video_state(enum tzbsp_video_state state)
>>> +{
>>> +	return qcom_scm_video_set_state(state, 0);
>>
>> This functions doesn't seem to exist. Is there a prerequisite patch series that
>> introduces this function?
> 
> yes, the patchset [1] is under review.
> 

What is the status of this patchset?

Regards,

	Hans
