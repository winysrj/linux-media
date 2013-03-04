Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4432 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3CDJFr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:05:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/11] davinci/vpbe_display: remove deprecated current_norm.
Date: Mon,  4 Mar 2013 10:05:02 +0100
Message-Id: <02cb33521404120c6c8262187514fd9b3ec3eab3.1362387265.git.hans.verkuil@cisco.com>
In-Reply-To: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
References: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
References: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since vpbe_display already provides a g_std op setting current_norm
didn't do anything. Remove that code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpbe_display.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 1f59955..a9e90b0 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1176,10 +1176,6 @@ vpbe_display_s_dv_timings(struct file *file, void *priv,
 			"Failed to set the dv timings info\n");
 		return -EINVAL;
 	}
-	/* set the current norm to zero to be consistent. If STD is used
-	 * v4l2 layer will set the norm properly on successful s_std call
-	 */
-	layer->video_dev.current_norm = 0;
 
 	return 0;
 }
@@ -1693,12 +1689,8 @@ static int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
 	vbd->vfl_dir	= VFL_DIR_TX;
 
 	if (disp_dev->vpbe_dev->current_timings.timings_type &
-			VPBE_ENC_STD) {
+			VPBE_ENC_STD)
 		vbd->tvnorms = (V4L2_STD_525_60 | V4L2_STD_625_50);
-		vbd->current_norm =
-			disp_dev->vpbe_dev->current_timings.std_id;
-	} else
-		vbd->current_norm = 0;
 
 	snprintf(vbd->name, sizeof(vbd->name),
 			"DaVinci_VPBE Display_DRIVER_V%d.%d.%d",
-- 
1.7.10.4

