Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1552 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaF0OP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 10:15:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: it@sca-uk.com, =stoth@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] cx23885: fix UNSET/TUNER_ABSENT confusion.
Date: Fri, 27 Jun 2014 16:15:41 +0200
Message-Id: <1403878542-1230-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1403878542-1230-1-git-send-email-hverkuil@xs4all.nl>
References: <1403878542-1230-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Sometimes dev->tuner_type is compared to UNSET, sometimes to TUNER_ABSENT,
but these defines have different values.

Standardize to TUNER_ABSENT.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   |  8 ++++----
 drivers/media/pci/cx23885/cx23885-video.c | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 95666ee..bf89fc8 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1266,7 +1266,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	struct cx23885_fh  *fh  = file->private_data;
 	struct cx23885_dev *dev = fh->dev;
 
-	if (UNSET == dev->tuner_type)
+	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
 	if (0 != t->index)
 		return -EINVAL;
@@ -1284,7 +1284,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	struct cx23885_fh  *fh  = file->private_data;
 	struct cx23885_dev *dev = fh->dev;
 
-	if (UNSET == dev->tuner_type)
+	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
 
 	/* Update the A/V core */
@@ -1299,7 +1299,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct cx23885_fh  *fh  = file->private_data;
 	struct cx23885_dev *dev = fh->dev;
 
-	if (UNSET == dev->tuner_type)
+	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
 	f->type = V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->freq;
@@ -1347,7 +1347,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		V4L2_CAP_READWRITE     |
 		V4L2_CAP_STREAMING     |
 		0;
-	if (UNSET != dev->tuner_type)
+	if (dev->tuner_type != TUNER_ABSENT)
 		cap->capabilities |= V4L2_CAP_TUNER;
 
 	return 0;
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index e0a5952..2a890e9 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1156,7 +1156,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		V4L2_CAP_READWRITE     |
 		V4L2_CAP_STREAMING     |
 		V4L2_CAP_VBI_CAPTURE;
-	if (UNSET != dev->tuner_type)
+	if (dev->tuner_type != TUNER_ABSENT)
 		cap->capabilities |= V4L2_CAP_TUNER;
 	return 0;
 }
@@ -1474,7 +1474,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 
-	if (unlikely(UNSET == dev->tuner_type))
+	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
 	if (0 != t->index)
 		return -EINVAL;
@@ -1490,7 +1490,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 
-	if (UNSET == dev->tuner_type)
+	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
 	if (0 != t->index)
 		return -EINVAL;
@@ -1506,7 +1506,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct cx23885_fh *fh = priv;
 	struct cx23885_dev *dev = fh->dev;
 
-	if (unlikely(UNSET == dev->tuner_type))
+	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
 
 	/* f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV; */
@@ -1522,7 +1522,7 @@ static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency
 {
 	struct v4l2_control ctrl;
 
-	if (unlikely(UNSET == dev->tuner_type))
+	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
-- 
2.0.0

