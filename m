Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:38860 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbeGBHFe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 03:05:34 -0400
Received: by mail-yb0-f193.google.com with SMTP id i9-v6so1122471ybo.5
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 00:05:34 -0700 (PDT)
Received: from mail-yb0-f180.google.com (mail-yb0-f180.google.com. [209.85.213.180])
        by smtp.gmail.com with ESMTPSA id o126-v6sm4306606ywf.102.2018.07.02.00.05.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 00:05:32 -0700 (PDT)
Received: by mail-yb0-f180.google.com with SMTP id i3-v6so4727732ybl.9
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 00:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com> <1522376100-22098-7-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1522376100-22098-7-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 2 Jul 2018 16:05:20 +0900
Message-ID: <CAAFQd5BdEvzEv63oXpC1PmPdut8kNmFzdL63nEVqhnLHets2ZA@mail.gmail.com>
Subject: Re: [PATCH v6 06/12] intel-ipu3: css: Add support for firmware management
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Hi Yong,

Continuing my review. Sorry for the delay.

On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
>
> Introduce functions to load and install ImgU FW blobs.
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-abi.h    | 1888 ++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-css-fw.c |  261 ++++
>  drivers/media/pci/intel/ipu3/ipu3-css-fw.h |  198 +++
>  3 files changed, 2347 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-abi.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.h
>
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-abi.h b/drivers/media/pci/intel/ipu3/ipu3-abi.h
> new file mode 100644
> index 000000000000..24102647a89e
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-abi.h
[snip]
> +/* SYSTEM_REQ_0_5_0_IMGHMMADR */
> +#define IMGU_REG_SYSTEM_REQ                    0x18
> +#define IMGU_SYSTEM_REQ_FREQ_MASK              0x3f
> +#define IMGU_SYSTEM_REQ_FREQ_DIVIDER           25
> +#define IMGU_REG_INT_STATUS                    0x30
> +#define IMGU_REG_INT_ENABLE                    0x34
> +#define IMGU_REG_INT_CSS_IRQ                   (1 << 31)

BIT(31)

[snip]
> +       IMGU_ABI_FRAME_FORMAT_CSI_MIPI_LEGACY_YUV420_8, /* Legacy YUV420.
> +                                                        * UY odd line;
> +                                                        * VY even line
> +                                                        */
> +       IMGU_ABI_FRAME_FORMAT_CSI_MIPI_YUV420_10,/* 10 bit per Y/U/V. Y odd
> +                                                 * line; UYVY interleaved
> +                                                 * even line
> +                                                 */
> +       IMGU_ABI_FRAME_FORMAT_YCgCo444_16, /* Internal format for ISP2.7,

Macros and enums should be uppercase.

[snip]
> +struct imgu_abi_shd_intra_frame_operations_data {
> +       struct imgu_abi_acc_operation
> +               operation_list[IMGU_ABI_SHD_MAX_OPERATIONS] IPU3_ALIGN;
> +       struct imgu_abi_acc_process_lines_cmd_data
> +               process_lines_data[IMGU_ABI_SHD_MAX_PROCESS_LINES] IPU3_ALIGN;
> +       struct imgu_abi_shd_transfer_luts_set_data
> +               transfer_data[IMGU_ABI_SHD_MAX_TRANSFERS] IPU3_ALIGN;
> +} __packed;
> +
> +struct imgu_abi_shd_config {
> +       struct ipu3_uapi_shd_config_static shd IMGU_ABI_PAD;
> +       struct imgu_abi_shd_intra_frame_operations_data shd_ops IMGU_ABI_PAD;
> +       struct ipu3_uapi_shd_lut shd_lut IMGU_ABI_PAD;

Definitions of both IPU3_ALIGN and IMGU_ABI_PAD seem to be equivalent.
Could we remove one and use the other everywhere?

[snip]
> +struct imgu_abi_osys_scaler_params {
> +       __u32 inp_buf_y_st_addr;
> +       __u32 inp_buf_y_line_stride;
> +       __u32 inp_buf_y_buffer_stride;
> +       __u32 inp_buf_u_st_addr;
> +       __u32 inp_buf_v_st_addr;
> +       __u32 inp_buf_uv_line_stride;
> +       __u32 inp_buf_uv_buffer_stride;
> +       __u32 inp_buf_chunk_width;
> +       __u32 inp_buf_nr_buffers;
> +       /* Output buffers */
> +       __u32 out_buf_y_st_addr;
> +       __u32 out_buf_y_line_stride;
> +       __u32 out_buf_y_buffer_stride;
> +       __u32 out_buf_u_st_addr;
> +       __u32 out_buf_v_st_addr;
> +       __u32 out_buf_uv_line_stride;
> +       __u32 out_buf_uv_buffer_stride;
> +       __u32 out_buf_nr_buffers;
> +       /* Intermediate buffers */
> +       __u32 int_buf_y_st_addr;
> +       __u32 int_buf_y_line_stride;
> +       __u32 int_buf_u_st_addr;
> +       __u32 int_buf_v_st_addr;
> +       __u32 int_buf_uv_line_stride;
> +       __u32 int_buf_height;
> +       __u32 int_buf_chunk_width;
> +       __u32 int_buf_chunk_height;
> +       /* Context buffers */
> +       __u32 ctx_buf_hor_y_st_addr;
> +       __u32 ctx_buf_hor_u_st_addr;
> +       __u32 ctx_buf_hor_v_st_addr;
> +       __u32 ctx_buf_ver_y_st_addr;
> +       __u32 ctx_buf_ver_u_st_addr;
> +       __u32 ctx_buf_ver_v_st_addr;
> +       /* Addresses for release-input and process-output tokens */
> +       __u32 release_inp_buf_addr;
> +       __u32 release_inp_buf_en;
> +       __u32 release_out_buf_en;
> +       __u32 process_out_buf_addr;
> +       /* Settings dimensions, padding, cropping */
> +       __u32 input_image_y_width;
> +       __u32 input_image_y_height;
> +       __u32 input_image_y_start_column;
> +       __u32 input_image_uv_start_column;
> +       __u32 input_image_y_left_pad;
> +       __u32 input_image_uv_left_pad;
> +       __u32 input_image_y_right_pad;
> +       __u32 input_image_uv_right_pad;
> +       __u32 input_image_y_top_pad;
> +       __u32 input_image_uv_top_pad;
> +       __u32 input_image_y_bottom_pad;
> +       __u32 input_image_uv_bottom_pad;
> +       __u32 processing_mode;
> +#define IMGU_ABI_OSYS_PROCMODE_BYPASS          0
> +#define IMGU_ABI_OSYS_PROCMODE_UPSCALE         1
> +#define IMGU_ABI_OSYS_PROCMODE_DOWNSCALE       2

