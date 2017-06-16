Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:34276 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbdFPKP7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 06:15:59 -0400
Received: by mail-yw0-f173.google.com with SMTP id e142so16773930ywa.1
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 03:15:59 -0700 (PDT)
Received: from mail-yw0-f169.google.com (mail-yw0-f169.google.com. [209.85.161.169])
        by smtp.gmail.com with ESMTPSA id a203sm734118ywc.39.2017.06.16.03.15.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Jun 2017 03:15:57 -0700 (PDT)
Received: by mail-yw0-f169.google.com with SMTP id 63so16761642ywr.0
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 03:15:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1496695157-19926-8-git-send-email-yong.zhi@intel.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com> <1496695157-19926-8-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 16 Jun 2017 19:15:35 +0900
Message-ID: <CAAFQd5AoNDZMNGPiEHykCCugjHeQJLFiHnXNWyQFN9Pt6+BitQ@mail.gmail.com>
Subject: Re: [PATCH 07/12] intel-ipu3: css: firmware management
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Please see my comments inline.

On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> Functions to load and install imgu FW blobs
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-abi.h    | 1572 ++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-css-fw.c |  272 +++++
>  drivers/media/pci/intel/ipu3/ipu3-css-fw.h |  215 ++++
>  drivers/media/pci/intel/ipu3/ipu3-css.h    |   54 +
>  4 files changed, 2113 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-abi.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.h
[snip]
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-fw.c b/drivers/media/pci/intel/ipu3/ipu3-css-fw.c
> new file mode 100644
> index 0000000..55edbb8
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-css-fw.c
> @@ -0,0 +1,272 @@
> +/*
> + * Copyright (c) 2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <asm/cacheflush.h>

Shouldn't need this.

> +#include <linux/device.h>
> +#include <linux/firmware.h>
> +#include <linux/slab.h>
> +
> +#include "ipu3-css.h"
> +#include "ipu3-css-fw.h"
> +
> +static void ipu3_css_fw_show_binary(struct device *dev,
> +                       struct imgu_fw_info *bi, const char *name)
> +{
> +       int i;
> +
> +       dev_dbg(dev, "found firmware binary type %i size %i name %s\n",
> +               bi->type, bi->blob.size, name);
> +       if (bi->type != IMGU_FW_ISP_FIRMWARE)
> +               return;
> +
> +       dev_dbg(dev, "    id %i mode %i bds 0x%x veceven %i/%i out_pins %i\n",
> +               bi->info.isp.sp.id, bi->info.isp.sp.pipeline.mode,
> +               bi->info.isp.sp.bds.supported_bds_factors,
> +               bi->info.isp.sp.enable.vf_veceven,
> +               bi->info.isp.sp.vf_dec.is_variable,
> +               bi->info.isp.num_output_pins);
> +
> +       dev_dbg(dev, "    input (%i,%i)-(%i,%i) formats %s%s%s\n",
> +               bi->info.isp.sp.input.min_width,
> +               bi->info.isp.sp.input.min_height,
> +               bi->info.isp.sp.input.max_width,
> +               bi->info.isp.sp.input.max_height,
> +               bi->info.isp.sp.enable.input_yuv ? "yuv420 " : "",
> +               bi->info.isp.sp.enable.input_feeder ||
> +               bi->info.isp.sp.enable.input_raw ? "raw8 raw10 " : "",
> +               bi->info.isp.sp.enable.input_raw ? "raw12" : "");
> +
> +       dev_dbg(dev, "    internal (%i,%i)\n",
> +               bi->info.isp.sp.internal.max_width,
> +               bi->info.isp.sp.internal.max_height);
> +
> +       dev_dbg(dev, "    output (%i,%i)-(%i,%i) formats",
> +               bi->info.isp.sp.output.min_width,
> +               bi->info.isp.sp.output.min_height,
> +               bi->info.isp.sp.output.max_width,
> +               bi->info.isp.sp.output.max_height);
> +       for (i = 0; i < bi->info.isp.num_output_formats; i++)
> +               dev_dbg(dev, " %i", bi->info.isp.output_formats[i]);
> +       dev_dbg(dev, " vf");
> +       for (i = 0; i < bi->info.isp.num_vf_formats; i++)
> +               dev_dbg(dev, " %i", bi->info.isp.vf_formats[i]);

When the function is called, neither num_output_formats nor
num_vf_formats is validated. It will cause an out of bound read here
if it isn't correct.

> +       dev_dbg(dev, "\n");
> +}
> +
> +const int ipu3_css_fw_obgrid_size(const struct imgu_fw_info *bi)
> +{
> +       unsigned int stripes = bi->info.isp.sp.iterator.num_stripes;
> +       unsigned int width, height, obgrid_size;
> +
> +       width = ALIGN(DIV_ROUND_UP(bi->info.isp.sp.internal.max_width,
> +               IMGU_OBGRID_TILE_SIZE * 2) + 1, IPU3_UAPI_ISP_VEC_ELEMS / 4);
> +       height = DIV_ROUND_UP(bi->info.isp.sp.internal.max_height,
> +               IMGU_OBGRID_TILE_SIZE * 2) + 1;
> +       obgrid_size = PAGE_ALIGN(width * height *
> +               sizeof(struct ipu3_uapi_obgrid_param)) * stripes;
> +
> +       return obgrid_size;
> +}
> +
> +void *ipu3_css_fw_pipeline_params(struct ipu3_css *css,
> +               enum imgu_abi_param_class c, enum imgu_abi_memories m,
> +               struct imgu_fw_isp_parameter *par, size_t par_size,
> +               void *binary_params)
> +{
> +       struct imgu_fw_info *bi = &css->fwp->binary_header[css->current_binary];
> +
> +       if (par->offset + par->size >
> +           bi->info.isp.sp.mem_initializers.params[c][m].size)
> +               return NULL;
> +
> +       if (par->size != par_size)
> +               pr_warn("parameter size doesn't match defined size\n");
> +
> +       if (par->size < par_size)
> +               return NULL;
> +
> +       return binary_params + par->offset;
> +}
> +
> +void ipu3_css_fw_cleanup(struct ipu3_css *css)
> +{
> +       if (css->binary) {
> +               int i;
> +
> +               for (i = 0; i < css->fwp->file_header.binary_nr; i++)
> +                       ipu3_css_dma_free(css->dev, &css->binary[i]);
> +               kfree(css->binary);
> +       }
> +       if (css->fw)
> +               release_firmware(css->fw);
> +
> +       css->binary = NULL;
> +       css->fw = NULL;
> +}
> +
> +int ipu3_css_fw_init(struct ipu3_css *css)
> +{
> +       static const u32 BLOCK_MAX = 65536;
> +       struct device *dev = css->dev;
> +       int binary_nr = 0;
> +       int i, j, r;
> +
> +       r = request_firmware(&css->fw, IMGU_FW_NAME, css->dev);
> +       if (r)
> +               return r;
> +
> +       /* Check and display fw header info */
> +
> +       css->fwp = (struct imgu_fw_header *)css->fw->data;
> +       if (css->fw->size < sizeof(struct imgu_fw_header *) ||
> +           css->fwp->file_header.h_size != sizeof(struct imgu_fw_bi_file_h))
> +               goto bad_fw;
> +       if (sizeof(struct imgu_fw_bi_file_h) +
> +           css->fwp->file_header.binary_nr * sizeof(struct imgu_fw_info) >
> +           css->fw->size)
> +               goto bad_fw;
> +
> +       dev_info(dev, "loaded firmware version %.64s, %u binaries, %u bytes\n",
> +                css->fwp->file_header.version, css->fwp->file_header.binary_nr,
> +                (int)css->fw->size);

