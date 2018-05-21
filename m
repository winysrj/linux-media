Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34938 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbeEUOZH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 10:25:07 -0400
Received: by mail-wm0-f67.google.com with SMTP id o78-v6so27035358wmg.0
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 07:25:07 -0700 (PDT)
Subject: Re: [PATCH v2 02/29] venus: hfi: preparation to support venus 4xx
To: Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-3-stanimir.varbanov@linaro.org>
 <CAAFQd5Ddfrj7Gh5KAkUxEjiT_LPaYqyzxOd53eCcG5Q7weMEmw@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <219b48c2-4bd9-7c32-5b21-7d391f051a34@linaro.org>
Date: Mon, 21 May 2018 17:25:03 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Ddfrj7Gh5KAkUxEjiT_LPaYqyzxOd53eCcG5Q7weMEmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the comments!

On 05/18/2018 12:44 PM, Tomasz Figa wrote:
> Hi Stanimir,
> 
> On Tue, May 15, 2018 at 5:14 PM Stanimir Varbanov <
> stanimir.varbanov@linaro.org> wrote:
> 
>> This covers the differences between 1xx,3xx and 4xx.
> 
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>    drivers/media/platform/qcom/venus/core.h         |  4 ++
>>    drivers/media/platform/qcom/venus/helpers.c      | 37 +++++++----
>>    drivers/media/platform/qcom/venus/hfi_helper.h   | 84
> ++++++++++++++++++++++--
>>    drivers/media/platform/qcom/venus/hfi_venus_io.h | 24 +++++++
>>    drivers/media/platform/qcom/venus/vdec.c         |  5 +-
>>    drivers/media/platform/qcom/venus/venc.c         |  5 +-
>>    6 files changed, 137 insertions(+), 22 deletions(-)
> 
> Please see my comments inline.
> 
> [snip]
> 
>> @@ -257,12 +273,11 @@ static int load_scale_clocks(struct venus_core
> *core)
> 
>>    set_freq:
> 
>> -       if (core->res->hfi_version == HFI_VERSION_3XX) {
>> -               ret = clk_set_rate(clk, freq);
>> +       ret = clk_set_rate(clk, freq);
>> +
>> +       if (IS_V3(core) || IS_V4(core)) {
>>                   ret |= clk_set_rate(core->core0_clk, freq);
>>                   ret |= clk_set_rate(core->core1_clk, freq);
>> -       } else {
>> -               ret = clk_set_rate(clk, freq);
>>           }
> 
> nit: The clock API defines NULL clock as a special no-op value and so
> clk_set_rate(NULL, ...) would return 0 instantly. Maybe it would just make
> sense to have core0_clk and core1_clk set to NULL for V1 and remove the
> condition here?

OK, we could avoid the condition but I'll add a comment that those
clocks exist from v3 onwards.

> 
>>           if (ret) {
>> diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h
> b/drivers/media/platform/qcom/venus/hfi_helper.h
>> index 55d8eb21403a..1bc5aab1ce6b 100644
>> --- a/drivers/media/platform/qcom/venus/hfi_helper.h
>> +++ b/drivers/media/platform/qcom/venus/hfi_helper.h
>> @@ -121,6 +121,7 @@
>>    #define HFI_EXTRADATA_METADATA_FILLER                  0x7fe00002
> 
>>    #define HFI_INDEX_EXTRADATA_INPUT_CROP                 0x0700000e
>> +#define HFI_INDEX_EXTRADATA_OUTPUT_CROP                        0x0700000f
> 
> nit: Would it make sense to suffix this _4XX, so that reader could know
> that it was introduced in this version? Similarly for other newly added
> definitions.

I personally don't like the version suffix on defines. Also seems this
is not used in the code, so I'll drop it for now.

> 
>>    #define HFI_INDEX_EXTRADATA_DIGITAL_ZOOM               0x07000010
>>    #define HFI_INDEX_EXTRADATA_ASPECT_RATIO               0x7f100003
> 
>> @@ -376,13 +377,18 @@
>>    #define HFI_BUFFER_OUTPUT2                     0x3
>>    #define HFI_BUFFER_INTERNAL_PERSIST            0x4
>>    #define HFI_BUFFER_INTERNAL_PERSIST_1          0x5
>> -#define HFI_BUFFER_INTERNAL_SCRATCH            0x1000001
>> -#define HFI_BUFFER_EXTRADATA_INPUT             0x1000002
>> -#define HFI_BUFFER_EXTRADATA_OUTPUT            0x1000003
>> -#define HFI_BUFFER_EXTRADATA_OUTPUT2           0x1000004
>> -#define HFI_BUFFER_INTERNAL_SCRATCH_1          0x1000005
>> -#define HFI_BUFFER_INTERNAL_SCRATCH_2          0x1000006
>> -
>> +#define HFI_BUFFER_INTERNAL_SCRATCH(ver)       \
>> +       (((ver) == HFI_VERSION_4XX) ? 0x6 : 0x1000001)
>> +#define HFI_BUFFER_INTERNAL_SCRATCH_1(ver)     \
>> +       (((ver) == HFI_VERSION_4XX) ? 0x7 : 0x1000005)
>> +#define HFI_BUFFER_INTERNAL_SCRATCH_2(ver)     \
>> +       (((ver) == HFI_VERSION_4XX) ? 0x8 : 0x1000006)
>> +#define HFI_BUFFER_EXTRADATA_INPUT(ver)                \
>> +       (((ver) == HFI_VERSION_4XX) ? 0xc : 0x1000002)
>> +#define HFI_BUFFER_EXTRADATA_OUTPUT(ver)       \
>> +       (((ver) == HFI_VERSION_4XX) ? 0xa : 0x1000003)
>> +#define HFI_BUFFER_EXTRADATA_OUTPUT2(ver)      \
>> +       (((ver) == HFI_VERSION_4XX) ? 0xb : 0x1000004)
> 
> nit: Does it make sense to add an argument, rather than simply defining
> separate HFI_BUFFER_INTERNAL_SCRATCH_1XX and
> HFI_BUFFER_INTERNAL_SCRATCH_4XX? In my subjective opinion, the argument

I'd like to keep the name of the define version agnostic.

> just makes it harder to read, as it's not clear how it is used inside the
> macro from reading just the call to it. Also it would get messy when adding
> further variants in future.
> 
> [snip]
> 
>> +/* HFI 4XX reorder the fields, use these macros */
>> +#define HFI_BUFREQ_HOLD_COUNT(bufreq, ver)     \
>> +       ((ver) == HFI_VERSION_4XX ? 0 : (bufreq)->hold_count)
>> +#define HFI_BUFREQ_COUNT_MIN(bufreq, ver)      \
>> +       ((ver) == HFI_VERSION_4XX ? (bufreq)->hold_count :
> (bufreq)->count_min)
>> +#define HFI_BUFREQ_COUNT_MIN_HOST(bufreq, ver) \
>> +       ((ver) == HFI_VERSION_4XX ? (bufreq)->count_min : 0)
>> +
> 
> Hmm, this is a bit messy. The macro is supposed to return count_min, but it
> returns hold_count. Shouldn't we define a separate

yep, that was the purpose of the macro, i.e. to swap the fields
depending on the version.

> hfi_buffer_requirements_4xx struct for 4XX?

With above macros I wanted to avoid that. We already have few structures
with 3x prefix and I want to stop that growing.

> 
> Even though this seems to simplify the code eventually, I think it might be
> quite confusing for anyone working with the driver in the future.

It is a matter of taste in the end of the day.

> 
> Also HFI_BUFREQ_HOLD_COUNT and HFI_BUFREQ_COUNT_MIN_HOST don't seem to be
> used anywhere.

yes, they are here for completeness ;)

> 
> [snip]
> 
>> +/* vcodec noc error log registers */
>> +#define VCODEC_CORE0_VIDEO_NOC_BASE_OFFS               0x4000
>> +#define VCODEC_CORE1_VIDEO_NOC_BASE_OFFS               0xc000
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_SWID_LOW_OFFS       0x500
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_SWID_HIGH_OFFS      0x504
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_MAINCTL_LOW_OFFS    0x508
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRVLD_LOW_OFFS     0x510
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRCLR_LOW_OFFS     0x518
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRLOG0_LOW_OFFS    0x520
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRLOG0_HIGH_OFFS   0x524
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRLOG1_LOW_OFFS    0x528
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRLOG1_HIGH_OFFS   0x52c
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRLOG2_LOW_OFFS    0x530
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRLOG2_HIGH_OFFS   0x534
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRLOG3_LOW_OFFS    0x538
>> +#define VCODEC_COREX_VIDEO_NOC_ERR_ERRLOG3_HIGH_OFFS   0x53c
> 
> What are these offsets from?

Those registers are used in donwstream driver for debug purpose. In case
iommu fault is triggered dumping these registers could give us a clue
what goes wrong.

> 
> nit: Other registers seem to be defined as (xxx_BASE + offset). Is there
> any reason to define these in another way?

For example the first register in the list is a BASE address for core0.
Next _COREX_ are offsets from the base.

Looks these registers are not used in this patchset I'll drop them for now.

> 
>> +
>>    #endif
>> diff --git a/drivers/media/platform/qcom/venus/vdec.c
> b/drivers/media/platform/qcom/venus/vdec.c
>> index 49bbd1861d3a..261a51adeef2 100644
>> --- a/drivers/media/platform/qcom/venus/vdec.c
>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>> @@ -689,6 +689,7 @@ static int vdec_queue_setup(struct vb2_queue *q,
> 
>>    static int vdec_verify_conf(struct venus_inst *inst)
>>    {
>> +       enum hfi_version ver = inst->core->res->hfi_version;
>>           struct hfi_buffer_requirements bufreq;
>>           int ret;
> 
>> @@ -700,14 +701,14 @@ static int vdec_verify_conf(struct venus_inst *inst)
>>                   return ret;
> 
>>           if (inst->num_output_bufs < bufreq.count_actual ||
>> -           inst->num_output_bufs < bufreq.count_min)
>> +           inst->num_output_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
>>                   return -EINVAL;
> 
>>           ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
>>           if (ret)
>>                   return ret;
> 
>> -       if (inst->num_input_bufs < bufreq.count_min)
>> +       if (inst->num_input_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
>>                   return -EINVAL;
> 
> Back to the point I raised above, maybe we could make
> venus_helper_get_bufreq() untangle the order of fields for 4XX? It seems to
> do a memcpy anyway, so doing it field by field for such small struct
> shouldn't really matter.

That couldn't happen because the structure fields are not only reordered
but also renamed.

1xx and 3xx	vs.	4xx

hold_count		count_min
count_min		count_min_host
count_actual		count_actual

-- 
regards,
Stan
