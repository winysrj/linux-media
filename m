Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53804 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbbHKMJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 08:09:24 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH RFC v2 09/16] media: use media_graph_obj for link endpoints
Date: Tue, 11 Aug 2015 09:09:15 -0300
Message-Id: <6d02794028ea4f7ad33e3ba0e07e0c690e2feee2.1439292977.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439292977.git.mchehab@osg.samsung.com>
References: <cover.1439292977.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we'll need to create links between entities and interfaces,
we need to identify the link endpoints by the media_graph_obj.

Most of the changes here was done by this small script:

for i in `find drivers/media -type f` `find drivers/staging/media -type f`; do
	perl -ne 's,([\w]+)\-\>(source|sink)\-\>entity,gobj_to_pad($1->$2)->entity,; print $_;' <$i >a && mv a $i
done

Please note that, while we're now using graph_obj to reference
the link endpoints, we're still assuming that all endpoints are
pads. This is true for all existing links, so no problems
are expected so far.

Yet, as we introduce links between entities and interfaces,
we may need to change some existing code to work with links
that aren't pad to pad.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 842b9c8f80c6..4de93d6b203e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -635,7 +635,9 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 
 	for (i = 0; i < entity->num_links; i++) {
 		link = &entity->links[i];
-		if (link->sink->entity == entity) {
+		if (link->sink.type != MEDIA_GRAPH_PAD)
+			continue;
+		if (gobj_to_pad(link->sink)->entity == entity) {
 			found_link = link;
 			n_links++;
 			if (link->flags & MEDIA_LNK_FL_ENABLED)
@@ -658,14 +660,16 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	source = found_link->source->entity;
+	source = gobj_to_pad(found_link->source)->entity;
 	fepriv->pipe_start_entity = source;
 	for (i = 0; i < source->num_links; i++) {
 		struct media_entity *sink;
 		int flags = 0;
 
 		link = &source->links[i];
-		sink = link->sink->entity;
+		if (link->sink.type != MEDIA_GRAPH_PAD)
+			continue;
+		sink = gobj_to_pad(link->sink)->entity;
 
 		if (sink == entity)
 			flags = MEDIA_LNK_FL_ENABLED;
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index a95ca981aabb..40597e9a0ff0 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -155,14 +155,19 @@ static long __media_device_enum_links(struct media_device *mdev,
 		list_for_each_entry(ent_link, &entity->links, list) {
 			struct media_link_desc link;
 
+			/* Only PAD to PAD links should be enumerated with legacy API */
+			if (ent_link->source->type != MEDIA_GRAPH_PAD ||
+			    ent_link->sink->type != MEDIA_GRAPH_PAD)
+				continue;
+
 			/* Ignore backlinks. */
-			if (ent_link->source->entity != entity)
+			if (gobj_to_pad(ent_link->source)->entity != entity)
 				continue;
 
 			memset(&link, 0, sizeof(link));
-			media_device_kpad_to_upad(ent_link->source,
+			media_device_kpad_to_upad(gobj_to_pad(ent_link->source),
 						  &link.source);
-			media_device_kpad_to_upad(ent_link->sink,
+			media_device_kpad_to_upad(gobj_to_pad(ent_link->sink),
 						  &link.sink);
 			link.flags = ent_link->flags;
 			if (copy_to_user(ulink, &link, sizeof(*ulink)))
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4a42ccfeffab..c8bbf122f4a6 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -121,10 +121,15 @@ EXPORT_SYMBOL_GPL(media_entity_cleanup);
 static struct media_entity *
 media_entity_other(struct media_entity *entity, struct media_link *link)
 {
-	if (link->source->entity == entity)
-		return link->sink->entity;
+	/* For now, we only do graph traversal with PADs */
+	if (link->sink->type != MEDIA_GRAPH_PAD ||
+	    link->source->type != MEDIA_GRAPH_PAD)
+		return NULL;
+
+	if (gobj_to_pad(link->source)->entity == entity)
+		return gobj_to_pad(link->sink)->entity;
 	else
-		return link->source->entity;
+		return gobj_to_pad(link->source)->entity;
 }
 
 /* push an entity to traversal stack */
@@ -217,6 +222,10 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 		/* Get the entity in the other end of the link . */
 		next = media_entity_other(entity, link);
+		if (!next) {
+			list_rotate_left(&link_top(graph));
+			continue;
+		}
 		if (WARN_ON(next->id >= MEDIA_ENTITY_ENUM_MAX_ID))
 			return NULL;
 
@@ -285,8 +294,16 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		bitmap_fill(has_no_links, entity->num_pads);
 
 		list_for_each_entry(link, &entity->links, list) {
-			struct media_pad *pad = link->sink->entity == entity
+			struct media_graph_obj *gobj;
+			struct media_pad *pad;
+
+			/* For now, ignore interface<->entity links */
+			if (link->sink->type != MEDIA_GRAPH_PAD)
+				continue;
+
+			gobj = gobj_to_pad(link->sink)->entity == entity
 						? link->sink : link->source;
+			pad = gobj_to_pad(gobj);
 
 			/* Mark that a pad is connected by a link. */
 			bitmap_clear(has_no_links, pad->index, 1);
@@ -304,7 +321,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			 * Link validation will only take place for
 			 * sink ends of the link that are enabled.
 			 */
-			if (link->sink != pad ||
+			if (link->sink != gobj ||
 			    !(link->flags & MEDIA_LNK_FL_ENABLED))
 				continue;
 
@@ -312,9 +329,10 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			if (ret < 0 && ret != -ENOIOCTLCMD) {
 				dev_dbg(entity->parent->dev,
 					"link validation failed for \"%s\":%u -> \"%s\":%u, error %d\n",
-					entity->name, link->source->index,
-					link->sink->entity->name,
-					link->sink->index, ret);
+					entity->name,
+					gobj_to_pad(link->source)->index,
+					gobj_to_pad(link->sink)->entity->name,
+					gobj_to_pad(link->sink)->index, ret);
 				goto error;
 			}
 		}
@@ -477,8 +495,8 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 	if (link == NULL)
 		return -ENOMEM;
 
-	link->source = &source->pads[source_pad];
-	link->sink = &sink->pads[sink_pad];
+	link->source = &source->pads[source_pad].graph_obj;
+	link->sink = &sink->pads[sink_pad].graph_obj;
 	link->flags = flags;
 
 	/* Create the backlink. Backlinks are used to help graph traversal and
@@ -490,8 +508,8 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 		return -ENOMEM;
 	}
 
-	backlink->source = &source->pads[source_pad];
-	backlink->sink = &sink->pads[sink_pad];
+	backlink->source = &source->pads[source_pad].graph_obj;
+	backlink->sink = &sink->pads[sink_pad].graph_obj;
 	backlink->flags = flags;
 
 	link->reverse = backlink;
@@ -510,10 +528,10 @@ static void __media_entity_remove_link(struct media_entity *entity,
 	struct media_entity *remote;
 	unsigned int r = 0;
 
-	if (link->source->entity == entity)
-		remote = link->sink->entity;
+	if (gobj_to_pad(link->source)->entity == entity)
+		remote = gobj_to_pad(link->sink)->entity;
 	else
-		remote = link->source->entity;
+		remote = gobj_to_pad(link->source)->entity;
 
 	list_for_each_entry_safe(rlink, tmp, &remote->links, list) {
 		if (rlink != link->reverse) {
@@ -521,7 +539,7 @@ static void __media_entity_remove_link(struct media_entity *entity,
 			continue;
 		}
 
-		if (link->source->entity == entity)
+		if (gobj_to_pad(link->source)->entity == entity)
 			remote->num_backlinks--;
 
 		if (--remote->num_links == 0)
@@ -564,16 +582,19 @@ static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
 	int ret;
 
 	/* Notify both entities. */
-	ret = media_entity_call(link->source->entity, link_setup,
-				link->source, link->sink, flags);
+	ret = media_entity_call(gobj_to_pad(link->source)->entity, link_setup,
+				gobj_to_pad(link->source),
+				gobj_to_pad(link->sink), flags);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		return ret;
 
-	ret = media_entity_call(link->sink->entity, link_setup,
-				link->sink, link->source, flags);
+	ret = media_entity_call(gobj_to_pad(link->sink)->entity, link_setup,
+				gobj_to_pad(link->sink),
+				gobj_to_pad(link->source), flags);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		media_entity_call(link->source->entity, link_setup,
-				  link->source, link->sink, link->flags);
+		media_entity_call(gobj_to_pad(link->source)->entity, link_setup,
+				  gobj_to_pad(link->source),
+				  gobj_to_pad(link->sink), link->flags);
 		return ret;
 	}
 
@@ -617,8 +638,8 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 	if (link->flags == flags)
 		return 0;
 
-	source = link->source->entity;
-	sink = link->sink->entity;
+	source = gobj_to_pad(link->source)->entity;
+	sink = gobj_to_pad(link->sink)->entity;
 
 	if (!(link->flags & MEDIA_LNK_FL_DYNAMIC) &&
 	    (source->stream_count || sink->stream_count))
@@ -645,9 +666,9 @@ int media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	int ret;
 
-	mutex_lock(&link->source->entity->parent->graph_mutex);
+	mutex_lock(&gobj_to_pad(link->source)->entity->parent->graph_mutex);
 	ret = __media_entity_setup_link(link, flags);
-	mutex_unlock(&link->source->entity->parent->graph_mutex);
+	mutex_unlock(&gobj_to_pad(link->source)->entity->parent->graph_mutex);
 
 	return ret;
 }
@@ -667,10 +688,10 @@ media_entity_find_link(struct media_pad *source, struct media_pad *sink)
 	struct media_link *link;
 
 	list_for_each_entry(link, &source->entity->links, list) {
-		if (link->source->entity == source->entity &&
-		    link->source->index == source->index &&
-		    link->sink->entity == sink->entity &&
-		    link->sink->index == sink->index)
+		if (gobj_to_pad(link->source)->entity == source->entity &&
+		    gobj_to_pad(link->source)->index == source->index &&
+		    gobj_to_pad(link->sink)->entity == sink->entity &&
+		    gobj_to_pad(link->sink)->index == sink->index)
 			return link;
 	}
 
@@ -696,11 +717,11 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad)
 		if (!(link->flags & MEDIA_LNK_FL_ENABLED))
 			continue;
 
-		if (link->source == pad)
-			return link->sink;
+		if (gobj_to_pad(link->source) == pad)
+			return gobj_to_pad(link->sink);
 
-		if (link->sink == pad)
-			return link->source;
+		if (gobj_to_pad(link->sink) == pad)
+			return gobj_to_pad(link->source);
 	}
 
 	return NULL;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a4cbff..f924148767ba 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1091,7 +1091,7 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
 static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
 				unsigned int notification)
 {
-	struct media_entity *sink = link->sink->entity;
+	struct media_entity *sink = gobj_to_pad(link->sink)->entity;
 	int ret = 0;
 
 	/* Before link disconnection */
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 12be830d704f..7e2f4c9c0eef 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -822,8 +822,8 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
 static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
 				    unsigned int notification)
 {
-	struct media_entity *source = link->source->entity;
-	struct media_entity *sink = link->sink->entity;
+	struct media_entity *source = gobj_to_pad(link->source)->entity;
+	struct media_entity *sink = gobj_to_pad(link->sink)->entity;
 	int source_use = isp_pipeline_pm_use_count(source);
 	int sink_use = isp_pipeline_pm_use_count(sink);
 	int ret;
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 3b10304b580b..f01b540d1841 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2419,7 +2419,7 @@ static int ccdc_link_validate(struct v4l2_subdev *sd,
 	if (ccdc->input == CCDC_INPUT_PARALLEL) {
 		struct isp_parallel_cfg *parcfg =
 			&((struct isp_bus_cfg *)
-			  media_entity_to_v4l2_subdev(link->source->entity)
+			  media_entity_to_v4l2_subdev(gobj_to_pad(link->source)->entity)
 			  ->host_priv)->bus.parallel;
 		parallel_shift = parcfg->data_lane_shift * 2;
 	} else {
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index e8baff4d6290..55b41113426c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -128,7 +128,7 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 		return 0;
 
 	list_for_each_entry(link, &decoder->links, list) {
-		if (link->sink->entity == decoder) {
+		if (gobj_to_pad(link->sink)->entity == decoder) {
 			found_link = link;
 			if (link->flags & MEDIA_LNK_FL_ENABLED)
 				active_links++;
@@ -139,12 +139,12 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 	if (active_links == 1 || !found_link)
 		return 0;
 
-	source = found_link->source->entity;
+	source = gobj_to_pad(found_link->source)->entity;
 	list_for_each_entry(link, &source->links, list) {
 		struct media_entity *sink;
 		int flags = 0;
 
-		sink = link->sink->entity;
+		sink = gobj_to_pad(link->sink)->entity;
 
 		if (sink == entity)
 			flags = MEDIA_LNK_FL_ENABLED;
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 83615b8fb46a..87de18a7b1c4 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -523,9 +523,11 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate_default);
 
 static int
-v4l2_subdev_link_validate_get_format(struct media_pad *pad,
+v4l2_subdev_link_validate_get_format(struct media_graph_obj *gobj,
 				     struct v4l2_subdev_format *fmt)
 {
+	struct media_pad *pad = gobj_to_pad(gobj);
+
 	if (media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV) {
 		struct v4l2_subdev *sd =
 			media_entity_to_v4l2_subdev(pad->entity);
@@ -558,7 +560,7 @@ int v4l2_subdev_link_validate(struct media_link *link)
 	if (rval < 0)
 		return 0;
 
-	sink = media_entity_to_v4l2_subdev(link->sink->entity);
+	sink = media_entity_to_v4l2_subdev(gobj_to_pad(link->sink)->entity);
 
 	rval = v4l2_subdev_call(sink, pad, link_validate, link,
 				&source_fmt, &sink_fmt);
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 9bfb725b9986..5556ffbd7619 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -142,7 +142,7 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,
 
 	fmt.pad = link->source->index;
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->sink->entity),
+	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(gobj_to_pad(link->sink)->entity),
 			       pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return -EPIPE;
@@ -526,8 +526,8 @@ int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
 static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
 				    unsigned int notification)
 {
-	struct media_entity *source = link->source->entity;
-	struct media_entity *sink = link->sink->entity;
+	struct media_entity *source = gobj_to_pad(link->source)->entity;
+	struct media_entity *sink = gobj_to_pad(link->sink)->entity;
 	int source_use = iss_pipeline_pm_use_count(source);
 	int sink_use = iss_pipeline_pm_use_count(sink);
 	int ret;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index e936cfc218cb..47df6be236bc 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1026,7 +1026,7 @@ static int csi2_link_validate(struct v4l2_subdev *sd, struct media_link *link,
 	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
 	int rval;
 
-	pipe->external = media_entity_to_v4l2_subdev(link->source->entity);
+	pipe->external = media_entity_to_v4l2_subdev(gobj_to_pad(link->source)->entity);
 	rval = omap4iss_get_external_info(pipe, link);
 	if (rval < 0)
 		return rval;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 403019035424..f6e2136480f1 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -43,6 +43,17 @@ enum media_graph_type {
 	MEDIA_GRAPH_LINK,
 };
 
+/**
+ * enum media_graph_link_dir - direction of a link
+ *
+ * @MEDIA_LINK_DIR_BIDIRECTIONAL	Link is bidirectional
+ * @MEDIA_LINK_DIR_PAD_0_TO_1		Link is unidirectional,
+ *					from port 0 (source) to port 1 (sink)
+ */
+enum media_graph_link_dir {
+	MEDIA_LINK_DIR_BIDIRECTIONAL,
+	MEDIA_LINK_DIR_PORT0_TO_PORT1,
+};
 
 /* Structs to represent the objects that belong to a media graph */
 
@@ -72,9 +83,9 @@ struct media_pipeline {
 
 struct media_link {
 	struct list_head list;
-	struct media_graph_obj			graph_obj;
-	struct media_pad *source;	/* Source pad */
-	struct media_pad *sink;		/* Sink pad  */
+	struct media_graph_obj		graph_obj;
+	enum media_graph_link_dir	dir;
+	struct media_graph_obj		*source, *sink;
 	struct media_link *reverse;	/* Link in the reverse direction */
 	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
 };
@@ -115,6 +126,11 @@ struct media_entity {
 	u32 group_id;			/* Entity group ID */
 
 	u16 num_pads;			/* Number of sink and source pads */
+
+	/*
+	 * Both num_links and num_backlinks are used only to report
+	 * the number of links via MEDIA_IOC_ENUM_ENTITIES at media_device.c
+	 */
 	u16 num_links;			/* Number of existing links, both
 					 * enabled and disabled */
 	u16 num_backlinks;		/* Number of backlinks */
@@ -171,6 +187,12 @@ struct media_entity_graph {
 #define gobj_to_entity(gobj) \
 		container_of(gobj, struct media_entity, graph_obj)
 
+#define gobj_to_link(gobj) \
+		container_of(gobj, struct media_link, graph_obj)
+
+#define gobj_to_pad(gobj) \
+		container_of(gobj, struct media_pad, graph_obj)
+
 void graph_obj_init(struct media_device *mdev,
 		    enum media_graph_type type,
 		    struct media_graph_obj *gobj);
-- 
2.4.3