Could we move it to a separate enum, to be consistent with other
structs? (e.g. imgu_abi_osys_frame_params::format)

> +       __u32 scaling_ratio;
> +       __u32 y_left_phase_init;
> +       __u32 uv_left_phase_init;
> +       __u32 y_top_phase_init;
> +       __u32 uv_top_phase_init;
> +       __u32 coeffs_exp_shift;
> +       __u32 out_y_left_crop;
> +       __u32 out_uv_left_crop;
> +       __u32 out_y_top_crop;
> +       __u32 out_uv_top_crop;
> +} __packed;
> +
> +struct imgu_abi_osys_scaler {
> +       struct imgu_abi_osys_scaler_params param IPU3_ALIGN;
> +} __packed;
> +
> +struct imgu_abi_osys_frame_params {
> +       /* Output pins */
> +       __u32 enable;
> +       __u32 format;           /* enum imgu_abi_osys_format */
> +       __u32 flip;
> +       __u32 mirror;
> +       __u32 tiling;           /* enum imgu_abi_osys_tiling */
> +       __u32 width;
> +       __u32 height;
> +       __u32 stride;
> +       __u32 scaled;
> +} __packed;
[snip]
> +/* Defect pixel correction */
> +
> +struct imgu_abi_dpc_config {
> +       __u8 __reserved[240832];
> +} __packed;

Do we need this structure? One could just add a reserved field in the
parent structure. Also, just to confirm, is 240832 really the right
value here? Where does it come from? Please create a macro for it,
possibly further breaking it down into the values used to compute this
number.

