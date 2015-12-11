Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbbLKOR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 09:17:28 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] media-entity.h: move kernel-doc tags from media-entity.c
Date: Fri, 11 Dec 2015 12:17:14 -0200
Message-Id: <8dda5ddcdedccbf7c1326d2154c9ccd35e942f31.1449843430.git.mchehab@osg.samsung.com>
In-Reply-To: <faaf893f35d36170424cfc665546b423e3e6978f.1449843430.git.mchehab@osg.samsung.com>
References: <faaf893f35d36170424cfc665546b423e3e6978f.1449843430.git.mchehab@osg.samsung.com>
In-Reply-To: <faaf893f35d36170424cfc665546b423e3e6978f.1449843430.git.mchehab@osg.samsung.com>
References: <faaf893f35d36170424cfc665546b423e3e6978f.1449843430.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several additional functions are described at media-entity.c.
Moving them to the header file, to make the code cleaner and
to have all such macros at the same place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 163 +++----------------------------------------
 include/media/media-entity.h | 136 +++++++++++++++++++++++++++++++++++-
 2 files changed, 145 insertions(+), 154 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 861c8e7b8773..ada2b44ea4e1 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -26,15 +26,6 @@
 #include <media/media-entity.h>
 #include <media/media-device.h>
 
-/**
- *  dev_dbg_obj - Prints in debug mode a change on some object
- *
- * @event_name:	Name of the event to report. Could be __func__
- * @gobj:	Pointer to the object
- *
- * Enabled only if DEBUG or CONFIG_DYNAMIC_DEBUG. Otherwise, it
- * won't produce any code.
- */
 static inline const char *gobj_type(enum media_gobj_type type)
 {
 	switch (type) {
@@ -79,6 +70,15 @@ static inline const char *intf_type(struct media_interface *intf)
 	}
 };
 
+/**
+ *  dev_dbg_obj - Prints in debug mode a change on some object
+ *
+ * @event_name:	Name of the event to report. Could be __func__
+ * @gobj:	Pointer to the object
+ *
+ * Enabled only if DEBUG or CONFIG_DYNAMIC_DEBUG. Otherwise, it
+ * won't produce any code.
+ */
 static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 {
 #if defined(DEBUG) || defined (CONFIG_DYNAMIC_DEBUG)
@@ -133,19 +133,6 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 #endif
 }
 
-/**
- *  media_gobj_create - Initialize a graph object
- *
- * @mdev:	Pointer to the media_device that contains the object
- * @type:	Type of the object
- * @gobj:	Pointer to the object
- *
- * This routine initializes the embedded struct media_gobj inside a
- * media graph object. It is called automatically if media_*_create()
- * calls are used. However, if the object (entity, link, pad, interface)
- * is embedded on some other object, this function should be called before
- * registering the object at the media controller.
- */
 void media_gobj_create(struct media_device *mdev,
 			   enum media_gobj_type type,
 			   struct media_gobj *gobj)
@@ -179,13 +166,6 @@ void media_gobj_create(struct media_device *mdev,
 	dev_dbg_obj(__func__, gobj);
 }
 
-/**
- *  media_gobj_destroy - Stop using a graph object on a media device
- *
- * @graph_obj:	Pointer to the object
- *
- * This should be called at media_device_unregister_*() routines
- */
 void media_gobj_destroy(struct media_gobj *gobj)
 {
 	dev_dbg_obj(__func__, gobj);
@@ -196,31 +176,8 @@ void media_gobj_destroy(struct media_gobj *gobj)
 	list_del(&gobj->list);
 }
 
