Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42325 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751132AbeCZVLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Riccardo Schirone <sirmy15@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Georgiana Chelu <georgiana.chelu93@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 15/18] media: staging: atomisp: get rid of some static warnings
Date: Mon, 26 Mar 2018 17:10:48 -0400
Message-Id: <231d3439cf1de93f51a3236a90eb569d0aa0189f.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of those warnings:

    drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.c:18:15: warning: symbol 'g_pyramid' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c:66:23: warning: symbol 'sh_mmu_mrfld' was not declared. Should it be static?
    drivers/staging/media/atomisp/i2c/gc0310.h:381:26: warning: symbol 'gc0310_res_preview' was not declared. Should it be static?
    drivers/staging/media/atomisp/i2c/atomisp-gc0310.c:622:25: warning: symbol 'gc0310_controls' was not declared. Should it be static?
    drivers/staging/media/atomisp/i2c/ov2722.h:1099:26: warning: symbol 'ov2722_res_preview' was not declared. Should it be static?
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:574:25: warning: symbol 'ov2722_controls' was not declared. Should it be static?
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:727:25: warning: symbol 'ov2680_controls' was not declared. Should it be static?
    drivers/staging/media/atomisp/i2c/ov5693/ov5693.h:1090:26: warning: symbol 'ov5693_res_preview' was not declared. Should it be static?
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:958:5: warning: symbol 'ad5823_t_focus_abs' was not declared. Should it be static?
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:1139:25: warning: symbol 'ov5693_controls' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:91:6: warning: symbol 'atomisp_css2_hw_store_8' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:129:10: warning: symbol 'atomisp_css2_hw_load_16' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:139:10: warning: symbol 'atomisp_css2_hw_load_32' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:2868:14: warning: symbol 'atomisp_get_pipe_index' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5165:5: warning: symbol 'configure_pp_input_nop' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5171:5: warning: symbol 'configure_output_nop' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5179:5: warning: symbol 'get_frame_info_nop' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:6630:5: warning: symbol 'atomisp_get_pipe_id' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter.c:48:12: warning: symbol 'HIVE_IF_BIN_COPY' was not declared. Should it be static?
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:1610:6: warning: symbol '__wdt_on_master_slave_sensor' was not declared. Should it be static?

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c     |  2 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c     |  2 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c     |  2 +-
 drivers/staging/media/atomisp/i2c/gc0310.h             |  3 +--
 drivers/staging/media/atomisp/i2c/ov2722.h             |  2 +-
 .../staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c  |  4 ++--
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h      |  2 +-
 .../staging/media/atomisp/pci/atomisp2/atomisp_cmd.c   | 18 +++++++++---------
 .../media/atomisp/pci/atomisp2/atomisp_compat_css20.c  | 11 ++++++-----
 .../staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c |  8 +++++---
 .../css2400/hive_isp_css_common/host/input_formatter.c |  5 +++--
 .../css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.c  |  2 +-
 .../media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c      |  1 +
 13 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
index 93753cb96180..512fa87fa11b 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
@@ -619,7 +619,7 @@ static const struct v4l2_ctrl_ops ctrl_ops = {
 	.g_volatile_ctrl = gc0310_g_volatile_ctrl
 };
 
