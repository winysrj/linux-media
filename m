Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:58259 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbeJ3HRx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 03:17:53 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v7 09/16] intel-ipu3: css: Add support for firmware management
Date: Mon, 29 Oct 2018 15:23:03 -0700
Message-Id: <1540851790-1777-10-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce functions to load and install ImgU FW blobs.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-css-fw.c | 264 +++++++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-css-fw.h | 188 ++++++++++++++++++++
 2 files changed, 452 insertions(+)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.h

diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-fw.c b/drivers/media/pci/intel/ipu3/ipu3-css-fw.c
new file mode 100644
index 0000000..ba459e9
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-fw.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Intel Corporation
+
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+
+#include "ipu3-css.h"
+#include "ipu3-css-fw.h"
+#include "ipu3-dmamap.h"
+
+static void ipu3_css_fw_show_binary(struct device *dev, struct imgu_fw_info *bi,
+				    const char *name)
+{
+	unsigned int i;
+
+	dev_dbg(dev, "found firmware binary type %i size %i name %s\n",
+		bi->type, bi->blob.size, name);
+	if (bi->type != IMGU_FW_ISP_FIRMWARE)
+		return;
+
+	dev_dbg(dev, "    id %i mode %i bds 0x%x veceven %i/%i out_pins %i\n",
+		bi->info.isp.sp.id, bi->info.isp.sp.pipeline.mode,
+		bi->info.isp.sp.bds.supported_bds_factors,
+		bi->info.isp.sp.enable.vf_veceven,
+		bi->info.isp.sp.vf_dec.is_variable,
+		bi->info.isp.num_output_pins);
+
+	dev_dbg(dev, "    input (%i,%i)-(%i,%i) formats %s%s%s\n",
+		bi->info.isp.sp.input.min_width,
+		bi->info.isp.sp.input.min_height,
+		bi->info.isp.sp.input.max_width,
+		bi->info.isp.sp.input.max_height,
+		bi->info.isp.sp.enable.input_yuv ? "yuv420 " : "",
+		bi->info.isp.sp.enable.input_feeder ||
+		bi->info.isp.sp.enable.input_raw ? "raw8 raw10 " : "",
+		bi->info.isp.sp.enable.input_raw ? "raw12" : "");
+
+	dev_dbg(dev, "    internal (%i,%i)\n",
+		bi->info.isp.sp.internal.max_width,
+		bi->info.isp.sp.internal.max_height);
+
+	dev_dbg(dev, "    output (%i,%i)-(%i,%i) formats",
+		bi->info.isp.sp.output.min_width,
+		bi->info.isp.sp.output.min_height,
+		bi->info.isp.sp.output.max_width,
+		bi->info.isp.sp.output.max_height);
+	for (i = 0; i < bi->info.isp.num_output_formats; i++)
+		dev_dbg(dev, " %i", bi->info.isp.output_formats[i]);
+	dev_dbg(dev, " vf");
+	for (i = 0; i < bi->info.isp.num_vf_formats; i++)
+		dev_dbg(dev, " %i", bi->info.isp.vf_formats[i]);
+	dev_dbg(dev, "\n");
+}
+
+unsigned int ipu3_css_fw_obgrid_size(const struct imgu_fw_info *bi)
+{
+	unsigned int width = DIV_ROUND_UP(bi->info.isp.sp.internal.max_width,
+					  IMGU_OBGRID_TILE_SIZE * 2) + 1;
+	unsigned int height = DIV_ROUND_UP(bi->info.isp.sp.internal.max_height,
+					   IMGU_OBGRID_TILE_SIZE * 2) + 1;
+	unsigned int obgrid_size;
+
+	width = ALIGN(width, IPU3_UAPI_ISP_VEC_ELEMS / 4);
+	obgrid_size = PAGE_ALIGN(width * height *
+				 sizeof(struct ipu3_uapi_obgrid_param)) *
+				 bi->info.isp.sp.iterator.num_stripes;
+	return obgrid_size;
+}
+
+void *ipu3_css_fw_pipeline_params(struct ipu3_css *css,
+				  enum imgu_abi_param_class c,
+				  enum imgu_abi_memories m,
+				  struct imgu_fw_isp_parameter *par,
+				  size_t par_size, void *binary_params)
+{
+	struct imgu_fw_info *bi = &css->fwp->binary_header[css->current_binary];
+
+	if (par->offset + par->size >
+	    bi->info.isp.sp.mem_initializers.params[c][m].size)
+		return NULL;
+
+	if (par->size != par_size)
+		pr_warn("parameter size doesn't match defined size\n");
+
+	if (par->size < par_size)
+		return NULL;
+
+	return binary_params + par->offset;
+}
+
+void ipu3_css_fw_cleanup(struct ipu3_css *css)
+{
+	struct imgu_device *imgu = dev_get_drvdata(css->dev);
+
+	if (css->binary) {
+		unsigned int i;
+
+		for (i = 0; i < css->fwp->file_header.binary_nr; i++)
+			ipu3_dmamap_free(imgu, &css->binary[i]);
+		kfree(css->binary);
+	}
+	if (css->fw)
+		release_firmware(css->fw);
+
+	css->binary = NULL;
+	css->fw = NULL;
+}
+
+int ipu3_css_fw_init(struct ipu3_css *css)
+{
+	static const u32 BLOCK_MAX = 65536;
+	struct imgu_device *imgu = dev_get_drvdata(css->dev);
+	struct device *dev = css->dev;
+	unsigned int i, j, binary_nr;
+	int r;
+
+	r = request_firmware(&css->fw, IMGU_FW_NAME, css->dev);
+	if (r)
+		return r;
+
+	/* Check and display fw header info */
+
+	css->fwp = (struct imgu_fw_header *)css->fw->data;
+	if (css->fw->size < sizeof(struct imgu_fw_header *) ||
+	    css->fwp->file_header.h_size != sizeof(struct imgu_fw_bi_file_h))
+		goto bad_fw;
+	if (sizeof(struct imgu_fw_bi_file_h) +
+	    css->fwp->file_header.binary_nr * sizeof(struct imgu_fw_info) >
+	    css->fw->size)
+		goto bad_fw;
+
+	dev_info(dev, "loaded firmware version %.64s, %u binaries, %zu bytes\n",
+		 css->fwp->file_header.version, css->fwp->file_header.binary_nr,
+		 css->fw->size);
+
+	/* Validate and display info on fw binaries */
+
+	binary_nr = css->fwp->file_header.binary_nr;
+
+	css->fw_bl = -1;
+	css->fw_sp[0] = -1;
+	css->fw_sp[1] = -1;
+
+	for (i = 0; i < binary_nr; i++) {
+		struct imgu_fw_info *bi = &css->fwp->binary_header[i];
+		const char *name = (void *)css->fwp + bi->blob.prog_name_offset;
+		size_t len;
+
+		if (bi->blob.prog_name_offset >= css->fw->size)
+			goto bad_fw;
+		len = strnlen(name, css->fw->size - bi->blob.prog_name_offset);
+		if (len + 1 > css->fw->size - bi->blob.prog_name_offset ||
+		    len + 1 >= IMGU_ABI_MAX_BINARY_NAME)
+			goto bad_fw;
+
+		if (bi->blob.size != bi->blob.text_size + bi->blob.icache_size
+		    + bi->blob.data_size + bi->blob.padding_size)
+			goto bad_fw;
+		if (bi->blob.offset + bi->blob.size > css->fw->size)
+			goto bad_fw;
+
+		if (bi->type == IMGU_FW_BOOTLOADER_FIRMWARE) {
+			css->fw_bl = i;
+			if (bi->info.bl.sw_state >= css->iomem_length ||
+			    bi->info.bl.num_dma_cmds >= css->iomem_length ||
+			    bi->info.bl.dma_cmd_list >= css->iomem_length)
+				goto bad_fw;
+		}
+		if (bi->type == IMGU_FW_SP_FIRMWARE ||
+		    bi->type == IMGU_FW_SP1_FIRMWARE) {
+			css->fw_sp[bi->type == IMGU_FW_SP_FIRMWARE ? 0 : 1] = i;
+			if (bi->info.sp.per_frame_data >= css->iomem_length ||
+			    bi->info.sp.init_dmem_data >= css->iomem_length ||
+			    bi->info.sp.host_sp_queue >= css->iomem_length ||
+			    bi->info.sp.isp_started >= css->iomem_length ||
+			    bi->info.sp.sw_state >= css->iomem_length ||
+			    bi->info.sp.sleep_mode >= css->iomem_length ||
+			    bi->info.sp.invalidate_tlb >= css->iomem_length ||
+			    bi->info.sp.host_sp_com >= css->iomem_length ||
+			    bi->info.sp.output + 12 >= css->iomem_length ||
+			    bi->info.sp.host_sp_queues_initialized >=
+			    css->iomem_length)
+				goto bad_fw;
+		}
+		if (bi->type != IMGU_FW_ISP_FIRMWARE)
+			continue;
+
+		if (bi->info.isp.sp.pipeline.mode >= IPU3_CSS_PIPE_ID_NUM)
+			goto bad_fw;
+
+		if (bi->info.isp.sp.iterator.num_stripes >
+		    IPU3_UAPI_MAX_STRIPES)
+			goto bad_fw;
+
+		if (bi->info.isp.num_vf_formats > IMGU_ABI_FRAME_FORMAT_NUM ||
+		    bi->info.isp.num_output_formats > IMGU_ABI_FRAME_FORMAT_NUM)
+			goto bad_fw;
+
+		for (j = 0; j < bi->info.isp.num_output_formats; j++)
+			if (bi->info.isp.output_formats[j] < 0 ||
+			    bi->info.isp.output_formats[j] >=
+			    IMGU_ABI_FRAME_FORMAT_NUM)
+				goto bad_fw;
+		for (j = 0; j < bi->info.isp.num_vf_formats; j++)
+			if (bi->info.isp.vf_formats[j] < 0 ||
+			    bi->info.isp.vf_formats[j] >=
+			    IMGU_ABI_FRAME_FORMAT_NUM)
+				goto bad_fw;
+
+		if (bi->info.isp.sp.block.block_width <= 0 ||
+		    bi->info.isp.sp.block.block_width > BLOCK_MAX ||
+		    bi->info.isp.sp.block.output_block_height <= 0 ||
+		    bi->info.isp.sp.block.output_block_height > BLOCK_MAX)
+			goto bad_fw;
+
+		if (bi->blob.memory_offsets.offsets[IMGU_ABI_PARAM_CLASS_PARAM]
+		    + sizeof(struct imgu_fw_param_memory_offsets) >
+		    css->fw->size ||
+		    bi->blob.memory_offsets.offsets[IMGU_ABI_PARAM_CLASS_CONFIG]
+		    + sizeof(struct imgu_fw_config_memory_offsets) >
+		    css->fw->size ||
+		    bi->blob.memory_offsets.offsets[IMGU_ABI_PARAM_CLASS_STATE]
+		    + sizeof(struct imgu_fw_state_memory_offsets) >
+		    css->fw->size)
+			goto bad_fw;
+
+		ipu3_css_fw_show_binary(dev, bi, name);
+	}
+
+	if (css->fw_bl == -1 || css->fw_sp[0] == -1 || css->fw_sp[1] == -1)
+		goto bad_fw;
+
+	/* Allocate and map fw binaries into IMGU */
+
+	css->binary = kcalloc(binary_nr, sizeof(*css->binary), GFP_KERNEL);
+	if (!css->binary) {
+		r = -ENOMEM;
+		goto error_out;
+	}
+
+	for (i = 0; i < css->fwp->file_header.binary_nr; i++) {
+		struct imgu_fw_info *bi = &css->fwp->binary_header[i];
+		void *blob = (void *)css->fwp + bi->blob.offset;
+		size_t size = bi->blob.size;
+
+		if (!ipu3_dmamap_alloc(imgu, &css->binary[i], size)) {
+			r = -ENOMEM;
+			goto error_out;
+		}
+		memcpy(css->binary[i].vaddr, blob, size);
+	}
+
+	return 0;
+
+bad_fw:
+	dev_err(dev, "invalid firmware binary, size %u\n", (int)css->fw->size);
+	r = -ENODEV;
+
+error_out:
+	ipu3_css_fw_cleanup(css);
+	return r;
+}
diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-fw.h b/drivers/media/pci/intel/ipu3/ipu3-css-fw.h
new file mode 100644
index 0000000..954bb31
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-fw.h
@@ -0,0 +1,188 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018 Intel Corporation */
+
+#ifndef __IPU3_CSS_FW_H
+#define __IPU3_CSS_FW_H
+
+/******************* Firmware file definitions *******************/
+
+#define IMGU_FW_NAME			"ipu3-fw.bin"
+
+typedef u32 imgu_fw_ptr;
+
+enum imgu_fw_type {
+	IMGU_FW_SP_FIRMWARE,	/* Firmware for the SP */
+	IMGU_FW_SP1_FIRMWARE,	/* Firmware for the SP1 */
+	IMGU_FW_ISP_FIRMWARE,	/* Firmware for the ISP */
+	IMGU_FW_BOOTLOADER_FIRMWARE,	/* Firmware for the BootLoader */
+	IMGU_FW_ACC_FIRMWARE	/* Firmware for accelerations */
+};
+
+enum imgu_fw_acc_type {
+	IMGU_FW_ACC_NONE,	/* Normal binary */
+	IMGU_FW_ACC_OUTPUT,	/* Accelerator stage on output frame */
+	IMGU_FW_ACC_VIEWFINDER,	/* Accelerator stage on viewfinder frame */
+	IMGU_FW_ACC_STANDALONE,	/* Stand-alone acceleration */
+};
+
+struct imgu_fw_isp_parameter {
+	u32 offset;		/* Offset in isp_<mem> config, params, etc. */
+	u32 size;		/* Disabled if 0 */
+};
+
+struct imgu_fw_param_memory_offsets {
+	struct {
+		struct imgu_fw_isp_parameter lin;	/* lin_vmem_params */
+		struct imgu_fw_isp_parameter tnr3;	/* tnr3_vmem_params */
+		struct imgu_fw_isp_parameter xnr3;	/* xnr3_vmem_params */
+	} vmem;
+	struct {
+		struct imgu_fw_isp_parameter tnr;
+		struct imgu_fw_isp_parameter tnr3;	/* tnr3_params */
+		struct imgu_fw_isp_parameter xnr3;	/* xnr3_params */
+		struct imgu_fw_isp_parameter plane_io_config;	/* 192 bytes */
+		struct imgu_fw_isp_parameter rgbir;	/* rgbir_params */
+	} dmem;
+};
+
+struct imgu_fw_config_memory_offsets {
+	struct {
+		struct imgu_fw_isp_parameter iterator;
+		struct imgu_fw_isp_parameter dvs;
+		struct imgu_fw_isp_parameter output;
+		struct imgu_fw_isp_parameter raw;
+		struct imgu_fw_isp_parameter input_yuv;
+		struct imgu_fw_isp_parameter tnr;
+		struct imgu_fw_isp_parameter tnr3;
+		struct imgu_fw_isp_parameter ref;
+	} dmem;
+};
+
+struct imgu_fw_state_memory_offsets {
+	struct {
+		struct imgu_fw_isp_parameter tnr;
+		struct imgu_fw_isp_parameter tnr3;
+		struct imgu_fw_isp_parameter ref;
+	} dmem;
+};
+
+union imgu_fw_all_memory_offsets {
+	struct {
+		u64 imgu_fw_mem_offsets[3]; /* params, config, state */
+	} offsets;
+	struct {
+		u64 ptr;
+	} array[IMGU_ABI_PARAM_CLASS_NUM];
+};
+
+struct imgu_fw_binary_xinfo {
+	/* Part that is of interest to the SP. */
+	struct imgu_abi_binary_info sp;
+
+	/* Rest of the binary info, only interesting to the host. */
+	u32 type;	/* enum imgu_fw_acc_type */
+
+	u32 num_output_formats __aligned(8);
+	u32 output_formats[IMGU_ABI_FRAME_FORMAT_NUM];	/* enum frame_format */
+
+	/* number of supported vf formats */
+	u32 num_vf_formats __aligned(8);
+	/* types of supported vf formats */
+	u32 vf_formats[IMGU_ABI_FRAME_FORMAT_NUM];	/* enum frame_format */
+	u8 num_output_pins;
+	imgu_fw_ptr xmem_addr;
+
+	u64 imgu_fw_blob_descr_ptr __aligned(8);
+	u32 blob_index __aligned(8);
+	union imgu_fw_all_memory_offsets mem_offsets __aligned(8);
+	struct imgu_fw_binary_xinfo *next __aligned(8);
+};
+
+struct imgu_fw_sp_info {
+	u32 init_dmem_data;	/* data sect config, stored to dmem */
+	u32 per_frame_data;	/* Per frame data, stored to dmem */
+	u32 group;		/* Per pipeline data, loaded by dma */
+	u32 output;		/* SP output data, loaded by dmem */
+	u32 host_sp_queue;	/* Host <-> SP queues */
+	u32 host_sp_com;	/* Host <-> SP commands */
+	u32 isp_started;	/* P'ed from sensor thread, csim only */
+	u32 sw_state;		/* Polled from css, enum imgu_abi_sp_swstate */
+	u32 host_sp_queues_initialized;	/* Polled from the SP */
+	u32 sleep_mode;		/* different mode to halt SP */
+	u32 invalidate_tlb;	/* inform SP to invalidate mmu TLB */
+	u32 debug_buffer_ddr_address;	/* the addr of DDR debug queue */
+
+	/* input system perf count array */
+	u32 perf_counter_input_system_error;
+	u32 threads_stack;	/* sp thread's stack pointers */
+	u32 threads_stack_size;	/* sp thread's stack sizes */
+	u32 curr_binary_id;	/* current binary id */
+	u32 raw_copy_line_count;	/* raw copy line counter */
+	u32 ddr_parameter_address;	/* acc param ddrptr, sp dmem */
+	u32 ddr_parameter_size;	/* acc param size, sp dmem */
+	/* Entry functions */
+	u32 sp_entry;		/* The SP entry function */
+	u32 tagger_frames_addr;	/* Base address of tagger state */
+};
+
+struct imgu_fw_bl_info {
+	u32 num_dma_cmds;	/* Number of cmds sent by CSS */
+	u32 dma_cmd_list;	/* Dma command list sent by CSS */
+	u32 sw_state;		/* Polled from css, enum imgu_abi_bl_swstate */
+	/* Entry functions */
+	u32 bl_entry;		/* The SP entry function */
+};
+
+struct imgu_fw_acc_info {
+	u32 per_frame_data;	/* Dummy for now */
+};
+
+union imgu_fw_union {
+	struct imgu_fw_binary_xinfo isp;	/* ISP info */
+	struct imgu_fw_sp_info sp;	/* SP info */
+	struct imgu_fw_sp_info sp1;	/* SP1 info */
+	struct imgu_fw_bl_info bl;	/* Bootloader info */
+	struct imgu_fw_acc_info acc;	/* Accelerator info */
+};
+
+struct imgu_fw_info {
+	size_t header_size;	/* size of fw header */
+	u32 type __aligned(8);	/* enum imgu_fw_type */
+	union imgu_fw_union info;	/* Binary info */
+	struct imgu_abi_blob_info blob;	/* Blob info */
+	/* Dynamic part */
+	u64 next;
+
+	u32 loaded __aligned(8);	/* Firmware has been loaded */
+	const u64 isp_code __aligned(8);	/* ISP pointer to code */
+	/* Firmware handle between user space and kernel */
+	u32 handle __aligned(8);
+	/* Sections to copy from/to ISP */
+	struct imgu_abi_isp_param_segments mem_initializers;
+	/* Initializer for local ISP memories */
+};
+
+struct imgu_fw_bi_file_h {
+	char version[64];	/* branch tag + week day + time */
+	int binary_nr;		/* Number of binaries */
+	unsigned int h_size;	/* sizeof(struct imgu_fw_bi_file_h) */
+};
+
+struct imgu_fw_header {
+	struct imgu_fw_bi_file_h file_header;
+	struct imgu_fw_info binary_header[1];	/* binary_nr items */
+};
+
+/******************* Firmware functions *******************/
+
+int ipu3_css_fw_init(struct ipu3_css *css);
+void ipu3_css_fw_cleanup(struct ipu3_css *css);
+
+unsigned int ipu3_css_fw_obgrid_size(const struct imgu_fw_info *bi);
+void *ipu3_css_fw_pipeline_params(struct ipu3_css *css,
+				  enum imgu_abi_param_class c,
+				  enum imgu_abi_memories m,
+				  struct imgu_fw_isp_parameter *par,
+				  size_t par_size, void *binary_params);
+
+#endif
-- 
2.7.4
