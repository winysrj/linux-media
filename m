Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbbHWUSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v7 11/44] [media] media: use entity.graph_obj.mdev instead of .parent
Date: Sun, 23 Aug 2015 17:17:28 -0300
Message-Id: <dc1be98277c46ddd87e431148fc7e332176828ab.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Javier Martinez Canillas <javier@osg.samsung.com>

The struct media_entity has a .parent field that stores a pointer
to the parent struct media_device. But recently a media_gobj was
embedded into the entities and since struct media_gojb already has
a pointer to a struct media_device in the .mdev field, the .parent
field becomes redundant and can be removed.

This patch replaces all the usage of .parent by .graph_obj.mdev so
that field will become unused and can be removed on a later patch.

No functional changes.

The transformation was made using the following coccinelle spatch:

@@
struct media_entity *me;
@@

- me->parent
+ me->graph_obj.mdev

@@
struct media_entity *link;
@@

- link->source->entity->parent
+ link->source->entity->graph_obj.mdev

@@
struct exynos_video_entity *ve;
@@

- ve->vdev.entity.parent
+ ve->vdev.entity.graph_obj.mdev

Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 0f3844470147..138b18416460 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -435,8 +435,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	int i;
 
 	/* Warn if we apparently re-register an entity */
-	WARN_ON(entity->parent != NULL);
-	entity->parent = mdev;
+	WARN_ON(entity->graph_obj.mdev != NULL);
+	entity->graph_obj.mdev = mdev;
 
 	spin_lock(&mdev->lock);
 	/* Initialize media_gobj embedded at the entity */
