Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58933 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdFCDK0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 23:10:26 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC PATCH v3 03/11] [media] vimc: common: Add vimc_ent_sd_* helper
Date: Fri,  2 Jun 2017 23:58:03 -0300
Message-Id: <1496458714-16834-4-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1496458714-16834-1-git-send-email-helen.koike@collabora.com>
References: <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
 <1496458714-16834-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As all the subdevices in the topology will be initialized in the same
way, to avoid code repetition the vimc_ent_sd_{register, unregister}
helper functions were created

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v3:
[media] vimc: Add vimc_ent_sd_* helper functions
	- add it in vimc-common.c instead in vimc-core.c
	- fix vimc_ent_sd_register, use function parameter to assign
	sd->entity.function instead of using a fixed value
	- rename commit to add the "common" tag

Changes in v2:
[media] vimc: Add vimc_ent_sd_* helper functions
	- Comments in vimc_ent_sd_init
	- Update vimc_ent_sd_init with upstream code as media_entity_pads_init
	(instead of media_entity_init), entity->function intead of entity->type
	- Add missing vimc_pads_cleanup in vimc_ent_sd_cleanup
	- remove subdevice v4l2_dev and dev fields
	- change unregister order in vimc_ent_sd_cleanup
	- rename vimc_ent_sd_{init,cleanup} to vimc_ent_sd_{register,unregister}
	- remove struct vimc_ent_subdevice, use ved and sd directly
	- don't impose struct vimc_sen_device to declare ved and sd struct first
	- add kernel docs


---
 drivers/media/platform/vimc/vimc-common.c | 66 +++++++++++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-common.h | 39 ++++++++++++++++++
 drivers/media/platform/vimc/vimc-sensor.c | 58 +++++----------------------
 3 files changed, 114 insertions(+), 49 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index 42f779a..3afbabd 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -219,3 +219,69 @@ struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
 
 	return pads;
 }
+
+static const struct media_entity_operations vimc_ent_sd_mops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+int vimc_ent_sd_register(struct vimc_ent_device *ved,
+			 struct v4l2_subdev *sd,
+			 struct v4l2_device *v4l2_dev,
+			 const char *const name,
+			 u32 function,
+			 u16 num_pads,
+			 const unsigned long *pads_flag,
+			 const struct v4l2_subdev_ops *sd_ops,
+			 void (*sd_destroy)(struct vimc_ent_device *))
+{
+	int ret;
+
+	/* Allocate the pads */
+	ved->pads = vimc_pads_init(num_pads, pads_flag);
+	if (IS_ERR(ved->pads))
+		return PTR_ERR(ved->pads);
+
+	/* Fill the vimc_ent_device struct */
+	ved->destroy = sd_destroy;
+	ved->ent = &sd->entity;
+
+	/* Initialize the subdev */
+	v4l2_subdev_init(sd, sd_ops);
+	sd->entity.function = function;
+	sd->entity.ops = &vimc_ent_sd_mops;
+	sd->owner = THIS_MODULE;
+	strlcpy(sd->name, name, sizeof(sd->name));
+	v4l2_set_subdevdata(sd, ved);
+
+	/* Expose this subdev to user space */
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	/* Initialize the media entity */
+	ret = media_entity_pads_init(&sd->entity, num_pads, ved->pads);
+	if (ret)
+		goto err_clean_pads;
+
+	/* Register the subdev with the v4l2 and the media framework */
+	ret = v4l2_device_register_subdev(v4l2_dev, sd);
+	if (ret) {
+		dev_err(v4l2_dev->dev,
+			"%s: subdev register failed (err=%d)\n",
+			name, ret);
+		goto err_clean_m_ent;
+	}
+
+	return 0;
+
+err_clean_m_ent:
+	media_entity_cleanup(&sd->entity);
+err_clean_pads:
+	vimc_pads_cleanup(ved->pads);
+	return ret;
+}
+
+void vimc_ent_sd_unregister(struct vimc_ent_device *ved, struct v4l2_subdev *sd)
+{
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(ved->ent);
+	vimc_pads_cleanup(ved->pads);
+}
diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 00d3da4..9ec361c 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -110,4 +110,43 @@ const struct vimc_pix_map *vimc_pix_map_by_code(u32 code);
  */
 const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat);
 
