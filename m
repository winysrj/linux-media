Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2404 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaHNJyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 09/20] cx23885: drop radio-related dead code
Date: Thu, 14 Aug 2014 11:53:54 +0200
Message-Id: <1408010045-24016-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Currently no radio device nodes are ever created, so remove the dead radio
code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 15 +++------------
 drivers/media/pci/cx23885/cx23885.h       |  3 ---
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 9bb19fd..50694c6 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -49,15 +49,12 @@ MODULE_LICENSE("GPL");
 
 static unsigned int video_nr[] = {[0 ... (CX23885_MAXBOARDS - 1)] = UNSET };
 static unsigned int vbi_nr[]   = {[0 ... (CX23885_MAXBOARDS - 1)] = UNSET };
-static unsigned int radio_nr[] = {[0 ... (CX23885_MAXBOARDS - 1)] = UNSET };
 
 module_param_array(video_nr, int, NULL, 0444);
 module_param_array(vbi_nr,   int, NULL, 0444);
-module_param_array(radio_nr, int, NULL, 0444);
 
 MODULE_PARM_DESC(video_nr, "video device numbers");
 MODULE_PARM_DESC(vbi_nr, "vbi device numbers");
-MODULE_PARM_DESC(radio_nr, "radio device numbers");
 
 static unsigned int video_debug;
 module_param(video_debug, int, 0644);
@@ -727,7 +724,6 @@ static int video_open(struct file *file)
 	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh;
 	enum v4l2_buf_type type = 0;
-	int radio = 0;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
@@ -736,13 +732,10 @@ static int video_open(struct file *file)
 	case VFL_TYPE_VBI:
 		type = V4L2_BUF_TYPE_VBI_CAPTURE;
 		break;
-	case VFL_TYPE_RADIO:
-		radio = 1;
-		break;
 	}
 
-	dprintk(1, "open dev=%s radio=%d type=%s\n",
-		video_device_node_name(vdev), radio, v4l2_type_names[type]);
+	dprintk(1, "open dev=%s type=%s\n",
+		video_device_node_name(vdev), v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
@@ -752,7 +745,6 @@ static int video_open(struct file *file)
 	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = &fh->fh;
 	fh->dev      = dev;
-	fh->radio    = radio;
 	fh->type     = type;
 	fh->width    = 320;
 	fh->height   = 240;
@@ -1333,8 +1325,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
 
-	/* f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV; */
-	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	f->type = V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->freq;
 
 	call_all(dev, tuner, g_frequency, f);
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 2d57af7..94ab000 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -144,7 +144,6 @@ struct cx23885_fh {
 	struct v4l2_fh		   fh;
 	struct cx23885_dev         *dev;
 	enum v4l2_buf_type         type;
-	int                        radio;
 	u32                        resources;
 
 	/* video overlay */
@@ -413,7 +412,6 @@ struct cx23885_dev {
 	unsigned int               tuner_bus;
 	unsigned int               radio_type;
 	unsigned char              radio_addr;
-	unsigned int               has_radio;
 	struct v4l2_subdev 	   *sd_cx25840;
 	struct work_struct	   cx25840_work;
 
@@ -431,7 +429,6 @@ struct cx23885_dev {
 	u32                        freq;
 	struct video_device        *video_dev;
 	struct video_device        *vbi_dev;
-	struct video_device        *radio_dev;
 
 	struct cx23885_dmaqueue    vidq;
 	struct cx23885_dmaqueue    vbiq;
-- 
2.1.0.rc1