[snip]
> +struct imgu_abi_acc_param {
> +       struct imgu_abi_stripe_data stripe;
> +       __u8 padding[8];
> +       struct imgu_abi_input_feeder_config input_feeder;
> +       struct ipu3_uapi_bnr_static_config bnr;
> +       struct ipu3_uapi_bnr_static_config_green_disparity green_disparity
> +               IPU3_ALIGN;
> +       struct ipu3_uapi_dm_config dm IPU3_ALIGN;
> +       struct ipu3_uapi_ccm_mat_config ccm IPU3_ALIGN;
> +       struct ipu3_uapi_gamma_config gamma IPU3_ALIGN;
> +       struct ipu3_uapi_csc_mat_config csc IPU3_ALIGN;
> +       struct ipu3_uapi_cds_params cds IPU3_ALIGN;
> +       struct imgu_abi_shd_config shd IPU3_ALIGN;
> +       struct imgu_abi_dvs_stat_config dvs_stat;
> +       __u8 padding1[224];     /* reserved for lace_stat */
> +       struct ipu3_uapi_yuvp1_iefd_config iefd IPU3_ALIGN;
> +       struct ipu3_uapi_yuvp1_yds_config yds_c0 IPU3_ALIGN;
> +       struct ipu3_uapi_yuvp1_chnr_config chnr_c0 IPU3_ALIGN;
> +       struct ipu3_uapi_yuvp1_y_ee_nr_config y_ee_nr IPU3_ALIGN;
> +       struct ipu3_uapi_yuvp1_yds_config yds IPU3_ALIGN;
> +       struct ipu3_uapi_yuvp1_chnr_config chnr IPU3_ALIGN;
> +       struct ipu3_uapi_yuvp2_y_tm_lut_static_config ytm IPU3_ALIGN;
> +       struct ipu3_uapi_yuvp1_yds_config yds2 IPU3_ALIGN;
> +       struct ipu3_uapi_yuvp2_tcc_static_config tcc IPU3_ALIGN;
> +       struct imgu_abi_dpc_config dpc IPU3_ALIGN;
> +       struct imgu_abi_bds_config bds;
> +       struct ipu3_uapi_anr_config anr;
> +       struct imgu_abi_awb_fr_config awb_fr;
> +       struct imgu_abi_ae_config ae;
> +       struct imgu_abi_af_config af;
> +       struct imgu_abi_awb_config awb;
> +       struct imgu_abi_osys_config osys;

Why some fields here need and some don't need the IPU3_ALIGN specifier?

[snip]
> +/*
> + * Frame info struct. This describes the contents of an image frame buffer.
> + */
> +struct imgu_abi_frame_sp_info {
> +       struct imgu_abi_sp_resolution res;
> +       u16 padded_width;               /* stride of line in memory
> +                                        * (in pixels)
> +                                        */
> +       u8 format;                      /* format of the frame data */
> +       u8 raw_bit_depth;               /* number of valid bits per pixel,
> +                                        * only valid for RAW bayer frames
> +                                        */
> +       u8 raw_bayer_order;             /* bayer order, only valid
> +                                        * for RAW bayer frames
> +                                        */
> +       u8 raw_type;            /* To choose the proper raw frame type. for
> +                                * Legacy SKC pipes/Default is set to
> +                                * IMGU_ABI_RAW_TYPE_BAYER. For RGB IR sensor -
> +                                * driver should set it to:
> +                                * IronGr case - IMGU_ABI_RAW_TYPE_IR_ON_GR
> +                                * IronGb case - IMGU_ABI_RAW_TYPE_IR_ON_GB
> +                                */
> +#define IMGU_ABI_RAW_TYPE_BAYER                0
> +#define IMGU_ABI_RAW_TYPE_IR_ON_GR     1
> +#define IMGU_ABI_RAW_TYPE_IR_ON_GB     2

Can we have a separate enum for this, consistently with other structs
defined earlier?

[snip]
> +/* Information for a single pipeline stage */
> +struct imgu_abi_sp_stage {
> +       /* Multiple boolean flags can be stored in an integer */
> +       u8 num;                         /* Stage number */
> +       u8 isp_online;
> +       u8 isp_copy_vf;
> +       u8 isp_copy_output;
> +       u8 sp_enable_xnr;
> +       u8 isp_deci_log_factor;
> +       u8 isp_vf_downscale_bits;
> +       u8 deinterleaved;
> +       /*
> +        * NOTE: Programming the input circuit can only be done at the
> +        * start of a session. It is illegal to program it during execution
> +        * The input circuit defines the connectivity
> +        */
> +       u8 program_input_circuit;
> +       u8 func;
> +#define IMGU_ABI_STAGE_FUNC_RAW_COPY   0
> +#define IMGU_ABI_STAGE_FUNC_BIN_COPY   1
> +#define IMGU_ABI_STAGE_FUNC_ISYS_COPY  2
> +#define IMGU_ABI_STAGE_FUNC_NO_FUNC    3

Enum please.

> +       u8 stage_type;                  /* The type of the pipe-stage */
> +#define IMGU_ABI_STAGE_TYPE_SP         0
> +#define IMGU_ABI_STAGE_TYPE_ISP                1

Enum please.

[snip]
> +/*
> + * Blob descriptor.
> + * This structure describes an SP or ISP blob.
> + * It describes the test, data and bss sections as well as position in a
> + * firmware file.
> + * For convenience, it contains dynamic data after loading.
> + */
> +struct imgu_abi_blob_info {
> +       /* Static blob data */
> +       u32 offset;                     /* Blob offset in fw file */
> +       struct imgu_abi_isp_param_memory_offsets memory_offsets;
> +                                       /* offset wrt hdr in bytes */
> +       u32 prog_name_offset;           /* offset wrt hdr in bytes */
> +       u32 size;                       /* Size of blob */
> +       u32 padding_size;               /* total cummulative of bytes added
> +                                        * due to section alignment
> +                                        */
> +       u32 icache_source;              /* Position of icache in blob */
> +       u32 icache_size;                /* Size of icache section */
> +       u32 icache_padding;     /* added due to icache section alignment */
> +       u32 text_source;                /* Position of text in blob */
> +       u32 text_size;                  /* Size of text section */
> +       u32 text_padding;       /* bytes added due to text section alignment */
> +       u32 data_source;                /* Position of data in blob */
> +       u32 data_target;                /* Start of data in SP dmem */
> +       u32 data_size;                  /* Size of text section */
> +       u32 data_padding;       /* bytes added due to data section alignment */
> +       u32 bss_target;         /* Start position of bss in SP dmem */
> +       u32 bss_size;                   /* Size of bss section
> +                                        * Dynamic data filled by loader
> +                                        */
> +       const void *code __aligned(8);  /* Code section absolute pointer */
> +                                       /* within fw, code = icache + text */
> +       const void *data __aligned(8);  /* Data section absolute pointer */
> +                                       /* within fw, data = data + bss */

How are these pointers used? I couldn't find any code referencing
them. Are you sure these are kernel pointers (e.g. not just some
offsets)?

[snip]
> +struct imgu_abi_binary_input_info {
> +       u32 min_width;
> +       u32 min_height;
> +       u32 max_width;
> +       u32 max_height;
> +       u32 source;                     /* memory, sensor, variable */
> +#define IMGU_ABI_BINARY_INPUT_SOURCE_SENSOR    0
> +#define IMGU_ABI_BINARY_INPUT_SOURCE_MEMORY    1
> +#define IMGU_ABI_BINARY_INPUT_SOURCE_VARIABLE  2

Enum please.

[snip]
> +/* Information for a pipeline */
> +struct imgu_abi_sp_pipeline {
> +       u32 pipe_id;                    /* the pipe ID */
> +       u32 pipe_num;                   /* the dynamic pipe number */
> +       u32 thread_id;                  /* the sp thread ID */
> +       u32 pipe_config;                /* the pipe config */
> +#define IMGU_ABI_PIPE_CONFIG_ACQUIRE_ISP       (1 << 31)
> +       u32 pipe_qos_config;            /* Bitmap of multiple QOS extension fw
> +                                        * state, 0xffffffff indicates non
> +                                        * QOS pipe.
> +                                        */
> +       u32 inout_port_config;
> +#define IMGU_ABI_PORT_CONFIG_TYPE_INPUT_HOST           (1 << 0)
> +#define IMGU_ABI_PORT_CONFIG_TYPE_INPUT_COPYSINK       (1 << 1)
> +#define IMGU_ABI_PORT_CONFIG_TYPE_INPUT_TAGGERSINK     (1 << 2)
> +#define IMGU_ABI_PORT_CONFIG_TYPE_OUTPUT_HOST          (1 << 4)
> +#define IMGU_ABI_PORT_CONFIG_TYPE_OUTPUT_COPYSINK      (1 << 5)
> +#define IMGU_ABI_PORT_CONFIG_TYPE_OUTPUT_TAGGERSINK    (1 << 6)
> +       u32 required_bds_factor;
> +       u32 dvs_frame_delay;
> +       u32 num_stages;         /* the pipe config */
> +       u32 running;                    /* needed for pipe termination */
> +       imgu_addr_t sp_stage_addr[IMGU_ABI_MAX_STAGES];
> +       imgu_addr_t scaler_pp_lut;      /* Early bound LUT */
> +       u32 stage;                      /* stage ptr is only used on sp */
> +       s32 num_execs;                  /* number of times to run if this is
> +                                        * an acceleration pipe.
> +                                        */
> +       union {
> +               struct {
> +                       u32 bytes_available;
> +

The message is cut off here for me. Please split this patch for next
respin. Possibly 1 patch for registers and enums at the top, then 1
patch for structs and 1 more patch for the code being added in this
patch.

Best regards,
Tomasz