+/**
+ * vimc_ent_sd_register - initialize and register a subdev node
+ *
+ * @ved:	the vimc_ent_device struct to be initialize
+ * @sd:		the v4l2_subdev struct to be initialize and registered
+ * @v4l2_dev:	the v4l2 device to register the v4l2_subdev
+ * @name:	name of the sub-device. Please notice that the name must be
+ *		unique.
+ * @function:	media entity function defined by MEDIA_ENT_F_* macros
+ * @num_pads:	number of pads to initialize
+ * @pads_flag:	flags to use in each pad
+ * @sd_ops:	pointer to &struct v4l2_subdev_ops.
+ * @sd_destroy:	callback to destroy the node
+ *
+ * Helper function initialize and register the struct vimc_ent_device and struct
+ * v4l2_subdev which represents a subdev node in the topology
+ */
+int vimc_ent_sd_register(struct vimc_ent_device *ved,
+			 struct v4l2_subdev *sd,
+			 struct v4l2_device *v4l2_dev,
+			 const char *const name,
+			 u32 function,
+			 u16 num_pads,
+			 const unsigned long *pads_flag,
+			 const struct v4l2_subdev_ops *sd_ops,
+			 void (*sd_destroy)(struct vimc_ent_device *));
+
+/**
+ * vimc_ent_sd_register - initialize and register a subdev node
+ *
+ * @ved:	the vimc_ent_device struct to be initialize
+ * @sd:		the v4l2_subdev struct to be initialize and registered
+ *
+ * Helper function cleanup and unregister the struct vimc_ent_device and struct
+ * v4l2_subdev which represents a subdev node in the topology
+ */
+void vimc_ent_sd_unregister(struct vimc_ent_device *ved,
+			    struct v4l2_subdev *sd);
+
 #endif
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 2e83487..6386ac1 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -113,11 +113,6 @@ static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
 	.set_fmt		= vimc_sen_get_fmt,
 };
 
-/* media operations */
-static const struct media_entity_operations vimc_sen_mops = {
-	.link_validate = v4l2_subdev_link_validate,
-};
-
 static int vimc_sen_tpg_thread(void *data)
 {
 	struct vimc_sen_device *vsen = data;
@@ -217,9 +212,8 @@ static void vimc_sen_destroy(struct vimc_ent_device *ved)
 	struct vimc_sen_device *vsen =
 				container_of(ved, struct vimc_sen_device, ved);
 
+	vimc_ent_sd_unregister(ved, &vsen->sd);
 	tpg_free(&vsen->tpg);
-	v4l2_device_unregister_subdev(&vsen->sd);
-	media_entity_cleanup(ved->ent);
 	kfree(vsen);
 }
 
@@ -246,33 +240,12 @@ struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
 	if (!vsen)
 		return ERR_PTR(-ENOMEM);
 
-	/* Allocate the pads */
-	vsen->ved.pads = vimc_pads_init(num_pads, pads_flag);
-	if (IS_ERR(vsen->ved.pads)) {
-		ret = PTR_ERR(vsen->ved.pads);
-		goto err_free_vsen;
-	}
-
-	/* Fill the vimc_ent_device struct */
-	vsen->ved.destroy = vimc_sen_destroy;
-	vsen->ved.ent = &vsen->sd.entity;
-
-	/* Initialize the subdev */
-	v4l2_subdev_init(&vsen->sd, &vimc_sen_ops);
-	vsen->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
-	vsen->sd.entity.ops = &vimc_sen_mops;
-	vsen->sd.owner = THIS_MODULE;
-	strlcpy(vsen->sd.name, name, sizeof(vsen->sd.name));
-	v4l2_set_subdevdata(&vsen->sd, &vsen->ved);
-
-	/* Expose this subdev to user space */
-	vsen->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	/* Initialize the media entity */
-	ret = media_entity_pads_init(&vsen->sd.entity,
-				     num_pads, vsen->ved.pads);
+	/* Initialize ved and sd */
+	ret = vimc_ent_sd_register(&vsen->ved, &vsen->sd, v4l2_dev, name,
+				   MEDIA_ENT_F_CAM_SENSOR, num_pads, pads_flag,
+				   &vimc_sen_ops, vimc_sen_destroy);
 	if (ret)
-		goto err_clean_pads;
+		goto err_free_vsen;
 
 	/* Set the active frame format (this is hardcoded for now) */
 	vsen->mbus_format.width = 640;
@@ -288,25 +261,12 @@ struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
 		 vsen->mbus_format.height);
 	ret = tpg_alloc(&vsen->tpg, VIMC_SEN_FRAME_MAX_WIDTH);
 	if (ret)
-		goto err_clean_m_ent;
-
-	/* Register the subdev with the v4l2 and the media framework */
-	ret = v4l2_device_register_subdev(v4l2_dev, &vsen->sd);
-	if (ret) {
-		dev_err(vsen->sd.v4l2_dev->dev,
-			"%s: subdev register failed (err=%d)\n",
-			vsen->sd.name, ret);
-		goto err_free_tpg;
-	}
+		goto err_unregister_ent_sd;
 
 	return &vsen->ved;
 
-err_free_tpg:
-	tpg_free(&vsen->tpg);
-err_clean_m_ent:
-	media_entity_cleanup(&vsen->sd.entity);
-err_clean_pads:
-	vimc_pads_cleanup(vsen->ved.pads);
+err_unregister_ent_sd:
+	vimc_ent_sd_unregister(&vsen->ved,  &vsen->sd);
 err_free_vsen:
 	kfree(vsen);
 
-- 
2.7.4
