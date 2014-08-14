Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1409 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaHNJyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 01/20] cx23885: fix querycap
Date: Thu, 14 Aug 2014 11:53:46 +0200
Message-Id: <1408010045-24016-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set device_caps to fix the v4l2-compliance QUERYCAP complaints.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 91e4cb4..2666ac4 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1146,19 +1146,22 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_querycap(struct file *file, void  *priv,
 	struct v4l2_capability *cap)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
 
 	strcpy(cap->driver, "cx23885");
 	strlcpy(cap->card, cx23885_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
-	cap->capabilities =
-		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE     |
-		V4L2_CAP_STREAMING     |
-		V4L2_CAP_VBI_CAPTURE;
+	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	if (dev->tuner_type != TUNER_ABSENT)
-		cap->capabilities |= V4L2_CAP_TUNER;
+		cap->device_caps |= V4L2_CAP_TUNER;
+	if (vdev->vfl_type == VFL_TYPE_VBI)
+		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
+	else
+		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_VBI_CAPTURE |
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
2.1.0.rc1

