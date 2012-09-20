Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4856 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2ITMHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 06/14] vpif_capture: move routing info from subdev to input.
Date: Thu, 20 Sep 2012 14:06:25 +0200
Message-Id: <dedef717b23ad46abe8b0446bc16d8031128a670.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
References: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Routing information is a property of the input, not of the subdev.
One subdev may provide multiple inputs, each with its own routing
information.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/mach-davinci/board-da850-evm.c       |    8 ++++----
 arch/arm/mach-davinci/board-dm646x-evm.c      |    8 ++++----
 drivers/media/platform/davinci/vpif_capture.c |    7 +++++--
 include/media/davinci/vpif_types.h            |    4 ++--
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index d92e0ab..514d4d4 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1184,6 +1184,8 @@ static const struct vpif_input da850_ch0_inputs[] = {
 			.type  = V4L2_INPUT_TYPE_CAMERA,
 			.std   = TVP514X_STD_ALL,
 		},
+		.input_route = INPUT_CVBS_VI2B,
+		.output_route = OUTPUT_10BIT_422_EMBEDDED_SYNC,
 		.subdev_name = TVP5147_CH0,
 	},
 };
@@ -1196,6 +1198,8 @@ static const struct vpif_input da850_ch1_inputs[] = {
 			.type  = V4L2_INPUT_TYPE_CAMERA,
 			.std   = TVP514X_STD_ALL,
 		},
+		.input_route = INPUT_SVIDEO_VI2C_VI1C,
+		.output_route = OUTPUT_10BIT_422_EMBEDDED_SYNC,
 		.subdev_name = TVP5147_CH1,
 	},
 };
@@ -1207,8 +1211,6 @@ static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
 			I2C_BOARD_INFO("tvp5146", 0x5d),
 			.platform_data = &tvp5146_pdata,
 		},
-		.input = INPUT_CVBS_VI2B,
-		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
 		.vpif_if = {
 			.if_type = VPIF_IF_BT656,
 			.hd_pol  = 1,
@@ -1222,8 +1224,6 @@ static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
 			I2C_BOARD_INFO("tvp5146", 0x5c),
 			.platform_data = &tvp5146_pdata,
 		},
-		.input = INPUT_SVIDEO_VI2C_VI1C,
-		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
 		.vpif_if = {
 			.if_type = VPIF_IF_BT656,
 			.hd_pol  = 1,
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index a0be63b..0daec7e 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -601,8 +601,6 @@ static struct vpif_subdev_info vpif_capture_sdev_info[] = {
 			I2C_BOARD_INFO("tvp5146", 0x5d),
 			.platform_data = &tvp5146_pdata,
 		},
-		.input = INPUT_CVBS_VI2B,
-		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
 		.vpif_if = {
 			.if_type = VPIF_IF_BT656,
 			.hd_pol = 1,
@@ -616,8 +614,6 @@ static struct vpif_subdev_info vpif_capture_sdev_info[] = {
 			I2C_BOARD_INFO("tvp5146", 0x5c),
 			.platform_data = &tvp5146_pdata,
 		},
-		.input = INPUT_SVIDEO_VI2C_VI1C,
-		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
 		.vpif_if = {
 			.if_type = VPIF_IF_BT656,
 			.hd_pol = 1,
@@ -636,6 +632,8 @@ static const struct vpif_input dm6467_ch0_inputs[] = {
 			.std = TVP514X_STD_ALL,
 		},
 		.subdev_name = TVP5147_CH0,
+		.input_route = INPUT_CVBS_VI2B,
+		.output_route = OUTPUT_10BIT_422_EMBEDDED_SYNC,
 	},
 };
 
@@ -648,6 +646,8 @@ static const struct vpif_input dm6467_ch1_inputs[] = {
 			.std = TVP514X_STD_ALL,
 		},
 		.subdev_name = TVP5147_CH1,
+		.input_route = INPUT_SVIDEO_VI2C_VI1C,
+		.output_route = OUTPUT_10BIT_422_EMBEDDED_SYNC,
 	},
 };
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 81ad6a2..e40eacd1 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1464,6 +1464,9 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 
+	if (index >= chan_cfg->input_count)
+		return -EINVAL;
+
 	if (common->started) {
 		vpif_err("Streaming in progress\n");
 		return -EBUSY;
@@ -1502,8 +1505,8 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 		}
 	}
 
-	input = subdev_info->input;
-	output = subdev_info->output;
+	input = chan_cfg->inputs[index].input_route;
+	output = chan_cfg->inputs[index].output_route;
 	ret = v4l2_subdev_call(vpif_obj.sd[sd_index], video, s_routing,
 			input, output, 0);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index 1fe46a5..a422ed0 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -37,8 +37,6 @@ struct vpif_interface {
 struct vpif_subdev_info {
 	const char *name;
 	struct i2c_board_info board_info;
-	u32 input;
-	u32 output;
 	struct vpif_interface vpif_if;
 };
 
@@ -56,6 +54,8 @@ struct vpif_display_config {
 struct vpif_input {
 	struct v4l2_input input;
 	const char *subdev_name;
+	u32 input_route;
+	u32 output_route;
 };
 
 struct vpif_capture_chan_config {
-- 
1.7.10.4

