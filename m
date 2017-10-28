Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:55421 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbdJ1UlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 16:41:14 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 7/9] media: staging/imx: convert static vdev lists to list_head
Date: Sat, 28 Oct 2017 13:36:47 -0700
Message-Id: <1509223009-6392-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
References: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Although not technically necessary because imx-media has only a
maximum of 8 video devices, and once setup the video device lists
are static, in anticipation of moving control ineritance to
v4l2-core, make the vdev lists more generic by converting to
dynamic list_head's.

After doing that, 'struct imx_media_pad' is now just a list_head
of video devices reachable from a pad. Allocate an array of list_head's,
one list_head for each pad, and attach that array to sd->host_priv.
An entry in the pad lists is of type 'struct imx_media_pad_vdev', and
points to a video device from the master list.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-capture.c |  2 +
 drivers/staging/media/imx/imx-media-dev.c     | 77 +++++++++++++++------------
 drivers/staging/media/imx/imx-media-utils.c   | 16 +-----
 drivers/staging/media/imx/imx-media.h         | 39 +++++++-------
 4 files changed, 68 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index ea145ba..def3df2 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -754,6 +754,8 @@ imx_media_capture_device_init(struct v4l2_subdev *src_sd, int pad)
 	vfd->queue = &priv->q;
 	priv->vdev.vfd = vfd;
 
