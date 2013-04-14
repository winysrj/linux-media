Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2177 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3DNP2B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:28:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 23/30] cx25821: remove custom ioctls that duplicate v4l2 ioctls.
Date: Sun, 14 Apr 2013 17:27:19 +0200
Message-Id: <1365953246-8972-24-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

No idea why these custom ioctls exist: they have perfectly normal v4l2
counterparts which are already implemented.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |  128 ++---------------------------
 drivers/media/pci/cx25821/cx25821-video.h |    8 --
 drivers/media/pci/cx25821/cx25821.h       |   13 ---
 3 files changed, 6 insertions(+), 143 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index aec6fdf..d3aa166 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -1038,134 +1038,18 @@ static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
 	return 0;
 }
 
-static long video_ioctl_set(struct file *file, unsigned int cmd,
-			   unsigned long arg)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-	struct downstream_user_struct *data_from_user;
-	int command;
-	int width = 720;
-	int selected_channel = 0;
-	int pix_format = 0;
-	int i = 0;
-	int cif_enable = 0;
-	int cif_width = 0;
-
-	data_from_user = (struct downstream_user_struct *)arg;
-
-	if (!data_from_user) {
-		pr_err("%s(): User data is INVALID. Returning\n", __func__);
-		return 0;
-	}
-
-	command = data_from_user->command;
-
-	if (command != SET_VIDEO_STD && command != SET_PIXEL_FORMAT
-	   && command != ENABLE_CIF_RESOLUTION && command != REG_READ
-	   && command != REG_WRITE && command != MEDUSA_READ
-	   && command != MEDUSA_WRITE) {
-		return 0;
-	}
-
-	switch (command) {
-	case SET_VIDEO_STD:
-		if (!strcmp(data_from_user->vid_stdname, "PAL"))
-			dev->tvnorm = V4L2_STD_PAL_BG;
-		else
-			dev->tvnorm = V4L2_STD_NTSC_M;
-		medusa_set_videostandard(dev);
-		break;
-
-	case SET_PIXEL_FORMAT:
-		selected_channel = data_from_user->decoder_select;
-		pix_format = data_from_user->pixel_format;
-
-		if (!(selected_channel <= 7 && selected_channel >= 0)) {
-			selected_channel -= 4;
-			selected_channel = selected_channel % 8;
-		}
-
-		if (selected_channel >= 0)
-			cx25821_set_pixel_format(dev, selected_channel,
-						pix_format);
-
-		break;
-
-	case ENABLE_CIF_RESOLUTION:
-		selected_channel = data_from_user->decoder_select;
-		cif_enable = data_from_user->cif_resolution_enable;
-		cif_width = data_from_user->cif_width;
-
-		if (cif_enable) {
-			if (dev->tvnorm & V4L2_STD_PAL_BG
-			    || dev->tvnorm & V4L2_STD_PAL_DK) {
-				width = 352;
-			} else {
-				width = cif_width;
-				if (cif_width != 320 && cif_width != 352)
-					width = 320;
-			}
-		}
-
-		if (!(selected_channel <= 7 && selected_channel >= 0)) {
-			selected_channel -= 4;
-			selected_channel = selected_channel % 8;
-		}
-
-		if (selected_channel <= 7 && selected_channel >= 0) {
-			dev->channels[selected_channel].use_cif_resolution =
-				cif_enable;
-			dev->channels[selected_channel].cif_width = width;
-		} else {
-			for (i = 0; i < VID_CHANNEL_NUM; i++) {
-				dev->channels[i].use_cif_resolution =
-					cif_enable;
-				dev->channels[i].cif_width = width;
-			}
-		}
-
-		medusa_set_resolution(dev, width, selected_channel);
-		break;
-	case REG_READ:
-		data_from_user->reg_data = cx_read(data_from_user->reg_address);
-		break;
-	case REG_WRITE:
-		cx_write(data_from_user->reg_address, data_from_user->reg_data);
-		break;
-	case MEDUSA_READ:
-		cx25821_i2c_read(&dev->i2c_bus[0],
-					 (u16) data_from_user->reg_address,
-					 &data_from_user->reg_data);
-		break;
-	case MEDUSA_WRITE:
-		cx25821_i2c_write(&dev->i2c_bus[0],
-				  (u16) data_from_user->reg_address,
-				  data_from_user->reg_data);
-		break;
-	}
-
-	return 0;
-}
-
 static long cx25821_video_ioctl(struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
-	int ret = 0;
 
 	/* check to see if it's the video upstream */
-	if (chan->id == SRAM_CH09) {
-		ret = video_ioctl_upstream9(file, cmd, arg);
-		return ret;
-	} else if (chan->id == SRAM_CH10) {
-		ret = video_ioctl_upstream10(file, cmd, arg);
-		return ret;
-	} else if (chan->id == SRAM_CH11) {
-		ret = video_ioctl_upstream11(file, cmd, arg);
-		ret = video_ioctl_set(file, cmd, arg);
-		return ret;
-	}
+	if (chan->id == SRAM_CH09)
+		return video_ioctl_upstream9(file, cmd, arg);
+	if (chan->id == SRAM_CH10)
+		return video_ioctl_upstream10(file, cmd, arg);
+	if (chan->id == SRAM_CH11)
+		return video_ioctl_upstream11(file, cmd, arg);
 
 	return video_ioctl2(file, cmd, arg);
 }
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index eb54e53..8871c4e 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -55,14 +55,6 @@ do {									\
 #define UPSTREAM_START_AUDIO        702
 #define UPSTREAM_STOP_AUDIO         703
 #define UPSTREAM_DUMP_REGISTERS     702
-#define SET_VIDEO_STD               800
-#define SET_PIXEL_FORMAT            1000
-#define ENABLE_CIF_RESOLUTION       1001
-
-#define REG_READ		    900
-#define REG_WRITE		    901
-#define MEDUSA_READ		    910
-#define MEDUSA_WRITE		    911
 
 #define FORMAT_FLAGS_PACKED       0x01
 extern void cx25821_video_wakeup(struct cx25821_dev *dev,
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 40b16b0..cfda5ac 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -360,19 +360,6 @@ struct upstream_user_struct {
 	int command;
 };
 
-struct downstream_user_struct {
-	char *vid_stdname;
-	int pixel_format;
-	int cif_resolution_enable;
-	int cif_width;
-	int decoder_select;
-	int command;
-	int reg_address;
-	int reg_data;
-};
-
-extern struct upstream_user_struct *up_data;
-
 static inline struct cx25821_dev *get_cx25821(struct v4l2_device *v4l2_dev)
 {
 	return container_of(v4l2_dev, struct cx25821_dev, v4l2_dev);
-- 
1.7.10.4

