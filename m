Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39028 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752430AbeGBMfu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 08:35:50 -0400
Received: by mail-wm0-f66.google.com with SMTP id p11-v6so8523658wmc.4
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 05:35:49 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH v4 02/27] venus: hfi: preparation to support venus 4xx
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        Tomasz Figa <tfiga@chromium.org>
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
 <20180627152725.9783-3-stanimir.varbanov@linaro.org>
 <CAPBb6MVST50MfDbs_GydCBDAA_fsVTYVVU9iCGiaCnMxPBRBPg@mail.gmail.com>
Message-ID: <22e415b0-fe3c-0584-e5ee-f0de94937234@linaro.org>
Date: Mon, 2 Jul 2018 15:35:46 +0300
MIME-Version: 1.0
In-Reply-To: <CAPBb6MVST50MfDbs_GydCBDAA_fsVTYVVU9iCGiaCnMxPBRBPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

Thanks for the comments!

On 07/02/2018 11:45 AM, Alexandre Courbot wrote:
> On Thu, Jun 28, 2018 at 12:35 AM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> This covers the differences between 1xx,3xx and 4xx.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/core.h         |  4 ++
>>  drivers/media/platform/qcom/venus/helpers.c      | 37 +++++++----
>>  drivers/media/platform/qcom/venus/hfi_helper.h   | 84 ++++++++++++++++++++++--
>>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  7 ++
>>  drivers/media/platform/qcom/venus/vdec.c         |  5 +-
>>  drivers/media/platform/qcom/venus/venc.c         |  5 +-
>>  6 files changed, 120 insertions(+), 22 deletions(-)
>>

<snip>