-struct v4l2_ctrl_config gc0310_controls[] = {
+static const struct v4l2_ctrl_config gc0310_controls[] = {
 	{
 	 .ops = &ctrl_ops,
 	 .id = V4L2_CID_EXPOSURE_ABSOLUTE,
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
index 1d814bcb18b8..c0849299d592 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
@@ -724,7 +724,7 @@ static const struct v4l2_ctrl_ops ctrl_ops = {
 	.g_volatile_ctrl = ov2680_g_volatile_ctrl
 };
 
-struct v4l2_ctrl_config ov2680_controls[] = {
+static const struct v4l2_ctrl_config ov2680_controls[] = {
 	{
 	 .ops = &ctrl_ops,
 	 .id = V4L2_CID_EXPOSURE_ABSOLUTE,
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
index dc9a6d4f1824..a362eebd882f 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
@@ -571,7 +571,7 @@ static const struct v4l2_ctrl_ops ctrl_ops = {
 	.g_volatile_ctrl = ov2722_g_volatile_ctrl
 };
 
-struct v4l2_ctrl_config ov2722_controls[] = {
+static const struct v4l2_ctrl_config ov2722_controls[] = {
 	{
 	 .ops = &ctrl_ops,
 	 .id = V4L2_CID_EXPOSURE_ABSOLUTE,
diff --git a/drivers/staging/media/atomisp/i2c/gc0310.h b/drivers/staging/media/atomisp/i2c/gc0310.h
index af6b11f6e5e7..70c252c5163c 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.h
+++ b/drivers/staging/media/atomisp/i2c/gc0310.h
@@ -377,8 +377,7 @@ static struct gc0310_reg const gc0310_VGA_30fps[] = {
 	{GC0310_TOK_TERM, 0, 0},
 };
 
-
-struct gc0310_resolution gc0310_res_preview[] = {
+static struct gc0310_resolution gc0310_res_preview[] = {
 	{
 		.desc = "gc0310_VGA_30fps",
 		.width = 656, // 648,
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.h b/drivers/staging/media/atomisp/i2c/ov2722.h
index 028b04aaaa8f..757b37613ccc 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.h
+++ b/drivers/staging/media/atomisp/i2c/ov2722.h
@@ -1096,7 +1096,7 @@ static struct ov2722_reg const ov2722_720p_30fps[] = {
 	{OV2722_TOK_TERM, 0, 0},
 };
 
-struct ov2722_resolution ov2722_res_preview[] = {
+static struct ov2722_resolution ov2722_res_preview[] = {
 	{
 		.desc = "ov2722_1632_1092_30fps",
 		.width = 1632,
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index e3a2a63c52cb..714297c36b3e 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -955,7 +955,7 @@ static int ad5823_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
 	return ret;
 }
 
-int ad5823_t_focus_abs(struct v4l2_subdev *sd, s32 value)
+static int ad5823_t_focus_abs(struct v4l2_subdev *sd, s32 value)
 {
 	value = min(value, AD5823_MAX_FOCUS_POS);
 	return ad5823_t_focus_vcm(sd, value);
@@ -1136,7 +1136,7 @@ static const struct v4l2_ctrl_ops ctrl_ops = {
 	.g_volatile_ctrl = ov5693_g_volatile_ctrl
 };
 
-struct v4l2_ctrl_config ov5693_controls[] = {
+static const struct v4l2_ctrl_config ov5693_controls[] = {
 	{
 	 .ops = &ctrl_ops,
 	 .id = V4L2_CID_EXPOSURE_ABSOLUTE,
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
index 6d27dd849a62..9058a82455a6 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
@@ -1087,7 +1087,7 @@ static struct ov5693_reg const ov5693_2576x1936_30fps[] = {
 	{OV5693_TOK_TERM, 0, 0}
 };
 
-struct ov5693_resolution ov5693_res_preview[] = {
+static struct ov5693_resolution ov5693_res_preview[] = {
 	{
 		.desc = "ov5693_736x496_30fps",
 		.width = 736,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 2f6c88a0f4ee..b1efbd4d2828 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -5162,22 +5162,22 @@ static int __enable_continuous_mode(struct atomisp_sub_device *asd,
 	return atomisp_update_run_mode(asd);
 }
 
-int configure_pp_input_nop(struct atomisp_sub_device *asd,
-			   unsigned int width, unsigned int height)
+static int configure_pp_input_nop(struct atomisp_sub_device *asd,
+				  unsigned int width, unsigned int height)
 {
 	return 0;
 }
 
-int configure_output_nop(struct atomisp_sub_device *asd,
-			 unsigned int width, unsigned int height,
-			 unsigned int min_width,
-			 enum atomisp_css_frame_format sh_fmt)
+static int configure_output_nop(struct atomisp_sub_device *asd,
+				unsigned int width, unsigned int height,
+				unsigned int min_width,
+				enum atomisp_css_frame_format sh_fmt)
 {
 	return 0;
 }
 
-int get_frame_info_nop(struct atomisp_sub_device *asd,
-		       struct atomisp_css_frame_info *finfo)
+static int get_frame_info_nop(struct atomisp_sub_device *asd,
+			      struct atomisp_css_frame_info *finfo)
 {
 	return 0;
 }
@@ -6627,7 +6627,7 @@ int atomisp_inject_a_fake_event(struct atomisp_sub_device *asd, int *event)
 	return 0;
 }
 
-int atomisp_get_pipe_id(struct atomisp_video_pipe *pipe)
+static int atomisp_get_pipe_id(struct atomisp_video_pipe *pipe)
 {
 	struct atomisp_sub_device *asd = pipe->asd;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index b0e584b3cfc7..388b8a8a7009 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -88,7 +88,7 @@ unsigned int atomisp_css_debug_get_dtrace_level(void)
 	return ia_css_debug_trace_level;
 }
 
-void atomisp_css2_hw_store_8(hrt_address addr, uint8_t data)
+static void atomisp_css2_hw_store_8(hrt_address addr, uint8_t data)
 {
 	unsigned long flags;
 
@@ -126,7 +126,7 @@ static uint8_t atomisp_css2_hw_load_8(hrt_address addr)
 	return ret;
 }
 
-uint16_t atomisp_css2_hw_load_16(hrt_address addr)
+static uint16_t atomisp_css2_hw_load_16(hrt_address addr)
 {
 	unsigned long flags;
 	uint16_t ret;
@@ -136,7 +136,8 @@ uint16_t atomisp_css2_hw_load_16(hrt_address addr)
 	spin_unlock_irqrestore(&mmio_lock, flags);
 	return ret;
 }
-uint32_t atomisp_css2_hw_load_32(hrt_address addr)
+
+static uint32_t atomisp_css2_hw_load_32(hrt_address addr)
 {
 	unsigned long flags;
 	uint32_t ret;
@@ -2865,8 +2866,8 @@ static int __get_frame_info(struct atomisp_sub_device *asd,
 	return -EINVAL;
 }
 
-unsigned int atomisp_get_pipe_index(struct atomisp_sub_device *asd,
-					uint16_t source_pad)
+static unsigned int atomisp_get_pipe_index(struct atomisp_sub_device *asd,
+					   uint16_t source_pad)
 {
 	struct atomisp_device *isp = asd->isp;
 	/*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 4222724347cc..61bd550dafb9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -1607,10 +1607,12 @@ int atomisp_stream_on_master_slave_sensor(struct atomisp_device *isp,
 
 /* FIXME! */
 #ifndef ISP2401
-void __wdt_on_master_slave_sensor(struct atomisp_device *isp, unsigned int wdt_duration)
+static void __wdt_on_master_slave_sensor(struct atomisp_device *isp,
+					 unsigned int wdt_duration)
 #else
-void __wdt_on_master_slave_sensor(struct atomisp_video_pipe *pipe,
-				unsigned int wdt_duration, bool enable)
+static void __wdt_on_master_slave_sensor(struct atomisp_video_pipe *pipe,
+					 unsigned int wdt_duration,
+					 bool enable)
 #endif
 {
 #ifndef ISP2401
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter.c
index a8997e45738e..0e1ca995fb06 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_formatter.c
@@ -45,8 +45,9 @@ const uint8_t HIVE_IF_SWITCH_CODE[N_INPUT_FORMATTER_ID] = {
 	HIVE_INPUT_SWITCH_SELECT_STR_TO_MEM};
 
 /* MW Should be part of system_global.h, where we have the main enumeration */
-const bool HIVE_IF_BIN_COPY[N_INPUT_FORMATTER_ID] = {
-	false, false, false, true};
+static const bool HIVE_IF_BIN_COPY[N_INPUT_FORMATTER_ID] = {
+	false, false, false, true
+};
 
 void input_formatter_rst(
 	const input_formatter_ID_t		ID)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.c
index e775af51c0c0..78a113bfe8f1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.c
@@ -15,7 +15,7 @@
 #include "ia_css_debug.h"
 #include "ia_css_tdf.host.h"
 
-const int16_t g_pyramid[8][8] = {
+static const int16_t g_pyramid[8][8] = {
 {128, 384, 640, 896, 896, 640, 384, 128},
 {384, 1152, 1920, 2688, 2688, 1920, 1152, 384},
 {640, 1920, 3200, 4480, 4480, 3200, 1920, 640},
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c b/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c
index 4cbf907bd07b..c0212564b7c8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c
@@ -18,6 +18,7 @@
  */
 #include "type_support.h"
 #include "mmu/isp_mmu.h"
+#include "mmu/sh_mmu_mrfld.h"
 #include "memory_access/memory_access.h"
 #include "atomisp_compat.h"
 
-- 
2.14.3