nit: This cast is not needed. All you need is correct print format,
which is "%zu" in this case.

> +
> +       /* Validate and display info on fw binaries */
> +
> +       binary_nr = css->fwp->file_header.binary_nr;
> +
> +       css->fw_bl = css->fw_sp[0] = css->fw_sp[1] = -1;
> +       for (i = 0; i < binary_nr; i++) {
> +               struct imgu_fw_info *bi = &css->fwp->binary_header[i];
> +               const char *name = (void *)css->fwp + bi->blob.prog_name_offset;
> +               size_t len;
> +
> +               if (bi->blob.prog_name_offset >= css->fw->size)
> +                       goto bad_fw;
> +               len = strnlen(name, css->fw->size - bi->blob.prog_name_offset);
> +               if (len + 1 >= css->fw->size - bi->blob.prog_name_offset ||

Isn't this an off by one error? (css->fw->size -
bi->blob.prog_name_offset) would be size of the space from start of
the string to the end of the firmware. So I think we only need to
ensure that the string including zero (len + 1 bytes) fits there,
which would be also true when (len + 1 == css->fw->size -
bi->blob.prog_name_offset). Unless I'm missing something, the test
should be >, not >=.

> +                   len + 1 >= IMGU_ABI_MAX_BINARY_NAME)

