Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32881 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3H0Jbo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 05:31:44 -0400
Message-ID: <1377595851.4338.18.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH/RFC v3 06/19] video: display: OF support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Date: Tue, 27 Aug 2013 11:30:51 +0200
In-Reply-To: <1376089398-13322-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	 <1376089398-13322-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I have another small issue with the graph helpers below:

Am Samstag, den 10.08.2013, 01:03 +0200 schrieb Laurent Pinchart:
[...]
> +/* -----------------------------------------------------------------------------
>   * Graph Helpers
>   */
>  
> @@ -420,6 +599,161 @@ int display_entity_link_graph(struct device *dev, struct list_head *entities)
>  }
>  EXPORT_SYMBOL_GPL(display_entity_link_graph);
>  
> +#ifdef CONFIG_OF
> +
> +static int display_of_entity_link_entity(struct device *dev,
> +					 struct display_entity *entity,
> +					 struct list_head *entities,
> +					 struct display_entity *root)
> +{
> +	u32 link_flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
> +	const struct device_node *node = entity->dev->of_node;
> +	struct media_entity *local = &entity->entity;
> +	struct device_node *ep = NULL;
> +	int ret = 0;
> +
> +	dev_dbg(dev, "creating links for entity %s\n", local->name);
> +
> +	while (1) {
> +		struct media_entity *remote = NULL;
> +		struct media_pad *remote_pad;
> +		struct media_pad *local_pad;
> +		struct display_of_link link;
> +		struct display_entity *ent;
> +		struct device_node *next;
> +
> +		/* Get the next endpoint and parse its link. */
> +		next = display_of_get_next_endpoint(node, ep);
> +		if (next == NULL)
> +			break;
> +
> +		of_node_put(ep);
> +		ep = next;
> +
> +		dev_dbg(dev, "processing endpoint %s\n", ep->full_name);
> +
> +		ret = display_of_parse_link(ep, &link);
> +		if (ret < 0) {
> +			dev_err(dev, "failed to parse link for %s\n",
> +				ep->full_name);
> +			continue;
> +		}
> +
> +		/* Skip source pads, they will be processed from the other end of
> +		 * the link.
> +		 */
> +		if (link.local_port >= local->num_pads) {
> +			dev_err(dev, "invalid port number %u on %s\n",
> +				link.local_port, link.local_node->full_name);
> +			display_of_put_link(&link);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		local_pad = &local->pads[link.local_port];
> +
> +		if (local_pad->flags & MEDIA_PAD_FL_SOURCE) {
> +			dev_dbg(dev, "skipping source port %s:%u\n",
> +				link.local_node->full_name, link.local_port);
> +			display_of_put_link(&link);
> +			continue;
> +		}
> +
> +		/* Find the remote entity. If not found, just skip the link as
> +		 * it goes out of scope of the entities handled by the notifier.
> +		 */
> +		list_for_each_entry(ent, entities, list) {
> +			if (ent->dev->of_node == link.remote_node) {
> +				remote = &ent->entity;
> +				break;
> +			}
> +		}
> +
> +		if (root->dev->of_node == link.remote_node)
> +			remote = &root->entity;
> +
> +		if (remote == NULL) {
> +			dev_dbg(dev, "no entity found for %s\n",
> +				link.remote_node->full_name);
> +			display_of_put_link(&link);
> +			continue;
> +		}
> +
> +		if (link.remote_port >= remote->num_pads) {
> +			dev_err(dev, "invalid port number %u on %s\n",
> +				link.remote_port, link.remote_node->full_name);
> +			display_of_put_link(&link);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		remote_pad = &remote->pads[link.remote_port];
> +
> +		display_of_put_link(&link);
> +
> +		/* Create the media link. */
> +		dev_dbg(dev, "creating %s:%u -> %s:%u link\n",
> +			remote->name, remote_pad->index,
> +			local->name, local_pad->index);
> +
> +		ret = media_entity_create_link(remote, remote_pad->index,
> +					       local, local_pad->index,
> +					       link_flags);
> +		if (ret < 0) {
> +			dev_err(dev,
> +				"failed to create %s:%u -> %s:%u link\n",
> +				remote->name, remote_pad->index,
> +				local->name, local_pad->index);
> +			break;
> +		}
> +	}
> +
> +	of_node_put(ep);
> +	return ret;
> +}
> +
> +/**
> + * display_of_entity_link_graph - Link all entities in a graph
> + * @dev: device used to print debugging and error messages
> + * @root: optional root display entity
> + * @entities: list of display entities in the graph
> + *
> + * This function creates media controller links for all entities in a graph
> + * based on the device tree graph representation. It relies on all entities
> + * having been instantiated from the device tree.
> + *
> + * The list of entities is typically taken directly from a display notifier
> + * done list. It will thus not include any display entity not handled by the
> + * notifier, such as entities directly accessible by the caller without going
> + * through the notification process. The optional root entity parameter can be
> + * used to pass such a display entity and include it in the graph. For all
> + * practical purpose the root entity is handled is if it was part of the
> + * entities list.
> + *
> + * Return 0 on success or a negative error code otherwise.
> + */
> +int display_of_entity_link_graph(struct device *dev, struct list_head *entities,
> +				 struct display_entity *root)
> +{
> +	struct display_entity *entity;
> +	int ret;
> +
> +	list_for_each_entry(entity, entities, list) {
> +		if (WARN_ON(entity->match->type != DISPLAY_ENTITY_BUS_DT))
> +			return -EINVAL;
> +
> +		ret = display_of_entity_link_entity(dev, entity, entities,
> +						    root);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return display_of_entity_link_entity(dev, root, entities, root);
> +}
> +EXPORT_SYMBOL_GPL(display_of_entity_link_graph);

The root display entity given to display_of_entity_link_graph is documented
to be optional. Therefore, do not try to dereference root if it is NULL:

diff --git a/drivers/video/display/display-core.c b/drivers/video/display/display-core.c
index 328ead7..6c8094f 100644
--- a/drivers/video/display/display-core.c
+++ b/drivers/video/display/display-core.c
@@ -669,7 +669,7 @@ static int display_of_entity_link_entity(struct device *dev,
 			}
 		}
 
-		if (root->dev->of_node == link.remote_node)
+		if (root && root->dev->of_node == link.remote_node)
 			remote = &root->entity;
 
 		if (remote == NULL) {
@@ -748,6 +748,9 @@ int display_of_entity_link_graph(struct device *dev, struct list_head *entities,
 			return ret;
 	}
 
+	if (!root)
+		return 0;
+
 	return display_of_entity_link_entity(dev, root, entities, root);
 }
 EXPORT_SYMBOL_GPL(display_of_entity_link_graph);
-- 
1.8.4.rc3

regards
Philipp