-/**
- * media_entity_pads_init - Initialize a media entity
- *
- * @num_pads: Total number of sink and source pads.
- * @pads: Array of 'num_pads' pads.
- *
- * The total number of pads is an intrinsic property of entities known by the
- * entity driver, while the total number of links depends on hardware design
- * and is an extrinsic property unknown to the entity driver. However, in most
- * use cases the number of links can safely be assumed to be equal to or
- * larger than the number of pads.
- *
- * For those reasons the links array can be preallocated based on the number
- * of pads and will be reallocated later if extra links need to be created.
- *
- * This function allocates a links array with enough space to hold at least
- * 'num_pads' elements. The media_entity::max_links field will be set to the
- * number of allocated elements.
- *
- * The pads array is managed by the entity driver and passed to
- * media_entity_pads_init() where its pointer will be stored in the entity structure.
- */
-int
-media_entity_pads_init(struct media_entity *entity, u16 num_pads,
-		  struct media_pad *pads)
+int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
+			   struct media_pad *pads)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	unsigned int i;
@@ -285,16 +242,6 @@ static struct media_entity *stack_pop(struct media_entity_graph *graph)
 #define link_top(en)	((en)->stack[(en)->top].link)
 #define stack_top(en)	((en)->stack[(en)->top].entity)
 
-/**
- * media_entity_graph_walk_start - Start walking the media graph at a given entity
- * @graph: Media graph structure that will be used to walk the graph
- * @entity: Starting entity
- *
- * This function initializes the graph traversal structure to walk the entities
- * graph starting at the given entity. The traversal structure must not be
- * modified by the caller during graph traversal. When done the structure can
- * safely be freed.
- */
 void media_entity_graph_walk_start(struct media_entity_graph *graph,
 				   struct media_entity *entity)
 {
@@ -310,18 +257,6 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
 
-/**
- * media_entity_graph_walk_next - Get the next entity in the graph
- * @graph: Media graph structure
- *
- * Perform a depth-first traversal of the given media entities graph.
- *
- * The graph structure must have been previously initialized with a call to
- * media_entity_graph_walk_start().
- *
- * Return the next entity in the graph or NULL if the whole graph have been
- * traversed.
- */
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph)
 {
@@ -370,20 +305,6 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
  * Pipeline management
  */
 
-/**
- * media_entity_pipeline_start - Mark a pipeline as streaming
- * @entity: Starting entity
- * @pipe: Media pipeline to be assigned to all entities in the pipeline.
- *
- * Mark all entities connected to a given entity through enabled links, either
- * directly or indirectly, as streaming. The given pipeline object is assigned to
- * every entity in the pipeline and stored in the media_entity pipe field.
- *
- * Calls to this function can be nested, in which case the same number of
- * media_entity_pipeline_stop() calls will be required to stop streaming. The
- * pipeline pointer must be identical for all nested calls to
- * media_entity_pipeline_start().
- */
 __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe)
 {
@@ -494,18 +415,6 @@ error:
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
 
-/**
- * media_entity_pipeline_stop - Mark a pipeline as not streaming
- * @entity: Starting entity
- *
- * Mark all entities connected to a given entity through enabled links, either
- * directly or indirectly, as not streaming. The media_entity pipe field is
- * reset to NULL.
- *
- * If multiple calls to media_entity_pipeline_start() have been made, the same
- * number of calls to this function are required to mark the pipeline as not
- * streaming.
- */
 void media_entity_pipeline_stop(struct media_entity *entity)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
@@ -529,16 +438,6 @@ EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
  * Module use count
  */
 
-/*
- * media_entity_get - Get a reference to the parent module
- * @entity: The entity
- *
- * Get a reference to the parent media device module.
- *
- * The function will return immediately if @entity is NULL.
- *
- * Return a pointer to the entity on success or NULL on failure.
- */
 struct media_entity *media_entity_get(struct media_entity *entity)
 {
 	if (entity == NULL)
@@ -552,14 +451,6 @@ struct media_entity *media_entity_get(struct media_entity *entity)
 }
 EXPORT_SYMBOL_GPL(media_entity_get);
 
-/*
- * media_entity_put - Release the reference to the parent module
- * @entity: The entity
- *
- * Release the reference count acquired by media_entity_get().
- *
- * The function will return immediately if @entity is NULL.
- */
 void media_entity_put(struct media_entity *entity)
 {
 	if (entity == NULL)
@@ -718,20 +609,6 @@ static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
 	return 0;
 }
 
-/**
- * __media_entity_setup_link - Configure a media link
- * @link: The link being configured
- * @flags: Link configuration flags
- *
- * The bulk of link setup is handled by the two entities connected through the
- * link. This function notifies both entities of the link configuration change.
- *
- * If the link is immutable or if the current and new configuration are
- * identical, return immediately.
- *
- * The user is expected to hold link->source->parent->mutex. If not,
- * media_entity_setup_link() should be used instead.
- */
 int __media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	const u32 mask = MEDIA_LNK_FL_ENABLED;
@@ -788,14 +665,6 @@ int media_entity_setup_link(struct media_link *link, u32 flags)
 }
 EXPORT_SYMBOL_GPL(media_entity_setup_link);
 
