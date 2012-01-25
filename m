Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40589 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab2AYPFl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:05:41 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id q0PF5d12020854
	for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 09:05:40 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 1/4] davinci: vpif: add check for genuine interrupts in the isr
Date: Wed, 25 Jan 2012 20:35:31 +0530
Message-ID: <1327503934-28186-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
References: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add a condition to in the isr to check for interrupt ownership and
channel number to make sure we do not service wrong interrupts.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpif_capture.c |    5 +++++
 drivers/media/video/davinci/vpif_display.c |    5 +++++
 include/media/davinci/vpif_types.h         |    2 ++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 6504e40..33d865d 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -333,6 +333,7 @@ static void vpif_schedule_next_buffer(struct common_obj *common)
  */
 static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 {
+	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct vpif_device *dev = &vpif_obj;
 	struct common_obj *common;
 	struct channel_obj *ch;
@@ -341,6 +342,10 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	int fid = -1, i;
 
 	channel_id = *(int *)(dev_id);
+	if (!config->intr_status ||
+			!config->intr_status(vpif_base, channel_id))
+		return IRQ_NONE;
+
 	ch = dev->dev[channel_id];
 
 	field = ch->common[VPIF_VIDEO_INDEX].fmt.fmt.pix.field;
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 286f029..b315ccf 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -301,6 +301,7 @@ static void process_interlaced_mode(int fid, struct common_obj *common)
  */
 static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 {
+	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct vpif_device *dev = &vpif_obj;
 	struct channel_obj *ch;
 	struct common_obj *common;
@@ -309,6 +310,10 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	int channel_id = 0;
 
 	channel_id = *(int *)(dev_id);
+	if (!config->intr_status ||
+		!config->intr_status(vpif_base, channel_id + 2))
+		return IRQ_NONE;
+
 	ch = dev->dev[channel_id];
 	field = ch->common[VPIF_VIDEO_INDEX].fmt.fmt.pix.field;
 	for (i = 0; i < VPIF_NUMOBJECTS; i++) {
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index 9929b05..4802d06 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -43,6 +43,7 @@ struct vpif_subdev_info {
 
 struct vpif_display_config {
 	int (*set_clock)(int, int);
+	int (*intr_status)(void __iomem *vpif_base, int);
 	struct vpif_subdev_info *subdevinfo;
 	int subdev_count;
 	const char **output;
@@ -63,6 +64,7 @@ struct vpif_capture_chan_config {
 struct vpif_capture_config {
 	int (*setup_input_channel_mode)(int);
 	int (*setup_input_path)(int, const char *);
+	int (*intr_status)(void __iomem *vpif_base, int);
 	struct vpif_capture_chan_config chan_config[VPIF_CAPTURE_MAX_CHANNELS];
 	struct vpif_subdev_info *subdev_info;
 	int subdev_count;
-- 
1.6.2.4