I guess this one depends on what is the meaning of
IMGU_ABI_MAX_BINARY_NAME. If it doesn't include the terminating zero,
then this test is okay.

> +                       goto bad_fw;
> +
> +               ipu3_css_fw_show_binary(dev, bi, name);
> +
> +               if (bi->blob.size != bi->blob.text_size + bi->blob.icache_size
> +                   + bi->blob.data_size + bi->blob.padding_size)
> +                       goto bad_fw;
> +               if (bi->blob.offset + bi->blob.size > css->fw->size)
> +                       goto bad_fw;
> +
> +               if (bi->type == IMGU_FW_BOOTLOADER_FIRMWARE) {
> +                       css->fw_bl = i;
> +                       if (bi->info.bl.sw_state >= css->iomem_length ||
> +                           bi->info.bl.num_dma_cmds >= css->iomem_length
> +                           || bi->info.bl.dma_cmd_list >=
> +                           css->iomem_length)
> +                               goto bad_fw;
> +               }
> +               if (bi->type == IMGU_FW_SP_FIRMWARE ||
> +                   bi->type == IMGU_FW_SP1_FIRMWARE) {
> +                       css->fw_sp[bi->type == IMGU_FW_SP_FIRMWARE ? 0 : 1] = i;
> +                       if (bi->info.sp.per_frame_data >= css->iomem_length
> +                           || bi->info.sp.init_dmem_data >=
> +                           css->iomem_length
> +                           || bi->info.sp.host_sp_queue >=
> +                           css->iomem_length
> +                           || bi->info.sp.isp_started >= css->iomem_length
> +                           || bi->info.sp.sw_state >= css->iomem_length
> +                           || bi->info.sp.host_sp_queues_initialized >=
> +                           css->iomem_length
> +                           || bi->info.sp.sleep_mode >= css->iomem_length
> +                           || bi->info.sp.invalidate_tlb >=
> +                           css->iomem_length
> +                           || bi->info.sp.host_sp_com >= css->iomem_length
> +                           || bi->info.sp.output + 12 >=
> +                           css->iomem_length)
> +                               goto bad_fw;
> +               }
> +               if (bi->type != IMGU_FW_ISP_FIRMWARE)
> +                       continue;
> +
> +               if (bi->info.isp.sp.pipeline.mode >= IPU3_CSS_PIPE_ID_NUM)
> +                       goto bad_fw;
> +
> +               if (bi->info.isp.sp.iterator.num_stripes >
> +                   IPU3_UAPI_MAX_STRIPES)
> +                       goto bad_fw;
> +
> +               if (bi->info.isp.num_output_formats > IMGU_ABI_FRAME_FORMAT_NUM
> +                   || bi->info.isp.num_vf_formats > IMGU_ABI_FRAME_FORMAT_NUM)
> +                       goto bad_fw;
> +
> +               for (j = 0; j < bi->info.isp.num_output_formats; j++)
> +                       if (bi->info.isp.output_formats[j] < 0 ||
> +                           bi->info.isp.output_formats[j] >=
> +                           IMGU_ABI_FRAME_FORMAT_NUM)
> +                               goto bad_fw;
> +               for (j = 0; j < bi->info.isp.num_vf_formats; j++)
> +                       if (bi->info.isp.vf_formats[j] < 0 ||
> +                           bi->info.isp.vf_formats[j] >=
> +                           IMGU_ABI_FRAME_FORMAT_NUM)
> +                               goto bad_fw;

I think this is the first safe place where we can actually call
ipu3_css_fw_show_binary(). But for simplicity, I would just call it at
the end of the loop iteration after all the validations are done.

