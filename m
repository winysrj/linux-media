Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B35C10F01
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C62DA21902
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfBTLU5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:20:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:35976 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfBTLU5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 06:20:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2019 03:20:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,390,1544515200"; 
   d="scan'208";a="144997512"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002.fm.intel.com with ESMTP; 20 Feb 2019 03:20:55 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 3DDF820859;
        Wed, 20 Feb 2019 13:20:54 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gwPus-000240-Me; Wed, 20 Feb 2019 13:19:54 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org, rajmohan.mani@intel.com
Subject: [PATCH 1/5] staging: imgu: Switch to __aligned() from __attribute__((aligned()))
Date:   Wed, 20 Feb 2019 13:19:49 +0200
Message-Id: <20190220111953.7886-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190220111953.7886-1-sakari.ailus@linux.intel.com>
References: <20190220111953.7886-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

__aligned() is preferred. The patch has been generated using the following
command in the drivers/staging/media/ipu3 directory:

$ git grep -l 'aligned(32)' | \
	xargs perl -i -pe \
	's/__attribute__\s*\(\(\s*aligned\s*\(([0-9]+)\s*\)\s*\)\)/__aligned($1)/g;'

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/ipu3/include/intel-ipu3.h | 74 ++++++++++++-------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/media/ipu3/include/intel-ipu3.h b/drivers/staging/media/ipu3/include/intel-ipu3.h
index eb6f52aca9929..cbb62643172be 100644
--- a/drivers/staging/media/ipu3/include/intel-ipu3.h
+++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
@@ -83,7 +83,7 @@ struct ipu3_uapi_grid_config {
  */
 struct ipu3_uapi_awb_raw_buffer {
 	__u8 meta_data[IPU3_UAPI_AWB_MAX_BUFFER_SIZE]
-		__attribute__((aligned(32)));
+		__aligned(32);
 } __packed;
 
 /**
@@ -104,7 +104,7 @@ struct ipu3_uapi_awb_config_s {
 	__u16 rgbs_thr_gb;
 	__u16 rgbs_thr_b;
 	struct ipu3_uapi_grid_config grid;
-} __attribute__((aligned(32))) __packed;
+} __aligned(32) __packed;
 
 /**
  * struct ipu3_uapi_awb_config - AWB config wrapper
@@ -112,7 +112,7 @@ struct ipu3_uapi_awb_config_s {
  * @config: config for auto white balance as defined by &ipu3_uapi_awb_config_s
  */
 struct ipu3_uapi_awb_config {
-	struct ipu3_uapi_awb_config_s config __attribute__((aligned(32)));
+	struct ipu3_uapi_awb_config_s config __aligned(32);
 } __packed;
 
 #define IPU3_UAPI_AE_COLORS				4	/* R, G, B, Y */
@@ -137,7 +137,7 @@ struct ipu3_uapi_ae_raw_buffer {
  * @buff: &ipu3_uapi_ae_raw_buffer to hold full frame meta data.
  */
 struct ipu3_uapi_ae_raw_buffer_aligned {
-	struct ipu3_uapi_ae_raw_buffer buff __attribute__((aligned(32)));
+	struct ipu3_uapi_ae_raw_buffer buff __aligned(32);
 } __packed;
 
 /**
@@ -243,10 +243,10 @@ struct ipu3_uapi_ae_ccm {
  * Calculate AE grid from image resolution, resample ae weights.
  */
 struct ipu3_uapi_ae_config {
-	struct ipu3_uapi_ae_grid_config grid_cfg __attribute__((aligned(32)));
+	struct ipu3_uapi_ae_grid_config grid_cfg __aligned(32);
 	struct ipu3_uapi_ae_weight_elem weights[
-			IPU3_UAPI_AE_WEIGHTS] __attribute__((aligned(32)));
-	struct ipu3_uapi_ae_ccm ae_ccm __attribute__((aligned(32)));
+			IPU3_UAPI_AE_WEIGHTS] __aligned(32);
+	struct ipu3_uapi_ae_ccm ae_ccm __aligned(32);
 } __packed;
 
 /**
@@ -388,7 +388,7 @@ struct ipu3_uapi_af_filter_config {
  *		each cell.
  */
 struct ipu3_uapi_af_raw_buffer {
-	__u8 y_table[IPU3_UAPI_AF_Y_TABLE_MAX_SIZE] __attribute__((aligned(32)));
+	__u8 y_table[IPU3_UAPI_AF_Y_TABLE_MAX_SIZE] __aligned(32);
 } __packed;
 
 /**
@@ -401,9 +401,9 @@ struct ipu3_uapi_af_raw_buffer {
  *	      grid size for large image and vice versa.
  */
 struct ipu3_uapi_af_config_s {
-	struct ipu3_uapi_af_filter_config filter_config __attribute__((aligned(32)));
+	struct ipu3_uapi_af_filter_config filter_config __aligned(32);
 	__u8 padding[4];
-	struct ipu3_uapi_grid_config grid_cfg __attribute__((aligned(32)));
+	struct ipu3_uapi_grid_config grid_cfg __aligned(32);
 } __packed;
 
 #define IPU3_UAPI_AWB_FR_MAX_SETS			24
@@ -424,7 +424,7 @@ struct ipu3_uapi_af_config_s {
  */
 struct ipu3_uapi_awb_fr_raw_buffer {
 	__u8 meta_data[IPU3_UAPI_AWB_FR_BAYER_TABLE_MAX_SIZE]
-		__attribute__((aligned(32)));
+		__aligned(32);
 } __packed;
 
 /**
@@ -450,7 +450,7 @@ struct ipu3_uapi_awb_fr_config_s {
 	__u32 bayer_sign;
 	__u8 bayer_nf;
 	__u8 reserved2[3];
-} __attribute__((aligned(32))) __packed;
+} __aligned(32) __packed;
 
 /**
  * struct ipu3_uapi_4a_config - 4A config
@@ -462,7 +462,7 @@ struct ipu3_uapi_awb_fr_config_s {
  * @awb_fr_config: &ipu3_uapi_awb_fr_config_s, default resolution 16x16
  */
 struct ipu3_uapi_4a_config {
-	struct ipu3_uapi_awb_config_s awb_config __attribute__((aligned(32)));
+	struct ipu3_uapi_awb_config_s awb_config __aligned(32);
 	struct ipu3_uapi_ae_grid_config ae_grd_config;
 	__u8 padding[20];
 	struct ipu3_uapi_af_config_s af_config;
@@ -485,7 +485,7 @@ struct ipu3_uapi_4a_config {
  * @padding3: padding bytes.
  */
 struct ipu3_uapi_bubble_info {
-	__u32 num_of_stripes __attribute__((aligned(32)));
+	__u32 num_of_stripes __aligned(32);
 	__u8 padding[28];
 	__u32 num_sets;
 	__u8 padding1[28];
@@ -517,7 +517,7 @@ struct ipu3_uapi_stats_3a_bubble_info_per_stripe {
  * @padding3: padding config
  */
 struct ipu3_uapi_ff_status {
-	__u32 awb_en __attribute__((aligned(32)));
+	__u32 awb_en __aligned(32);
 	__u8 padding[28];
 	__u32 ae_en;
 	__u8 padding1[28];
@@ -990,8 +990,8 @@ struct ipu3_uapi_gamma_corr_lut {
  * @gc_lut: lookup table of gamma correction &ipu3_uapi_gamma_corr_lut
  */
 struct ipu3_uapi_gamma_config {
-	struct ipu3_uapi_gamma_corr_ctrl gc_ctrl __attribute__((aligned(32)));
-	struct ipu3_uapi_gamma_corr_lut gc_lut __attribute__((aligned(32)));
+	struct ipu3_uapi_gamma_corr_ctrl gc_ctrl __aligned(32);
+	struct ipu3_uapi_gamma_corr_lut gc_lut __aligned(32);
 } __packed;
 
 /**
@@ -1194,8 +1194,8 @@ struct ipu3_uapi_shd_lut {
  * @shd_lut:	shading lookup table &ipu3_uapi_shd_lut
  */
 struct ipu3_uapi_shd_config {
-	struct ipu3_uapi_shd_config_static shd __attribute__((aligned(32)));
-	struct ipu3_uapi_shd_lut shd_lut __attribute__((aligned(32)));
+	struct ipu3_uapi_shd_config_static shd __aligned(32);
+	struct ipu3_uapi_shd_lut shd_lut __aligned(32);
 } __packed;
 
 /* Image Enhancement Filter directed */
@@ -2414,8 +2414,8 @@ struct ipu3_uapi_anr_stitch_config {
  * @stitch: create 4x4 patch from 4 surrounding 8x8 patches.
  */
 struct ipu3_uapi_anr_config {
-	struct ipu3_uapi_anr_transform_config transform __attribute__((aligned(32)));
-	struct ipu3_uapi_anr_stitch_config stitch __attribute__((aligned(32)));
+	struct ipu3_uapi_anr_transform_config transform __aligned(32);
+	struct ipu3_uapi_anr_stitch_config stitch __aligned(32);
 } __packed;
 
 /**
@@ -2456,21 +2456,21 @@ struct ipu3_uapi_anr_config {
 struct ipu3_uapi_acc_param {
 	struct ipu3_uapi_bnr_static_config bnr;
 	struct ipu3_uapi_bnr_static_config_green_disparity
-				green_disparity __attribute__((aligned(32)));
-	struct ipu3_uapi_dm_config dm __attribute__((aligned(32)));
-	struct ipu3_uapi_ccm_mat_config ccm __attribute__((aligned(32)));
-	struct ipu3_uapi_gamma_config gamma __attribute__((aligned(32)));
-	struct ipu3_uapi_csc_mat_config csc __attribute__((aligned(32)));
-	struct ipu3_uapi_cds_params cds __attribute__((aligned(32)));
-	struct ipu3_uapi_shd_config shd __attribute__((aligned(32)));
-	struct ipu3_uapi_yuvp1_iefd_config iefd __attribute__((aligned(32)));
-	struct ipu3_uapi_yuvp1_yds_config yds_c0 __attribute__((aligned(32)));
-	struct ipu3_uapi_yuvp1_chnr_config chnr_c0 __attribute__((aligned(32)));
-	struct ipu3_uapi_yuvp1_y_ee_nr_config y_ee_nr __attribute__((aligned(32)));
-	struct ipu3_uapi_yuvp1_yds_config yds __attribute__((aligned(32)));
-	struct ipu3_uapi_yuvp1_chnr_config chnr __attribute__((aligned(32)));
-	struct ipu3_uapi_yuvp1_yds_config yds2 __attribute__((aligned(32)));
-	struct ipu3_uapi_yuvp2_tcc_static_config tcc __attribute__((aligned(32)));
+				green_disparity __aligned(32);
+	struct ipu3_uapi_dm_config dm __aligned(32);
+	struct ipu3_uapi_ccm_mat_config ccm __aligned(32);
+	struct ipu3_uapi_gamma_config gamma __aligned(32);
+	struct ipu3_uapi_csc_mat_config csc __aligned(32);
+	struct ipu3_uapi_cds_params cds __aligned(32);
+	struct ipu3_uapi_shd_config shd __aligned(32);
+	struct ipu3_uapi_yuvp1_iefd_config iefd __aligned(32);
+	struct ipu3_uapi_yuvp1_yds_config yds_c0 __aligned(32);
+	struct ipu3_uapi_yuvp1_chnr_config chnr_c0 __aligned(32);
+	struct ipu3_uapi_yuvp1_y_ee_nr_config y_ee_nr __aligned(32);
+	struct ipu3_uapi_yuvp1_yds_config yds __aligned(32);
+	struct ipu3_uapi_yuvp1_chnr_config chnr __aligned(32);
+	struct ipu3_uapi_yuvp1_yds_config yds2 __aligned(32);
+	struct ipu3_uapi_yuvp2_tcc_static_config tcc __aligned(32);
 	struct ipu3_uapi_anr_config anr;
 	struct ipu3_uapi_awb_fr_config_s awb_fr;
 	struct ipu3_uapi_ae_config ae;
@@ -2758,7 +2758,7 @@ struct ipu3_uapi_flags {
  */
 struct ipu3_uapi_params {
 	/* Flags which of the settings below are to be applied */
-	struct ipu3_uapi_flags use __attribute__((aligned(32)));
+	struct ipu3_uapi_flags use __aligned(32);
 
 	/* Accelerator cluster parameters */
 	struct ipu3_uapi_acc_param acc_param;
-- 
2.11.0

