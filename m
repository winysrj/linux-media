Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35841 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754389AbcI2Atx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 20:49:53 -0400
Received: by mail-pf0-f169.google.com with SMTP id q2so22613835pfj.3
        for <linux-media@vger.kernel.org>; Wed, 28 Sep 2016 17:49:53 -0700 (PDT)
Subject: Re: [PATCH v2 3/8] media: vidc: decoder: add video decoder files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
 <1473248229-5540-4-git-send-email-stanimir.varbanov@linaro.org>
 <92676ec7-ff83-5216-afd7-c9bfd8005d9d@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <b9a8ce56-542b-04ab-44ba-46df513c166f@linaro.org>
Date: Thu, 29 Sep 2016 03:49:51 +0300
MIME-Version: 1.0
In-Reply-To: <92676ec7-ff83-5216-afd7-c9bfd8005d9d@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/19/2016 01:12 PM, Hans Verkuil wrote:
> On 09/07/2016 01:37 PM, Stanimir Varbanov wrote:
>> This consists of video decoder implementation plus decoder
>> controls.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/vidc/vdec.c       | 1091 +++++++++++++++++++++++++
>>  drivers/media/platform/qcom/vidc/vdec.h       |   29 +
>>  drivers/media/platform/qcom/vidc/vdec_ctrls.c |  200 +++++
>>  drivers/media/platform/qcom/vidc/vdec_ctrls.h |   21 +
>>  4 files changed, 1341 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/vidc/vdec.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/vdec.h
>>  create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.c
>>  create mode 100644 drivers/media/platform/qcom/vidc/vdec_ctrls.h
>>
> 
> <snip>
> 
>> +static int vdec_event_notify(struct hfi_inst *hfi_inst, u32 event,
>> +			     struct hfi_event_data *data)
>> +{
>> +	struct vidc_inst *inst = hfi_inst->ops_priv;
>> +	struct device *dev = inst->core->dev;
>> +	const struct v4l2_event ev = { .type = V4L2_EVENT_SOURCE_CHANGE };
> 
> 1) this can be static
> 2) set the u.src_change.changes as well.

Sure will do.

-- 
regards,
Stan
