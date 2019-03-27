Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F431C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 13:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E98E8204FD
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 13:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfC0NpQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 09:45:16 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:35629 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728101AbfC0NpP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 09:45:15 -0400
Received: from [IPv6:2001:420:44c1:2579:f45d:db5a:3412:ff5f] ([IPv6:2001:420:44c1:2579:f45d:db5a:3412:ff5f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 98rYhBdndUjKf98rbhpBOF; Wed, 27 Mar 2019 14:45:08 +0100
Subject: Re: [PATCH v4 3/3] [media] allegro: add SPS/PPS nal unit writer
To:     Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, dshah@xilinx.com
References: <20190301152718.23134-1-m.tretter@pengutronix.de>
 <20190301152718.23134-4-m.tretter@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <63d0c159-8092-417a-a2ae-678317ac0eb1@xs4all.nl>
Date:   Wed, 27 Mar 2019 14:45:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190301152718.23134-4-m.tretter@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNeKDOmHgwGf+amY/cqtco2QxyjOh7+2XEvgOxCcDUfClnFyLTWN2LddIWZHEhutL/eR4Ip8/rzgXuiESqJX5NV0ghxK3qQp7DMCsVosVJeHgM+ULScu
 PnCRBAK+f0AamIy3sSO6beok/Oa6bZI7gpwnGoUJz+h8+JiiTAtKuawai8CPewrnCzxOr+xkcjhRHciDBTYN17foTF8pzNIALaaQgI7Sf6pWspds8bzzacHd
 nr6zLFiLMC/Gr7PBj29V2/n8Vjxsp4OsYEEknf0wgnwf3pb/5s25Q2Yz45+tCRMmRl8mbDod2OnsX1wDNdx9uo8fOW7ocIUjZbrsRxlqnphobH6m0k9n8Ne9
 3bsz3TNb1e3ZV6Akt1tckwY/oU/ExE07fLFk+mSeHd5SWiL2MdgY4BJ1v/qTN0dUML7jJWnIICsOoE4+/IcTbD3cWkGD/KvBmxeScN1sxG3beVv3Br4QZLit
 WJQwHC6OmkdVa7HoCYOYltGAHRJiiY0+DBMidw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/1/19 4:27 PM, Michael Tretter wrote:
> The allegro hardware encoder does not write SPS/PPS nal units into the
> encoded video stream. Therefore, we need to write the units in software.
> 
> The implementation follows Rec. ITU-T H.264 (04/2017) to allow to
> convert between a C struct and the RBSP representation of the SPS and
> PPS nal units.
> 
> The allegro driver writes the nal units into the v4l2 capture buffer in
> front of the actual video data which is written at an offset by the IP
> core. The remaining gap is filled with a filler nal unit.
> 
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> ---
> v3 -> v4:
> fix compiler warnings regarding printing size_t
> add documentation for nal_h264.h
> 
> v2 -> v3:
> none
> 
> v1 -> v2:
> - clean up debug log levels
> - fix missing error handling in allegro_h264_write_sps
> - enable configuration of frame size
> - enable configuration of bit rate and CPB size
> ---
>  drivers/staging/media/allegro-dvt/Makefile    |    4 +-
>  .../staging/media/allegro-dvt/allegro-core.c  |  182 ++-
>  drivers/staging/media/allegro-dvt/nal-h264.c  | 1278 +++++++++++++++++
>  drivers/staging/media/allegro-dvt/nal-h264.h  |  330 +++++
>  4 files changed, 1792 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.c
>  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.h
> 
> diff --git a/drivers/staging/media/allegro-dvt/Makefile b/drivers/staging/media/allegro-dvt/Makefile
> index bc30addee47f..eee9713c10e3 100644
> --- a/drivers/staging/media/allegro-dvt/Makefile
> +++ b/drivers/staging/media/allegro-dvt/Makefile
> @@ -1,4 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
> -allegro-objs := allegro-core.o
> +ccflags-y += -I$(src)
> +
> +allegro-objs := allegro-core.o nal-h264.o
>  
>  obj-$(CONFIG_VIDEO_ALLEGRO_DVT) += allegro.o
> diff --git a/drivers/staging/media/allegro-dvt/allegro-core.c b/drivers/staging/media/allegro-dvt/allegro-core.c
> index 0bf761ac22c2..7e4c5f4bbd5c 100644
> --- a/drivers/staging/media/allegro-dvt/allegro-core.c
> +++ b/drivers/staging/media/allegro-dvt/allegro-core.c
> @@ -26,6 +26,8 @@
>  #include <media/videobuf2-dma-contig.h>
>  #include <media/videobuf2-v4l2.h>
>  
> +#include "nal-h264.h"
> +
>  /*
>   * Support up to 4k video streams. The hardware actually supports higher
>   * resolutions, which are specified in PG252 June 6, 2018 (H.264/H.265 Video
> @@ -1269,6 +1271,131 @@ static int allocate_reference_buffers(struct allegro_channel *channel,
>  					 n, PAGE_ALIGN(size));
>  }
>  
> +static ssize_t allegro_h264_write_sps(struct allegro_channel *channel,
> +				      void *dest, size_t n)
> +{
> +	struct allegro_dev *dev = channel->dev;
> +	struct nal_h264_sps *sps;
> +	ssize_t size;
> +	unsigned int size_mb = SIZE_MACROBLOCK;
> +	/* Calculation of crop units in Rec. ITU-T H.264 (04/2017) p. 76 */
> +	unsigned int crop_unit_x = 2;
> +	unsigned int crop_unit_y = 2;
> +
> +	sps = kzalloc(sizeof(*sps), GFP_KERNEL);
> +	if (!sps)
> +		return -ENOMEM;
> +
> +	sps->profile_idc = nal_h264_profile_from_v4l2(channel->profile);
> +	sps->constraint_set0_flag = 0;
> +	sps->constraint_set1_flag = 1;
> +	sps->constraint_set2_flag = 0;
> +	sps->constraint_set3_flag = 0;
> +	sps->constraint_set4_flag = 0;
> +	sps->constraint_set5_flag = 0;
> +	sps->level_idc = nal_h264_level_from_v4l2(channel->level);
> +	sps->seq_parameter_set_id = 0;
> +	sps->log2_max_frame_num_minus4 = 0;
> +	sps->pic_order_cnt_type = 0;
> +	sps->log2_max_pic_order_cnt_lsb_minus4 = 6;
> +	sps->max_num_ref_frames = 3;
> +	sps->gaps_in_frame_num_value_allowed_flag = 0;
> +	sps->pic_width_in_mbs_minus1 =
> +		DIV_ROUND_UP(channel->width, size_mb) - 1;
> +	sps->pic_height_in_map_units_minus1 =
> +		DIV_ROUND_UP(channel->height, size_mb) - 1;
> +	sps->frame_mbs_only_flag = 1;
> +	sps->mb_adaptive_frame_field_flag = 0;
> +	sps->direct_8x8_inference_flag = 1;
> +	sps->frame_cropping_flag =
> +		(channel->width % size_mb) || (channel->height % size_mb);
> +	if (sps->frame_cropping_flag) {
> +		sps->crop_left = 0;
> +		sps->crop_right = (round_up(channel->width, size_mb) - channel->width) / crop_unit_x;
> +		sps->crop_top = 0;
> +		sps->crop_bottom = (round_up(channel->height, size_mb) - channel->height) / crop_unit_y;
> +	}
> +	sps->vui_parameters_present_flag = 1;
> +	sps->vui.aspect_ratio_info_present_flag = 0;
> +	sps->vui.overscan_info_present_flag = 0;
> +	sps->vui.video_signal_type_present_flag = 1;
> +	sps->vui.video_format = 1;
> +	sps->vui.video_full_range_flag = 0;
> +	sps->vui.colour_description_present_flag = 1;
> +	sps->vui.colour_primaries = 5;
> +	sps->vui.transfer_characteristics = 5;
> +	sps->vui.matrix_coefficients = 5;
> +	sps->vui.chroma_loc_info_present_flag = 1;
> +	sps->vui.chroma_sample_loc_type_top_field = 0;
> +	sps->vui.chroma_sample_loc_type_bottom_field = 0;
> +	sps->vui.timing_info_present_flag = 1;
> +	sps->vui.num_units_in_tick = 1;
> +	sps->vui.time_scale = 50;
> +	sps->vui.fixed_frame_rate_flag = 1;
> +	sps->vui.nal_hrd_parameters_present_flag = 0;
> +	sps->vui.vcl_hrd_parameters_present_flag = 1;
> +	sps->vui.vcl_hrd_parameters.cpb_cnt_minus1 = 0;
> +	sps->vui.vcl_hrd_parameters.bit_rate_scale = 0;
> +	sps->vui.vcl_hrd_parameters.cpb_size_scale = 1;
> +	/* See Rec. ITU-T H.264 (04/2017) p. 410 E-53 */
> +	sps->vui.vcl_hrd_parameters.bit_rate_value_minus1[0] =
> +		channel->bitrate_peak / (1 << (6 + sps->vui.vcl_hrd_parameters.bit_rate_scale)) - 1;
> +	/* See Rec. ITU-T H.264 (04/2017) p. 410 E-54 */
> +	sps->vui.vcl_hrd_parameters.cpb_size_value_minus1[0] =
> +		(channel->cpb_size * 1000) / (1 << (4 + sps->vui.vcl_hrd_parameters.cpb_size_scale)) - 1;
> +	sps->vui.vcl_hrd_parameters.cbr_flag[0] = 1;
> +	sps->vui.vcl_hrd_parameters.initial_cpb_removal_delay_length_minus1 = 31;
> +	sps->vui.vcl_hrd_parameters.cpb_removal_delay_length_minus1 = 31;
> +	sps->vui.vcl_hrd_parameters.dpb_output_delay_length_minus1 = 31;
> +	sps->vui.vcl_hrd_parameters.time_offset_length = 0;
> +	sps->vui.low_delay_hrd_flag = 0;
> +	sps->vui.pic_struct_present_flag = 1;
> +	sps->vui.bitstream_restriction_flag = 0;
> +
> +	size = nal_h264_write_sps(&dev->plat_dev->dev, dest, n, sps);
> +
> +	kfree(sps);
> +
> +	return size;
> +}
> +
> +static ssize_t allegro_h264_write_pps(struct allegro_channel *channel,
> +				      void *dest, size_t n)
> +{
> +	struct allegro_dev *dev = channel->dev;
> +	struct nal_h264_pps *pps;
> +	ssize_t size;
> +
> +	pps = kzalloc(sizeof(*pps), GFP_KERNEL);
> +	if (!pps)
> +		return -ENOMEM;
> +
> +	pps->pic_parameter_set_id = 0;
> +	pps->seq_parameter_set_id = 0;
> +	pps->entropy_coding_mode_flag = 0;
> +	pps->bottom_field_pic_order_in_frame_present_flag = 0;
> +	pps->num_slice_groups_minus1 = 0;
> +	pps->num_ref_idx_l0_default_active_minus1 = 2;
> +	pps->num_ref_idx_l1_default_active_minus1 = 2;
> +	pps->weighted_pred_flag = 0;
> +	pps->weighted_bipred_idc = 0;
> +	pps->pic_init_qp_minus26 = 0;
> +	pps->pic_init_qs_minus26 = 0;
> +	pps->chroma_qp_index_offset = 0;
> +	pps->deblocking_filter_control_present_flag = 1;
> +	pps->constrained_intra_pred_flag = 0;
> +	pps->redundant_pic_cnt_present_flag = 0;
> +	pps->transform_8x8_mode_flag = 0;
> +	pps->pic_scaling_matrix_present_flag = 0;
> +	pps->second_chroma_qp_index_offset = 0;
> +
> +	size = nal_h264_write_pps(&dev->plat_dev->dev, dest, n, pps);
> +
> +	kfree(pps);
> +
> +	return size;
> +}
> +
>  static void allegro_finish_frame(struct allegro_channel *channel,
>  				 struct mcu_msg_encode_frame_response *msg)
>  {
> @@ -1280,6 +1407,9 @@ static void allegro_finish_frame(struct allegro_channel *channel,
>  		u32 size;
>  	} *partition;
>  	enum vb2_buffer_state state = VB2_BUF_STATE_ERROR;
> +	char *curr;
> +	ssize_t len;
> +	ssize_t free;
>  
>  	src_buf = v4l2_m2m_src_buf_remove(channel->fh.m2m_ctx);
>  
> @@ -1327,10 +1457,60 @@ static void allegro_finish_frame(struct allegro_channel *channel,
>  	 * The payload must include the data before the partition offset,
>  	 * because we will put the sps and pps data there.
>  	 */
> -
>  	vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
>  			      partition->offset + partition->size);
>  
> +	curr = vb2_plane_vaddr(&dst_buf->vb2_buf, 0);
> +	free = partition->offset;
> +	if (msg->is_idr) {
> +		len = allegro_h264_write_sps(channel, curr, free);
> +		if (len < 0) {
> +			v4l2_err(&dev->v4l2_dev,
> +				 "not enough space for sequence parameter set: %zd left\n",
> +				 free);
> +			goto err;
> +		}
> +		curr += len;
> +		free -= len;
> +		v4l2_dbg(1, debug, &dev->v4l2_dev,
> +			 "channel %d: wrote %zd byte SPS nal unit\n",
> +			 channel->mcu_channel_id, len);
> +	}
> +
> +	if (msg->slice_type == AL_ENC_SLICE_TYPE_I) {
> +		len = allegro_h264_write_pps(channel, curr, free);
> +		if (len < 0) {
> +			v4l2_err(&dev->v4l2_dev,
> +				 "not enough space for picture parameter set: %zd left\n",
> +				 free);
> +			goto err;
> +		}
> +		curr += len;
> +		free -= len;
> +		v4l2_dbg(1, debug, &dev->v4l2_dev,
> +			 "channel %d: wrote %zd byte PPS nal unit\n",
> +			 channel->mcu_channel_id, len);
> +	}
> +
> +	len = nal_h264_write_filler(&dev->plat_dev->dev, curr, free);
> +	if (len < 0) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "failed to write %zd filler data\n", free);
> +		goto err;
> +	}
> +	curr += len;
> +	free -= len;
> +	v4l2_dbg(2, debug, &dev->v4l2_dev,
> +		 "channel %d: wrote %zd bytes filler nal unit\n",
> +		 channel->mcu_channel_id, len);
> +
> +	if (free != 0) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "non-VCL NAL units do not fill space until VCL NAL unit: %zd bytes left\n",
> +			 free);
> +		goto err;
> +	}
> +
>  	state = VB2_BUF_STATE_DONE;
>  
>  	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, false);
> diff --git a/drivers/staging/media/allegro-dvt/nal-h264.c b/drivers/staging/media/allegro-dvt/nal-h264.c
> new file mode 100644
> index 000000000000..83bc98200c1a
> --- /dev/null
> +++ b/drivers/staging/media/allegro-dvt/nal-h264.c
> @@ -0,0 +1,1278 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Pengutronix, Michael Tretter <kernel@pengutronix.de>
> + *
> + * Convert NAL units between raw byte sequence payloads (RBSP) and C structs
> + *
> + * The conversion is defined in "ITU-T Rec. H.264 (04/2017) Advanced video
> + * coding for generic audiovisual services". Decoder drivers may use the
> + * parser to parse RBSP from encoded streams and configure the hardware, if
> + * the hardware is not able to parse RBSP itself.  Encoder drivers may use the
> + * generator to generate the RBSP for SPS/PPS nal units and add them to the
> + * encoded stream if the hardware does not generate the units.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <linux/v4l2-controls.h>
> +
> +#include <linux/device.h>
> +#include <linux/export.h>
> +#include <linux/log2.h>
> +
> +#include <nal-h264.h>
> +
> +struct rbsp {
> +	char *buf;
> +	int size;
> +	int pos;
> +	int num_consecutive_zeros;
> +};
> +
> +int nal_h264_profile_from_v4l2(enum v4l2_mpeg_video_h264_profile profile)
> +{
> +	switch (profile) {
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
> +		return 66;
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
> +		return 77;
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED:
> +		return 88;
> +	case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
> +		return 100;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +int nal_h264_level_from_v4l2(enum v4l2_mpeg_video_h264_level level)
> +{
> +	switch (level) {
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
> +		return 10;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
> +		return 9;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
> +		return 11;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
> +		return 12;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
> +		return 13;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
> +		return 20;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
> +		return 21;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
> +		return 22;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
> +		return 30;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
> +		return 31;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
> +		return 32;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
> +		return 40;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
> +		return 41;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_4_2:
> +		return 42;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_5_0:
> +		return 50;
> +	case V4L2_MPEG_VIDEO_H264_LEVEL_5_1:
> +		return 51;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int rbsp_read_bits(struct rbsp *rbsp, int num, int *val);
> +static int rbsp_write_bits(struct rbsp *rbsp, int num, int val);
> +
> +static int add_emulation_prevention_three_byte(struct rbsp *rbsp)
> +{
> +	rbsp->num_consecutive_zeros = 0;
> +	/*
> +	 * We are not actually the emulation_prevention_three_byte, but the 2
> +	 * one bits of the byte and the 6 zero bits of the next byte.
> +	 * Therefore, the discarded byte shifted by 6 bits.
> +	 */
> +	rbsp_write_bits(rbsp, 8, (0x3 << 6));
> +
> +	return 0;
> +}
> +
> +static int discard_emulation_prevention_three_byte(struct rbsp *rbsp)
> +{
> +	unsigned int tmp = 0;
> +
> +	rbsp->num_consecutive_zeros = 0;
> +	/*
> +	 * We are not actually discarding the emulation_prevention_three_byte,
> +	 * but the 2 one bits of the byte and the 6 zero bits of the next
> +	 * byte. Therefore, the discarded byte shifted by 6 bits.
> +	 */
> +	rbsp_read_bits(rbsp, 8, &tmp);
> +	if (tmp != (0x3 << 6))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static inline int rbsp_read_bit(struct rbsp *rbsp)
> +{
> +	int shift;
> +	int ofs;
> +	int bit;
> +	int err;
> +
> +	if (rbsp->num_consecutive_zeros == 22) {
> +		err = discard_emulation_prevention_three_byte(rbsp);
> +		if (err)
> +			return err;
> +	}
> +
> +	shift = 7 - (rbsp->pos % 8);
> +	ofs = rbsp->pos++ / 8;
> +
> +	if (ofs >= rbsp->size)
> +		return -EINVAL;
> +
> +	bit = (rbsp->buf[ofs] >> shift) & 1;
> +
> +	/*
> +	 * Counting zeros for the emulation_prevention_three_byte only starts
> +	 * at byte boundaries.
> +	 */
> +	if (bit == 1 ||
> +	    (rbsp->num_consecutive_zeros < 7 && (rbsp->pos % 8 == 0)))
> +		rbsp->num_consecutive_zeros = 0;
> +	else
> +		rbsp->num_consecutive_zeros++;
> +
> +	return bit;
> +}
> +
> +static inline int rbsp_write_bit(struct rbsp *rbsp, int bit)
> +{
> +	int shift;
> +	int ofs;
> +
> +	if (rbsp->num_consecutive_zeros == 22)
> +		add_emulation_prevention_three_byte(rbsp);
> +
> +	shift = 7 - (rbsp->pos % 8);
> +	ofs = rbsp->pos++ / 8;
> +
> +	if (ofs >= rbsp->size)
> +		return -EINVAL;
> +
> +	rbsp->buf[ofs] &= ~(1 << shift);
> +	rbsp->buf[ofs] |= bit << shift;
> +
> +	/*
> +	 * Counting zeros for the emulation_prevention_three_byte only starts
> +	 * at byte boundaries.
> +	 */
> +	if (bit == 1 ||
> +	    (rbsp->num_consecutive_zeros < 7 && (rbsp->pos % 8 == 0))) {
> +		rbsp->num_consecutive_zeros = 0;
> +	} else {
> +		rbsp->num_consecutive_zeros++;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int rbsp_read_bits(struct rbsp *rbsp, int num, int *val)
> +{
> +	int i, ret;
> +	int tmp = 0;
> +
> +	if (num > 32)
> +		return -EINVAL;
> +
> +	for (i = 0; i < num; i++) {
> +		ret = rbsp_read_bit(rbsp);
> +		if (ret < 0)
> +			return ret;
> +		tmp |= ret << (num - i - 1);
> +	}
> +
> +	if (val)
> +		*val = tmp;
> +
> +	return 0;
> +}
> +
> +static int rbsp_write_bits(struct rbsp *rbsp, int num, int value)
> +{
> +	int ret;
> +
> +	while (num--) {
> +		ret = rbsp_write_bit(rbsp, (value >> num) & 1);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rbsp_read_uev(struct rbsp *rbsp, unsigned int *val)
> +{
> +	int leading_zero_bits = 0;
> +	unsigned int tmp = 0;
> +	int ret;
> +
> +	while ((ret = rbsp_read_bit(rbsp)) == 0)
> +		leading_zero_bits++;
> +	if (ret < 0)
> +		return ret;
> +
> +	if (leading_zero_bits > 0) {
> +		ret = rbsp_read_bits(rbsp, leading_zero_bits, &tmp);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (val)
> +		*val = (1 << leading_zero_bits) - 1 + tmp;
> +
> +	return 0;
> +}
> +
> +static int rbsp_write_uev(struct rbsp *rbsp, unsigned int value)
> +{
> +	int i;
> +	int ret;
> +	int tmp = value + 1;
> +	int leading_zero_bits = fls(tmp) - 1;
> +
> +	for (i = 0; i < leading_zero_bits; i++) {
> +		ret = rbsp_write_bit(rbsp, 0);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return rbsp_write_bits(rbsp, leading_zero_bits + 1, tmp);
> +}
> +
> +static int rbsp_read_sev(struct rbsp *rbsp, int *val)
> +{
> +	unsigned int tmp;
> +	int ret;
> +
> +	ret = rbsp_read_uev(rbsp, &tmp);
> +	if (ret)
> +		return ret;
> +
> +	if (val) {
> +		if (tmp & 1)
> +			*val = (tmp + 1) / 2;
> +		else
> +			*val = -(tmp / 2);
> +	}
> +
> +	return 0;
> +}
> +
> +static int rbsp_write_sev(struct rbsp *rbsp, int val)
> +{
> +	unsigned int tmp;
> +
> +	if (val > 0)
> +		tmp = (2 * val) | 1;
> +	else
> +		tmp = -2 * val;
> +
> +	return rbsp_write_uev(rbsp, tmp);
> +}
> +
> +#define READ_BIT(field)						\
> +	do {							\
> +		int ret = rbsp_read_bit(rbsp);			\
> +		if (ret < 0)					\
> +			return ret;				\
> +		s->field = ret;					\
> +	} while (0)
> +
> +#define READ_BITS(num, field)					\
> +	do {							\
> +		int val;					\
> +		int ret = rbsp_read_bits(rbsp, (num), &val);	\
> +		if (ret)					\
> +			return ret;				\
> +		s->field = val;					\
> +	} while (0)
> +
> +#define READ_UEV(field)						\
> +	do {							\
> +		int ret = rbsp_read_uev(rbsp, &s->field);	\
> +		if (ret)					\
> +			return ret;				\
> +	} while (0)
> +
> +#define READ_SEV(field)						\
> +	do {							\
> +		int ret = rbsp_read_sev(rbsp, &s->field);	\
> +		if (ret)					\
> +			return ret;				\
> +	} while (0)
> +
> +#define WRITE_BIT(field)						\
> +	do {								\
> +		int ret = rbsp_write_bit(rbsp, s->field);		\
> +		if (ret < 0)						\
> +			return ret;					\
> +	} while (0)
> +
> +#define WRITE_BITS(num, field)						\
> +	do {								\
> +		int ret = rbsp_write_bits(rbsp, (num), s->field);	\
> +		if (ret)						\
> +			return ret;					\
> +	} while (0)
> +
> +#define WRITE_UEV(field)						\
> +	do {								\
> +		int ret = rbsp_write_uev(rbsp, s->field);		\
> +		if (ret)						\
> +			return ret;					\
> +	} while (0)
> +
> +#define WRITE_SEV(field)						\
> +	do {								\
> +		int ret = rbsp_write_sev(rbsp, s->field);		\
> +		if (ret)						\
> +			return ret;					\
> +	} while (0)
> +
> +#define PRINT_BIT(field)						\
> +		dev_dbg(dev, "field: %u\n", s->field)			\
> +
> +#define PRINT_BITS(num, field)						\

Huh? num isn't used!?

> +		dev_dbg(dev, "field: %u\n", s->field)			\
> +
> +#define PRINT_UEV(field)						\
> +		dev_dbg(dev, "field: %u\n", s->field)			\
> +
> +#define PRINT_SEV(field)						\
> +		dev_dbg(dev, "field: %d\n", s->field)			\

I get a lot of very similar checkpatch warnings for these macros. An
example:

CHECK: Macro argument 'field' may be better as '(field)' to avoid precedence issues
#526: FILE: drivers/staging/media/allegro-dvt/nal-h264.c:291:
+#define READ_BIT(field)                                                \
+       do {                                                    \
+               int ret = rbsp_read_bit(rbsp);                  \
+               if (ret < 0)                                    \
+                       return ret;                             \
+               s->field = ret;                                 \
+       } while (0)

WARNING: Macros with flow control statements should be avoided
#526: FILE: drivers/staging/media/allegro-dvt/nal-h264.c:291:
+#define READ_BIT(field)                                                \
+       do {                                                    \
+               int ret = rbsp_read_bit(rbsp);                  \
+               if (ret < 0)                                    \
+                       return ret;                             \
+               s->field = ret;                                 \
+       } while (0)


I would replace s->field by field in these macros. I think it will
make the code more readable in any case.

I think this would be a better way of doing this:

#define READ_BIT(field)                                        \
	if (!ret)                                              \
               ret = rbsp_read_bit(rbsp);

You might even be able to avoid the macros altogether:

	ret = ret ? : rbsp_read_bit(rbsp);

Doesn't look bad either.

Anyway, play with this a bit. I think this can be done better.

Regards,

	Hans

> +
> +static int nal_h264_write_trailing_bits(const struct device *dev,
> +					struct rbsp *rbsp)
> +{
> +	rbsp_write_bit(rbsp, 1);
> +	while (rbsp->pos % 8)
> +		rbsp_write_bit(rbsp, 0);
> +
> +	return 0;
> +}
> +
> +static int nal_h264_write_hrd_parameters(const struct device *dev,
> +					 struct rbsp *rbsp,
> +					 struct nal_h264_hrd_parameters *hrd)
> +{
> +	struct nal_h264_hrd_parameters *s = hrd;
> +	int i;
> +
> +	WRITE_UEV(cpb_cnt_minus1);
> +	WRITE_BITS(4, bit_rate_scale);
> +	WRITE_BITS(4, cpb_size_scale);
> +
> +	for (i = 0; i <= hrd->cpb_cnt_minus1; i++) {
> +		WRITE_UEV(bit_rate_value_minus1[i]);
> +		WRITE_UEV(cpb_size_value_minus1[i]);
> +		WRITE_BIT(cbr_flag[i]);
> +	}
> +
> +	WRITE_BITS(5, initial_cpb_removal_delay_length_minus1);
> +	WRITE_BITS(5, cpb_removal_delay_length_minus1);
> +	WRITE_BITS(5, dpb_output_delay_length_minus1);
> +	WRITE_BITS(5, time_offset_length);
> +
> +	return 0;
> +}
> +
> +static int nal_h264_read_hrd_parameters(const struct device *dev,
> +					struct rbsp *rbsp,
> +					struct nal_h264_hrd_parameters *hrd)
> +{
> +	struct nal_h264_hrd_parameters *s = hrd;
> +	unsigned int i;
> +
> +	READ_UEV(cpb_cnt_minus1);
> +	READ_BITS(4, bit_rate_scale);
> +	READ_BITS(4, cpb_size_scale);
> +
> +	for (i = 0; i <= hrd->cpb_cnt_minus1; i++) {
> +		READ_UEV(bit_rate_value_minus1[i]);
> +		READ_UEV(cpb_size_value_minus1[i]);
> +		READ_BIT(cbr_flag[i]);
> +	}
> +
> +	READ_BITS(5, initial_cpb_removal_delay_length_minus1);
> +	READ_BITS(5, cpb_removal_delay_length_minus1);
> +	READ_BITS(5, dpb_output_delay_length_minus1);
> +	READ_BITS(5, time_offset_length);
> +
> +	return 0;
> +}
> +
> +static void nal_h264_print_hrd_parameters(const struct device *dev,
> +					  struct nal_h264_hrd_parameters *hrd)
> +{
> +	struct nal_h264_hrd_parameters *s = hrd;
> +	unsigned int i;
> +
> +	if (!hrd)
> +		return;
> +
> +	PRINT_UEV(cpb_cnt_minus1);
> +	PRINT_BITS(4, bit_rate_scale);
> +	PRINT_BITS(4, cpb_size_scale);
> +
> +	for (i = 0; i <= s->cpb_cnt_minus1; i++) {
> +		PRINT_UEV(bit_rate_value_minus1[i]);
> +		PRINT_UEV(cpb_size_value_minus1[i]);
> +		PRINT_BIT(cbr_flag[i]);
> +	}
> +
> +	PRINT_BITS(5, initial_cpb_removal_delay_length_minus1);
> +	PRINT_BITS(5, cpb_removal_delay_length_minus1);
> +	PRINT_BITS(5, dpb_output_delay_length_minus1);
> +	PRINT_BITS(5, time_offset_length);
> +}
> +
> +static int nal_h264_read_vui_parameters(const struct device *dev,
> +					struct rbsp *rbsp,
> +					struct nal_h264_vui_parameters *vui)
> +{
> +	struct nal_h264_vui_parameters *s = vui;
> +	int err;
> +
> +	READ_BIT(aspect_ratio_info_present_flag);
> +	if (vui->aspect_ratio_info_present_flag) {
> +		READ_BITS(8, aspect_ratio_idc);
> +		if (vui->aspect_ratio_idc == 255) {
> +			READ_BITS(16, sar_width);
> +			READ_BITS(16, sar_height);
> +		}
> +	}
> +
> +	READ_BIT(overscan_info_present_flag);
> +	if (vui->overscan_info_present_flag)
> +		READ_BIT(overscan_appropriate_flag);
> +
> +	READ_BIT(video_signal_type_present_flag);
> +	if (vui->video_signal_type_present_flag) {
> +		READ_BITS(3, video_format);
> +		READ_BIT(video_full_range_flag);
> +		READ_BIT(colour_description_present_flag);
> +
> +		if (vui->colour_description_present_flag) {
> +			READ_BITS(8, colour_primaries);
> +			READ_BITS(8, transfer_characteristics);
> +			READ_BITS(8, matrix_coefficients);
> +		}
> +	}
> +
> +	READ_BIT(chroma_loc_info_present_flag);
> +	if (vui->chroma_loc_info_present_flag) {
> +		READ_UEV(chroma_sample_loc_type_top_field);
> +		READ_UEV(chroma_sample_loc_type_bottom_field);
> +	}
> +
> +	READ_BIT(timing_info_present_flag);
> +	if (vui->timing_info_present_flag) {
> +		READ_BITS(32, num_units_in_tick);
> +		READ_BITS(32, time_scale);
> +		READ_BIT(fixed_frame_rate_flag);
> +	}
> +
> +	READ_BIT(nal_hrd_parameters_present_flag);
> +	if (vui->nal_hrd_parameters_present_flag) {
> +		err = nal_h264_read_hrd_parameters(dev, rbsp,
> +						   &vui->nal_hrd_parameters);
> +		if (err)
> +			return err;
> +	}
> +
> +	READ_BIT(vcl_hrd_parameters_present_flag);
> +	if (vui->vcl_hrd_parameters_present_flag) {
> +		err = nal_h264_read_hrd_parameters(dev, rbsp,
> +						   &vui->vcl_hrd_parameters);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (vui->nal_hrd_parameters_present_flag ||
> +	    vui->vcl_hrd_parameters_present_flag)
> +		READ_BIT(low_delay_hrd_flag);
> +
> +	READ_BIT(pic_struct_present_flag);
> +
> +	READ_BIT(bitstream_restriction_flag);
> +	if (vui->bitstream_restriction_flag) {
> +		READ_BIT(motion_vectors_over_pic_boundaries_flag);
> +		READ_UEV(max_bytes_per_pic_denom);
> +		READ_UEV(max_bits_per_mb_denom);
> +		READ_UEV(log2_max_mv_length_horizontal);
> +		READ_UEV(log21_max_mv_length_vertical);
> +		READ_UEV(max_num_reorder_frames);
> +		READ_UEV(max_dec_frame_buffering);
> +	}
> +
> +	return 0;
> +}
> +
> +static ssize_t nal_h264_write_vui_parameters(const struct device *dev,
> +					     struct rbsp *rbsp,
> +					     struct nal_h264_vui_parameters *vui)
> +{
> +	struct nal_h264_vui_parameters *s = vui;
> +	int err;
> +
> +	WRITE_BIT(aspect_ratio_info_present_flag);
> +	if (vui->aspect_ratio_info_present_flag) {
> +		WRITE_BITS(8, aspect_ratio_idc);
> +		if (vui->aspect_ratio_idc == 255) {
> +			WRITE_BITS(16, sar_width);
> +			WRITE_BITS(16, sar_height);
> +		}
> +	}
> +
> +	WRITE_BIT(overscan_info_present_flag);
> +	if (vui->overscan_info_present_flag)
> +		WRITE_BIT(overscan_appropriate_flag);
> +
> +	WRITE_BIT(video_signal_type_present_flag);
> +	if (vui->video_signal_type_present_flag) {
> +		WRITE_BITS(3, video_format);
> +		WRITE_BIT(video_full_range_flag);
> +		WRITE_BIT(colour_description_present_flag);
> +
> +		if (vui->colour_description_present_flag) {
> +			WRITE_BITS(8, colour_primaries);
> +			WRITE_BITS(8, transfer_characteristics);
> +			WRITE_BITS(8, matrix_coefficients);
> +		}
> +	}
> +
> +	WRITE_BIT(chroma_loc_info_present_flag);
> +	if (vui->chroma_loc_info_present_flag) {
> +		WRITE_UEV(chroma_sample_loc_type_top_field);
> +		WRITE_UEV(chroma_sample_loc_type_bottom_field);
> +	}
> +
> +	WRITE_BIT(timing_info_present_flag);
> +	if (vui->timing_info_present_flag) {
> +		WRITE_BITS(32, num_units_in_tick);
> +		WRITE_BITS(32, time_scale);
> +		WRITE_BIT(fixed_frame_rate_flag);
> +	}
> +
> +	WRITE_BIT(nal_hrd_parameters_present_flag);
> +	if (vui->nal_hrd_parameters_present_flag) {
> +		err = nal_h264_write_hrd_parameters(dev, rbsp,
> +						    &vui->nal_hrd_parameters);
> +		if (err)
> +			return err;
> +	}
> +
> +	WRITE_BIT(vcl_hrd_parameters_present_flag);
> +	if (vui->vcl_hrd_parameters_present_flag) {
> +		err = nal_h264_write_hrd_parameters(dev, rbsp,
> +						    &vui->vcl_hrd_parameters);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (vui->nal_hrd_parameters_present_flag ||
> +	    vui->vcl_hrd_parameters_present_flag)
> +		WRITE_BIT(low_delay_hrd_flag);
> +
> +	WRITE_BIT(pic_struct_present_flag);
> +
> +	WRITE_BIT(bitstream_restriction_flag);
> +	if (vui->bitstream_restriction_flag) {
> +		WRITE_BIT(motion_vectors_over_pic_boundaries_flag);
> +		WRITE_UEV(max_bytes_per_pic_denom);
> +		WRITE_UEV(max_bits_per_mb_denom);
> +		WRITE_UEV(log2_max_mv_length_horizontal);
> +		WRITE_UEV(log21_max_mv_length_vertical);
> +		WRITE_UEV(max_num_reorder_frames);
> +		WRITE_UEV(max_dec_frame_buffering);
> +	}
> +
> +	return 0;
> +}
> +
> +static void nal_h264_print_vui_parameters(const struct device *dev,
> +					  struct nal_h264_vui_parameters *vui)
> +{
> +	struct nal_h264_vui_parameters *s = vui;
> +
> +	if (!vui)
> +		return;
> +
> +	PRINT_BIT(aspect_ratio_info_present_flag);
> +	if (vui->aspect_ratio_info_present_flag) {
> +		PRINT_BITS(8, aspect_ratio_idc);
> +		if (vui->aspect_ratio_idc == 255) {
> +			PRINT_BITS(16, sar_width);
> +			PRINT_BITS(16, sar_height);
> +		}
> +	}
> +
> +	PRINT_BIT(overscan_info_present_flag);
> +	if (vui->overscan_info_present_flag)
> +		PRINT_BIT(overscan_appropriate_flag);
> +
> +	PRINT_BIT(video_signal_type_present_flag);
> +	if (vui->video_signal_type_present_flag) {
> +		PRINT_BITS(3, video_format);
> +		PRINT_BIT(video_full_range_flag);
> +		PRINT_BIT(colour_description_present_flag);
> +
> +		if (vui->colour_description_present_flag) {
> +			PRINT_BITS(8, colour_primaries);
> +			PRINT_BITS(8, transfer_characteristics);
> +			PRINT_BITS(8, matrix_coefficients);
> +		}
> +	}
> +
> +	PRINT_BIT(chroma_loc_info_present_flag);
> +	if (vui->chroma_loc_info_present_flag) {
> +		PRINT_UEV(chroma_sample_loc_type_top_field);
> +		PRINT_UEV(chroma_sample_loc_type_bottom_field);
> +	}
> +
> +	PRINT_BIT(timing_info_present_flag);
> +	if (vui->timing_info_present_flag) {
> +		PRINT_BITS(32, num_units_in_tick);
> +		PRINT_BITS(32, time_scale);
> +		PRINT_BIT(fixed_frame_rate_flag);
> +	}
> +
> +	PRINT_BIT(nal_hrd_parameters_present_flag);
> +	if (vui->nal_hrd_parameters_present_flag)
> +		nal_h264_print_hrd_parameters(dev, &vui->nal_hrd_parameters);
> +
> +	PRINT_BIT(vcl_hrd_parameters_present_flag);
> +	if (vui->vcl_hrd_parameters_present_flag)
> +		nal_h264_print_hrd_parameters(dev, &vui->vcl_hrd_parameters);
> +
> +	if (vui->nal_hrd_parameters_present_flag ||
> +	    vui->vcl_hrd_parameters_present_flag)
> +		PRINT_BIT(low_delay_hrd_flag);
> +
> +	PRINT_BIT(pic_struct_present_flag);
> +
> +	PRINT_BIT(bitstream_restriction_flag);
> +	if (vui->bitstream_restriction_flag) {
> +		PRINT_BIT(motion_vectors_over_pic_boundaries_flag);
> +		PRINT_UEV(max_bytes_per_pic_denom);
> +		PRINT_UEV(max_bits_per_mb_denom);
> +		PRINT_UEV(log2_max_mv_length_horizontal);
> +		PRINT_UEV(log21_max_mv_length_vertical);
> +		PRINT_UEV(max_num_reorder_frames);
> +		PRINT_UEV(max_dec_frame_buffering);
> +	}
> +}
> +
> +static int nal_h264_rbsp_write_sps(const struct device *dev,
> +				   struct rbsp *rbsp, struct nal_h264_sps *sps)
> +{
> +	struct nal_h264_sps *s = sps;
> +	unsigned int i;
> +	int err;
> +
> +	if (rbsp->size < 3)
> +		return -EINVAL;
> +
> +	WRITE_BITS(8, profile_idc);
> +	WRITE_BIT(constraint_set0_flag);
> +	WRITE_BIT(constraint_set1_flag);
> +	WRITE_BIT(constraint_set2_flag);
> +	WRITE_BIT(constraint_set3_flag);
> +	WRITE_BIT(constraint_set4_flag);
> +	WRITE_BIT(constraint_set5_flag);
> +	WRITE_BITS(2, reserved_zero_2bits);
> +	WRITE_BITS(8, level_idc);
> +
> +	WRITE_UEV(seq_parameter_set_id);
> +
> +	if (sps->profile_idc == 100 || sps->profile_idc == 110 ||
> +	    sps->profile_idc == 122 || sps->profile_idc == 244 ||
> +	    sps->profile_idc == 44 || sps->profile_idc == 83 ||
> +	    sps->profile_idc == 86 || sps->profile_idc == 118 ||
> +	    sps->profile_idc == 128 || sps->profile_idc == 138 ||
> +	    sps->profile_idc == 139 || sps->profile_idc == 134 ||
> +	    sps->profile_idc == 135) {
> +		WRITE_UEV(chroma_format_idc);
> +
> +		if (sps->chroma_format_idc == 3)
> +			WRITE_BIT(separate_colour_plane_flag);
> +
> +		WRITE_UEV(bit_depth_luma_minus8);
> +		WRITE_UEV(bit_depth_chroma_minus8);
> +		WRITE_BIT(qpprime_y_zero_transform_bypass_flag);
> +		WRITE_BIT(seq_scaling_matrix_present_flag);
> +
> +		if (sps->seq_scaling_matrix_present_flag) {
> +			dev_err(dev,
> +				"%s: Handling scaling matrix not supported\n",
> +				__func__);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	WRITE_UEV(log2_max_frame_num_minus4);
> +
> +	WRITE_UEV(pic_order_cnt_type);
> +	if (sps->pic_order_cnt_type == 0) {
> +		WRITE_UEV(log2_max_pic_order_cnt_lsb_minus4);
> +	} else if (sps->pic_order_cnt_type == 1) {
> +		WRITE_BIT(delta_pic_order_always_zero_flag);
> +		WRITE_SEV(offset_for_non_ref_pic);
> +		WRITE_SEV(offset_for_top_to_bottom_field);
> +
> +		WRITE_UEV(num_ref_frames_in_pic_order_cnt_cycle);
> +		for (i = 0; i < sps->num_ref_frames_in_pic_order_cnt_cycle; i++)
> +			WRITE_SEV(offset_for_ref_frame[i]);
> +	} else {
> +		dev_err(dev,
> +			"%s: Invalid pic_order_cnt_type %u\n", __func__,
> +			sps->pic_order_cnt_type);
> +		return -EINVAL;
> +	}
> +
> +	WRITE_UEV(max_num_ref_frames);
> +	WRITE_BIT(gaps_in_frame_num_value_allowed_flag);
> +	WRITE_UEV(pic_width_in_mbs_minus1);
> +	WRITE_UEV(pic_height_in_map_units_minus1);
> +
> +	WRITE_BIT(frame_mbs_only_flag);
> +	if (!sps->frame_mbs_only_flag)
> +		WRITE_BIT(mb_adaptive_frame_field_flag);
> +
> +	WRITE_BIT(direct_8x8_inference_flag);
> +
> +	WRITE_BIT(frame_cropping_flag);
> +	if (sps->frame_cropping_flag) {
> +		WRITE_UEV(crop_left);
> +		WRITE_UEV(crop_right);
> +		WRITE_UEV(crop_top);
> +		WRITE_UEV(crop_bottom);
> +	}
> +
> +	WRITE_BIT(vui_parameters_present_flag);
> +	if (sps->vui_parameters_present_flag) {
> +		err = nal_h264_write_vui_parameters(dev, rbsp, &sps->vui);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int nal_h264_rbsp_read_sps(const struct device *dev,
> +				  struct rbsp *rbsp, struct nal_h264_sps *sps)
> +{
> +	struct nal_h264_sps *s = sps;
> +	unsigned int i;
> +	int err;
> +
> +	if (rbsp->size < 3)
> +		return -EINVAL;
> +
> +	READ_BITS(8, profile_idc);
> +	READ_BIT(constraint_set0_flag);
> +	READ_BIT(constraint_set1_flag);
> +	READ_BIT(constraint_set2_flag);
> +	READ_BIT(constraint_set3_flag);
> +	READ_BIT(constraint_set4_flag);
> +	READ_BIT(constraint_set5_flag);
> +	READ_BITS(2, reserved_zero_2bits);
> +	READ_BITS(8, level_idc);
> +
> +	READ_UEV(seq_parameter_set_id);
> +
> +	if (sps->profile_idc == 100 || sps->profile_idc == 110 ||
> +	    sps->profile_idc == 122 || sps->profile_idc == 244 ||
> +	    sps->profile_idc == 44 || sps->profile_idc == 83 ||
> +	    sps->profile_idc == 86 || sps->profile_idc == 118 ||
> +	    sps->profile_idc == 128 || sps->profile_idc == 138 ||
> +	    sps->profile_idc == 139 || sps->profile_idc == 134 ||
> +	    sps->profile_idc == 135) {
> +		READ_UEV(chroma_format_idc);
> +
> +		if (sps->chroma_format_idc == 3)
> +			READ_BIT(separate_colour_plane_flag);
> +
> +		READ_UEV(bit_depth_luma_minus8);
> +		READ_UEV(bit_depth_chroma_minus8);
> +		READ_BIT(qpprime_y_zero_transform_bypass_flag);
> +		READ_BIT(seq_scaling_matrix_present_flag);
> +
> +		if (sps->seq_scaling_matrix_present_flag) {
> +			dev_err(dev,
> +				"%s: Handling scaling matrix not supported\n",
> +				__func__);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	READ_UEV(log2_max_frame_num_minus4);
> +
> +	READ_UEV(pic_order_cnt_type);
> +	if (sps->pic_order_cnt_type == 0) {
> +		READ_UEV(log2_max_pic_order_cnt_lsb_minus4);
> +	} else if (sps->pic_order_cnt_type == 1) {
> +		READ_BIT(delta_pic_order_always_zero_flag);
> +		READ_SEV(offset_for_non_ref_pic);
> +		READ_SEV(offset_for_top_to_bottom_field);
> +
> +		READ_UEV(num_ref_frames_in_pic_order_cnt_cycle);
> +		for (i = 0; i < sps->num_ref_frames_in_pic_order_cnt_cycle; i++)
> +			READ_SEV(offset_for_ref_frame[i]);
> +	} else {
> +		dev_err(dev,
> +			"%s: Invalid pic_order_cnt_type %u\n", __func__,
> +			sps->pic_order_cnt_type);
> +		return -EINVAL;
> +	}
> +
> +	READ_UEV(max_num_ref_frames);
> +	READ_BIT(gaps_in_frame_num_value_allowed_flag);
> +	READ_UEV(pic_width_in_mbs_minus1);
> +	READ_UEV(pic_height_in_map_units_minus1);
> +
> +	READ_BIT(frame_mbs_only_flag);
> +	if (!sps->frame_mbs_only_flag)
> +		READ_BIT(mb_adaptive_frame_field_flag);
> +
> +	READ_BIT(direct_8x8_inference_flag);
> +
> +	READ_BIT(frame_cropping_flag);
> +	if (sps->frame_cropping_flag) {
> +		READ_UEV(crop_left);
> +		READ_UEV(crop_right);
> +		READ_UEV(crop_top);
> +		READ_UEV(crop_bottom);
> +	}
> +
> +	READ_BIT(vui_parameters_present_flag);
> +	if (sps->vui_parameters_present_flag) {
> +		err = nal_h264_read_vui_parameters(dev, rbsp, &sps->vui);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int nal_h264_rbsp_write_pps(const struct device *dev,
> +				   struct rbsp *rbsp, struct nal_h264_pps *pps)
> +{
> +	struct nal_h264_pps *s = pps;
> +	int i;
> +
> +	WRITE_UEV(pic_parameter_set_id);
> +	WRITE_UEV(seq_parameter_set_id);
> +	WRITE_BIT(entropy_coding_mode_flag);
> +	WRITE_BIT(bottom_field_pic_order_in_frame_present_flag);
> +	WRITE_UEV(num_slice_groups_minus1);
> +	if (pps->num_slice_groups_minus1 > 0) {
> +		WRITE_UEV(slice_group_map_type);
> +		if (pps->slice_group_map_type == 0) {
> +			for (i = 0; i < pps->num_slice_groups_minus1; i++)
> +				WRITE_UEV(run_length_minus1[i]);
> +		} else if (pps->slice_group_map_type == 2) {
> +			for (i = 0; i < pps->num_slice_groups_minus1; i++) {
> +				WRITE_UEV(top_left[i]);
> +				WRITE_UEV(bottom_right[i]);
> +			}
> +		} else if (pps->slice_group_map_type == 3 ||
> +			   pps->slice_group_map_type == 4 ||
> +			   pps->slice_group_map_type == 5) {
> +			WRITE_BIT(slice_group_change_direction_flag);
> +			WRITE_UEV(slice_group_change_rate_minus1);
> +		} else if (pps->slice_group_map_type == 6) {
> +			WRITE_UEV(pic_size_in_map_units_minus1);
> +			for (i = 0; i < pps->pic_size_in_map_units_minus1; i++)
> +				WRITE_BITS(order_base_2
> +					   (s->num_slice_groups_minus1 + 1),
> +					   slice_group_id[i]);
> +		}
> +	}
> +	WRITE_UEV(num_ref_idx_l0_default_active_minus1);
> +	WRITE_UEV(num_ref_idx_l1_default_active_minus1);
> +	WRITE_BIT(weighted_pred_flag);
> +	WRITE_BITS(2, weighted_bipred_idc);
> +	WRITE_SEV(pic_init_qp_minus26);
> +	WRITE_SEV(pic_init_qs_minus26);
> +	WRITE_SEV(chroma_qp_index_offset);
> +	WRITE_BIT(deblocking_filter_control_present_flag);
> +	WRITE_BIT(constrained_intra_pred_flag);
> +	WRITE_BIT(redundant_pic_cnt_present_flag);
> +	if (/* more_rbsp_data() */ false) {
> +		WRITE_BIT(transform_8x8_mode_flag);
> +		WRITE_BIT(pic_scaling_matrix_present_flag);
> +		if (pps->pic_scaling_matrix_present_flag) {
> +			dev_err(dev,
> +				"%s: Handling scaling matrix not supported\n",
> +				__func__);
> +			return -EINVAL;
> +		}
> +		WRITE_SEV(second_chroma_qp_index_offset);
> +	}
> +
> +	return 0;
> +}
> +
> +static int nal_h264_rbsp_read_pps(const struct device *dev,
> +				  struct rbsp *rbsp, struct nal_h264_pps *pps)
> +{
> +	struct nal_h264_pps *s = pps;
> +	unsigned int i;
> +
> +	READ_UEV(pic_parameter_set_id);
> +	READ_UEV(seq_parameter_set_id);
> +	READ_BIT(entropy_coding_mode_flag);
> +	READ_BIT(bottom_field_pic_order_in_frame_present_flag);
> +	READ_UEV(num_slice_groups_minus1);
> +	if (s->num_slice_groups_minus1 > 0) {
> +		READ_UEV(slice_group_map_type);
> +		if (pps->slice_group_map_type == 0) {
> +			for (i = 0; i < pps->num_slice_groups_minus1; i++)
> +				READ_UEV(run_length_minus1[i]);
> +		} else if (pps->slice_group_map_type == 2) {
> +			for (i = 0; i < pps->num_slice_groups_minus1; i++) {
> +				READ_UEV(top_left[i]);
> +				READ_UEV(bottom_right[i]);
> +			}
> +		} else if (s->slice_group_map_type == 3 ||
> +			   s->slice_group_map_type == 4 ||
> +			   s->slice_group_map_type == 5) {
> +			READ_BIT(slice_group_change_direction_flag);
> +			READ_UEV(slice_group_change_rate_minus1);
> +		} else if (s->slice_group_map_type == 6) {
> +			READ_UEV(pic_size_in_map_units_minus1);
> +			for (i = 0; i < s->pic_size_in_map_units_minus1; i++)
> +				READ_BITS(order_base_2
> +					  (s->num_slice_groups_minus1 + 1),
> +					  slice_group_id[i]);
> +		}
> +	}
> +	READ_UEV(num_ref_idx_l0_default_active_minus1);
> +	READ_UEV(num_ref_idx_l1_default_active_minus1);
> +	READ_BIT(weighted_pred_flag);
> +	READ_BITS(2, weighted_bipred_idc);
> +	READ_SEV(pic_init_qp_minus26);
> +	READ_SEV(pic_init_qs_minus26);
> +	READ_SEV(chroma_qp_index_offset);
> +	READ_BIT(deblocking_filter_control_present_flag);
> +	READ_BIT(constrained_intra_pred_flag);
> +	READ_BIT(redundant_pic_cnt_present_flag);
> +	if (/* more_rbsp_data() */ false) {
> +		READ_BIT(transform_8x8_mode_flag);
> +		READ_BIT(pic_scaling_matrix_present_flag);
> +		if (pps->pic_scaling_matrix_present_flag) {
> +			dev_err(dev,
> +				"%s: Handling scaling matrix not supported\n",
> +				__func__);
> +			return -EINVAL;
> +		}
> +		READ_SEV(second_chroma_qp_index_offset);
> +	}
> +
> +	return 0;
> +}
> +
> +ssize_t nal_h264_write_sps(const struct device *dev,
> +			   void *dest, size_t n, struct nal_h264_sps *sps)
> +{
> +	struct rbsp rbsp;
> +	int err;
> +	u8 *p = dest;
> +
> +	rbsp.buf = p + 5;
> +	rbsp.size = n - 5;
> +	rbsp.pos = 0;
> +
> +	err = nal_h264_rbsp_write_sps(dev, &rbsp, sps);
> +	if (err)
> +		return err;
> +
> +	err = nal_h264_write_trailing_bits(dev, &rbsp);
> +	if (err)
> +		return err;
> +
> +	p[0] = 0x00;
> +	p[1] = 0x00;
> +	p[2] = 0x00;
> +	p[3] = 0x01;
> +	p[4] = 0x07;
> +
> +	return ((rbsp.pos + 7) / 8) + 5;
> +}
> +EXPORT_SYMBOL_GPL(nal_h264_write_sps);
> +
> +ssize_t nal_h264_read_sps(const struct device *dev,
> +			  struct nal_h264_sps *sps, void *src, size_t n)
> +{
> +	struct rbsp rbsp;
> +	int err;
> +
> +	rbsp.buf = src;
> +	rbsp.size = n;
> +	rbsp.pos = 0;
> +
> +	rbsp.buf += 5;
> +	rbsp.size -= 5;
> +
> +	err = nal_h264_rbsp_read_sps(dev, &rbsp, sps);
> +	if (err)
> +		return err;
> +
> +	return ((rbsp.pos + 7) / 8) + 5;
> +}
> +EXPORT_SYMBOL_GPL(nal_h264_read_sps);
> +
> +void nal_h264_print_sps(const struct device *dev, struct nal_h264_sps *sps)
> +{
> +	struct nal_h264_sps *s = sps;
> +	unsigned int i;
> +
> +	if (!sps)
> +		return;
> +
> +	PRINT_BITS(8, profile_idc);
> +	PRINT_BIT(constraint_set0_flag);
> +	PRINT_BIT(constraint_set1_flag);
> +	PRINT_BIT(constraint_set2_flag);
> +	PRINT_BIT(constraint_set3_flag);
> +	PRINT_BIT(constraint_set4_flag);
> +	PRINT_BIT(constraint_set5_flag);
> +	PRINT_BITS(2, reserved_zero_2bits);
> +	PRINT_BITS(8, level_idc);
> +
> +	PRINT_UEV(seq_parameter_set_id);
> +
> +	if (sps->profile_idc == 100 || sps->profile_idc == 110 ||
> +	    sps->profile_idc == 122 || sps->profile_idc == 244 ||
> +	    sps->profile_idc == 44 || sps->profile_idc == 83 ||
> +	    sps->profile_idc == 86 || sps->profile_idc == 118 ||
> +	    sps->profile_idc == 128 || sps->profile_idc == 138 ||
> +	    sps->profile_idc == 139 || sps->profile_idc == 134 ||
> +	    sps->profile_idc == 135) {
> +		PRINT_UEV(chroma_format_idc);
> +
> +		if (sps->chroma_format_idc == 3)
> +			PRINT_BIT(separate_colour_plane_flag);
> +
> +		PRINT_UEV(bit_depth_luma_minus8);
> +		PRINT_UEV(bit_depth_chroma_minus8);
> +		PRINT_BIT(qpprime_y_zero_transform_bypass_flag);
> +		PRINT_BIT(seq_scaling_matrix_present_flag);
> +
> +		if (sps->seq_scaling_matrix_present_flag)
> +			dev_err(dev,
> +				"%s: Handling scaling matrix not supported\n",
> +				__func__);
> +	}
> +
> +	PRINT_UEV(log2_max_frame_num_minus4);
> +
> +	PRINT_UEV(pic_order_cnt_type);
> +	if (sps->pic_order_cnt_type == 0) {
> +		PRINT_UEV(log2_max_pic_order_cnt_lsb_minus4);
> +	} else if (sps->pic_order_cnt_type == 1) {
> +		PRINT_BIT(delta_pic_order_always_zero_flag);
> +		PRINT_SEV(offset_for_non_ref_pic);
> +		PRINT_SEV(offset_for_top_to_bottom_field);
> +
> +		PRINT_UEV(num_ref_frames_in_pic_order_cnt_cycle);
> +		for (i = 0; i < sps->num_ref_frames_in_pic_order_cnt_cycle; i++)
> +			PRINT_SEV(offset_for_ref_frame[i]);
> +	} else {
> +		dev_err(dev,
> +			"%s: Invalid pic_order_cnt_type %u\n", __func__,
> +			sps->pic_order_cnt_type);
> +	}
> +
> +	PRINT_UEV(max_num_ref_frames);
> +	PRINT_BIT(gaps_in_frame_num_value_allowed_flag);
> +	PRINT_UEV(pic_width_in_mbs_minus1);
> +	PRINT_UEV(pic_height_in_map_units_minus1);
> +
> +	PRINT_BIT(frame_mbs_only_flag);
> +	if (!sps->frame_mbs_only_flag)
> +		PRINT_BIT(mb_adaptive_frame_field_flag);
> +
> +	PRINT_BIT(direct_8x8_inference_flag);
> +
> +	PRINT_BIT(frame_cropping_flag);
> +	if (sps->frame_cropping_flag) {
> +		PRINT_UEV(crop_left);
> +		PRINT_UEV(crop_right);
> +		PRINT_UEV(crop_top);
> +		PRINT_UEV(crop_bottom);
> +	}
> +
> +	PRINT_BIT(vui_parameters_present_flag);
> +	if (sps->vui_parameters_present_flag)
> +		nal_h264_print_vui_parameters(dev, &sps->vui);
> +}
> +EXPORT_SYMBOL_GPL(nal_h264_print_sps);
> +
> +ssize_t nal_h264_write_pps(const struct device *dev,
> +			   void *dest, size_t n, struct nal_h264_pps *pps)
> +{
> +	struct rbsp rbsp;
> +	int err;
> +	u8 *p = dest;
> +
> +	rbsp.buf = p + 5;
> +	rbsp.size = n - 5;
> +	rbsp.pos = 0;
> +
> +	err = nal_h264_rbsp_write_pps(dev, &rbsp, pps);
> +	if (err)
> +		return err;
> +
> +	err = nal_h264_write_trailing_bits(dev, &rbsp);
> +	if (err)
> +		return err;
> +
> +	p[0] = 0x00;
> +	p[1] = 0x00;
> +	p[2] = 0x00;
> +	p[3] = 0x01;
> +	p[4] = 0x08;
> +
> +	return ((rbsp.pos + 7) / 8) + 5;
> +}
> +EXPORT_SYMBOL_GPL(nal_h264_write_pps);
> +
> +ssize_t nal_h264_read_pps(const struct device *dev,
> +			  struct nal_h264_pps *pps, void *src, size_t n)
> +{
> +	struct rbsp rbsp;
> +	int err;
> +
> +	rbsp.buf = src;
> +	rbsp.size = n;
> +	rbsp.pos = 0;
> +
> +	rbsp.buf += 5;
> +	rbsp.size -= 5;
> +
> +	err = nal_h264_rbsp_read_pps(dev, &rbsp, pps);
> +	if (err)
> +		return err;
> +
> +	return ((rbsp.pos + 7) / 8) + 5;
> +}
> +EXPORT_SYMBOL_GPL(nal_h264_read_pps);
> +
> +void nal_h264_print_pps(const struct device *dev, struct nal_h264_pps *pps)
> +{
> +	struct nal_h264_pps *s = pps;
> +	unsigned int i;
> +
> +	if (!pps)
> +		return;
> +
> +	PRINT_UEV(pic_parameter_set_id);
> +	PRINT_UEV(seq_parameter_set_id);
> +	PRINT_BIT(entropy_coding_mode_flag);
> +	PRINT_BIT(bottom_field_pic_order_in_frame_present_flag);
> +	PRINT_UEV(num_slice_groups_minus1);
> +	if (s->num_slice_groups_minus1 > 0) {
> +		PRINT_UEV(slice_group_map_type);
> +		if (pps->slice_group_map_type == 0) {
> +			for (i = 0; i < pps->num_slice_groups_minus1; i++)
> +				PRINT_UEV(run_length_minus1[i]);
> +		} else if (pps->slice_group_map_type == 2) {
> +			for (i = 0; i < pps->num_slice_groups_minus1; i++) {
> +				PRINT_UEV(top_left[i]);
> +				PRINT_UEV(bottom_right[i]);
> +			}
> +		} else if (s->slice_group_map_type == 3 ||
> +			   s->slice_group_map_type == 4 ||
> +			   s->slice_group_map_type == 5) {
> +			PRINT_BIT(slice_group_change_direction_flag);
> +			PRINT_UEV(slice_group_change_rate_minus1);
> +		} else if (s->slice_group_map_type == 6) {
> +			PRINT_UEV(pic_size_in_map_units_minus1);
> +			for (i = 0; i < s->pic_size_in_map_units_minus1; i++)
> +				PRINT_BITS(order_base_2
> +					   (s->num_slice_groups_minus1 + 1),
> +					   slice_group_id[i]);
> +		}
> +	}
> +	PRINT_UEV(num_ref_idx_l0_default_active_minus1);
> +	PRINT_UEV(num_ref_idx_l1_default_active_minus1);
> +	PRINT_BIT(weighted_pred_flag);
> +	PRINT_BITS(2, weighted_bipred_idc);
> +	PRINT_SEV(pic_init_qp_minus26);
> +	PRINT_SEV(pic_init_qs_minus26);
> +	PRINT_SEV(chroma_qp_index_offset);
> +	PRINT_BIT(deblocking_filter_control_present_flag);
> +	PRINT_BIT(constrained_intra_pred_flag);
> +	PRINT_BIT(redundant_pic_cnt_present_flag);
> +	if (/* more_rbsp_data() */ false) {
> +		PRINT_BIT(transform_8x8_mode_flag);
> +		PRINT_BIT(pic_scaling_matrix_present_flag);
> +		if (pps->pic_scaling_matrix_present_flag) {
> +			dev_err(dev,
> +				"%s: Handling scaling matrix not supported\n",
> +				__func__);
> +		}
> +		PRINT_SEV(second_chroma_qp_index_offset);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(nal_h264_print_pps);
> +
> +ssize_t nal_h264_read_filler(const struct device *dev, void *src, size_t n)
> +{
> +	char *p = src;
> +	size_t i = 5;
> +
> +	if (p[0] != 0x00 || p[1] != 0x00 || p[2] != 0x00 || p[3] != 0x01)
> +		return -EINVAL;
> +
> +	if (p[4] != 0x0c)
> +		return -EINVAL;
> +
> +	while (p[i] == 0xff && i < n)
> +		i++;
> +
> +	if (p[i] != 0x80)
> +		return -EINVAL;
> +
> +	return i;
> +}
> +EXPORT_SYMBOL_GPL(nal_h264_read_filler);
> +
> +ssize_t nal_h264_write_filler(const struct device *dev, void *dest, size_t n)
> +{
> +	char *p = dest;
> +
> +	if (n < 6)
> +		return -EINVAL;
> +
> +	p[0] = 0x00;
> +	p[1] = 0x00;
> +	p[2] = 0x00;
> +	p[3] = 0x01;
> +	p[4] = 0x0c;
> +	memset(p + 5, 0xff, n - 6);
> +	p[n - 1] = 0x80;
> +
> +	return n;
> +}
> +EXPORT_SYMBOL_GPL(nal_h264_write_filler);
> diff --git a/drivers/staging/media/allegro-dvt/nal-h264.h b/drivers/staging/media/allegro-dvt/nal-h264.h
> new file mode 100644
> index 000000000000..7c77806ee0b1
> --- /dev/null
> +++ b/drivers/staging/media/allegro-dvt/nal-h264.h
> @@ -0,0 +1,330 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 Pengutronix, Michael Tretter <kernel@pengutronix.de>
> + *
> + * Convert NAL units between raw byte sequence payloads (RBSP) and C structs.
> + */
> +
> +#ifndef __NAL_H264_H__
> +#define __NAL_H264_H__
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +
> +/**
> + * struct nal_h264_hdr_parameters - HDR parameters
> + *
> + * C struct representation of the sequence parameter set NAL unit as defined by
> + * Rec. ITU-T H.264 (04/2017) E.1.2 HRD parameters syntax.
> + */
> +struct nal_h264_hrd_parameters {
> +	unsigned int cpb_cnt_minus1;
> +	unsigned int bit_rate_scale:4;
> +	unsigned int cpb_size_scale:4;
> +	struct {
> +		int bit_rate_value_minus1[16];
> +		int cpb_size_value_minus1[16];
> +		unsigned int cbr_flag[16];
> +	};
> +	unsigned int initial_cpb_removal_delay_length_minus1:5;
> +	unsigned int cpb_removal_delay_length_minus1:5;
> +	unsigned int dpb_output_delay_length_minus1:5;
> +	unsigned int time_offset_length:5;
> +};
> +
> +/**
> + * struct nal_h264_vui_parameters - VUI parameters
> + *
> + * C struct representation of the VUI parameters as defined by Rec. ITU-T
> + * H.264 (04/2017) E.1.1 VUI parameters syntax.
> + */
> +struct nal_h264_vui_parameters {
> +	unsigned int aspect_ratio_info_present_flag:1;
> +	struct {
> +		unsigned int aspect_ratio_idc:8;
> +		unsigned int sar_width:16;
> +		unsigned int sar_height:16;
> +	};
> +	unsigned int overscan_info_present_flag:1;
> +	unsigned int overscan_appropriate_flag:1;
> +	unsigned int video_signal_type_present_flag:1;
> +	struct {
> +		unsigned int video_format:3;
> +		unsigned int video_full_range_flag:1;
> +		unsigned int colour_description_present_flag:1;
> +		struct {
> +			unsigned int colour_primaries:8;
> +			unsigned int transfer_characteristics:8;
> +			unsigned int matrix_coefficients:8;
> +		};
> +	};
> +	unsigned int chroma_loc_info_present_flag:1;
> +	struct {
> +		unsigned int chroma_sample_loc_type_top_field;
> +		unsigned int chroma_sample_loc_type_bottom_field;
> +	};
> +	unsigned int timing_info_present_flag:1;
> +	struct {
> +		unsigned int num_units_in_tick:32;
> +		unsigned int time_scale:32;
> +		unsigned int fixed_frame_rate_flag:1;
> +	};
> +	unsigned int nal_hrd_parameters_present_flag:1;
> +	struct nal_h264_hrd_parameters nal_hrd_parameters;
> +	unsigned int vcl_hrd_parameters_present_flag:1;
> +	struct nal_h264_hrd_parameters vcl_hrd_parameters;
> +	unsigned int low_delay_hrd_flag:1;
> +	unsigned int pic_struct_present_flag:1;
> +	unsigned int bitstream_restriction_flag:1;
> +	struct {
> +		unsigned int motion_vectors_over_pic_boundaries_flag:1;
> +		unsigned int max_bytes_per_pic_denom;
> +		unsigned int max_bits_per_mb_denom;
> +		unsigned int log2_max_mv_length_horizontal;
> +		unsigned int log21_max_mv_length_vertical;
> +		unsigned int max_num_reorder_frames;
> +		unsigned int max_dec_frame_buffering;
> +	};
> +};
> +
> +/**
> + * struct nal_h264_sps - Sequence parameter set
> + *
> + * C struct representation of the sequence parameter set NAL unit as defined by
> + * Rec. ITU-T H.264 (04/2017) 7.3.2.1.1 Sequence parameter set data syntax.
> + */
> +struct nal_h264_sps {
> +	unsigned int profile_idc:8;
> +	unsigned int constraint_set0_flag:1;
> +	unsigned int constraint_set1_flag:1;
> +	unsigned int constraint_set2_flag:1;
> +	unsigned int constraint_set3_flag:1;
> +	unsigned int constraint_set4_flag:1;
> +	unsigned int constraint_set5_flag:1;
> +	unsigned int reserved_zero_2bits:2;
> +	unsigned int level_idc:8;
> +	unsigned int seq_parameter_set_id;
> +	struct {
> +		unsigned int chroma_format_idc;
> +		unsigned int separate_colour_plane_flag:1;
> +		unsigned int bit_depth_luma_minus8;
> +		unsigned int bit_depth_chroma_minus8;
> +		unsigned int qpprime_y_zero_transform_bypass_flag:1;
> +		unsigned int seq_scaling_matrix_present_flag:1;
> +	};
> +	unsigned int log2_max_frame_num_minus4;
> +	unsigned int pic_order_cnt_type;
> +	union {
> +		unsigned int log2_max_pic_order_cnt_lsb_minus4;
> +		struct {
> +			unsigned int delta_pic_order_always_zero_flag:1;
> +			int offset_for_non_ref_pic;
> +			int offset_for_top_to_bottom_field;
> +			unsigned int num_ref_frames_in_pic_order_cnt_cycle;
> +			int offset_for_ref_frame[255];
> +		};
> +	};
> +	unsigned int max_num_ref_frames;
> +	unsigned int gaps_in_frame_num_value_allowed_flag:1;
> +	unsigned int pic_width_in_mbs_minus1;
> +	unsigned int pic_height_in_map_units_minus1;
> +	unsigned int frame_mbs_only_flag:1;
> +	unsigned int mb_adaptive_frame_field_flag:1;
> +	unsigned int direct_8x8_inference_flag:1;
> +	unsigned int frame_cropping_flag:1;
> +	struct {
> +		unsigned int crop_left;
> +		unsigned int crop_right;
> +		unsigned int crop_top;
> +		unsigned int crop_bottom;
> +	};
> +	unsigned int vui_parameters_present_flag:1;
> +	struct nal_h264_vui_parameters vui;
> +};
> +
> +/**
> + * struct nal_h264_pps - Picture parameter set
> + *
> + * C struct representation of the picture parameter set NAL unit as defined by
> + * Rec. ITU-T H.264 (04/2017) 7.3.2.2 Picture parameter set RBSP syntax.
> + */
> +struct nal_h264_pps {
> +	unsigned int pic_parameter_set_id;
> +	unsigned int seq_parameter_set_id;
> +	unsigned int entropy_coding_mode_flag:1;
> +	unsigned int bottom_field_pic_order_in_frame_present_flag:1;
> +	unsigned int num_slice_groups_minus1;
> +	unsigned int slice_group_map_type;
> +	union {
> +		unsigned int run_length_minus1[8];
> +		struct {
> +			unsigned int top_left[8];
> +			unsigned int bottom_right[8];
> +		};
> +		struct {
> +			unsigned int slice_group_change_direction_flag:1;
> +			unsigned int slice_group_change_rate_minus1;
> +		};
> +		struct {
> +			unsigned int pic_size_in_map_units_minus1;
> +			unsigned int slice_group_id[8];
> +		};
> +	};
> +	unsigned int num_ref_idx_l0_default_active_minus1;
> +	unsigned int num_ref_idx_l1_default_active_minus1;
> +	unsigned int weighted_pred_flag:1;
> +	unsigned int weighted_bipred_idc:2;
> +	int pic_init_qp_minus26;
> +	int pic_init_qs_minus26;
> +	int chroma_qp_index_offset;
> +	unsigned int deblocking_filter_control_present_flag:1;
> +	unsigned int constrained_intra_pred_flag:1;
> +	unsigned int redundant_pic_cnt_present_flag:1;
> +	struct {
> +		unsigned int transform_8x8_mode_flag:1;
> +		unsigned int pic_scaling_matrix_present_flag:1;
> +		int second_chroma_qp_index_offset;
> +	};
> +};
> +
> +/**
> + * nal_h264_level_from_v4l2() - Get level_idc for v4l2 h264 level
> + * @level: the level as &enum v4l2_mpeg_video_h264_level
> + *
> + * Convert the &enum v4l2_mpeg_video_h264_level to level_idc as specified in
> + * Rec. ITU-T H.264 (04/2017) A.3.2.
> + *
> + * Return: the level_idc for the passed level
> + */
> +int nal_h264_level_from_v4l2(enum v4l2_mpeg_video_h264_level level);
> +
> +/**
> + * nal_h264_profile_from_v4l2() - Get profile_idc for v4l2 h264 profile
> + * @profile: the profile as &enum v4l2_mpeg_video_h264_profile
> + *
> + * Convert the &enum v4l2_mpeg_video_h264_profile to profile_idc as specified
> + * in Rec. ITU-T H.264 (04/2017) A.2.
> + *
> + * Return: the profile_idc for the passed level
> + */
> +int nal_h264_profile_from_v4l2(enum v4l2_mpeg_video_h264_profile profile);
> +
> +/**
> + * nal_h264_write_sps() - Write SPS NAL unit into RBSP format
> + * @dev:
> + * @dest: the buffer that is filled with RBSP data
> + * @n: maximum size of @dest in bytes
> + * @sps: &struct nal_h264_sps to convert to RBSP
> + *
> + * Convert @sps to RBSP data and write it into @dest.
> + *
> + * The size of the SPS NAL unit is not known in advance and this function will
> + * fail, if @dest does not hold sufficient space for the SPS NAL unit.
> + *
> + * Return: number of bytes written to @dest or negative error code
> + */
> +ssize_t nal_h264_write_sps(const struct device *dev,
> +			   void *dest, size_t n, struct nal_h264_sps *sps);
> +
> +/**
> + * nal_h264_read_sps() - Read SPS NAL unit from RBSP format
> + * @dev:
> + * @sps: the &struct nal_h264_sps to fill from the RBSP data
> + * @src: the buffer that contains the RBSP data
> + * @n: size of @src in bytes
> + *
> + * Read RBSP data from @src and use it to fill @sps.
> + *
> + * Return: number of bytes read from @src or negative error code
> + */
> +ssize_t nal_h264_read_sps(const struct device *dev,
> +			  struct nal_h264_sps *sps, void *src, size_t n);
> +
> +/**
> + * nal_h264_print_sps() - Print SPS NAL unit
> + * @dev:
> + * @sps: the &struct nal_h264_sps that shall be printed
> + *
> + * Print the given @struct hal_h264_sps for debugging.
> + */
> +void nal_h264_print_sps(const struct device *dev, struct nal_h264_sps *sps);
> +
> +/**
> + * nal_h264_write_pps() - Write PPS NAL unit into RBSP format
> + * @dev:
> + * @dest: the buffer that is filled with RBSP data
> + * @n: maximum size of @dest in bytes
> + * @pps: &struct nal_h264_pps to convert to RBSP
> + *
> + * Convert @pps to RBSP data and write it into @dest.
> + *
> + * The size of the PPS NAL unit is not known in advance and this function will
> + * fail, if @dest does not hold sufficient space for the PPS NAL unit.
> + *
> + * Return: number of bytes written to @dest or negative error code
> + */
> +ssize_t nal_h264_write_pps(const struct device *dev,
> +			   void *dest, size_t n, struct nal_h264_pps *pps);
> +
> +/**
> + * nal_h264_read_pps() - Read PPS NAL unit from RBSP format
> + * @dev:
> + * @pps: the &struct nal_h264_pps to fill from the RBSP data
> + * @src: the buffer that contains the RBSP data
> + * @n: size of @src in bytes
> + *
> + * Read RBSP data from @src and use it to fill @pps.
> + *
> + * Return: number of bytes read from @src or negative error code
> + */
> +ssize_t nal_h264_read_pps(const struct device *dev,
> +			  struct nal_h264_pps *pps, void *src, size_t n);
> +
> +/**
> + * nal_h264_print_pps() - Print PPS NAL unit
> + * @dev:
> + * @pps: the &struct nal_h264_pps that shall be printed
> + *
> + * Print the given @struct hal_h264_pps for debugging.
> + */
> +void nal_h264_print_pps(const struct device *dev, struct nal_h264_pps *pps);
> +
> +/**
> + * nal_h264_write_filler() - Write filler data RBSP
> + * @dev:
> + * @dest: buffer to fill with filler data
> + * @n: size of the buffer to fill with filler data
> + *
> + * Write a filler data RBSP to @dest with a size of @n bytes and return the
> + * number of written filler data bytes.
> + *
> + * Use this function to generate dummy data in an RBSP data stream that can be
> + * safely ignored by h264 decoders.
> + *
> + * The RBSP format of the filler data is specified in Rec. ITU-T H.264
> + * (04/2017) 7.3.2.7 Filler data RBSP syntax.
> + *
> + * Return: number of filler data bytes (including marker) or negative error
> + */
> +ssize_t nal_h264_write_filler(const struct device *dev, void *dest, size_t n);
> +
> +/**
> + * nal_h264_write_filler() - Read filler data RBSP
> + * @dev:
> + * @src: buffer with RBSP data that is read
> + * @n: maximum size of src that shall be read
> + *
> + * Read a filler data RBSP from @src up to a maximum size of @n bytes and
> + * return the size of the filler data in bytes including the marker.
> + *
> + * This function is used to parse filler data and skip the respective bytes in
> + * the RBSP data.
> + *
> + * The RBSP format of the filler data is specified in Rec. ITU-T H.264
> + * (04/2017) 7.3.2.7 Filler data RBSP syntax.
> + *
> + * Return: number of filler data bytes (including marker) or negative error
> + */
> +ssize_t nal_h264_read_filler(const struct device *dev, void *src, size_t n);
> +
> +#endif /* __NAL_H264_H__ */
> 

