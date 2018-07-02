Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:53856 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933652AbeGBIpu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 04:45:50 -0400
Received: by mail-it0-f68.google.com with SMTP id a195-v6so11059251itd.3
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:45:49 -0700 (PDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id m14-v6sm6389026ioj.58.2018.07.02.01.45.47
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 01:45:47 -0700 (PDT)
Received: by mail-io0-f174.google.com with SMTP id q9-v6so3308080ioj.8
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org> <20180627152725.9783-3-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-3-stanimir.varbanov@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 2 Jul 2018 17:45:35 +0900
Message-ID: <CAPBb6MVST50MfDbs_GydCBDAA_fsVTYVVU9iCGiaCnMxPBRBPg@mail.gmail.com>
Subject: Re: [PATCH v4 02/27] venus: hfi: preparation to support venus 4xx
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 28, 2018 at 12:35 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> This covers the differences between 1xx,3xx and 4xx.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/core.h         |  4 ++
>  drivers/media/platform/qcom/venus/helpers.c      | 37 +++++++----
>  drivers/media/platform/qcom/venus/hfi_helper.h   | 84 ++++++++++++++++++++++--
>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  7 ++
>  drivers/media/platform/qcom/venus/vdec.c         |  5 +-
>  drivers/media/platform/qcom/venus/venc.c         |  5 +-
>  6 files changed, 120 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 0360d295f4c8..8d3e150800c9 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -305,6 +305,10 @@ struct venus_inst {
>         struct hfi_buffer_requirements bufreq[HFI_BUFFER_TYPE_MAX];
>  };
>
> +#define IS_V1(core)    ((core)->res->hfi_version == HFI_VERSION_1XX)
> +#define IS_V3(core)    ((core)->res->hfi_version == HFI_VERSION_3XX)
> +#define IS_V4(core)    ((core)->res->hfi_version == HFI_VERSION_4XX)
> +
>  #define ctrl_to_inst(ctrl)     \
>         container_of((ctrl)->handler, struct venus_inst, ctrl_handler)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 0ce9559a2924..d9065cc8a7d3 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -166,21 +166,37 @@ static int intbufs_unset_buffers(struct venus_inst *inst)
>         return ret;
>  }
>
> -static const unsigned int intbuf_types[] = {
> -       HFI_BUFFER_INTERNAL_SCRATCH,
> -       HFI_BUFFER_INTERNAL_SCRATCH_1,
> -       HFI_BUFFER_INTERNAL_SCRATCH_2,
> +static const unsigned int intbuf_types_1xx[] = {
> +       HFI_BUFFER_INTERNAL_SCRATCH(HFI_VERSION_1XX),
> +       HFI_BUFFER_INTERNAL_SCRATCH_1(HFI_VERSION_1XX),
> +       HFI_BUFFER_INTERNAL_SCRATCH_2(HFI_VERSION_1XX),
> +       HFI_BUFFER_INTERNAL_PERSIST,
> +       HFI_BUFFER_INTERNAL_PERSIST_1,
> +};
> +
> +static const unsigned int intbuf_types_4xx[] = {
> +       HFI_BUFFER_INTERNAL_SCRATCH(HFI_VERSION_4XX),
> +       HFI_BUFFER_INTERNAL_SCRATCH_1(HFI_VERSION_4XX),
> +       HFI_BUFFER_INTERNAL_SCRATCH_2(HFI_VERSION_4XX),
>         HFI_BUFFER_INTERNAL_PERSIST,
>         HFI_BUFFER_INTERNAL_PERSIST_1,
>  };
>
>  static int intbufs_alloc(struct venus_inst *inst)
>  {
> -       unsigned int i;
> +       size_t arr_sz;
> +       size_t i;
>         int ret;
>
> -       for (i = 0; i < ARRAY_SIZE(intbuf_types); i++) {
> -               ret = intbufs_set_buffer(inst, intbuf_types[i]);
> +       if (IS_V4(inst->core))
> +               arr_sz = ARRAY_SIZE(intbuf_types_4xx);
> +       else
> +               arr_sz = ARRAY_SIZE(intbuf_types_1xx);
> +
> +       for (i = 0; i < arr_sz; i++) {
> +               ret = intbufs_set_buffer(inst,
> +                           IS_V4(inst->core) ? intbuf_types_4xx[i] :
> +                                               intbuf_types_1xx[i]);

I suspect you could simplify this a bit by doing something like:

    const unsigned int *intbuf;

    if (IS_V4(inst->core)) {
        arr_sz = ARRAY_SIZE(intbuf_types_4xx);
        intbuf = intbuf_types_4xx;
    } else {
        arr_sz = ARRAY_SIZE(intbuf_types_1xx);
        intbuf = intbuf_types_1xx;
    }

    for (i = 0; i < arr_sz; i++) {
        ret = intbufs_set_buffer(inst, intbuf[i]);
        if (ret)
            goto error;
    }

>                 if (ret)
>                         goto error;
>         }
> @@ -257,12 +273,11 @@ static int load_scale_clocks(struct venus_core *core)
>
>  set_freq:
>
> -       if (core->res->hfi_version == HFI_VERSION_3XX) {
> -               ret = clk_set_rate(clk, freq);
> +       ret = clk_set_rate(clk, freq);
> +
> +       if (IS_V3(core) || IS_V4(core)) {
>                 ret |= clk_set_rate(core->core0_clk, freq);
>                 ret |= clk_set_rate(core->core1_clk, freq);
> -       } else {
> -               ret = clk_set_rate(clk, freq);
>         }
>
>         if (ret) {
> diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h b/drivers/media/platform/qcom/venus/hfi_helper.h
> index 55d8eb21403a..1bc5aab1ce6b 100644
> --- a/drivers/media/platform/qcom/venus/hfi_helper.h
> +++ b/drivers/media/platform/qcom/venus/hfi_helper.h
> @@ -121,6 +121,7 @@
>  #define HFI_EXTRADATA_METADATA_FILLER                  0x7fe00002
>
>  #define HFI_INDEX_EXTRADATA_INPUT_CROP                 0x0700000e
> +#define HFI_INDEX_EXTRADATA_OUTPUT_CROP                        0x0700000f
>  #define HFI_INDEX_EXTRADATA_DIGITAL_ZOOM               0x07000010
>  #define HFI_INDEX_EXTRADATA_ASPECT_RATIO               0x7f100003
>
> @@ -376,13 +377,18 @@
>  #define HFI_BUFFER_OUTPUT2                     0x3
>  #define HFI_BUFFER_INTERNAL_PERSIST            0x4
>  #define HFI_BUFFER_INTERNAL_PERSIST_1          0x5
> -#define HFI_BUFFER_INTERNAL_SCRATCH            0x1000001
> -#define HFI_BUFFER_EXTRADATA_INPUT             0x1000002
> -#define HFI_BUFFER_EXTRADATA_OUTPUT            0x1000003
> -#define HFI_BUFFER_EXTRADATA_OUTPUT2           0x1000004
> -#define HFI_BUFFER_INTERNAL_SCRATCH_1          0x1000005
> -#define HFI_BUFFER_INTERNAL_SCRATCH_2          0x1000006
> -
> +#define HFI_BUFFER_INTERNAL_SCRATCH(ver)       \
> +       (((ver) == HFI_VERSION_4XX) ? 0x6 : 0x1000001)
> +#define HFI_BUFFER_INTERNAL_SCRATCH_1(ver)     \
> +       (((ver) == HFI_VERSION_4XX) ? 0x7 : 0x1000005)
> +#define HFI_BUFFER_INTERNAL_SCRATCH_2(ver)     \
> +       (((ver) == HFI_VERSION_4XX) ? 0x8 : 0x1000006)
> +#define HFI_BUFFER_EXTRADATA_INPUT(ver)                \
> +       (((ver) == HFI_VERSION_4XX) ? 0xc : 0x1000002)
> +#define HFI_BUFFER_EXTRADATA_OUTPUT(ver)       \
> +       (((ver) == HFI_VERSION_4XX) ? 0xa : 0x1000003)
> +#define HFI_BUFFER_EXTRADATA_OUTPUT2(ver)      \
> +       (((ver) == HFI_VERSION_4XX) ? 0xb : 0x1000004)
>  #define HFI_BUFFER_TYPE_MAX                    11
>
>  #define HFI_BUFFER_MODE_STATIC                 0x1000001
> @@ -424,12 +430,14 @@
>  #define HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED                        0x100e
>  #define HFI_PROPERTY_PARAM_MVC_BUFFER_LAYOUT                   0x100f
>  #define HFI_PROPERTY_PARAM_MAX_SESSIONS_SUPPORTED              0x1010
> +#define HFI_PROPERTY_PARAM_WORK_MODE                           0x1015
>
>  /*
>   * HFI_PROPERTY_CONFIG_COMMON_START
>   * HFI_DOMAIN_BASE_COMMON + HFI_ARCH_COMMON_OFFSET + 0x2000
>   */
>  #define HFI_PROPERTY_CONFIG_FRAME_RATE                         0x2001
> +#define HFI_PROPERTY_CONFIG_VIDEOCORES_USAGE                   0x2002
>
>  /*
>   * HFI_PROPERTY_PARAM_VDEC_COMMON_START
> @@ -438,6 +446,9 @@
>  #define HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM                   0x1003001
>  #define HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR                  0x1003002
>  #define HFI_PROPERTY_PARAM_VDEC_NONCP_OUTPUT2                  0x1003003
> +#define HFI_PROPERTY_PARAM_VDEC_PIXEL_BITDEPTH                 0x1003007
> +#define HFI_PROPERTY_PARAM_VDEC_PIC_STRUCT                     0x1003009
> +#define HFI_PROPERTY_PARAM_VDEC_COLOUR_SPACE                   0x100300a
>
>  /*
>   * HFI_PROPERTY_CONFIG_VDEC_COMMON_START
> @@ -518,6 +529,7 @@
>  enum hfi_version {
>         HFI_VERSION_1XX,
>         HFI_VERSION_3XX,
> +       HFI_VERSION_4XX
>  };
>
>  struct hfi_buffer_info {
> @@ -767,12 +779,56 @@ struct hfi_framesize {
>         u32 height;
>  };
>
> +#define VIDC_CORE_ID_DEFAULT   0
> +#define VIDC_CORE_ID_1         1
> +#define VIDC_CORE_ID_2         2
> +#define VIDC_CORE_ID_3         3
> +
> +struct hfi_videocores_usage_type {
> +       u32 video_core_enable_mask;
> +};
> +
> +#define VIDC_WORK_MODE_1       1
> +#define VIDC_WORK_MODE_2       2
> +
> +struct hfi_video_work_mode {
> +       u32 video_work_mode;
> +};
> +
>  struct hfi_h264_vui_timing_info {
>         u32 enable;
>         u32 fixed_framerate;
>         u32 time_scale;
>  };
>
> +struct hfi_bit_depth {
> +       u32 buffer_type;
> +       u32 bit_depth;
> +};
> +
> +struct hfi_picture_type {
> +       u32 is_sync_frame;
> +       u32 picture_type;
> +};
> +
> +struct hfi_pic_struct {
> +       u32 progressive_only;
> +};
> +
> +struct hfi_colour_space {
> +       u32 colour_space;
> +};
> +
> +struct hfi_extradata_input_crop {
> +       u32 size;
> +       u32 version;
> +       u32 port_index;
> +       u32 left;
> +       u32 top;
> +       u32 width;
> +       u32 height;
> +};

These structures are being used in the next patch - wouldn't it make
more sense to move their declaration there as well?

> +
>  #define HFI_COLOR_FORMAT_MONOCHROME            0x01
>  #define HFI_COLOR_FORMAT_NV12                  0x02
>  #define HFI_COLOR_FORMAT_NV21                  0x03
> @@ -961,6 +1017,12 @@ struct hfi_buffer_count_actual {
>         u32 count_actual;
>  };
>
> +struct hfi_buffer_count_actual_4xx {
> +       u32 type;
> +       u32 count_actual;
> +       u32 count_min_host;
> +};
> +
>  struct hfi_buffer_size_actual {
>         u32 type;
>         u32 size;
> @@ -971,6 +1033,14 @@ struct hfi_buffer_display_hold_count_actual {
>         u32 hold_count;
>  };
>
> +/* HFI 4XX reorder the fields, use these macros */
> +#define HFI_BUFREQ_HOLD_COUNT(bufreq, ver)     \
> +       ((ver) == HFI_VERSION_4XX ? 0 : (bufreq)->hold_count)
> +#define HFI_BUFREQ_COUNT_MIN(bufreq, ver)      \
> +       ((ver) == HFI_VERSION_4XX ? (bufreq)->hold_count : (bufreq)->count_min)
> +#define HFI_BUFREQ_COUNT_MIN_HOST(bufreq, ver) \
> +       ((ver) == HFI_VERSION_4XX ? (bufreq)->count_min : 0)
> +
>  struct hfi_buffer_requirements {
>         u32 type;
>         u32 size;
> diff --git a/drivers/media/platform/qcom/venus/hfi_venus_io.h b/drivers/media/platform/qcom/venus/hfi_venus_io.h
> index 98cc350113ab..d327b5cea334 100644
> --- a/drivers/media/platform/qcom/venus/hfi_venus_io.h
> +++ b/drivers/media/platform/qcom/venus/hfi_venus_io.h
> @@ -110,4 +110,11 @@
>  #define WRAPPER_CPU_STATUS                     (WRAPPER_BASE + 0x2014)
>  #define WRAPPER_SW_RESET                       (WRAPPER_BASE + 0x3000)
>
> +/* Venus 4xx */
> +#define WRAPPER_VCODEC0_MMCC_POWER_STATUS      (WRAPPER_BASE + 0x90)
> +#define WRAPPER_VCODEC0_MMCC_POWER_CONTROL     (WRAPPER_BASE + 0x94)
> +
> +#define WRAPPER_VCODEC1_MMCC_POWER_STATUS      (WRAPPER_BASE + 0x110)
> +#define WRAPPER_VCODEC1_MMCC_POWER_CONTROL     (WRAPPER_BASE + 0x114)
> +
>  #endif
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 49bbd1861d3a..261a51adeef2 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -689,6 +689,7 @@ static int vdec_queue_setup(struct vb2_queue *q,
>
>  static int vdec_verify_conf(struct venus_inst *inst)
>  {
> +       enum hfi_version ver = inst->core->res->hfi_version;
>         struct hfi_buffer_requirements bufreq;
>         int ret;
>
> @@ -700,14 +701,14 @@ static int vdec_verify_conf(struct venus_inst *inst)
>                 return ret;
>
>         if (inst->num_output_bufs < bufreq.count_actual ||
> -           inst->num_output_bufs < bufreq.count_min)
> +           inst->num_output_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
>                 return -EINVAL;
>
>         ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
>         if (ret)
>                 return ret;
>
> -       if (inst->num_input_bufs < bufreq.count_min)
> +       if (inst->num_input_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
>                 return -EINVAL;
>
>         return 0;
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index 6b2ce479584e..947001170a77 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -892,6 +892,7 @@ static int venc_queue_setup(struct vb2_queue *q,
>
>  static int venc_verify_conf(struct venus_inst *inst)
>  {
> +       enum hfi_version ver = inst->core->res->hfi_version;
>         struct hfi_buffer_requirements bufreq;
>         int ret;
>
> @@ -903,7 +904,7 @@ static int venc_verify_conf(struct venus_inst *inst)
>                 return ret;
>
>         if (inst->num_output_bufs < bufreq.count_actual ||
> -           inst->num_output_bufs < bufreq.count_min)
> +           inst->num_output_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
>                 return -EINVAL;
>
>         ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
> @@ -911,7 +912,7 @@ static int venc_verify_conf(struct venus_inst *inst)
>                 return ret;
>
>         if (inst->num_input_bufs < bufreq.count_actual ||
> -           inst->num_input_bufs < bufreq.count_min)
> +           inst->num_input_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
>                 return -EINVAL;
>
>         return 0;
> --
> 2.14.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
