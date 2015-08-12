Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbbHLUPL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 16:15:11 -0400
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
	Akihiro Tsukada <tskd08@gmail.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Antti Palosaari <crope@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH RFC v3 10/16] media: rename link source/sink to pad0_source/pad1_sink
Date: Wed, 12 Aug 2015 17:14:54 -0300
Message-Id: <30472f0a7f52ee834978c70cbecc5c035ce20f71.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the internal namespace for links between two pads to
have the "pad" there.

We're also numbering it, as a common constructor is to do
things like:

 	if (link->port1.type != MEDIA_GRAPH_PAD)
 		continue;
 	if (link->pad1_sink->entity == entity)
		/* do something */

by preserving the number, we keep consistency between
port1 and pad1_sink, and port0 and pad0_source.

This was generated via this script:
	for i in $(find drivers/media -name '*.[ch]' -type f) $(find drivers/staging/media -name '*.[ch]' -type f) $(find include/ -name '*.h' -type f) ; do sed "s,link->sink,link->pad1_sink,g; s,link->source,link->pad0_source,g;" <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 3c97ebdf9f2a..e673f6f7c398 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -637,7 +637,7 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 		link = &entity->links[i];
 		if (link->port1.type != MEDIA_GRAPH_PAD)
 			continue;
-		if (link->sink->entity == entity) {
+		if (link->pad1_sink->entity == entity) {
 			found_link = link;
 			n_links++;
 			if (link->flags & MEDIA_LNK_FL_ENABLED)
@@ -660,7 +660,7 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	source = found_link->source->entity;
+	source = found_link->pad0_source->entity;
 	fepriv->pipe_start_entity = source;
 	for (i = 0; i < source->num_links; i++) {
 		struct media_entity *sink;
@@ -669,7 +669,7 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 		link = &source->links[i];
 		if (link->port1.type != MEDIA_GRAPH_PAD)
 			continue;
-		sink = link->sink->entity;
+		sink = link->pad1_sink->entity;
 
 		if (sink == entity)
 			flags = MEDIA_LNK_FL_ENABLED;
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index b4bd718ad736..2c29c4600c3a 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -160,13 +160,13 @@ static long __media_device_enum_links(struct media_device *mdev,
 			    ent_link->port1->type != MEDIA_GRAPH_PAD)
 				continue;
 			/* Ignore backlinks. */
-			if (ent_link->source->entity != entity)
+			if (ent_link->pad0_source->entity != entity)
 				continue;
 
 			memset(&link, 0, sizeof(link));
-			media_device_kpad_to_upad(ent_link->source,
+			media_device_kpad_to_upad(ent_link->pad0_source,
 						  &link.source);
-			media_device_kpad_to_upad(ent_link->sink,
+			media_device_kpad_to_upad(ent_link->pad1_sink,
 						  &link.sink);
 			link.flags = ent_link->flags;
 			if (copy_to_user(ulink, &link, sizeof(*ulink)))
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index fc2e4886c830..aafa1119fba7 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -125,10 +125,10 @@ media_entity_other(struct media_entity *entity, struct media_link *link)
 	if (link->port0->type != MEDIA_GRAPH_PAD ||
 	    link->port1->type != MEDIA_GRAPH_PAD)
 		return NULL;
-	if (link->source->entity == entity)
-		return link->sink->entity;
+	if (link->pad0_source->entity == entity)
+		return link->pad1_sink->entity;
 	else
-		return link->source->entity;
+		return link->pad0_source->entity;
 }
 
 /* push an entity to traversal stack */
@@ -299,8 +299,8 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			if (link->port0->type != MEDIA_GRAPH_PAD)
 				continue;
 
-			pad = link->sink->entity == entity
-				? link->sink : link->source;
+			pad = link->pad1_sink->entity == entity
+				? link->pad1_sink : link->pad0_source;
 
 			/* Mark that a pad is connected by a link. */
 			bitmap_clear(has_no_links, pad->index, 1);
@@ -318,7 +318,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			 * Link validation will only take place for
 			 * sink ends of the link that are enabled.
 			 */
-			if (link->sink != pad ||
+			if (link->pad1_sink != pad ||
 			    !(link->flags & MEDIA_LNK_FL_ENABLED))
 				continue;
 
@@ -326,9 +326,9 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			if (ret < 0 && ret != -ENOIOCTLCMD) {
 				dev_dbg(entity->parent->dev,
 					"link validation failed for \"%s\":%u -> \"%s\":%u, error %d\n",
-					entity->name, link->source->index,
-					link->sink->entity->name,
-					link->sink->index, ret);
+					entity->name, link->pad0_source->index,
+					link->pad1_sink->entity->name,
+					link->pad1_sink->index, ret);
 				goto error;
 			}
 		}
@@ -493,8 +493,8 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 	if (link == NULL)
 		return -ENOMEM;
 
-	link->source = &source->pads[source_pad];
-	link->sink = &sink->pads[sink_pad];
+	link->pad0_source = &source->pads[source_pad];
+	link->pad1_sink = &sink->pads[sink_pad];
 	link->flags = flags;
 
 	/* Create the backlink. Backlinks are used to help graph traversal and
@@ -506,8 +506,8 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 		return -ENOMEM;
 	}
 
-	backlink->source = &source->pads[source_pad];
-	backlink->sink = &sink->pads[sink_pad];
+	backlink->pad0_source = &source->pads[source_pad];
+	backlink->pad1_sink = &sink->pads[sink_pad];
 	backlink->flags = flags;
 
 	link->reverse = backlink;
@@ -526,10 +526,10 @@ static void __media_entity_remove_link(struct media_entity *entity,
 	struct media_entity *remote;
 	unsigned int r = 0;
 
-	if (link->source->entity == entity)
-		remote = link->sink->entity;
+	if (link->pad0_source->entity == entity)
+		remote = link->pad1_sink->entity;
 	else
-		remote = link->source->entity;
+		remote = link->pad0_source->entity;
 
 	list_for_each_entry_safe(rlink, tmp, &remote->links, list) {
 		if (rlink != link->reverse) {
@@ -537,7 +537,7 @@ static void __media_entity_remove_link(struct media_entity *entity,
 			continue;
 		}
 
-		if (link->source->entity == entity)
+		if (link->pad0_source->entity == entity)
 			remote->num_backlinks--;
 
 		if (--remote->num_links == 0)
@@ -580,16 +580,16 @@ static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
 	int ret;
 
 	/* Notify both entities. */
-	ret = media_entity_call(link->source->entity, link_setup,
-				link->source, link->sink, flags);
+	ret = media_entity_call(link->pad0_source->entity, link_setup,
+				link->pad0_source, link->pad1_sink, flags);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		return ret;
 
-	ret = media_entity_call(link->sink->entity, link_setup,
-				link->sink, link->source, flags);
+	ret = media_entity_call(link->pad1_sink->entity, link_setup,
+				link->pad1_sink, link->pad0_source, flags);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		media_entity_call(link->source->entity, link_setup,
-				  link->source, link->sink, link->flags);
+		media_entity_call(link->pad0_source->entity, link_setup,
+				  link->pad0_source, link->pad1_sink, link->flags);
 		return ret;
 	}
 
@@ -610,7 +610,7 @@ static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
  * If the link is immutable or if the current and new configuration are
  * identical, return immediately.
  *
- * The user is expected to hold link->source->parent->mutex. If not,
+ * The user is expected to hold link->pad0_source->parent->mutex. If not,
  * media_entity_setup_link() should be used instead.
  */
 int __media_entity_setup_link(struct media_link *link, u32 flags)
@@ -633,8 +633,8 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 	if (link->flags == flags)
 		return 0;
 
-	source = link->source->entity;
-	sink = link->sink->entity;
+	source = link->pad0_source->entity;
+	sink = link->pad1_sink->entity;
 
 	if (!(link->flags & MEDIA_LNK_FL_DYNAMIC) &&
 	    (source->stream_count || sink->stream_count))
@@ -661,9 +661,9 @@ int media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	int ret;
 
-	mutex_lock(&link->source->entity->parent->graph_mutex);
+	mutex_lock(&link->pad0_source->entity->parent->graph_mutex);
 	ret = __media_entity_setup_link(link, flags);
-	mutex_unlock(&link->source->entity->parent->graph_mutex);
+	mutex_unlock(&link->pad0_source->entity->parent->graph_mutex);
 
 	return ret;
 }
@@ -683,10 +683,10 @@ media_entity_find_link(struct media_pad *source, struct media_pad *sink)
 	struct media_link *link;
 
 	list_for_each_entry(link, &source->entity->links, list) {
-		if (link->source->entity == source->entity &&
-		    link->source->index == source->index &&
-		    link->sink->entity == sink->entity &&
-		    link->sink->index == sink->index)
+		if (link->pad0_source->entity == source->entity &&
+		    link->pad0_source->index == source->index &&
+		    link->pad1_sink->entity == sink->entity &&
+		    link->pad1_sink->index == sink->index)
 			return link;
 	}
 
@@ -712,11 +712,11 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad)
 		if (!(link->flags & MEDIA_LNK_FL_ENABLED))
 			continue;
 
