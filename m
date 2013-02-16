Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3551 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3BPJ27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:28:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/18] blackfin: replace V4L2_IN/OUT_CAP_CUSTOM_TIMINGS by DV_TIMINGS
Date: Sat, 16 Feb 2013 10:28:10 +0100
Message-Id: <9caf012071d9b8618638dbcd94176494a21afc12.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The use of V4L2_IN/OUT_CAP_CUSTOM_TIMINGS is obsolete, use DV_TIMINGS instead.
Note that V4L2_IN/OUT_CAP_CUSTOM_TIMINGS is just a #define for
V4L2_IN/OUT_CAP_DV_TIMINGS.

At some point in the future these CUSTOM_TIMINGS defines might be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
---
 arch/blackfin/mach-bf609/boards/ezkit.c        |    8 ++++----
 drivers/media/platform/blackfin/bfin_capture.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/mach-bf609/boards/ezkit.c b/arch/blackfin/mach-bf609/boards/ezkit.c
index 61c1f47..97d7016 100644
--- a/arch/blackfin/mach-bf609/boards/ezkit.c
+++ b/arch/blackfin/mach-bf609/boards/ezkit.c
@@ -936,19 +936,19 @@ static struct v4l2_input adv7842_inputs[] = {
 		.index = 2,
 		.name = "Component",
 		.type = V4L2_INPUT_TYPE_CAMERA,
-		.capabilities = V4L2_IN_CAP_CUSTOM_TIMINGS,
+		.capabilities = V4L2_IN_CAP_DV_TIMINGS,
 	},
 	{
 		.index = 3,
 		.name = "VGA",
 		.type = V4L2_INPUT_TYPE_CAMERA,
-		.capabilities = V4L2_IN_CAP_CUSTOM_TIMINGS,
+		.capabilities = V4L2_IN_CAP_DV_TIMINGS,
 	},
 	{
 		.index = 4,
 		.name = "HDMI",
 		.type = V4L2_INPUT_TYPE_CAMERA,
-		.capabilities = V4L2_IN_CAP_CUSTOM_TIMINGS,
+		.capabilities = V4L2_IN_CAP_DV_TIMINGS,
 	},
 };
 
@@ -1074,7 +1074,7 @@ static struct v4l2_output adv7511_outputs[] = {
 		.index = 0,
 		.name = "HDMI",
 		.type = V4L2_INPUT_TYPE_CAMERA,
-		.capabilities = V4L2_OUT_CAP_CUSTOM_TIMINGS,
+		.capabilities = V4L2_OUT_CAP_DV_TIMINGS,
 	},
 };
 
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 5f209d5..6691355 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -384,7 +384,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	params.ppi_control = bcap_dev->cfg->ppi_control;
 	params.int_mask = bcap_dev->cfg->int_mask;
 	if (bcap_dev->cfg->inputs[bcap_dev->cur_input].capabilities
-			& V4L2_IN_CAP_CUSTOM_TIMINGS) {
+			& V4L2_IN_CAP_DV_TIMINGS) {
 		struct v4l2_bt_timings *bt = &bcap_dev->dv_timings.bt;
 
 		params.hdelay = bt->hsync + bt->hbackporch;
@@ -1110,7 +1110,7 @@ static int bcap_probe(struct platform_device *pdev)
 		}
 		bcap_dev->std = std;
 	}
-	if (config->inputs[0].capabilities & V4L2_IN_CAP_CUSTOM_TIMINGS) {
+	if (config->inputs[0].capabilities & V4L2_IN_CAP_DV_TIMINGS) {
 		struct v4l2_dv_timings dv_timings;
 		ret = v4l2_subdev_call(bcap_dev->sd, video,
 				g_dv_timings, &dv_timings);
-- 
1.7.10.4

