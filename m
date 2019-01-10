Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB407C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 20:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A641208E3
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 20:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbfAJU52 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 15:57:28 -0500
Received: from mga18.intel.com ([134.134.136.126]:23358 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbfAJU52 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 15:57:28 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 12:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,462,1539673200"; 
   d="scan'208";a="125086379"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 10 Jan 2019 12:57:25 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ghhOH-00011B-9k; Fri, 11 Jan 2019 04:57:25 +0800
Date:   Fri, 11 Jan 2019 04:56:28 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Michael Tretter <m.tretter@pengutronix.de>
Cc:     kbuild-all@01.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        robh+dt@kernel.org, mchehab@kernel.org, tfiga@chromium.org,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: Re: [PATCH 3/3] [media] allegro: add SPS/PPS nal unit writer
Message-ID: <201901110444.GvAmr7Mv%fengguang.wu@intel.com>
References: <20190109113037.28430-4-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109113037.28430-4-m.tretter@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Michael,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v5.0-rc1 next-20190110]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Michael-Tretter/Add-ZynqMP-VCU-Allegro-DVT-H-264-encoder-driver/20190110-020930
base:   git://linuxtv.org/media_tree.git master

New smatch warnings:
drivers/staging/media/allegro-dvt/allegro-core.c:1090 allegro_h264_write_sps() error: potential null dereference 'sps'.  (kzalloc returns null)
drivers/staging/media/allegro-dvt/allegro-core.c:1159 allegro_h264_write_pps() error: potential null dereference 'pps'.  (kzalloc returns null)
drivers/staging/media/allegro-dvt/nal-h264.c:1251 nal_h264_read_filler() warn: impossible condition '(p[i] == 255) => ((-128)-127 == 255)'
drivers/staging/media/allegro-dvt/nal-h264.c:1251 nal_h264_read_filler() warn: impossible condition '(p[i] == 255) => ((-128)-127 == 255)'
drivers/staging/media/allegro-dvt/nal-h264.c:1254 nal_h264_read_filler() warn: always true condition '(p[i] != 128) => ((-128)-127 != 128)'

Old smatch warnings:
drivers/staging/media/allegro-dvt/allegro-core.c:625 allegro_mbox_write() error: uninitialized symbol 'err'.
drivers/staging/media/allegro-dvt/allegro-core.c:752 v4l2_profile_to_mcu_profile() warn: signedness bug returning '(-22)'
drivers/staging/media/allegro-dvt/allegro-core.c:762 v4l2_level_to_mcu_level() warn: signedness bug returning '(-22)'
drivers/staging/media/allegro-dvt/allegro-core.c:1320 allegro_receive_message() warn: struct type mismatch 'mcu_msg_header vs mcu_msg_encode_one_frm_response'