-		if (link->source == pad)
-			return link->sink;
+		if (link->pad0_source == pad)
+			return link->pad1_sink;
 
-		if (link->sink == pad)
-			return link->source;
+		if (link->pad1_sink == pad)
+			return link->pad0_source;
 	}
 
 	return NULL;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a4cbff..3cafcf85cafc 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1091,7 +1091,7 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
 static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
 				unsigned int notification)
 {
-	struct media_entity *sink = link->sink->entity;
+	struct media_entity *sink = link->pad1_sink->entity;
 	int ret = 0;
 
 	/* Before link disconnection */
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 12be830d704f..cbd22a422bd3 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -822,8 +822,8 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
 static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
 				    unsigned int notification)
 {
-	struct media_entity *source = link->source->entity;
-	struct media_entity *sink = link->sink->entity;
+	struct media_entity *source = link->pad0_source->entity;
+	struct media_entity *sink = link->pad1_sink->entity;
 	int source_use = isp_pipeline_pm_use_count(source);
 	int sink_use = isp_pipeline_pm_use_count(sink);
 	int ret;
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 3b10304b580b..cb236b54d770 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2419,7 +2419,7 @@ static int ccdc_link_validate(struct v4l2_subdev *sd,
 	if (ccdc->input == CCDC_INPUT_PARALLEL) {
 		struct isp_parallel_cfg *parcfg =
 			&((struct isp_bus_cfg *)
-			  media_entity_to_v4l2_subdev(link->source->entity)
+			  media_entity_to_v4l2_subdev(link->pad0_source->entity)
 			  ->host_priv)->bus.parallel;
 		parallel_shift = parcfg->data_lane_shift * 2;
 	} else {
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index e8baff4d6290..9416a8b7d575 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -128,7 +128,7 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 		return 0;
 
 	list_for_each_entry(link, &decoder->links, list) {
-		if (link->sink->entity == decoder) {
+		if (link->pad1_sink->entity == decoder) {
 			found_link = link;
 			if (link->flags & MEDIA_LNK_FL_ENABLED)
 				active_links++;
@@ -139,12 +139,12 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 	if (active_links == 1 || !found_link)
 		return 0;
 
-	source = found_link->source->entity;
+	source = found_link->pad0_source->entity;
 	list_for_each_entry(link, &source->links, list) {
 		struct media_entity *sink;
 		int flags = 0;
 
-		sink = link->sink->entity;
+		sink = link->pad1_sink->entity;
 
 		if (sink == entity)
 			flags = MEDIA_LNK_FL_ENABLED;
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 83615b8fb46a..53729ccdea80 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -549,16 +549,16 @@ int v4l2_subdev_link_validate(struct media_link *link)
 	int rval;
 
 	rval = v4l2_subdev_link_validate_get_format(
-		link->source, &source_fmt);
+		link->pad0_source, &source_fmt);
 	if (rval < 0)
 		return 0;
 
 	rval = v4l2_subdev_link_validate_get_format(
-		link->sink, &sink_fmt);
+		link->pad1_sink, &sink_fmt);
 	if (rval < 0)
 		return 0;
 
-	sink = media_entity_to_v4l2_subdev(link->sink->entity);
+	sink = media_entity_to_v4l2_subdev(link->pad1_sink->entity);
 
 	rval = v4l2_subdev_call(sink, pad, link_validate, link,
 				&source_fmt, &sink_fmt);
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 9bfb725b9986..37694999d189 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -140,9 +140,9 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,
 
 	memset(&fmt, 0, sizeof(fmt));
 
-	fmt.pad = link->source->index;
+	fmt.pad = link->pad0_source->index;
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->sink->entity),
+	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->pad1_sink->entity),
 			       pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return -EPIPE;
@@ -526,8 +526,8 @@ int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
 static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
 				    unsigned int notification)
 {
-	struct media_entity *source = link->source->entity;
-	struct media_entity *sink = link->sink->entity;
+	struct media_entity *source = link->pad0_source->entity;
+	struct media_entity *sink = link->pad1_sink->entity;
 	int source_use = iss_pipeline_pm_use_count(source);
 	int sink_use = iss_pipeline_pm_use_count(sink);
 	int ret;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index e936cfc218cb..e39f1bbbdae1 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1026,7 +1026,7 @@ static int csi2_link_validate(struct v4l2_subdev *sd, struct media_link *link,
 	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
 	int rval;
 
-	pipe->external = media_entity_to_v4l2_subdev(link->source->entity);
+	pipe->external = media_entity_to_v4l2_subdev(link->pad0_source->entity);
 	rval = omap4iss_get_external_info(pipe, link);
 	if (rval < 0)
 		return rval;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index a6464499902e..412cf5d00315 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -87,12 +87,12 @@ struct media_link {
 	enum media_graph_link_dir	dir;
 	union {
 		struct media_graph_obj *port0;
-		struct media_pad *source;
+		struct media_pad *pad0_source;
 		struct media_interface *port0_intf;
 	};
 	union {
 		struct media_graph_obj *port1;
-		struct media_pad *sink;
+		struct media_pad *pad1_sink;
 		struct media_entity *port1_entity;
 	};
 	struct media_link *reverse;	/* Link in the reverse direction */
-- 
2.4.3