-/**
- * media_entity_find_link - Find a link between two pads
- * @source: Source pad
- * @sink: Sink pad
- *
- * Return a pointer to the link between the two entities. If no such link
- * exists, return NULL.
- */
 struct media_link *
 media_entity_find_link(struct media_pad *source, struct media_pad *sink)
 {
@@ -813,16 +682,6 @@ media_entity_find_link(struct media_pad *source, struct media_pad *sink)
 }
 EXPORT_SYMBOL_GPL(media_entity_find_link);
 
-/**
- * media_entity_remote_pad - Find the pad at the remote end of a link
- * @pad: Pad at the local end of the link
- *
- * Search for a remote pad connected to the given pad by iterating over all
- * links originating or terminating at that pad until an enabled link is found.
- *
- * Return a pointer to the pad at the remote end of the first found enabled
- * link, or NULL if no enabled link has been found.
- */
 struct media_pad *media_entity_remote_pad(struct media_pad *pad)
 {
 	struct media_link *link;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 1b954fb88def..d073b205e6a6 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -338,17 +338,43 @@ struct media_entity_graph {
 #define intf_to_devnode(intf) \
 		container_of(intf, struct media_intf_devnode, intf)
 
+/**
+ *  media_gobj_create - Initialize a graph object
+ *
+ * @mdev:	Pointer to the media_device that contains the object
+ * @type:	Type of the object
+ * @gobj:	Pointer to the graph object
+ *
+ * This routine initializes the embedded struct media_gobj inside a
+ * media graph object. It is called automatically if media_*_create()
+ * calls are used. However, if the object (entity, link, pad, interface)
+ * is embedded on some other object, this function should be called before
+ * registering the object at the media controller.
+ */
 void media_gobj_create(struct media_device *mdev,
 		    enum media_gobj_type type,
 		    struct media_gobj *gobj);
+
+/**
+ *  media_gobj_destroy - Stop using a graph object on a media device
+ *
+ * @gobj:	Pointer to the graph object
+ *
+ * This should be called by all routines like media_device_unregister()
+ * that remove/destroy media graph objects.
+ */
 void media_gobj_destroy(struct media_gobj *gobj);
 
 /**
  * media_entity_pads_init() - Initialize the entity pads
  *
  * @entity:	entity where the pads belong
- * @num_pads:	number of pads to be initialized
- * @pads:	pads array
+ * @num_pads:	total number of sink and source pads
+ * @pads:	Array of @num_pads pads.
+ *
+ * The pads array is managed by the entity driver and passed to
+ * media_entity_pads_init() where its pointer will be stored in the entity
+ * structure.
  *
  * If no pads are needed, drivers could either directly fill
  * &media_entity->@num_pads with 0 and &media_entity->@pads with NULL or call
@@ -413,6 +439,20 @@ void __media_entity_remove_links(struct media_entity *entity);
  */
 void media_entity_remove_links(struct media_entity *entity);
 
+/**
+ * __media_entity_setup_link - Configure a media link without locking
+ * @link: The link being configured
+ * @flags: Link configuration flags
+ *
+ * The bulk of link setup is handled by the two entities connected through the
+ * link. This function notifies both entities of the link configuration change.
+ *
+ * If the link is immutable or if the current and new configuration are
+ * identical, return immediately.
+ *
+ * The user is expected to hold link->source->parent->mutex. If not,
+ * media_entity_setup_link() should be used instead.
+ */
 int __media_entity_setup_link(struct media_link *link, u32 flags);
 
 /**
@@ -450,19 +490,111 @@ int __media_entity_setup_link(struct media_link *link, u32 flags);
  * on media_create_intf_link(), for interface to entity links.
  */
 int media_entity_setup_link(struct media_link *link, u32 flags);
+
+/**
+ * media_entity_find_link - Find a link between two pads
+ * @source: Source pad
+ * @sink: Sink pad
+ *
+ * Return a pointer to the link between the two entities. If no such link
+ * exists, return NULL.
+ */
 struct media_link *media_entity_find_link(struct media_pad *source,
 		struct media_pad *sink);
+
+/**
+ * media_entity_remote_pad - Find the pad at the remote end of a link
+ * @pad: Pad at the local end of the link
+ *
+ * Search for a remote pad connected to the given pad by iterating over all
+ * links originating or terminating at that pad until an enabled link is found.
+ *
+ * Return a pointer to the pad at the remote end of the first found enabled
+ * link, or NULL if no enabled link has been found.
+ */
 struct media_pad *media_entity_remote_pad(struct media_pad *pad);
 
+/**
+ * media_entity_get - Get a reference to the parent module
+ *
+ * @entity: The entity
+ *
+ * Get a reference to the parent media device module.
+ *
+ * The function will return immediately if @entity is NULL.
+ *
+ * Return a pointer to the entity on success or NULL on failure.
+ */
 struct media_entity *media_entity_get(struct media_entity *entity);
+
+/**
+ * media_entity_put - Release the reference to the parent module
+ *
+ * @entity: The entity
+ *
+ * Release the reference count acquired by media_entity_get().
+ *
+ * The function will return immediately if @entity is NULL.
+ */
 void media_entity_put(struct media_entity *entity);
 
+/**
+ * media_entity_graph_walk_start - Start walking the media graph at a given entity
+ * @graph: Media graph structure that will be used to walk the graph
+ * @entity: Starting entity
+ *
+ * This function initializes the graph traversal structure to walk the entities
+ * graph starting at the given entity. The traversal structure must not be
+ * modified by the caller during graph traversal. When done the structure can
+ * safely be freed.
+ */
 void media_entity_graph_walk_start(struct media_entity_graph *graph,
 		struct media_entity *entity);
+
+/**
+ * media_entity_graph_walk_next - Get the next entity in the graph
+ * @graph: Media graph structure
+ *
+ * Perform a depth-first traversal of the given media entities graph.
+ *
+ * The graph structure must have been previously initialized with a call to
+ * media_entity_graph_walk_start().
+ *
+ * Return the next entity in the graph or NULL if the whole graph have been
+ * traversed.
+ */
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph);
+
+/**
+ * media_entity_pipeline_start - Mark a pipeline as streaming
+ * @entity: Starting entity
+ * @pipe: Media pipeline to be assigned to all entities in the pipeline.
+ *
+ * Mark all entities connected to a given entity through enabled links, either
+ * directly or indirectly, as streaming. The given pipeline object is assigned to
+ * every entity in the pipeline and stored in the media_entity pipe field.
+ *
+ * Calls to this function can be nested, in which case the same number of
+ * media_entity_pipeline_stop() calls will be required to stop streaming. The
+ * pipeline pointer must be identical for all nested calls to
+ * media_entity_pipeline_start().
+ */
 __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe);
+
+/**
+ * media_entity_pipeline_stop - Mark a pipeline as not streaming
+ * @entity: Starting entity
+ *
+ * Mark all entities connected to a given entity through enabled links, either
+ * directly or indirectly, as not streaming. The media_entity pipe field is
+ * reset to NULL.
+ *
+ * If multiple calls to media_entity_pipeline_start() have been made, the same
+ * number of calls to this function are required to mark the pipeline as not
+ * streaming.
+ */
 void media_entity_pipeline_stop(struct media_entity *entity);
 
 /**
-- 
2.5.0

