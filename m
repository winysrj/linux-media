Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60658 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967795AbaLLN3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:29:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/7] cx25821: remove video output support
Date: Fri, 12 Dec 2014 14:28:00 +0100
Message-Id: <1418390880-39009-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
References: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The video output functionality never worked for this driver. Now remove the
creation of the output video nodes as well to prevent users from thinking
that video output is available, when it isn't.

To correctly implement this the video output should use vb2 as well, and
that requires rewriting the output DMA setup. But without hardware to test
I am not able to do that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/Makefile        | 2 +-
 drivers/media/pci/cx25821/cx25821-core.c  | 6 +++++-
 drivers/media/pci/cx25821/cx25821-video.c | 2 +-
 drivers/media/pci/cx25821/cx25821.h       | 7 +++++++
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx25821/Makefile b/drivers/media/pci/cx25821/Makefile
index 5872feb..c8f8598 100644
--- a/drivers/media/pci/cx25821/Makefile
+++ b/drivers/media/pci/cx25821/Makefile
@@ -1,6 +1,6 @@
 cx25821-y   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
 		       cx25821-gpio.o cx25821-medusa-video.o \
-		       cx25821-video.o cx25821-video-upstream.o
+		       cx25821-video.o
 
 obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
 obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index c1ea24e..559f829 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -965,11 +965,15 @@ void cx25821_dev_unregister(struct cx25821_dev *dev)
 
 	release_mem_region(dev->base_io_addr, pci_resource_len(dev->pci, 0));
 
-	for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; i++) {
+	for (i = 0; i < MAX_VID_CAP_CHANNEL_NUM - 1; i++) {
 		if (i == SRAM_CH08) /* audio channel */
 			continue;
+		/*
+		 * TODO: enable when video output is properly
+		 * supported.
 		if (i == SRAM_CH09 || i == SRAM_CH10)
 			cx25821_free_mem_upstream(&dev->channels[i]);
+		 */
 		cx25821_video_unregister(dev, i);
 	}
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 827c3c0..7bc495e 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -692,7 +692,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 
 	spin_lock_init(&dev->slock);
 
-	for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; ++i) {
+	for (i = 0; i < MAX_VID_CAP_CHANNEL_NUM - 1; ++i) {
 		struct cx25821_channel *chan = &dev->channels[i];
 		struct video_device *vdev = &chan->vdev;
 		struct v4l2_ctrl_handler *hdl = &chan->hdl;
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 34c5ff1..d81a08a 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -88,6 +88,13 @@
 
 #define CX25821_BOARD_CONEXANT_ATHENA10 1
 #define MAX_VID_CHANNEL_NUM     12
+
+/*
+ * Maximum capture-only channels. This can go away once video/audio output
+ * is fully supported in this driver.
+ */
+#define MAX_VID_CAP_CHANNEL_NUM     10
+
 #define VID_CHANNEL_NUM 8
 
 struct cx25821_fmt {
-- 
2.1.3

