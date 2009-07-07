Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52821 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbZGGMjA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2009 08:39:00 -0400
From: Chaithrika U S <chaithrika@ti.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com,
	Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH]: v4l: DaVinci: DM646x: Updates to VPIF display driver
Date: Tue,  7 Jul 2009 07:51:42 -0400
Message-Id: <1246967503-8525-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Minor fixes like change in the names of the standards,
remove inclusion of version.h in the header file.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
---
Applies to v4l-dvb repo

 drivers/media/video/davinci/vpif_display.c |   16 +++++-----------
 drivers/media/video/davinci/vpif_display.h |    1 -
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 969d4b3..0fba8d8 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -85,11 +85,11 @@ static struct device *vpif_dev;
 
 static const struct vpif_channel_config_params ch_params[] = {
 	{
-		"NTSC", 720, 480, 30, 0, 1, 268, 1440, 1, 23, 263, 266,
+		"NTSC_M", 720, 480, 30, 0, 1, 268, 1440, 1, 23, 263, 266,
 		286, 525, 525, 0, 1, 0, V4L2_STD_525_60,
 	},
 	{
-		"PAL", 720, 576, 25, 0, 1, 280, 1440, 1, 23, 311, 313,
+		"PAL_BDGHIK", 720, 576, 25, 0, 1, 280, 1440, 1, 23, 311, 313,
 		336, 624, 625, 0, 1, 0, V4L2_STD_625_50,
 	},
 };
@@ -390,6 +390,7 @@ static int vpif_get_std_info(struct channel_obj *ch)
 		config = &ch_params[index];
 		if (config->stdid & std_info->stdid) {
 			memcpy(std_info, config, sizeof(*config));
+			std_info->stdid = vid_ch->stdid & config->stdid;
 			break;
 		}
 	}
@@ -997,6 +998,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 		return -EINVAL;
 	}
 
+	*std_id = ch->vpifparams.std_info.stdid;
 	if ((ch->vpifparams.std_info.width *
 		ch->vpifparams.std_info.height * 2) >
 		config_params.channel_bufsize[ch->channel_id]) {
@@ -1395,7 +1397,7 @@ static int initialize_vpif(void)
 	/* Allocate memory for six channel objects */
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		vpif_obj.dev[i] =
-		    kmalloc(sizeof(struct channel_obj), GFP_KERNEL);
+		    kzalloc(sizeof(struct channel_obj), GFP_KERNEL);
 		/* If memory allocation fails, return error */
 		if (!vpif_obj.dev[i]) {
 			free_channel_objects_index = i;
@@ -1511,20 +1513,12 @@ static __init int vpif_probe(struct platform_device *pdev)
 		/* Initialize field of the channel objects */
 		atomic_set(&ch->usrs, 0);
 		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
-			ch->common[k].numbuffers = 0;
 			common = &ch->common[k];
-			common->io_usrs = 0;
-			common->started = 0;
 			spin_lock_init(&common->irqlock);
 			mutex_init(&common->lock);
-			common->numbuffers = 0;
 			common->set_addr = NULL;
-			common->ytop_off = common->ybtm_off = 0;
-			common->ctop_off = common->cbtm_off = 0;
 			common->cur_frm = common->next_frm = NULL;
-			memset(&common->fmt, 0, sizeof(common->fmt));
 			common->numbuffers = config_params.numbuffers[k];
-
 		}
 		ch->initialized = 0;
 		ch->channel_id = j;
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index a2a7cd1..14efb89 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -18,7 +18,6 @@
 
 /* Header files */
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
-- 
1.5.6