+	INIT_LIST_HEAD(&priv->vdev.list);
+
 	video_set_drvdata(vfd, priv);
 
 	v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 40c7cfd..b6acddb 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -229,10 +229,11 @@ static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
 				     struct media_pad *srcpad)
 {
 	struct media_entity *entity = srcpad->entity;
-	struct imx_media_pad *imxpad;
+	struct imx_media_pad_vdev *pad_vdev;
+	struct list_head *pad_vdev_list;
 	struct media_link *link;
 	struct v4l2_subdev *sd;
-	int i, vdev_idx, ret;
+	int i, ret;
 
 	/* skip this entity if not a v4l2_subdev */
 	if (!is_media_entity_v4l2_subdev(entity))
@@ -240,8 +241,8 @@ static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
 
 	sd = media_entity_to_v4l2_subdev(entity);
 
-	imxpad = to_imx_media_pad(sd, srcpad->index);
-	if (!imxpad) {
+	pad_vdev_list = to_pad_vdev_list(sd, srcpad->index);
+	if (!pad_vdev_list) {
 		v4l2_warn(&imxmd->v4l2_dev, "%s:%u has no vdev list!\n",
 			  entity->name, srcpad->index);
 		/*
@@ -251,23 +252,22 @@ static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
 		return 0;
 	}
 
-	vdev_idx = imxpad->num_vdevs;
-
 	/* just return if we've been here before */
-	for (i = 0; i < vdev_idx; i++)
-		if (vdev == imxpad->vdev[i])
+	list_for_each_entry(pad_vdev, pad_vdev_list, list) {
+		if (pad_vdev->vdev == vdev)
 			return 0;
-
-	if (vdev_idx >= IMX_MEDIA_MAX_VDEVS) {
-		dev_err(imxmd->md.dev, "can't add %s to pad %s:%u\n",
-			vdev->vfd->entity.name, entity->name, srcpad->index);
-		return -ENOSPC;
 	}
 
 	dev_dbg(imxmd->md.dev, "adding %s to pad %s:%u\n",
 		vdev->vfd->entity.name, entity->name, srcpad->index);
-	imxpad->vdev[vdev_idx] = vdev;
-	imxpad->num_vdevs++;
+
+	pad_vdev = devm_kzalloc(imxmd->md.dev, sizeof(*pad_vdev), GFP_KERNEL);
+	if (!pad_vdev)
+		return -ENOMEM;
+
+	/* attach this vdev to this pad */
+	pad_vdev->vdev = vdev;
+	list_add_tail(&pad_vdev->list, pad_vdev_list);
 
 	/* move upstream from this entity's sink pads */
 	for (i = 0; i < entity->num_pads; i++) {
@@ -289,22 +289,32 @@ static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
 	return 0;
 }
 
+/*
+ * For every subdevice, allocate an array of list_head's, one list_head
+ * for each pad, to hold the list of video devices reachable from that
+ * pad.
+ */
 static int imx_media_alloc_pad_vdev_lists(struct imx_media_dev *imxmd)
 {
-	struct imx_media_pad *imxpads;
+	struct list_head *vdev_lists;
 	struct media_entity *entity;
 	struct v4l2_subdev *sd;
+	int i;
 
 	list_for_each_entry(sd, &imxmd->v4l2_dev.subdevs, list) {
 		entity = &sd->entity;
-		imxpads = devm_kzalloc(imxmd->md.dev,
-				       entity->num_pads * sizeof(*imxpads),
-				       GFP_KERNEL);
-		if (!imxpads)
+		vdev_lists = devm_kzalloc(
+			imxmd->md.dev,
+			entity->num_pads * sizeof(*vdev_lists),
+			GFP_KERNEL);
+		if (!vdev_lists)
 			return -ENOMEM;
 
-		/* attach imxpads to the subdev's host private pointer */
-		sd->host_priv = imxpads;
+		/* attach to the subdev's host private pointer */
+		sd->host_priv = vdev_lists;
+
+		for (i = 0; i < entity->num_pads; i++)
+			INIT_LIST_HEAD(to_pad_vdev_list(sd, i));
 	}
 
 	return 0;
@@ -315,14 +325,13 @@ static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
 {
 	struct imx_media_video_dev *vdev;
 	struct media_link *link;
-	int i, ret;
+	int ret;
 
 	ret = imx_media_alloc_pad_vdev_lists(imxmd);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < imxmd->num_vdevs; i++) {
-		vdev = imxmd->vdev[i];
+	list_for_each_entry(vdev, &imxmd->vdev_list, list) {
 		link = list_first_entry(&vdev->vfd->entity.links,
 					struct media_link, list);
 		ret = imx_media_add_vdev_to_pad(imxmd, vdev, link->source);
@@ -405,11 +414,12 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 				 unsigned int notification)
 {
 	struct media_entity *source = link->source->entity;
-	struct imx_media_pad *imxpad;
+	struct imx_media_pad_vdev *pad_vdev;
+	struct list_head *pad_vdev_list;
 	struct imx_media_dev *imxmd;
 	struct video_device *vfd;
 	struct v4l2_subdev *sd;
-	int i, pad_idx, ret;
+	int pad_idx, ret;
 
 	ret = v4l2_pipeline_link_notify(link, flags, notification);
 	if (ret)
@@ -424,8 +434,8 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 
 	imxmd = dev_get_drvdata(sd->v4l2_dev->dev);
 
-	imxpad = to_imx_media_pad(sd, pad_idx);
-	if (!imxpad) {
+	pad_vdev_list = to_pad_vdev_list(sd, pad_idx);
+	if (!pad_vdev_list) {
 		/* shouldn't happen, but no reason to fail link setup */
 		return 0;
 	}
@@ -439,8 +449,8 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 	 */
 	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
 	    !(flags & MEDIA_LNK_FL_ENABLED)) {
-		for (i = 0; i < imxpad->num_vdevs; i++) {
-			vfd = imxpad->vdev[i]->vfd;
+		list_for_each_entry(pad_vdev, pad_vdev_list, list) {
+			vfd = pad_vdev->vdev->vfd;
 			dev_dbg(imxmd->md.dev,
 				"reset controls for %s\n",
 				vfd->entity.name);
@@ -449,8 +459,8 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 		}
 	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
 		   (link->flags & MEDIA_LNK_FL_ENABLED)) {
-		for (i = 0; i < imxpad->num_vdevs; i++) {
-			vfd = imxpad->vdev[i]->vfd;
+		list_for_each_entry(pad_vdev, pad_vdev_list, list) {
+			vfd = pad_vdev->vdev->vfd;
 			dev_dbg(imxmd->md.dev,
 				"refresh controls for %s\n",
 				vfd->entity.name);
@@ -505,6 +515,7 @@ static int imx_media_probe(struct platform_device *pdev)
 	dev_set_drvdata(imxmd->v4l2_dev.dev, imxmd);
 
 	INIT_LIST_HEAD(&imxmd->asd_list);
+	INIT_LIST_HEAD(&imxmd->vdev_list);
 
 	ret = imx_media_add_of_subdevs(imxmd, node);
 	if (ret) {
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index e143a88..13dafa7 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -705,24 +705,12 @@ EXPORT_SYMBOL_GPL(imx_media_find_subdev_by_devname);
 int imx_media_add_video_device(struct imx_media_dev *imxmd,
 			       struct imx_media_video_dev *vdev)
 {
-	int vdev_idx, ret = 0;
-
 	mutex_lock(&imxmd->mutex);
 
-	vdev_idx = imxmd->num_vdevs;
-	if (vdev_idx >= IMX_MEDIA_MAX_VDEVS) {
-		dev_err(imxmd->md.dev,
-			"%s: too many video devices! can't add %s\n",
-			__func__, vdev->vfd->name);
-		ret = -ENOSPC;
-		goto out;
-	}
+	list_add_tail(&vdev->list, &imxmd->vdev_list);
 
-	imxmd->vdev[vdev_idx] = vdev;
-	imxmd->num_vdevs++;
-out:
 	mutex_unlock(&imxmd->mutex);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(imx_media_add_video_device);
 
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 042de92..79d7958 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -19,9 +19,6 @@
 #include <media/videobuf2-dma-contig.h>
 #include <video/imx-ipu-v3.h>
 
-/* max video devices */
-#define IMX_MEDIA_MAX_VDEVS          8
-
 /*
  * Pad definitions for the subdevs with multiple source or
  * sink pads
@@ -82,6 +79,9 @@ struct imx_media_video_dev {
 	/* the user format */
 	struct v4l2_format fmt;
 	const struct imx_media_pixfmt *cc;
+
+	/* links this vdev to master list */
+	struct list_head list;
 };
 
 static inline struct imx_media_buffer *to_imx_media_vb(struct vb2_buffer *vb)
@@ -91,24 +91,26 @@ static inline struct imx_media_buffer *to_imx_media_vb(struct vb2_buffer *vb)
 	return container_of(vbuf, struct imx_media_buffer, vbuf);
 }
 
-/* to support control inheritance to video devices */
-struct imx_media_pad {
-	/*
-	 * list of video devices that can be reached from this pad,
-	 * list is only valid for source pads.
-	 */
-	struct imx_media_video_dev *vdev[IMX_MEDIA_MAX_VDEVS];
-	int num_vdevs;
-};
-
-static inline struct imx_media_pad *
-to_imx_media_pad(struct v4l2_subdev *sd, int pad_index)
+/*
+ * to support control inheritance to video devices, this
+ * retrieves a pad's list_head of video devices that can
+ * be reached from the pad. Note that only the lists in
+ * source pads get populated, sink pads have empty lists.
+ */
+static inline struct list_head *
+to_pad_vdev_list(struct v4l2_subdev *sd, int pad_index)
 {
-	struct imx_media_pad *imxpads = sd->host_priv;
+	struct list_head *vdev_list = sd->host_priv;
 
-	return imxpads ? &imxpads[pad_index] : NULL;
+	return vdev_list ? &vdev_list[pad_index] : NULL;
 }
 
+/* an entry in a pad's video device list */
+struct imx_media_pad_vdev {
+	struct imx_media_video_dev *vdev;
+	struct list_head list;
+};
+
 struct imx_media_internal_sd_platformdata {
 	char sd_name[V4L2_SUBDEV_NAME_SIZE];
 	u32 grp_id;
@@ -139,8 +141,7 @@ struct imx_media_dev {
 	struct mutex mutex; /* protect elements below */
 
 	/* master video device list */
-	struct imx_media_video_dev *vdev[IMX_MEDIA_MAX_VDEVS];
-	int num_vdevs;
+	struct list_head vdev_list;
 
 	/* IPUs this media driver control, valid after subdevs bound */
 	struct ipu_soc *ipu[2];
-- 
2.7.4
