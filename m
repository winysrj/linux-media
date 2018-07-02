Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55995 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752732AbeGBMnu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 08:43:50 -0400
Received: by mail-wm0-f67.google.com with SMTP id v16-v6so8919118wmv.5
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 05:43:49 -0700 (PDT)
Subject: Re: [PATCH v2 27/29] venus: implementing multi-stream support
To: Tomasz Figa <tfiga@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-28-stanimir.varbanov@linaro.org>
 <CAAFQd5Cyk2=YG+LVGt0qEcrRGdarpHJDJ73AzG1iWBbyhr+nAA@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <394e5547-9b85-604f-ee9e-fdb5ea2f4237@linaro.org>
Date: Mon, 2 Jul 2018 15:43:46 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Cyk2=YG+LVGt0qEcrRGdarpHJDJ73AzG1iWBbyhr+nAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 05/31/2018 12:51 PM, Tomasz Figa wrote:
> On Tue, May 15, 2018 at 5:00 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> This is implementing a multi-stream decoder support. The multi
>> stream gives an option to use the secondary decoder output
>> with different raw format (or the same in case of crop).
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/core.h    |   1 +
>>  drivers/media/platform/qcom/venus/helpers.c | 204 +++++++++++++++++++++++++++-
>>  drivers/media/platform/qcom/venus/helpers.h |   6 +
>>  drivers/media/platform/qcom/venus/vdec.c    |  91 ++++++++++++-
>>  drivers/media/platform/qcom/venus/venc.c    |   1 +
>>  5 files changed, 299 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
>> index 4d6c05f156c4..85e66e2dd672 100644
>> --- a/drivers/media/platform/qcom/venus/core.h
>> +++ b/drivers/media/platform/qcom/venus/core.h
>> @@ -259,6 +259,7 @@ struct venus_inst {
>>         struct list_head list;
>>         struct mutex lock;
>>         struct venus_core *core;
>> +       struct list_head dpbbufs;
>>         struct list_head internalbufs;
>>         struct list_head registeredbufs;
>>         struct list_head delayed_process;
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>> index ed569705ecac..87dcf9973e6f 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.c
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -85,6 +85,112 @@ bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
>>  }
>>  EXPORT_SYMBOL_GPL(venus_helper_check_codec);
>>
>> +static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
>> +{
>> +       struct intbuf *buf;
>> +       int ret = 0;
>> +
>> +       if (list_empty(&inst->dpbbufs))
>> +               return 0;
> 
> Does this special case give us anything other than few more source lines?

yes, thanks for spotting, will drop above lines here and below.

> 
>> +
>> +       list_for_each_entry(buf, &inst->dpbbufs, list) {
>> +               struct hfi_frame_data fdata;
>> +
>> +               memset(&fdata, 0, sizeof(fdata));
>> +               fdata.alloc_len = buf->size;
>> +               fdata.device_addr = buf->da;
>> +               fdata.buffer_type = buf->type;
>> +
>> +               ret = hfi_session_process_buf(inst, &fdata);
>> +               if (ret)
>> +                       goto fail;
>> +       }
>> +
>> +fail:
>> +       return ret;
>> +}
>> +
>> +int venus_helper_free_dpb_bufs(struct venus_inst *inst)
>> +{
>> +       struct intbuf *buf, *n;
>> +
>> +       if (list_empty(&inst->dpbbufs))
>> +               return 0;
> 
> Ditto.
> 
>> +
>> +       list_for_each_entry_safe(buf, n, &inst->dpbbufs, list) {
>> +               list_del_init(&buf->list);
>> +               dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
>> +                              buf->attrs);
>> +               kfree(buf);
>> +       }
>> +
>> +       INIT_LIST_HEAD(&inst->dpbbufs);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(venus_helper_free_dpb_bufs);
> [snip]
>> +int venus_helper_get_out_fmts(struct venus_inst *inst, u32 v4l2_fmt,
>> +                             u32 *out_fmt, u32 *out2_fmt, bool ubwc)
>> +{
>> +       struct venus_core *core = inst->core;
>> +       struct venus_caps *caps;
>> +       u32 ubwc_fmt, fmt = to_hfi_raw_fmt(v4l2_fmt);
>> +       bool found, found_ubwc;
>> +
>> +       *out_fmt = *out2_fmt = 0;
>> +
>> +       if (!fmt)
>> +               return -EINVAL;
>> +
>> +       caps = venus_caps_by_codec(core, inst->hfi_codec, inst->session_type);
>> +       if (!caps)
>> +               return -EINVAL;
>> +
>> +       if (ubwc) {
>> +               ubwc_fmt = fmt | HFI_COLOR_FORMAT_UBWC_BASE;
> 
> Does the UBWC base format have to be the same as fmt? Looking at
> HFI_COLOR_FORMAT_* macros, UBWC variants seem to exist only for few
> selected raw formats, for example there is none for NV21.

I think any raw format can have its UBWC variant. And yes we have only
one macro but we are checking against parsed capabilities from firmware
where the supported formats are stored.

-- 
regards,
Stan