> +
> +               if (bi->info.isp.sp.block.block_width <= 0 ||
> +                   bi->info.isp.sp.block.block_width > BLOCK_MAX ||
> +                   bi->info.isp.sp.block.output_block_height <= 0 ||
> +                   bi->info.isp.sp.block.output_block_height > BLOCK_MAX)
> +                       goto bad_fw;
> +
> +               if (bi->blob.memory_offsets.offsets[IMGU_ABI_PARAM_CLASS_PARAM]
> +                   + sizeof(struct imgu_fw_param_memory_offsets)
> +                   > css->fw->size ||
> +                   bi->blob.memory_offsets.offsets[IMGU_ABI_PARAM_CLASS_CONFIG]
> +                   + sizeof(struct imgu_fw_config_memory_offsets)
> +                   > css->fw->size ||
> +                   bi->blob.memory_offsets.offsets[IMGU_ABI_PARAM_CLASS_STATE]
> +                   + sizeof(struct imgu_fw_state_memory_offsets)
> +                   > css->fw->size)
> +                       goto bad_fw;
> +       }
> +
> +       if (css->fw_bl == -1 || css->fw_sp[0] == -1 || css->fw_sp[1] == -1)
> +               goto bad_fw;
> +
> +       /* Allocate and map fw binaries into IMGU */
> +
> +       css->binary = kcalloc(binary_nr, sizeof(*css->binary), GFP_KERNEL);
> +       if (!css->binary) {
> +               r = -ENOMEM;
> +               goto error_out;
> +       }
> +
> +       for (i = 0; i < css->fwp->file_header.binary_nr; i++) {
> +               struct imgu_fw_info *bi = &css->fwp->binary_header[i];
> +               void *blob = (void *)css->fwp + bi->blob.offset;
> +               size_t size = bi->blob.size;
> +
> +               if (ipu3_css_dma_alloc(dev, &css->binary[i], size)) {
> +                       r = -ENOMEM;
> +                       goto error_out;
> +               }
> +               memcpy(css->binary[i].vaddr, blob, size);
> +               clflush_cache_range(css->binary[i].vaddr, size);

This cache flush should not be necessary, given that the memory
allocated by ipu3_css_dma_alloc() is coherent.

> +       }
> +
> +       return 0;
> +
> +bad_fw:
> +       dev_err(dev, "invalid firmware binary, size %u\n", (int)css->fw->size);
> +       r = -ENODEV;
> +
> +error_out:
> +       ipu3_css_fw_cleanup(css);
> +       return r;
> +}
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-fw.h b/drivers/media/pci/intel/ipu3/ipu3-css-fw.h
> new file mode 100644
> index 0000000..5a247e3
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-css-fw.h
> @@ -0,0 +1,215 @@
> +/*
> + * Copyright (c) 2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __IPU3_CSS_FW_H
> +#define __IPU3_CSS_FW_H
> +
> +/******************* Firmware file definitions *******************/
> +
> +#define IMGU_FW_NAME                   "ipu3-fw.bin"
> +
> +typedef u32 imgu_fw_ptr;
> +
> +enum imgu_fw_type {
> +       IMGU_FW_SP_FIRMWARE,    /* Firmware for the SP */
> +       IMGU_FW_SP1_FIRMWARE,   /* Firmware for the SP1 */
> +       IMGU_FW_ISP_FIRMWARE,   /* Firmware for the ISP */
> +       IMGU_FW_BOOTLOADER_FIRMWARE,    /* Firmware for the BootLoader */
> +       IMGU_FW_ACC_FIRMWARE    /* Firmware for accelerations */
> +};
> +
> +enum imgu_fw_acc_type {
> +       IMGU_FW_ACC_NONE,       /* Normal binary */
> +       IMGU_FW_ACC_OUTPUT,     /* Accelerator stage on output frame */
> +       IMGU_FW_ACC_VIEWFINDER, /* Accelerator stage on viewfinder frame */
> +       IMGU_FW_ACC_STANDALONE, /* Stand-alone acceleration */
> +};
> +
> +struct imgu_fw_isp_parameter {
> +       u32 offset;             /* Offset in isp_<mem>)parameters, etc. */

I suspect a typo in the comment above: "isp_<mem>)".

> +       u32 size;               /* Disabled if 0 */
> +};
> +
> +struct imgu_fw_param_memory_offsets {
> +       struct {
> +               struct imgu_fw_isp_parameter lin;       /* lin_vmem_params */
> +               struct imgu_fw_isp_parameter tnr3;      /* tnr3_vmem_params */
> +               struct imgu_fw_isp_parameter xnr3;      /* xnr3_vmem_params */
> +       } vmem;
> +       struct {
> +               struct imgu_fw_isp_parameter tnr;
> +               struct imgu_fw_isp_parameter tnr3;      /* tnr3_params */
> +               struct imgu_fw_isp_parameter xnr3;      /* xnr3_params */
> +               struct imgu_fw_isp_parameter plane_io_config;   /* 192 bytes */
> +               struct imgu_fw_isp_parameter rgbir;     /* rgbir_params */
> +       } dmem;
> +};
> +
> +struct imgu_fw_config_memory_offsets {
> +       struct {
> +               struct imgu_fw_isp_parameter iterator;
> +               struct imgu_fw_isp_parameter dvs;
> +               struct imgu_fw_isp_parameter output;
> +               struct imgu_fw_isp_parameter raw;
> +               struct imgu_fw_isp_parameter input_yuv;
> +               struct imgu_fw_isp_parameter tnr;
> +               struct imgu_fw_isp_parameter tnr3;
> +               struct imgu_fw_isp_parameter ref;
> +       } dmem;
> +};
> +
> +struct imgu_fw_state_memory_offsets {
> +       struct {
> +               struct imgu_fw_isp_parameter tnr;
> +               struct imgu_fw_isp_parameter tnr3;
> +               struct imgu_fw_isp_parameter ref;
> +       } dmem;
> +};
> +
> +union imgu_fw_all_memory_offsets {
> +       struct {
> +               struct imgu_fw_param_memory_offsets *param __aligned(8);
> +               struct imgu_fw_config_memory_offsets *config __aligned(8);
> +               struct imgu_fw_state_memory_offsets *state __aligned(8);

Pointers in a firmware blob? First of all, not only pointer is of
variable size, depending on whether the code is compiled in 32-bit or
64-bit mode, but also why is it even possible to have kernel pointers
as a part of a firmware blob coming from userspace?

> +       } offsets;
> +       struct {
> +               void *ptr __aligned(8);

Pointer in a firmware blob?

> +       } array[IMGU_ABI_PARAM_CLASS_NUM];
> +};
> +
> +struct imgu_fw_binary_xinfo {
> +       /* Part that is of interest to the SP. */
> +       struct imgu_abi_binary_info sp;
> +
> +       /* Rest of the binary info, only interesting to the host. */
> +       enum imgu_fw_acc_type type;
> +
> +       u32 num_output_formats __aligned(8);
> +       enum imgu_abi_frame_format output_formats[IMGU_ABI_FRAME_FORMAT_NUM];
> +
> +       /* number of supported vf formats */
> +       u32 num_vf_formats __aligned(8);
> +       /* types of supported vf formats */
> +       enum imgu_abi_frame_format vf_formats[IMGU_ABI_FRAME_FORMAT_NUM];
> +       u8 num_output_pins;
> +       imgu_fw_ptr xmem_addr;
> +
> +       const struct imgu_fw_blob_descr *blob __aligned(8);

Pointer in a firmware blob?

> +       u32 blob_index __aligned(8);
> +       union imgu_fw_all_memory_offsets mem_offsets __aligned(8);
> +       struct imgu_fw_binary_xinfo *next __aligned(8);

Pointer in a firmware blob?

> +};
> +
> +struct imgu_fw_sp_info {
> +       u32 init_dmem_data;     /* data sect config, stored to dmem */
> +       u32 per_frame_data;     /* Per frame data, stored to dmem */
> +       u32 group;              /* Per pipeline data, loaded by dma */
> +       u32 output;             /* SP output data, loaded by dmem */
> +       u32 host_sp_queue;      /* Host <-> SP queues */
> +       u32 host_sp_com;        /* Host <-> SP commands */
> +       u32 isp_started;        /* P'ed from sensor thread, csim only */
> +       u32 sw_state;           /* Polled from css */
> +#define IMGU_ABI_SP_SWSTATE_TERMINATED 0
> +#define IMGU_ABI_SP_SWSTATE_INITIALIZED        1
> +#define IMGU_ABI_SP_SWSTATE_CONNECTED  2
> +#define IMGU_ABI_SP_SWSTATE_RUNNING    3
> +       u32 host_sp_queues_initialized; /* Polled from the SP */
> +       u32 sleep_mode;         /* different mode to halt SP */
> +       u32 invalidate_tlb;     /* inform SP to invalidate mmu TLB */
> +       u32 debug_buffer_ddr_address;   /* inform SP the addr of DDR debug
> +                                        * queue
> +                                        */
> +       /* input system perf count array */
> +       u32 perf_counter_input_system_error;
> +       u32 threads_stack;      /* sp thread's stack pointers */
> +       u32 threads_stack_size; /* sp thread's stack sizes */
> +       u32 curr_binary_id;     /* current binary id */
> +       u32 raw_copy_line_count;        /* raw copy line counter */
> +       u32 ddr_parameter_address;      /* acc param ddrptr, sp dmem */
> +       u32 ddr_parameter_size; /* acc param size, sp dmem */
> +       /* Entry functions */
> +       u32 sp_entry;           /* The SP entry function */
> +       u32 tagger_frames_addr; /* Base address of tagger state */
> +};
> +
> +struct imgu_fw_bl_info {
> +       u32 num_dma_cmds;       /* Number of cmds sent by CSS */
> +       u32 dma_cmd_list;       /* Dma command list sent by CSS */
> +       u32 sw_state;           /* Polled from css */
> +#define IMGU_ABI_BL_SWSTATE_OK         0x100
> +#define IMGU_ABI_BL_SWSTATE_BUSY       (IMGU_ABI_BL_SWSTATE_OK + 1)
> +#define IMGU_ABI_BL_SWSTATE_ERR                (IMGU_ABI_BL_SWSTATE_OK + 2)
> +       /* Entry functions */
> +       u32 bl_entry;           /* The SP entry function */
> +};
> +
> +struct imgu_fw_acc_info {
> +       u32 per_frame_data;     /* Dummy for now */
> +};
> +
> +union imgu_fw_union {
> +       struct imgu_fw_binary_xinfo isp;        /* ISP info */
> +       struct imgu_fw_sp_info sp;      /* SP info */
> +       struct imgu_fw_sp_info sp1;     /* SP1 info */
> +       struct imgu_fw_bl_info bl;      /* Bootloader info */
> +       struct imgu_fw_acc_info acc;    /* Accelerator info */
> +};
> +
> +struct imgu_fw_info {
> +       size_t header_size;     /* size of fw header */
> +       enum imgu_fw_type type __aligned(8);
> +       union imgu_fw_union info;       /* Binary info */
> +       struct imgu_abi_blob_info blob; /* Blob info */
> +       /* Dynamic part */
> +       struct imgu_fw_info *next;

Pointer in a firmware blob?

> +
> +       u32 loaded __aligned(8);        /* Firmware has been loaded */
> +       const u8 *isp_code __aligned(8);        /* ISP pointer to code */

Pointer in a firmware blob?

> +       /* Firmware handle between user space and kernel */
> +       u32 handle __aligned(8);
> +       /* Sections to copy from/to ISP */
> +       struct imgu_abi_isp_param_segments mem_initializers;
> +       /* Initializer for local ISP memories */
> +};
> +
> +struct imgu_fw_blob_descr {
> +       const unsigned char *blob;
> +       struct imgu_fw_info header;
> +       const char *name;
> +       union imgu_fw_all_memory_offsets mem_offsets;
> +};
> +
> +struct imgu_fw_bi_file_h {
> +       char version[64];       /* branch tag + week day + time */
> +       int binary_nr;          /* Number of binaries */
> +       unsigned int h_size;    /* sizeof(struct imgu_fw_bi_file_h) */
> +};
> +
> +struct imgu_fw_header {
> +       struct imgu_fw_bi_file_h file_header;
> +       struct imgu_fw_info binary_header[1];   /* binary_nr items */

Since we don't know the number of items, shouldn't it be binary_header[0]?

Best regards,
Tomasz
