Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:60497 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab2IRKx3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:29 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 05/11] vpif_capture: remove unnecessary can_route flag.
Date: Tue, 18 Sep 2012 12:53:07 +0200
Message-Id: <efb3f14ddf21ccf96eb76875344cac49605dd586.1347965140.git.hans.verkuil@cisco.com>
In-Reply-To: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
References: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
References: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling a subdev op that isn't implemented will just return -ENOIOCTLCMD
No need to have a flag for that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/mach-davinci/board-da850-evm.c    |    2 --
 arch/arm/mach-davinci/board-dm646x-evm.c   |    2 --
 drivers/media/video/davinci/vpif_capture.c |   18 ++++++++----------
 include/media/davinci/vpif_types.h         |    1 -
 4 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index d0954a2..d92e0ab 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1209,7 +1209,6 @@ static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
 		},
 		.input = INPUT_CVBS_VI2B,
 		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
-		.can_route = 1,
 		.vpif_if = {
 			.if_type = VPIF_IF_BT656,
 			.hd_pol  = 1,
@@ -1225,7 +1224,6 @@ static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
 		},
 		.input = INPUT_SVIDEO_VI2C_VI1C,
 		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
-		.can_route = 1,
 		.vpif_if = {
 			.if_type = VPIF_IF_BT656,
 			.hd_pol  = 1,
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 958679a..a0be63b 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -603,7 +603,6 @@ static struct vpif_subdev_info vpif_capture_sdev_info[] = {
 		},
 		.input = INPUT_CVBS_VI2B,
 		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
-		.can_route = 1,
 		.vpif_if = {
 			.if_type = VPIF_IF_BT656,
 			.hd_pol = 1,
@@ -619,7 +618,6 @@ static struct vpif_subdev_info vpif_capture_sdev_info[] = {
 		},
 		.input = INPUT_SVIDEO_VI2C_VI1C,
 		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
-		.can_route = 1,
 		.vpif_if = {
 			.if_type = VPIF_IF_BT656,
 			.hd_pol = 1,
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index eec687c..ae5cabf 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -1487,15 +1487,13 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 		}
 	}
 
-	if (subdev_info->can_route) {
-		input = subdev_info->input;
-		output = subdev_info->output;
-		ret = v4l2_subdev_call(vpif_obj.sd[sd_index], video, s_routing,
-					input, output, 0);
-		if (ret < 0) {
-			vpif_dbg(1, debug, "Failed to set input\n");
-			return ret;
-		}
+	input = subdev_info->input;
+	output = subdev_info->output;
+	ret = v4l2_subdev_call(vpif_obj.sd[sd_index], video, s_routing,
+			input, output, 0);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		vpif_dbg(1, debug, "Failed to set input\n");
+		return ret;
 	}
 	ch->input_idx = index;
 	ch->curr_subdev_info = subdev_info;
@@ -1505,7 +1503,7 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 
 	/* update tvnorms from the sub device input info */
 	ch->video_dev->tvnorms = chan_cfg->inputs[index].input.std;
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index d8f6ab1..1fe46a5 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -39,7 +39,6 @@ struct vpif_subdev_info {
 	struct i2c_board_info board_info;
 	u32 input;
 	u32 output;
-	unsigned can_route:1;
 	struct vpif_interface vpif_if;
 };
 
-- 
1.7.10.4