@@ -471,7 +471,7 @@ EXPORT_SYMBOL_GPL(media_device_register_entity);
 void media_device_unregister_entity(struct media_entity *entity)
 {
 	int i;
-	struct media_device *mdev = entity->parent;
+	struct media_device *mdev = entity->graph_obj.mdev;
 
 	if (mdev == NULL)
 		return;
@@ -484,7 +484,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 	media_gobj_remove(&entity->graph_obj);
 	list_del(&entity->list);
 	spin_unlock(&mdev->lock);
-	entity->parent = NULL;
+	entity->graph_obj.mdev = NULL;
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity);
 
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 35e52cd1fc5a..a23c93369a04 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -332,7 +332,7 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
 __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe)
 {
-	struct media_device *mdev = entity->parent;
+	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph graph;
 	struct media_entity *entity_err = entity;
 	int ret;
@@ -387,7 +387,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 
 			ret = entity->ops->link_validate(link);
 			if (ret < 0 && ret != -ENOIOCTLCMD) {
-				dev_dbg(entity->parent->dev,
+				dev_dbg(entity->graph_obj.mdev->dev,
 					"link validation failed for \"%s\":%u -> \"%s\":%u, error %d\n",
 					link->source->entity->name,
 					link->source->index,
@@ -401,7 +401,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 
 		if (!bitmap_full(active, entity->num_pads)) {
 			ret = -EPIPE;
-			dev_dbg(entity->parent->dev,
+			dev_dbg(entity->graph_obj.mdev->dev,
 				"\"%s\":%u must be connected by an enabled link\n",
 				entity->name,
 				(unsigned)find_first_zero_bit(
@@ -454,7 +454,7 @@ EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
  */
 void media_entity_pipeline_stop(struct media_entity *entity)
 {
-	struct media_device *mdev = entity->parent;
+	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph graph;
 
 	mutex_lock(&mdev->graph_mutex);
@@ -490,8 +490,8 @@ struct media_entity *media_entity_get(struct media_entity *entity)
 	if (entity == NULL)
 		return NULL;
 
-	if (entity->parent->dev &&
-	    !try_module_get(entity->parent->dev->driver->owner))
+	if (entity->graph_obj.mdev->dev &&
+	    !try_module_get(entity->graph_obj.mdev->dev->driver->owner))
 		return NULL;
 
 	return entity;
@@ -511,8 +511,8 @@ void media_entity_put(struct media_entity *entity)
 	if (entity == NULL)
 		return;
 
-	if (entity->parent->dev)
-		module_put(entity->parent->dev->driver->owner);
+	if (entity->graph_obj.mdev->dev)
+		module_put(entity->graph_obj.mdev->dev->driver->owner);
 }
 EXPORT_SYMBOL_GPL(media_entity_put);
 
@@ -561,7 +561,8 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	link->flags = flags;
 
 	/* Initialize graph object embedded at the new link */
-	media_gobj_init(source->parent, MEDIA_GRAPH_LINK, &link->graph_obj);
+	media_gobj_init(source->graph_obj.mdev, MEDIA_GRAPH_LINK,
+			&link->graph_obj);
 
 	/* Create the backlink. Backlinks are used to help graph traversal and
 	 * are not reported to userspace.
@@ -577,7 +578,8 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	backlink->flags = flags;
 
 	/* Initialize graph object embedded at the new link */
-	media_gobj_init(sink->parent, MEDIA_GRAPH_LINK, &backlink->graph_obj);
+	media_gobj_init(sink->graph_obj.mdev, MEDIA_GRAPH_LINK,
+			&backlink->graph_obj);
 
 	link->reverse = backlink;
 	backlink->reverse = link;
@@ -629,12 +631,12 @@ EXPORT_SYMBOL_GPL(__media_entity_remove_links);
 void media_entity_remove_links(struct media_entity *entity)
 {
 	/* Do nothing if the entity is not registered. */
-	if (entity->parent == NULL)
+	if (entity->graph_obj.mdev == NULL)
 		return;
 
-	mutex_lock(&entity->parent->graph_mutex);
+	mutex_lock(&entity->graph_obj.mdev->graph_mutex);
 	__media_entity_remove_links(entity);
-	mutex_unlock(&entity->parent->graph_mutex);
+	mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_entity_remove_links);
 
@@ -703,7 +705,7 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 	    (source->stream_count || sink->stream_count))
 		return -EBUSY;
 
-	mdev = source->parent;
+	mdev = source->graph_obj.mdev;
 
 	if (mdev->link_notify) {
 		ret = mdev->link_notify(link, flags,
@@ -724,9 +726,9 @@ int media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	int ret;
 
-	mutex_lock(&link->source->entity->parent->graph_mutex);
+	mutex_lock(&link->source->entity->graph_obj.mdev->graph_mutex);
 	ret = __media_entity_setup_link(link, flags);
-	mutex_unlock(&link->source->entity->parent->graph_mutex);
+	mutex_unlock(&link->source->entity->graph_obj.mdev->graph_mutex);
 
 	return ret;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index b7dc5ac66e36..3d9ccbf5f10f 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -288,7 +288,7 @@ static int isp_video_open(struct file *file)
 		goto rel_fh;
 
 	if (v4l2_fh_is_singular_file(file)) {
-		mutex_lock(&me->parent->graph_mutex);
+		mutex_lock(&me->graph_obj.mdev->graph_mutex);
 
 		ret = fimc_pipeline_call(ve, open, me, true);
 
@@ -296,7 +296,7 @@ static int isp_video_open(struct file *file)
 		if (ret == 0)
 			me->use_count++;
 
-		mutex_unlock(&me->parent->graph_mutex);
+		mutex_unlock(&me->graph_obj.mdev->graph_mutex);
 	}
 	if (!ret)
 		goto unlock;
@@ -312,7 +312,7 @@ static int isp_video_release(struct file *file)
 	struct fimc_isp *isp = video_drvdata(file);
 	struct fimc_is_video *ivc = &isp->video_capture;
 	struct media_entity *entity = &ivc->ve.vdev.entity;
-	struct media_device *mdev = entity->parent;
+	struct media_device *mdev = entity->graph_obj.mdev;
 
 	mutex_lock(&isp->video_lock);
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index e8f707d1729b..b2607da4ad14 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -500,7 +500,7 @@ static int fimc_lite_open(struct file *file)
 	    atomic_read(&fimc->out_path) != FIMC_IO_DMA)
 		goto unlock;
 
-	mutex_lock(&me->parent->graph_mutex);
+	mutex_lock(&me->graph_obj.mdev->graph_mutex);
 
 	ret = fimc_pipeline_call(&fimc->ve, open, me, true);
 
@@ -508,7 +508,7 @@ static int fimc_lite_open(struct file *file)
 	if (ret == 0)
 		me->use_count++;
 
-	mutex_unlock(&me->parent->graph_mutex);
+	mutex_unlock(&me->graph_obj.mdev->graph_mutex);
 
 	if (!ret) {
 		fimc_lite_clear_event_counters(fimc);
@@ -541,9 +541,9 @@ static int fimc_lite_release(struct file *file)
 		fimc_pipeline_call(&fimc->ve, close);
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
 
-		mutex_lock(&entity->parent->graph_mutex);
+		mutex_lock(&entity->graph_obj.mdev->graph_mutex);
 		entity->use_count--;
-		mutex_unlock(&entity->parent->graph_mutex);
+		mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
 	}
 
 	_vb2_fop_release(file, NULL);
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 3ba76940eef5..92dbade2fffc 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1046,7 +1046,7 @@ static int __fimc_md_modify_pipeline(struct media_entity *entity, bool enable)
 	return ret;
 }
 
-/* Locking: called with entity->parent->graph_mutex mutex held. */
+/* Locking: called with entity->graph_obj.mdev->graph_mutex mutex held. */
 static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
 {
 	struct media_entity *entity_err = entity;
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 03214541f149..9a69913b31cb 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -164,8 +164,8 @@ struct fimc_sensor_info *source_to_sensor_info(struct fimc_source_info *si)
 
 static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
 {
-	return me->parent == NULL ? NULL :
-		container_of(me->parent, struct fimc_md, media_dev);
+	return me->graph_obj.mdev == NULL ? NULL :
+		container_of(me->graph_obj.mdev, struct fimc_md, media_dev);
 }
 
 static inline struct fimc_md *notifier_to_fimc_md(struct v4l2_async_notifier *n)
@@ -175,12 +175,12 @@ static inline struct fimc_md *notifier_to_fimc_md(struct v4l2_async_notifier *n)
 
 static inline void fimc_md_graph_lock(struct exynos_video_entity *ve)
 {
-	mutex_lock(&ve->vdev.entity.parent->graph_mutex);
+	mutex_lock(&ve->vdev.entity.graph_obj.mdev->graph_mutex);
 }
 
 static inline void fimc_md_graph_unlock(struct exynos_video_entity *ve)
 {
-	mutex_unlock(&ve->vdev.entity.parent->graph_mutex);
+	mutex_unlock(&ve->vdev.entity.graph_obj.mdev->graph_mutex);
 }
 
 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 6351f35b0a65..aa13b17d19a0 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -787,7 +787,7 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
 	int change = use ? 1 : -1;
 	int ret;
 
-	mutex_lock(&entity->parent->graph_mutex);
+	mutex_lock(&entity->graph_obj.mdev->graph_mutex);
 
 	/* Apply use count to node. */
 	entity->use_count += change;
@@ -798,7 +798,7 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
 	if (ret < 0)
 		entity->use_count -= change;
 
-	mutex_unlock(&entity->parent->graph_mutex);
+	mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
 
 	return ret;
 }
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 6c89dc40df85..4c367352b1f7 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -226,7 +226,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
 {
 	struct media_entity_graph graph;
 	struct media_entity *entity = &video->video.entity;
-	struct media_device *mdev = entity->parent;
+	struct media_device *mdev = entity->graph_obj.mdev;
 	struct isp_video *far_end = NULL;
 
 	mutex_lock(&mdev->graph_mutex);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index debe4e539df6..1f94c1a54e00 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -409,7 +409,7 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 {
 	struct media_entity_graph graph;
 	struct media_entity *entity = &video->video.entity;
-	struct media_device *mdev = entity->parent;
+	struct media_device *mdev = entity->graph_obj.mdev;
 	unsigned int i;
 	int ret;
 
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index f7f9aa353a55..92e8116dc28f 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -181,7 +181,7 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 {
 	struct media_entity_graph graph;
 	struct media_entity *entity = &start->video.entity;
-	struct media_device *mdev = entity->parent;
+	struct media_device *mdev = entity->graph_obj.mdev;
 	unsigned int num_inputs = 0;
 	unsigned int num_outputs = 0;
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 61a8d5beff58..92573fa852a9 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -130,7 +130,7 @@ __vpfe_video_get_format(struct vpfe_video_device *video,
 static void vpfe_prepare_pipeline(struct vpfe_video_device *video)
 {
 	struct media_entity *entity = &video->video_dev.entity;
-	struct media_device *mdev = entity->parent;
+	struct media_device *mdev = entity->graph_obj.mdev;
 	struct vpfe_pipeline *pipe = &video->pipe;
 	struct vpfe_video_device *far_end = NULL;
 	struct media_entity_graph graph;
@@ -288,7 +288,7 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 	else
 		entity = &pipe->inputs[0]->video_dev.entity;
 
-	mdev = entity->parent;
+	mdev = entity->graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
 	media_entity_graph_walk_start(&graph, entity);
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -328,7 +328,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 	else
 		entity = &pipe->inputs[0]->video_dev.entity;
 
-	mdev = entity->parent;
+	mdev = entity->graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
 	media_entity_graph_walk_start(&graph, entity);
 
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 7226553ceb2f..40591963b42b 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -494,7 +494,7 @@ int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
 	int change = use ? 1 : -1;
 	int ret;
 
-	mutex_lock(&entity->parent->graph_mutex);
+	mutex_lock(&entity->graph_obj.mdev->graph_mutex);
 
 	/* Apply use count to node. */
 	entity->use_count += change;
@@ -505,7 +505,7 @@ int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
 	if (ret < 0)
 		entity->use_count -= change;
 
-	mutex_unlock(&entity->parent->graph_mutex);
+	mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
 
 	return ret;
 }
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 25e9e7a6b99d..45a3f2d778fc 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -207,7 +207,7 @@ iss_video_far_end(struct iss_video *video)
 {
 	struct media_entity_graph graph;
 	struct media_entity *entity = &video->video.entity;
-	struct media_device *mdev = entity->parent;
+	struct media_device *mdev = entity->graph_obj.mdev;
 	struct iss_video *far_end = NULL;
 
 	mutex_lock(&mdev->graph_mutex);
-- 
2.4.3

