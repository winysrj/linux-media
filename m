Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:53187 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998Ab2IRKxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:31 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 11/11] davinci: move struct vpif_interface to chan_cfg.
Date: Tue, 18 Sep 2012 12:53:13 +0200
Message-Id: <f7d971bb87838632b6a94289e7c98546e51880a7.1347965140.git.hans.verkuil@cisco.com>
In-Reply-To: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
References: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
References: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct vpif_interface is channel specific, not subdev specific.
Move it to the channel config.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/mach-davinci/board-da850-evm.c    |   24 ++++++++++++------------
 arch/arm/mach-davinci/board-dm646x-evm.c   |   24 ++++++++++++------------
 drivers/media/video/davinci/vpif_capture.c |    2 +-
 include/media/davinci/vpif_types.h         |    2 +-
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 514d4d4..3081ea4 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1211,12 +1211,6 @@ static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
 			I2C_BOARD_INFO("tvp5146", 0x5d),
 			.platform_data = &tvp5146_pdata,
 		},
-		.vpif_if = {
-			.if_type = VPIF_IF_BT656,
-			.hd_pol  = 1,
-			.vd_pol  = 1,
-			.fid_pol = 0,
-		},
 	},
 	{
 		.name = TVP5147_CH1,
@@ -1224,12 +1218,6 @@ static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
 			I2C_BOARD_INFO("tvp5146", 0x5c),
 			.platform_data = &tvp5146_pdata,
 		},
-		.vpif_if = {
-			.if_type = VPIF_IF_BT656,
-			.hd_pol  = 1,
-			.vd_pol  = 1,
-			.fid_pol = 0,
-		},
 	},
 };
 
@@ -1239,10 +1227,22 @@ static struct vpif_capture_config da850_vpif_capture_config = {
 	.chan_config[0] = {
 		.inputs = da850_ch0_inputs,
 		.input_count = ARRAY_SIZE(da850_ch0_inputs),
+		.vpif_if = {
+			.if_type = VPIF_IF_BT656,
+			.hd_pol  = 1,
+			.vd_pol  = 1,
+			.fid_pol = 0,
+		},
 	},
 	.chan_config[1] = {
 		.inputs = da850_ch1_inputs,
 		.input_count = ARRAY_SIZE(da850_ch1_inputs),
+		.vpif_if = {
+			.if_type = VPIF_IF_BT656,
+			.hd_pol  = 1,
+			.vd_pol  = 1,
+			.fid_pol = 0,
+		},
 	},
 	.card_name = "DA850/OMAP-L138 Video Capture",
 };
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 0daec7e..ad249c7 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -601,12 +601,6 @@ static struct vpif_subdev_info vpif_capture_sdev_info[] = {
 			I2C_BOARD_INFO("tvp5146", 0x5d),
 			.platform_data = &tvp5146_pdata,
 		},
-		.vpif_if = {
-			.if_type = VPIF_IF_BT656,
-			.hd_pol = 1,
-			.vd_pol = 1,
-			.fid_pol = 0,
-		},
 	},
 	{
 		.name	= TVP5147_CH1,
@@ -614,12 +608,6 @@ static struct vpif_subdev_info vpif_capture_sdev_info[] = {
 			I2C_BOARD_INFO("tvp5146", 0x5c),
 			.platform_data = &tvp5146_pdata,
 		},
-		.vpif_if = {
-			.if_type = VPIF_IF_BT656,
-			.hd_pol = 1,
-			.vd_pol = 1,
-			.fid_pol = 0,
-		},
 	},
 };
 
@@ -659,10 +647,22 @@ static struct vpif_capture_config dm646x_vpif_capture_cfg = {
 	.chan_config[0] = {
 		.inputs = dm6467_ch0_inputs,
 		.input_count = ARRAY_SIZE(dm6467_ch0_inputs),
+		.vpif_if = {
+			.if_type = VPIF_IF_BT656,
+			.hd_pol = 1,
+			.vd_pol = 1,
+			.fid_pol = 0,
+		},
 	},
 	.chan_config[1] = {
 		.inputs = dm6467_ch1_inputs,
 		.input_count = ARRAY_SIZE(dm6467_ch1_inputs),
+		.vpif_if = {
+			.if_type = VPIF_IF_BT656,
+			.hd_pol = 1,
+			.vd_pol = 1,
+			.fid_pol = 0,
+		},
 	},
 };
 
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 5266167..466f02d 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -1295,7 +1295,7 @@ static int vpif_set_input(
 	ch->input_idx = index;
 	ch->sd = sd;
 	/* copy interface parameters to vpif */
-	ch->vpifparams.iface = subdev_info->vpif_if;
+	ch->vpifparams.iface = chan_cfg->vpif_if;
 
 	/* update tvnorms from the sub device input info */
 	ch->video_dev->tvnorms = chan_cfg->inputs[index].input.std;
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index a422ed0..65e8fe1 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -37,7 +37,6 @@ struct vpif_interface {
 struct vpif_subdev_info {
 	const char *name;
 	struct i2c_board_info board_info;
-	struct vpif_interface vpif_if;
 };
 
 struct vpif_display_config {
@@ -59,6 +58,7 @@ struct vpif_input {
 };
 
 struct vpif_capture_chan_config {
+	struct vpif_interface vpif_if;
 	const struct vpif_input *inputs;
 	int input_count;
 };
-- 
1.7.10.4

