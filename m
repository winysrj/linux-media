Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44514 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409AbbCIQeq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:34:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/19] saa7146: embed video_device
Date: Mon,  9 Mar 2015 17:33:57 +0100
Message-Id: <1425918853-12371-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146/saa7146_fops.c | 19 ++++---------------
 drivers/media/pci/saa7146/hexium_gemini.c   |  2 +-
 drivers/media/pci/saa7146/hexium_orion.c    |  2 +-
 drivers/media/pci/saa7146/mxb.c             |  4 ++--
 drivers/media/pci/ttpci/av7110.h            |  4 ++--
 drivers/media/pci/ttpci/budget-av.c         |  2 +-
 include/media/saa7146_vv.h                  |  4 ++--
 7 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index b7d6393..df1e8c9 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -587,26 +587,20 @@ int saa7146_vv_release(struct saa7146_dev* dev)
 }
 EXPORT_SYMBOL_GPL(saa7146_vv_release);
 
-int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
+int saa7146_register_device(struct video_device *vfd, struct saa7146_dev *dev,
 			    char *name, int type)
 {
-	struct video_device *vfd;
 	int err;
 	int i;
 
 	DEB_EE("dev:%p, name:'%s', type:%d\n", dev, name, type);
 
-	// released by vfd->release
-	vfd = video_device_alloc();
-	if (vfd == NULL)
-		return -ENOMEM;
-
 	vfd->fops = &video_fops;
 	if (type == VFL_TYPE_GRABBER)
 		vfd->ioctl_ops = &dev->ext_vv_data->vid_ops;
 	else
 		vfd->ioctl_ops = &dev->ext_vv_data->vbi_ops;
-	vfd->release = video_device_release;
+	vfd->release = video_device_release_empty;
 	vfd->lock = &dev->v4l2_lock;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->tvnorms = 0;
@@ -618,25 +612,20 @@ int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
 	err = video_register_device(vfd, type, -1);
 	if (err < 0) {
 		ERR("cannot register v4l2 device. skipping.\n");
-		video_device_release(vfd);
 		return err;
 	}
 
 	pr_info("%s: registered device %s [v4l2]\n",
 		dev->name, video_device_node_name(vfd));
-
-	*vid = vfd;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(saa7146_register_device);
 
-int saa7146_unregister_device(struct video_device **vid, struct saa7146_dev* dev)
+int saa7146_unregister_device(struct video_device *vfd, struct saa7146_dev *dev)
 {
 	DEB_EE("dev:%p\n", dev);
 
-	video_unregister_device(*vid);
-	*vid = NULL;
-
+	video_unregister_device(vfd);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(saa7146_unregister_device);
diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index 366434f..03cbcd2 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -66,7 +66,7 @@ struct hexium
 {
 	int type;
 
-	struct video_device	*video_dev;
+	struct video_device	video_dev;
 	struct i2c_adapter	i2c_adapter;
 
 	int 		cur_input;	/* current input */
diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
index a1eb26d..15f0d66 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -63,7 +63,7 @@ struct hexium_data
 struct hexium
 {
 	int type;
-	struct video_device	*video_dev;
+	struct video_device	video_dev;
 	struct i2c_adapter	i2c_adapter;
 
 	int cur_input;	/* current input */
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index c4c8fce..0ca1e07 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -151,8 +151,8 @@ static struct mxb_routing TEA6420_line[MXB_AUDIOS + 1][2] = {
 
 struct mxb
 {
-	struct video_device	*video_dev;
-	struct video_device	*vbi_dev;
+	struct video_device	video_dev;
+	struct video_device	vbi_dev;
 
 	struct i2c_adapter	i2c_adapter;
 
diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
index ef3d960..835635b 100644
--- a/drivers/media/pci/ttpci/av7110.h
+++ b/drivers/media/pci/ttpci/av7110.h
@@ -102,8 +102,8 @@ struct av7110 {
 	struct dvb_device	dvb_dev;
 	struct dvb_net		dvb_net;
 
-	struct video_device	*v4l_dev;
-	struct video_device	*vbi_dev;
+	struct video_device	v4l_dev;
+	struct video_device	vbi_dev;
 
 	struct saa7146_dev	*dev;
 
diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index 0ba3875..54c9910 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -68,7 +68,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct budget_av {
 	struct budget budget;
-	struct video_device *vd;
+	struct video_device vd;
 	int cur_input;
 	int has_saa7113;
 	struct tasklet_struct ciintf_irq_tasklet;
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index 944ecdf..92766f7 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -178,8 +178,8 @@ struct saa7146_use_ops  {
 };
 
 /* from saa7146_fops.c */
-int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev, char *name, int type);
-int saa7146_unregister_device(struct video_device **vid, struct saa7146_dev* dev);
+int saa7146_register_device(struct video_device *vid, struct saa7146_dev *dev, char *name, int type);
+int saa7146_unregister_device(struct video_device *vid, struct saa7146_dev *dev);
 void saa7146_buffer_finish(struct saa7146_dev *dev, struct saa7146_dmaqueue *q, int state);
 void saa7146_buffer_next(struct saa7146_dev *dev, struct saa7146_dmaqueue *q,int vbi);
 int saa7146_buffer_queue(struct saa7146_dev *dev, struct saa7146_dmaqueue *q, struct saa7146_buf *buf);
-- 
2.1.4