>>
>>  static int intbufs_alloc(struct venus_inst *inst)
>>  {
>> -       unsigned int i;
>> +       size_t arr_sz;
>> +       size_t i;
>>         int ret;
>>
>> -       for (i = 0; i < ARRAY_SIZE(intbuf_types); i++) {
>> -               ret = intbufs_set_buffer(inst, intbuf_types[i]);
>> +       if (IS_V4(inst->core))
>> +               arr_sz = ARRAY_SIZE(intbuf_types_4xx);
>> +       else
>> +               arr_sz = ARRAY_SIZE(intbuf_types_1xx);
>> +
>> +       for (i = 0; i < arr_sz; i++) {
>> +               ret = intbufs_set_buffer(inst,
>> +                           IS_V4(inst->core) ? intbuf_types_4xx[i] :
>> +                                               intbuf_types_1xx[i]);
> 
> I suspect you could simplify this a bit by doing something like:
> 
>     const unsigned int *intbuf;
> 
>     if (IS_V4(inst->core)) {
>         arr_sz = ARRAY_SIZE(intbuf_types_4xx);
>         intbuf = intbuf_types_4xx;
>     } else {
>         arr_sz = ARRAY_SIZE(intbuf_types_1xx);
>         intbuf = intbuf_types_1xx;
>     }
> 
>     for (i = 0; i < arr_sz; i++) {
>         ret = intbufs_set_buffer(inst, intbuf[i]);
>         if (ret)
>             goto error;
>     }

yes, it looks better.

> 
>>                 if (ret)
>>                         goto error;
>>         }
>> @@ -257,12 +273,11 @@ static int load_scale_clocks(struct venus_core *core)
>>
>>  set_freq:
>>
>> -       if (core->res->hfi_version == HFI_VERSION_3XX) {
>> -               ret = clk_set_rate(clk, freq);
>> +       ret = clk_set_rate(clk, freq);
>> +
>> +       if (IS_V3(core) || IS_V4(core)) {
>>                 ret |= clk_set_rate(core->core0_clk, freq);
>>                 ret |= clk_set_rate(core->core1_clk, freq);
>> -       } else {
>> -               ret = clk_set_rate(clk, freq);
>>         }
>>
>>         if (ret) {
>> diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h b/drivers/media/platform/qcom/venus/hfi_helper.h
>> index 55d8eb21403a..1bc5aab1ce6b 100644
>> --- a/drivers/media/platform/qcom/venus/hfi_helper.h
>> +++ b/drivers/media/platform/qcom/venus/hfi_helper.h
>> @@ -121,6 +121,7 @@
>>  #define HFI_EXTRADATA_METADATA_FILLER                  0x7fe00002
>>
>>  #define HFI_INDEX_EXTRADATA_INPUT_CROP                 0x0700000e
>> +#define HFI_INDEX_EXTRADATA_OUTPUT_CROP                        0x0700000f
>>  #define HFI_INDEX_EXTRADATA_DIGITAL_ZOOM               0x07000010
>>  #define HFI_INDEX_EXTRADATA_ASPECT_RATIO               0x7f100003
>>
>> @@ -376,13 +377,18 @@
>>  #define HFI_BUFFER_OUTPUT2                     0x3
>>  #define HFI_BUFFER_INTERNAL_PERSIST            0x4
>>  #define HFI_BUFFER_INTERNAL_PERSIST_1          0x5
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
>>  #define HFI_BUFFER_TYPE_MAX                    11
>>
>>  #define HFI_BUFFER_MODE_STATIC                 0x1000001
>> @@ -424,12 +430,14 @@
>>  #define HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED                        0x100e
>>  #define HFI_PROPERTY_PARAM_MVC_BUFFER_LAYOUT                   0x100f
>>  #define HFI_PROPERTY_PARAM_MAX_SESSIONS_SUPPORTED              0x1010
>> +#define HFI_PROPERTY_PARAM_WORK_MODE                           0x1015
>>
>>  /*
>>   * HFI_PROPERTY_CONFIG_COMMON_START
>>   * HFI_DOMAIN_BASE_COMMON + HFI_ARCH_COMMON_OFFSET + 0x2000
>>   */
>>  #define HFI_PROPERTY_CONFIG_FRAME_RATE                         0x2001
>> +#define HFI_PROPERTY_CONFIG_VIDEOCORES_USAGE                   0x2002
>>
>>  /*
>>   * HFI_PROPERTY_PARAM_VDEC_COMMON_START
>> @@ -438,6 +446,9 @@
>>  #define HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM                   0x1003001
>>  #define HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR                  0x1003002
>>  #define HFI_PROPERTY_PARAM_VDEC_NONCP_OUTPUT2                  0x1003003
>> +#define HFI_PROPERTY_PARAM_VDEC_PIXEL_BITDEPTH                 0x1003007
>> +#define HFI_PROPERTY_PARAM_VDEC_PIC_STRUCT                     0x1003009
>> +#define HFI_PROPERTY_PARAM_VDEC_COLOUR_SPACE                   0x100300a
>>
>>  /*
>>   * HFI_PROPERTY_CONFIG_VDEC_COMMON_START
>> @@ -518,6 +529,7 @@
>>  enum hfi_version {
>>         HFI_VERSION_1XX,
>>         HFI_VERSION_3XX,
>> +       HFI_VERSION_4XX
>>  };
>>
>>  struct hfi_buffer_info {
>> @@ -767,12 +779,56 @@ struct hfi_framesize {
>>         u32 height;
>>  };
>>
>> +#define VIDC_CORE_ID_DEFAULT   0
>> +#define VIDC_CORE_ID_1         1
>> +#define VIDC_CORE_ID_2         2
>> +#define VIDC_CORE_ID_3         3
>> +
>> +struct hfi_videocores_usage_type {
>> +       u32 video_core_enable_mask;
>> +};
>> +
>> +#define VIDC_WORK_MODE_1       1
>> +#define VIDC_WORK_MODE_2       2
>> +
>> +struct hfi_video_work_mode {
>> +       u32 video_work_mode;
>> +};
>> +
>>  struct hfi_h264_vui_timing_info {
>>         u32 enable;
>>         u32 fixed_framerate;
>>         u32 time_scale;
>>  };
>>
>> +struct hfi_bit_depth {
>> +       u32 buffer_type;
>> +       u32 bit_depth;
>> +};
>> +
>> +struct hfi_picture_type {
>> +       u32 is_sync_frame;
>> +       u32 picture_type;
>> +};
>> +
>> +struct hfi_pic_struct {
>> +       u32 progressive_only;
>> +};
>> +
>> +struct hfi_colour_space {
>> +       u32 colour_space;
>> +};
>> +
>> +struct hfi_extradata_input_crop {
>> +       u32 size;
>> +       u32 version;
>> +       u32 port_index;
>> +       u32 left;
>> +       u32 top;
>> +       u32 width;
>> +       u32 height;
>> +};
> 
> These structures are being used in the next patch - wouldn't it make
> more sense to move their declaration there as well?

Ok. I'll move in next patch.

-- 
regards,
Stan