vim +/sps +1090 drivers/staging/media/allegro-dvt/allegro-core.c

  1080	
  1081	static ssize_t allegro_h264_write_sps(struct allegro_channel *channel,
  1082					      void *dest, size_t n)
  1083	{
  1084		struct allegro_dev *dev = channel->dev;
  1085		struct nal_h264_sps *sps = kzalloc(sizeof(*sps), GFP_KERNEL);
  1086		ssize_t size;
  1087	
  1088		v4l2_dbg(1, debug, &dev->v4l2_dev, "write sps nal unit\n");
  1089	
> 1090		sps->profile_idc = nal_h264_profile_from_v4l2(channel->profile);
  1091		sps->constraint_set0_flag = 0;
  1092		sps->constraint_set1_flag = 1;
  1093		sps->constraint_set2_flag = 0;
  1094		sps->constraint_set3_flag = 0;
  1095		sps->constraint_set4_flag = 0;
  1096		sps->constraint_set5_flag = 0;
  1097		sps->level_idc = nal_h264_level_from_v4l2(channel->level);
  1098		sps->seq_parameter_set_id = 0;
  1099		sps->log2_max_frame_num_minus4 = 0;
  1100		sps->pic_order_cnt_type = 0;
  1101		sps->log2_max_pic_order_cnt_lsb_minus4 = 6;
  1102		sps->max_num_ref_frames = 3;
  1103		sps->gaps_in_frame_num_value_allowed_flag = 0;
  1104		sps->pic_width_in_mbs_minus1 = 8;
  1105		sps->pic_height_in_map_units_minus1 = 8;
  1106		sps->frame_mbs_only_flag = 1;
  1107		sps->mb_adaptive_frame_field_flag = 0;
  1108		sps->direct_8x8_inference_flag = 1;
  1109		sps->frame_cropping_flag = 0;
  1110		sps->vui_parameters_present_flag = 1;
  1111		sps->vui.aspect_ratio_info_present_flag = 0;
  1112		sps->vui.overscan_info_present_flag = 0;
  1113		sps->vui.video_signal_type_present_flag = 1;
  1114		sps->vui.video_format = 1;
  1115		sps->vui.video_full_range_flag = 0;
  1116		sps->vui.colour_description_present_flag = 1;
  1117		sps->vui.colour_primaries = 5;
  1118		sps->vui.transfer_characteristics = 5;
  1119		sps->vui.matrix_coefficients = 5;
  1120		sps->vui.chroma_loc_info_present_flag = 1;
  1121		sps->vui.chroma_sample_loc_type_top_field = 0;
  1122		sps->vui.chroma_sample_loc_type_bottom_field = 0;
  1123		sps->vui.timing_info_present_flag = 1;
  1124		sps->vui.num_units_in_tick = 1;
  1125		sps->vui.time_scale = 50;
  1126		sps->vui.fixed_frame_rate_flag = 1;
  1127		sps->vui.nal_hrd_parameters_present_flag = 0;
  1128		sps->vui.vcl_hrd_parameters_present_flag = 1;
  1129		sps->vui.vcl_hrd_parameters.cpb_cnt_minus1 = 0;
  1130		sps->vui.vcl_hrd_parameters.bit_rate_scale = 0;
  1131		sps->vui.vcl_hrd_parameters.cpb_size_scale = 1;
  1132		sps->vui.vcl_hrd_parameters.bit_rate_value_minus1[0] = 10936;
  1133		sps->vui.vcl_hrd_parameters.cpb_size_value_minus1[0] = 21874;
  1134		sps->vui.vcl_hrd_parameters.cbr_flag[0] = 1;
  1135		sps->vui.vcl_hrd_parameters.initial_cpb_removal_delay_length_minus1 = 31;
  1136		sps->vui.vcl_hrd_parameters.cpb_removal_delay_length_minus1 = 31;
  1137		sps->vui.vcl_hrd_parameters.dpb_output_delay_length_minus1 = 31;
  1138		sps->vui.vcl_hrd_parameters.time_offset_length = 0;
  1139		sps->vui.low_delay_hrd_flag = 0;
  1140		sps->vui.pic_struct_present_flag = 1;
  1141		sps->vui.bitstream_restriction_flag = 0;
  1142	
  1143		size = nal_h264_write_sps(&dev->plat_dev->dev, dest, n, sps);
  1144	
  1145		kfree(sps);
  1146	
  1147		return size;
  1148	}
  1149	
  1150	static ssize_t allegro_h264_write_pps(struct allegro_channel *channel,
  1151					      void *dest, size_t n)
  1152	{
  1153		struct allegro_dev *dev = channel->dev;
  1154		struct nal_h264_pps *pps = kzalloc(sizeof(*pps), GFP_KERNEL);
  1155		ssize_t size;
  1156	
  1157		v4l2_dbg(1, debug, &dev->v4l2_dev, "write pps nal unit\n");
  1158	
> 1159		pps->pic_parameter_set_id = 0;
  1160		pps->seq_parameter_set_id = 0;
  1161		pps->entropy_coding_mode_flag = 0;
  1162		pps->bottom_field_pic_order_in_frame_present_flag = 0;
  1163		pps->num_slice_groups_minus1 = 0;
  1164		pps->num_ref_idx_l0_default_active_minus1 = 2;
  1165		pps->num_ref_idx_l1_default_active_minus1 = 2;
  1166		pps->weighted_pred_flag = 0;
  1167		pps->weighted_bipred_idc = 0;
  1168		pps->pic_init_qp_minus26 = 0;
  1169		pps->pic_init_qs_minus26 = 0;
  1170		pps->chroma_qp_index_offset = 0;
  1171		pps->deblocking_filter_control_present_flag = 1;
  1172		pps->constrained_intra_pred_flag = 0;
  1173		pps->redundant_pic_cnt_present_flag = 0;
  1174		pps->transform_8x8_mode_flag = 0;
  1175		pps->pic_scaling_matrix_present_flag = 0;
  1176		pps->second_chroma_qp_index_offset = 0;
  1177	
  1178		size = nal_h264_write_pps(&dev->plat_dev->dev, dest, n, pps);
  1179	
  1180		kfree(pps);
  1181	
  1182		return size;
  1183	}
  1184	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
