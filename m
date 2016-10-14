Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48625 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754525AbcJNRrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 23/25] [media] cx2341x: mark printk continuation lines as such
Date: Fri, 14 Oct 2016 14:46:01 -0300
Message-Id: <744e602144d08b09e58634892550d333cb0c3631.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has printk continuation lines for debugging purposes.

Since commit 563873318d32 ("Merge branch 'printk-cleanups'"),
this won't work as expected anymore. So, let's add KERN_CONT to
those lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/cx2341x.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/cx2341x.c b/drivers/media/common/cx2341x.c
index 5e4afa0131e6..2725702eda7b 100644
--- a/drivers/media/common/cx2341x.c
+++ b/drivers/media/common/cx2341x.c
@@ -1190,8 +1190,8 @@ void cx2341x_log_status(const struct cx2341x_mpeg_params *p, const char *prefix)
 		prefix,
 		cx2341x_menu_item(p, V4L2_CID_MPEG_STREAM_TYPE));
 	if (p->stream_insert_nav_packets)
-		printk(" (with navigation packets)");
-	printk("\n");
+		printk(KERN_CONT " (with navigation packets)");
+	printk(KERN_CONT "\n");
 	printk(KERN_INFO "%s: VBI Format: %s\n",
 		prefix,
 		cx2341x_menu_item(p, V4L2_CID_MPEG_STREAM_VBI_FMT));
@@ -1209,8 +1209,8 @@ void cx2341x_log_status(const struct cx2341x_mpeg_params *p, const char *prefix)
 		cx2341x_menu_item(p, V4L2_CID_MPEG_VIDEO_BITRATE_MODE),
 		p->video_bitrate);
 	if (p->video_bitrate_mode == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR)
-		printk(", Peak %d", p->video_bitrate_peak);
-	printk("\n");
+		printk(KERN_CONT ", Peak %d", p->video_bitrate_peak);
+	printk(KERN_CONT "\n");
 	printk(KERN_INFO
 		"%s: Video:  GOP Size %d, %d B-Frames, %sGOP Closure\n",
 		prefix,
@@ -1232,9 +1232,9 @@ void cx2341x_log_status(const struct cx2341x_mpeg_params *p, const char *prefix)
 		cx2341x_menu_item(p, V4L2_CID_MPEG_AUDIO_MODE),
 		p->audio_mute ? " (muted)" : "");
 	if (p->audio_mode == V4L2_MPEG_AUDIO_MODE_JOINT_STEREO)
-		printk(", %s", cx2341x_menu_item(p,
+		printk(KERN_CONT ", %s", cx2341x_menu_item(p,
 				V4L2_CID_MPEG_AUDIO_MODE_EXTENSION));
-	printk(", %s, %s\n",
+	printk(KERN_CONT ", %s, %s\n",
 		cx2341x_menu_item(p, V4L2_CID_MPEG_AUDIO_EMPHASIS),
 		cx2341x_menu_item(p, V4L2_CID_MPEG_AUDIO_CRC));
 
-- 
2.7.4


