Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54864 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031456Ab3HIXC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:27 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 06/19] video: display: OF support
Date: Sat, 10 Aug 2013 01:03:05 +0200
Message-Id: <1376089398-13322-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the notifier with DT node matching support, and add helper functions to
build the notifier and link entities based on a graph representation in
DT.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/video/display/display-core.c     | 334 +++++++++++++++++++++++++++++++
 drivers/video/display/display-notifier.c | 187 +++++++++++++++++
 include/video/display.h                  |  45 +++++
 3 files changed, 566 insertions(+)

diff --git a/drivers/video/display/display-core.c b/drivers/video/display/display-core.c
index c3b47d3..328ead7 100644
--- a/drivers/video/display/display-core.c
+++ b/drivers/video/display/display-core.c
@@ -14,6 +14,7 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 
 #include <media/media-device.h>
@@ -315,6 +316,184 @@ void display_entity_unregister(struct display_entity *entity)
 EXPORT_SYMBOL_GPL(display_entity_unregister);
 
 /* -----------------------------------------------------------------------------
+ * OF Helpers
+ */
+
+#ifdef CONFIG_OF
+
+/**
+ * display_of_get_next_endpoint() - get next endpoint node
+ * @parent: pointer to the parent device node
+ * @prev: previous endpoint node, or NULL to get first
+ *
+ * Return: An 'endpoint' node pointer with refcount incremented. Refcount
+ * of the passed @prev node is not decremented, the caller have to use
+ * of_node_put() on it when done.
+ */
+struct device_node *
+display_of_get_next_endpoint(const struct device_node *parent,
+			     struct device_node *prev)
+{
+	struct device_node *endpoint;
+	struct device_node *port = NULL;
+
+	if (!parent)
+		return NULL;
+
+	if (!prev) {
+		struct device_node *node;
+		/*
+		 * It's the first call, we have to find a port subnode
+		 * within this node or within an optional 'ports' node.
+		 */
+		node = of_get_child_by_name(parent, "ports");
+		if (node)
+			parent = node;
+
+		port = of_get_child_by_name(parent, "port");
+
+		if (port) {
+			/* Found a port, get an endpoint. */
+			endpoint = of_get_next_child(port, NULL);
+			of_node_put(port);
+		} else {
+			endpoint = NULL;
+		}
+
+		if (!endpoint)
+			pr_err("%s(): no endpoint nodes specified for %s\n",
+			       __func__, parent->full_name);
+		of_node_put(node);
+	} else {
+		port = of_get_parent(prev);
+		if (!port)
+			/* Hm, has someone given us the root node ?... */
+			return NULL;
+
+		/* Avoid dropping prev node refcount to 0. */
+		of_node_get(prev);
+		endpoint = of_get_next_child(port, prev);
+		if (endpoint) {
+			of_node_put(port);
+			return endpoint;
+		}
+
+		/* No more endpoints under this port, try the next one. */
+		do {
+			port = of_get_next_child(parent, port);
+			if (!port)
+				return NULL;
+		} while (of_node_cmp(port->name, "port"));
+
+		/* Pick up the first endpoint in this port. */
+		endpoint = of_get_next_child(port, NULL);
+		of_node_put(port);
+	}
+
+	return endpoint;
+}
+
+/**
+ * display_of_get_remote_port_parent() - get remote port's parent node
+ * @node: pointer to a local endpoint device_node
+ *
+ * Return: Remote device node associated with remote endpoint node linked
+ *	   to @node. Use of_node_put() on it when done.
+ */
+struct device_node *
+display_of_get_remote_port_parent(const struct device_node *node)
+{
+	struct device_node *np;
+	unsigned int depth;
+
+	/* Get remote endpoint node. */
+	np = of_parse_phandle(node, "remote-endpoint", 0);
+
+	/* Walk 3 levels up only if there is 'ports' node. */
+	for (depth = 3; depth && np; depth--) {
+		np = of_get_next_parent(np);
+		if (depth == 2 && of_node_cmp(np->name, "ports"))
+			break;
+	}
+	return np;
+}
+
+/**
+ * struct display_of_link - a link between two endpoints
+ * @local_node: pointer to device_node of this endpoint
+ * @local_port: identifier of the port this endpoint belongs to
+ * @remote_node: pointer to device_node of the remote endpoint
+ * @remote_port: identifier of the port the remote endpoint belongs to
+ */
+struct display_of_link {
+	struct device_node *local_node;
+	unsigned int local_port;
+	struct device_node *remote_node;
+	unsigned int remote_port;
+};
+
+/**
+ * display_of_parse_link() - parse a link between two endpoints
+ * @node: pointer to the endpoint at the local end of the link
+ * @link: pointer to the display OF link data structure
+ *
+ * Fill the link structure with the local and remote nodes and port numbers.
+ * The local_node and remote_node fields are set to point to the local and
+ * remote port parent nodes respectively (the port parent node being the parent
+ * node of the port node if that node isn't a 'ports' node, or the grand-parent
+ * node of the port node otherwise).
+ *
+ * A reference is taken to both the local and remote nodes, the caller must use
+ * display_of_put_link() to drop the references when done with the link.
+ *
+ * Return: 0 on success, or -ENOLINK if the remote endpoint can't be found.
+ */
+static int display_of_parse_link(const struct device_node *node,
+				 struct display_of_link *link)
+{
+	struct device_node *np;
+
+	memset(link, 0, sizeof(*link));
+
+	np = of_get_parent(node);
+	of_property_read_u32(np, "reg", &link->local_port);
+	np = of_get_next_parent(np);
+	if (of_node_cmp(np->name, "ports") == 0)
+		np = of_get_next_parent(np);
+	link->local_node = np;
+
+	np = of_parse_phandle(node, "remote-endpoint", 0);
+	if (!np) {
+		of_node_put(link->local_node);
+		return -ENOLINK;
+	}
+
+	np = of_get_parent(np);
+	of_property_read_u32(np, "reg", &link->remote_port);
+	np = of_get_next_parent(np);
+	if (of_node_cmp(np->name, "ports") == 0)
+		np = of_get_next_parent(np);
+	link->remote_node = np;
+
+	return 0;
+}
+
+/**
+ * display_of_put_link() - drop references to nodes in a link
+ * @link: pointer to the display OF link data structure
+ *
+ * Drop references to the local and remote nodes in the link. This function must
+ * be called on every link parsed with display_of_parse_link().
+ */
+static void display_of_put_link(struct display_of_link *link)
+{
+	of_node_put(link->local_node);
+	of_node_put(link->remote_node);
+}
+
+#endif /* CONFIG_OF */
+
+/* -----------------------------------------------------------------------------
  * Graph Helpers
  */
 
