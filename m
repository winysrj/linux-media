Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2335 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3DNP1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 06/30] cx25821: fix log_status, querycap.
Date: Sun, 14 Apr 2013 17:27:02 +0200
Message-Id: <1365953246-8972-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

log_status shouldn't print LOG STATUS lines, the core does that already.

Fix querycap version number and add device_caps support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 8ff8fc2..7cd8885 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -923,21 +923,14 @@ static int vidioc_log_status(struct file *file, void *priv)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	struct cx25821_fh *fh = priv;
-	char name[32 + 2];
-
-	struct sram_channel *sram_ch = dev->channels[fh->channel_id]
-								.sram_channels;
+	struct sram_channel *sram_ch =
+		dev->channels[fh->channel_id].sram_channels;
 	u32 tmp = 0;
 
-	snprintf(name, sizeof(name), "%s/2", dev->name);
-	pr_info("%s/2: ============  START LOG STATUS  ============\n",
-		dev->name);
 	cx25821_call_all(dev, core, log_status);
 	tmp = cx_read(sram_ch->dma_ctl);
 	pr_info("Video input 0 is %s\n",
 		(tmp & 0x11) ? "streaming" : "stopped");
-	pr_info("%s/2: =============  END LOG STATUS  =============\n",
-		dev->name);
 	return 0;
 }
 
@@ -1027,13 +1020,19 @@ int cx25821_vidioc_querycap(struct file *file, void *priv,
 			    struct v4l2_capability *cap)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+	struct cx25821_fh *fh = priv;
+	const u32 cap_input = V4L2_CAP_VIDEO_CAPTURE |
+			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	const u32 cap_output = V4L2_CAP_VIDEO_OUTPUT;
 
 	strcpy(cap->driver, "cx25821");
 	strlcpy(cap->card, cx25821_boards[dev->board].name, sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
-	cap->version = CX25821_VERSION_CODE;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-		V4L2_CAP_STREAMING;
+	if (fh->channel_id >= VID_CHANNEL_NUM)
+		cap->device_caps = cap_output;
+	else
+		cap->device_caps = cap_input;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.10.4

