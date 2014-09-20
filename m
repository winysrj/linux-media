Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4371 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbaITMmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/16] cx88: don't allow changes while vb2_is_busy
Date: Sat, 20 Sep 2014 14:41:48 +0200
Message-Id: <1411216911-7950-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make sure that changing the standard or format is not allowed while
one or more of the video, vbi or mpeg vb2 queues are busy.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c |  8 ++++++--
 drivers/media/pci/cx88/cx88-core.c      |  7 +++++++
 drivers/media/pci/cx88/cx88-video.c     | 14 +++++++++++---
 drivers/media/pci/cx88/cx88.h           | 13 +++++++++----
 4 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 13b8ed3..ff79782 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -855,6 +855,11 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core  *core = dev->core;
 
+	if (vb2_is_busy(&dev->vb2_mpegq))
+		return -EBUSY;
+	if (core->v4ldev && (vb2_is_busy(&core->v4ldev->vb2_vidq) ||
+			     vb2_is_busy(&core->v4ldev->vb2_vbiq)))
+		return -EBUSY;
 	vidioc_try_fmt_vid_cap(file, priv, f);
 	core->width = f->fmt.pix.width;
 	core->height = f->fmt.pix.height;
@@ -1002,8 +1007,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 
-	cx88_set_tvnorm(core, id);
-	return 0;
+	return cx88_set_tvnorm(core, id);
 }
 
 static const struct v4l2_file_operations mpeg_fops =
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index bbdbb58..9fa4acb 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -864,6 +864,13 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 	u32 bdelay,agcdelay,htotal;
 	u32 cxiformat, cxoformat;
 
+	if (norm == core->tvnorm)
+		return 0;
+	if (core->v4ldev && (vb2_is_busy(&core->v4ldev->vb2_vidq) ||
+			     vb2_is_busy(&core->v4ldev->vb2_vbiq)))
+		return -EBUSY;
+	if (core->dvbdev && vb2_is_busy(&core->dvbdev->vb2_mpegq))
+		return -EBUSY;
 	core->tvnorm = norm;
 	fsc8       = norm_fsc8(norm);
 	adc_clock  = xtal;
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index eadceeb..64d6a72 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -792,6 +792,10 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	if (0 != err)
 		return err;
+	if (vb2_is_busy(&dev->vb2_vidq) || vb2_is_busy(&dev->vb2_vbiq))
+		return -EBUSY;
+	if (core->dvbdev && vb2_is_busy(&core->dvbdev->vb2_mpegq))
+		return -EBUSY;
 	dev->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 	core->width = f->fmt.pix.width;
 	core->height = f->fmt.pix.height;
@@ -864,9 +868,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 
-	cx88_set_tvnorm(core, tvnorms);
-
-	return 0;
+	return cx88_set_tvnorm(core, tvnorms);
 }
 
 /* only one input in this sample driver */
@@ -1442,6 +1444,9 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
+	/* Maintain a reference so cx88-blackbird can query the 8800 device. */
+	core->v4ldev = dev;
+
 	/* initial device configuration */
 	mutex_lock(&core->lock);
 	cx88_set_tvnorm(core, core->tvnorm);
@@ -1544,6 +1549,7 @@ fail_unreg:
 	free_irq(pci_dev->irq, dev);
 	mutex_unlock(&core->lock);
 fail_core:
+	core->v4ldev = NULL;
 	cx88_core_put(core,dev->pci);
 fail_free:
 	kfree(dev);
@@ -1572,6 +1578,8 @@ static void cx8800_finidev(struct pci_dev *pci_dev)
 	free_irq(pci_dev->irq, dev);
 	cx8800_unregister_video(dev);
 
+	core->v4ldev = NULL;
+
 	/* free memory */
 	cx88_core_put(core,dev->pci);
 	kfree(dev);
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 93bc7cf..2fa4aa9 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -334,6 +334,9 @@ struct cx88_dmaqueue {
 	u32                    count;
 };
 
+struct cx8800_dev;
+struct cx8802_dev;
+
 struct cx88_core {
 	struct list_head           devlist;
 	atomic_t                   refcount;
@@ -401,8 +404,13 @@ struct cx88_core {
 	/* various v4l controls */
 	u32                        freq;
 
-	/* cx88-video needs to access cx8802 for hybrid tuner pll access. */
+	/*
+	 * cx88-video needs to access cx8802 for hybrid tuner pll access and
+	 * for vb2_is_busy() checks.
+	 */
 	struct cx8802_dev          *dvbdev;
+	/* cx88-blackbird needs to access cx8800 for vb2_is_busy() checks */
+	struct cx8800_dev          *v4ldev;
 	enum cx88_board_type       active_type_id;
 	int			   active_ref;
 	int			   active_fe_id;
@@ -456,9 +464,6 @@ static inline struct cx88_core *to_core(struct v4l2_device *v4l2_dev)
 		val;								\
 	})
 
-struct cx8800_dev;
-struct cx8802_dev;
-
 /* ----------------------------------------------------------- */
 /* function 0: video stuff                                     */
 
-- 
2.1.0