@@ -420,6 +599,161 @@ int display_entity_link_graph(struct device *dev, struct list_head *entities)
 }
 EXPORT_SYMBOL_GPL(display_entity_link_graph);
 
+#ifdef CONFIG_OF
+
+static int display_of_entity_link_entity(struct device *dev,
+					 struct display_entity *entity,
+					 struct list_head *entities,
+					 struct display_entity *root)
+{
+	u32 link_flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
+	const struct device_node *node = entity->dev->of_node;
+	struct media_entity *local = &entity->entity;
+	struct device_node *ep = NULL;
+	int ret = 0;
+
+	dev_dbg(dev, "creating links for entity %s\n", local->name);
+
+	while (1) {
+		struct media_entity *remote = NULL;
+		struct media_pad *remote_pad;
+		struct media_pad *local_pad;
+		struct display_of_link link;
+		struct display_entity *ent;
+		struct device_node *next;
+
+		/* Get the next endpoint and parse its link. */
+		next = display_of_get_next_endpoint(node, ep);
+		if (next == NULL)
+			break;
+
+		of_node_put(ep);
+		ep = next;
+
+		dev_dbg(dev, "processing endpoint %s\n", ep->full_name);
+
+		ret = display_of_parse_link(ep, &link);
+		if (ret < 0) {
+			dev_err(dev, "failed to parse link for %s\n",
+				ep->full_name);
+			continue;
+		}
+
+		/* Skip source pads, they will be processed from the other end of
+		 * the link.
+		 */
+		if (link.local_port >= local->num_pads) {
+			dev_err(dev, "invalid port number %u on %s\n",
+				link.local_port, link.local_node->full_name);
+			display_of_put_link(&link);
+			ret = -EINVAL;
+			break;
+		}
+
+		local_pad = &local->pads[link.local_port];
+
+		if (local_pad->flags & MEDIA_PAD_FL_SOURCE) {
+			dev_dbg(dev, "skipping source port %s:%u\n",
+				link.local_node->full_name, link.local_port);
+			display_of_put_link(&link);
+			continue;
+		}
+
+		/* Find the remote entity. If not found, just skip the link as
+		 * it goes out of scope of the entities handled by the notifier.
+		 */
+		list_for_each_entry(ent, entities, list) {
+			if (ent->dev->of_node == link.remote_node) {
+				remote = &ent->entity;
+				break;
+			}
+		}
+
+		if (root->dev->of_node == link.remote_node)
+			remote = &root->entity;
+
+		if (remote == NULL) {
+			dev_dbg(dev, "no entity found for %s\n",
+				link.remote_node->full_name);
+			display_of_put_link(&link);
+			continue;
+		}
+
+		if (link.remote_port >= remote->num_pads) {
+			dev_err(dev, "invalid port number %u on %s\n",
+				link.remote_port, link.remote_node->full_name);
+			display_of_put_link(&link);
+			ret = -EINVAL;
+			break;
+		}
+
+		remote_pad = &remote->pads[link.remote_port];
+
+		display_of_put_link(&link);
+
+		/* Create the media link. */
+		dev_dbg(dev, "creating %s:%u -> %s:%u link\n",
+			remote->name, remote_pad->index,
+			local->name, local_pad->index);
+
+		ret = media_entity_create_link(remote, remote_pad->index,
+					       local, local_pad->index,
+					       link_flags);
+		if (ret < 0) {
+			dev_err(dev,
+				"failed to create %s:%u -> %s:%u link\n",
+				remote->name, remote_pad->index,
+				local->name, local_pad->index);
+			break;
+		}
+	}
+
+	of_node_put(ep);
+	return ret;
+}
+
+/**
+ * display_of_entity_link_graph - Link all entities in a graph
+ * @dev: device used to print debugging and error messages
+ * @root: optional root display entity
+ * @entities: list of display entities in the graph
+ *
+ * This function creates media controller links for all entities in a graph
+ * based on the device tree graph representation. It relies on all entities
+ * having been instantiated from the device tree.
+ *
+ * The list of entities is typically taken directly from a display notifier
+ * done list. It will thus not include any display entity not handled by the
+ * notifier, such as entities directly accessible by the caller without going
+ * through the notification process. The optional root entity parameter can be
+ * used to pass such a display entity and include it in the graph. For all
+ * practical purpose the root entity is handled is if it was part of the
+ * entities list.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_of_entity_link_graph(struct device *dev, struct list_head *entities,
+				 struct display_entity *root)
+{
+	struct display_entity *entity;
+	int ret;
+
+	list_for_each_entry(entity, entities, list) {
+		if (WARN_ON(entity->match->type != DISPLAY_ENTITY_BUS_DT))
+			return -EINVAL;
+
+		ret = display_of_entity_link_entity(dev, entity, entities,
+						    root);
+		if (ret < 0)
+			return ret;
+	}
+
+	return display_of_entity_link_entity(dev, root, entities, root);
+}
+EXPORT_SYMBOL_GPL(display_of_entity_link_graph);
+
+#endif
+
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
 MODULE_DESCRIPTION("Display Core");
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/display/display-notifier.c b/drivers/video/display/display-notifier.c
index 2d752b3..6bede03 100644
--- a/drivers/video/display/display-notifier.c
+++ b/drivers/video/display/display-notifier.c
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/slab.h>
 
 #include <video/display.h>
 
@@ -36,6 +37,14 @@ static bool match_platform(struct device *dev,
 	return !strcmp(match->match.platform.name, dev_name(dev));
 }
 
+static bool match_dt(struct device *dev, struct display_entity_match *match)
+{
+	pr_debug("%s: matching device node '%s' with node '%s'\n", __func__,
+		 dev->of_node->full_name, match->match.dt.node->full_name);
+
+	return match->match.dt.node == dev->of_node;
+}
+
 static struct display_entity_match *
 display_entity_notifier_match(struct display_entity_notifier *notifier,
 			      struct display_entity *entity)
@@ -52,6 +61,9 @@ display_entity_notifier_match(struct display_entity_notifier *notifier,
 		case DISPLAY_ENTITY_BUS_PLATFORM:
 			match_func = match_platform;
 			break;
+		case DISPLAY_ENTITY_BUS_DT:
+			match_func = match_dt;
+			break;
 		}
 
 		if (match_func(entity->dev, match))
@@ -158,6 +170,7 @@ int display_entity_register_notifier(struct display_entity_notifier *notifier)
 
 		switch (match->type) {
 		case DISPLAY_ENTITY_BUS_PLATFORM:
+		case DISPLAY_ENTITY_BUS_DT:
 			break;
 		default:
 			dev_err(notifier->dev,
@@ -272,6 +285,180 @@ int display_entity_build_notifier(struct display_entity_notifier *notifier,
 EXPORT_SYMBOL_GPL(display_entity_build_notifier);
 
 /* -----------------------------------------------------------------------------
+ * OF Support
+ */
+
+#ifdef CONFIG_OF
+
+struct display_entity_of {
+	struct list_head list;
+	struct device_node *node;
+};
+
+static struct display_entity_of *
+display_of_find_entity(struct list_head *entities,
+		       const struct device_node *node)
+{
+	struct display_entity_of *entity;
+
+	list_for_each_entry(entity, entities, list) {
+		if (entity->node == node)
+			return entity;
+	}
+
+	return NULL;
+}
+
+static int display_of_parse_dt(struct display_entity_notifier *notifier,
+			       struct list_head *entities,
+			       struct device_node *node)
+{
+	struct display_entity_of *entity;
+	struct device_node *remote;
+	struct device_node *ep = NULL;
+	struct device_node *next;
+	unsigned int num_entities = 0;
+	int ret = 0;
+
+	/* Walk the device tree and build a list of nodes. */
+	dev_dbg(notifier->dev, "parsing node %s\n", node->full_name);
+
+	while (1) {
+		next = display_of_get_next_endpoint(node, ep);
+		if (next == NULL)
+			break;
+
+		of_node_put(ep);
+		ep = next;
+
+		dev_dbg(notifier->dev, "handling endpoint %s\n", ep->full_name);
+
+		remote = display_of_get_remote_port_parent(ep);
+		if (remote == NULL)
+			continue;
+
+		/* Skip entities that we have already processed. */
+		if (display_of_find_entity(entities, remote) || remote == node) {
+			dev_dbg(notifier->dev,
+				"entity %s already in list, skipping\n",
+				remote->full_name);
+			continue;
+		}
+
+		entity = kzalloc(sizeof(*entity), GFP_KERNEL);
+		if (entity == NULL) {
+			of_node_put(remote);
+			ret = -ENOMEM;
+			break;
+		}
+
+		dev_dbg(notifier->dev, "adding remote entity %s to list\n",
+			remote->full_name);
+
+		entity->node = remote;
+		list_add_tail(&entity->list, entities);
+		num_entities++;
+	}
+
+	of_node_put(ep);
+
+	if (ret < 0)
+		return ret;
+
+	return num_entities;
+}
+
+/**
+ * display_of_entity_build_notifier - build a notifier from device tree
+ * @notifier: display entity notifier to be built
+ * @node: device tree node
+ *
+ * Before registering a notifier drivers must initialize the notifier's list of
+ * entities. This helper function simplifies building the list of entities for
+ * drivers that use a device tree representation of the graph.
+ *
+ * The function allocates an array of struct display_entity_match, initialize it
+ * from the device tree, and sets the notifier entities and num_entities fields.
+ *
+ * The entities array is allocated using the managed memory allocation API on
+ * the notifier device, which must be initialized before calling this function.
+ *
+ * Return 0 on success or a negative error code on error.
+ */
+int display_of_entity_build_notifier(struct display_entity_notifier *notifier,
+				     struct device_node *node)
+{
+	struct display_entity_match *matches;
+	struct display_entity_of *entity;
+	struct display_entity_of *next;
+	unsigned int num_entities = 0;
+	LIST_HEAD(entities);
+	unsigned int i;
+	int ret;
+
+	/* Add an initial entity that stores the device tree node pointer to the
+	 * list.
+	 */
+	entity = kzalloc(sizeof(*entity), GFP_KERNEL);
+	if (entity == NULL)
+		return -ENOMEM;
+
+	entity->node = node;
+	list_add_tail(&entity->list, &entities);
+
+	/* Parse all entities in the list. New entities will be added at the
+	 * tail when parsing the device tree and will just be processed by the
+	 * next iterations.
+	 */
+	list_for_each_entry(entity, &entities, list) {
+		ret = display_of_parse_dt(notifier, &entities, entity->node);
+		if (ret < 0)
+			goto error;
+
+		num_entities += ret;
+	}
+
+	/* Allocate the entity matches array and fill it. */
+	matches = devm_kzalloc(notifier->dev, sizeof(*notifier->entities) *
+				num_entities, GFP_KERNEL);
+	if (matches == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	i = 0;
+	list_for_each_entry_safe(entity, next, &entities, list) {
+		struct display_entity_match *match;
+
+		/* Don't add the initial node to the matches array. */
+		if (entity->node != node) {
+			match = &matches[i++];
+			match->type = DISPLAY_ENTITY_BUS_DT;
+			match->match.dt.node = entity->node;
+		}
+
+		list_del(&entity->list);
+		kfree(entity);
+	}
+
+	notifier->num_entities = num_entities;
+	notifier->entities = matches;
+
+	return 0;
+
+error:
+	list_for_each_entry_safe(entity, next, &entities, list) {
+		list_del(&entity->list);
+		kfree(entity);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(display_of_entity_build_notifier);
+
+#endif /* CONFIG_OF */
+
+/* -----------------------------------------------------------------------------
  * Entity Registration
  */
 
diff --git a/include/video/display.h b/include/video/display.h
index 58ff0d1..36ff637 100644
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -22,6 +22,7 @@
  * Display Entity
  */
 
+struct device_node;
 struct display_entity;
 struct display_entity_match;
 struct display_entity_notify;
@@ -145,12 +146,33 @@ int display_entity_get_params(struct display_entity *entity, unsigned int port,
 int display_entity_set_stream(struct display_entity *entity, unsigned int port,
 			      enum display_entity_stream_state state);
 
+#ifdef CONFIG_OF
+struct device_node *
+display_of_get_next_endpoint(const struct device_node *parent,
+			     struct device_node *prev);
+struct device_node *
+display_of_get_remote_port_parent(const struct device_node *node);
+#else
+static inline struct device_node *
+display_of_get_next_endpoint(const struct device_node *parent,
+			     struct device_node *prev)
+{
+	return NULL;
+}
+static inline struct device_node *
+display_of_get_remote_port_parent(const struct device_node *node)
+{
+	return NULL;
+}
+#endif
+
 /* -----------------------------------------------------------------------------
  * Notifier
  */
 
 enum display_entity_bus_type {
 	DISPLAY_ENTITY_BUS_PLATFORM,
+	DISPLAY_ENTITY_BUS_DT,
 };
 
 /**
@@ -167,6 +189,9 @@ struct display_entity_match {
 		struct {
 			const char *name;
 		} platform;
+		struct {
+			const struct device_node *node;
+		} dt;
 	} match;
 
 	struct list_head list;
@@ -226,4 +251,24 @@ int display_entity_build_notifier(struct display_entity_notifier *notifier,
 				  const struct display_entity_graph_data *graph);
 int display_entity_link_graph(struct device *dev, struct list_head *entities);
 
+#ifdef CONFIG_OF
+int display_of_entity_build_notifier(struct display_entity_notifier *notifier,
+				     struct device_node *node);
+int display_of_entity_link_graph(struct device *dev, struct list_head *entities,
+				 struct display_entity *root);
+#else
+static inline int
+display_of_entity_build_notifier(struct display_entity_notifier *notifier,
+				 struct device_node *node)
+{
+	return -ENOSYS;
+}
+static inline int
+display_of_entity_link_graph(struct device *dev,struct list_head *entities,
+			     struct display_entity *root)
+{
+	return -ENOSYS;
+}
+#endif
+
 #endif /* __DISPLAY_H__ */
-- 
1.8.1.5

