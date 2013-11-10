Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42591 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3KJUgd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 15:36:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 03/19] uvcvideo: Add support for multiple chains with common roots.
Date: Sun, 10 Nov 2013 21:37:06 +0100
Message-ID: <2008407.YS3L85ZYJQ@avalon>
In-Reply-To: <1377829038-4726-4-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-4-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:02 Pawel Osciak wrote:
> This adds support for pipelines that fork into branches consisting of more
> than one entity, creating a chain for each fork and putting common entities
> on all chains that share them.
> 
> This requires us to share the ctrl_mutex across forked chains. Whenever we
> discover a shared part of a chain, we assign the pointer to an existing
> mutex to the sharing chain instead of creating a new one.
> 
> The "forward scan" is not needed anymore, as after scanning back from OTs,
> we go over all entities which are not on a path from an OT and accept
> single-XU branches, adding them to the existing chains.
> 
> Also extract control locking into __uvc_ctrl_{lock,unlock} functions.

This is one core piece of the UVC 1.5 rework, and I have mixed feelings about 
it.

Adding entities to multiple overlapping chains somehow doesn't feel right. 
What would you think about using a pipeline object instead, which would store 
all entities in the pipeline ?

The driver currently iterates over all entities in a chain for several 
purposes:

- registering streaming terminals as video nodes (uvc_driver.c)
- registering MC entities (uvc_entity.c)
- enumerating inputs (uvc_v4l2.c)
- finding controls and extension units (uvc_ctrl.c)

The first two uses could easily be replaced by iterations over the whole 
pipeline. Input enumeration would probably require a bit of custom code 
anyway, so we would be left with controls.

At first sight it would make sense to expose on a video node only the controls 
that can be reached from that video node moving up the pipeline (relatively to 
the video flow). However, this might break existing applications, as the 
driver currently also includes controls reacheable by forward scans of side 
branches. We thus need to carefully think about what controls to include, and 
we need to take into account output video nodes corresponding to input 
streaming terminals.

> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c   |  70 ++++++++-----
>  drivers/media/usb/uvc/uvc_driver.c | 210  +++++++++++++++++++--------------
>  drivers/media/usb/uvc/uvc_entity.c |  15 ++-
>  drivers/media/usb/uvc/uvc_v4l2.c   |   9 +-
>  drivers/media/usb/uvc/uvcvideo.h   |  20 +++-
>  5 files changed, 199 insertions(+), 125 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index a2f4501..ba159a4 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -841,6 +841,7 @@ static struct uvc_control *uvc_find_control(struct
> uvc_video_chain *chain, {
>  	struct uvc_control *ctrl = NULL;
>  	struct uvc_entity *entity;
> +	struct uvc_chain_entry *entry;
>  	int next = v4l2_id & V4L2_CTRL_FLAG_NEXT_CTRL;
> 
>  	*mapping = NULL;
> @@ -849,7 +850,8 @@ static struct uvc_control *uvc_find_control(struct
> uvc_video_chain *chain, v4l2_id &= V4L2_CTRL_ID_MASK;
> 
>  	/* Find the control. */
> -	list_for_each_entry(entity, &chain->entities, chain) {
> +	list_for_each_entry(entry, &chain->entities, chain_entry) {
> +		entity = entry->entity;
>  		__uvc_find_control(entity, v4l2_id, mapping, &ctrl, next);
>  		if (ctrl && !next)
>  			return ctrl;
> @@ -1048,6 +1050,16 @@ static int __uvc_query_v4l2_ctrl(struct
> uvc_video_chain *chain, return 0;
>  }
> 
> +int __uvc_ctrl_lock(struct uvc_video_chain *chain)
> +{
> +	return mutex_lock_interruptible(&chain->pipeline->ctrl_mutex) ?
> +					-ERESTARTSYS : 0;
> +}
> +void __uvc_ctrl_unlock(struct uvc_video_chain *chain)
> +{
> +	mutex_unlock(&chain->pipeline->ctrl_mutex);
> +}
> +
>  int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
>  	struct v4l2_queryctrl *v4l2_ctrl)
>  {
> @@ -1055,9 +1067,9 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
> struct uvc_control_mapping *mapping;
>  	int ret;
> 
> -	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
> +	ret = __uvc_ctrl_lock(chain);
>  	if (ret < 0)
> -		return -ERESTARTSYS;
> +		return ret;
> 
>  	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
>  	if (ctrl == NULL) {
> @@ -1067,7 +1079,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
> 
>  	ret = __uvc_query_v4l2_ctrl(chain, ctrl, mapping, v4l2_ctrl);
>  done:
> -	mutex_unlock(&chain->ctrl_mutex);
> +	__uvc_ctrl_unlock(chain);
>  	return ret;
>  }
> 
> @@ -1094,9 +1106,9 @@ int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
> query_menu->id = id;
>  	query_menu->index = index;
> 
> -	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
> +	ret = __uvc_ctrl_lock(chain);
>  	if (ret < 0)
> -		return -ERESTARTSYS;
> +		return ret;
> 
>  	ctrl = uvc_find_control(chain, query_menu->id, &mapping);
>  	if (ctrl == NULL || mapping->v4l2_type != V4L2_CTRL_TYPE_MENU) {
> @@ -1132,7 +1144,7 @@ int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
> strlcpy(query_menu->name, menu_info->name, sizeof query_menu->name);
> 
>  done:
> -	mutex_unlock(&chain->ctrl_mutex);
> +	__uvc_ctrl_unlock(chain);
>  	return ret;
>  }
> 
> @@ -1257,9 +1269,9 @@ static int uvc_ctrl_add_event(struct
> v4l2_subscribed_event *sev, unsigned elems) struct uvc_control *ctrl;
>  	int ret;
> 
> -	ret = mutex_lock_interruptible(&handle->chain->ctrl_mutex);
> +	ret = __uvc_ctrl_lock(handle->chain);
>  	if (ret < 0)
> -		return -ERESTARTSYS;
> +		return ret;
> 
>  	ctrl = uvc_find_control(handle->chain, sev->id, &mapping);
>  	if (ctrl == NULL) {
> @@ -1285,7 +1297,7 @@ static int uvc_ctrl_add_event(struct
> v4l2_subscribed_event *sev, unsigned elems) }
> 
>  done:
> -	mutex_unlock(&handle->chain->ctrl_mutex);
> +	__uvc_ctrl_unlock(handle->chain);
>  	return ret;
>  }
> 
> @@ -1293,9 +1305,9 @@ static void uvc_ctrl_del_event(struct
> v4l2_subscribed_event *sev) {
>  	struct uvc_fh *handle = container_of(sev->fh, struct uvc_fh, vfh);
> 
> -	mutex_lock(&handle->chain->ctrl_mutex);
> +	__uvc_ctrl_lock(handle->chain);
>  	list_del(&sev->node);
> -	mutex_unlock(&handle->chain->ctrl_mutex);
> +	__uvc_ctrl_unlock(handle->chain);
>  }
> 
>  const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops = {
> @@ -1331,7 +1343,7 @@ const struct v4l2_subscribed_event_ops
> uvc_ctrl_sub_ev_ops = { */
>  int uvc_ctrl_begin(struct uvc_video_chain *chain)
>  {
> -	return mutex_lock_interruptible(&chain->ctrl_mutex) ? -ERESTARTSYS : 0;
> +	return __uvc_ctrl_lock(chain);
>  }
> 
>  static int uvc_ctrl_commit_entity(struct uvc_device *dev,
> @@ -1390,10 +1402,12 @@ int __uvc_ctrl_commit(struct uvc_fh *handle, int
> rollback, {
>  	struct uvc_video_chain *chain = handle->chain;
>  	struct uvc_entity *entity;
> +	struct uvc_chain_entry *entry;
>  	int ret = 0;
> 
>  	/* Find the control. */
> -	list_for_each_entry(entity, &chain->entities, chain) {
> +	list_for_each_entry(entry, &chain->entities, chain_entry) {
> +		entity = entry->entity;
>  		ret = uvc_ctrl_commit_entity(chain->dev, entity, rollback);
>  		if (ret < 0)
>  			goto done;
> @@ -1402,7 +1416,7 @@ int __uvc_ctrl_commit(struct uvc_fh *handle, int
> rollback, if (!rollback)
>  		uvc_ctrl_send_events(handle, xctrls, xctrls_count);
>  done:
> -	mutex_unlock(&chain->ctrl_mutex);
> +	__uvc_ctrl_unlock(chain);
>  	return ret;
>  }
> 
> @@ -1667,7 +1681,8 @@ static int uvc_ctrl_init_xu_ctrl(struct uvc_device
> *dev, int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
>  	struct uvc_xu_control_query *xqry)
>  {
> -	struct uvc_entity *entity;
> +	struct uvc_entity *entity = NULL;
> +	struct uvc_chain_entry *entry;
>  	struct uvc_control *ctrl;
>  	unsigned int i, found = 0;
>  	__u32 reqflags;
> @@ -1676,13 +1691,14 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
> int ret;
> 
>  	/* Find the extension unit. */
> -	list_for_each_entry(entity, &chain->entities, chain) {
> +	list_for_each_entry(entry, &chain->entities, chain_entry) {
> +		entity = entry->entity;
>  		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT &&
>  		    entity->id == xqry->unit)
>  			break;
>  	}
> 
> -	if (entity->id != xqry->unit) {
> +	if (!entity || entity->id != xqry->unit) {
>  		uvc_trace(UVC_TRACE_CONTROL, "Extension unit %u not found.\n",
>  			xqry->unit);
>  		return -ENOENT;
> @@ -1703,8 +1719,9 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
>  		return -ENOENT;
>  	}
> 
> -	if (mutex_lock_interruptible(&chain->ctrl_mutex))
> -		return -ERESTARTSYS;
> +	ret = __uvc_ctrl_lock(chain);
> +	if (ret < 0)
> +		return ret;
> 
>  	ret = uvc_ctrl_init_xu_ctrl(chain->dev, ctrl);
>  	if (ret < 0) {
> @@ -1778,7 +1795,7 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
>  		ret = -EFAULT;
>  done:
>  	kfree(data);
> -	mutex_unlock(&chain->ctrl_mutex);
> +	__uvc_ctrl_unlock(chain);
>  	return ret;
>  }
> 
> @@ -1904,6 +1921,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain, const struct uvc_control_mapping *mapping)
>  {
>  	struct uvc_device *dev = chain->dev;
> +	struct uvc_chain_entry *entry;
>  	struct uvc_control_mapping *map;
>  	struct uvc_entity *entity;
>  	struct uvc_control *ctrl;
> @@ -1918,8 +1936,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain, }
> 
>  	/* Search for the matching (GUID/CS) control on the current chain */
> -	list_for_each_entry(entity, &chain->entities, chain) {
> +	list_for_each_entry(entry, &chain->entities, chain_entry) {
>  		unsigned int i;
> +		entity = entry->entity;
> 
>  		if (UVC_ENTITY_TYPE(entity) != UVC_VC_EXTENSION_UNIT ||
>  		    !uvc_entity_match_guid(entity, mapping->entity))
> @@ -1939,8 +1958,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain, if (!found)
>  		return -ENOENT;
> 
> -	if (mutex_lock_interruptible(&chain->ctrl_mutex))
> -		return -ERESTARTSYS;
> +	ret = __uvc_ctrl_lock(chain);
> +	if (ret < 0)
> +		return ret;
> 
>  	/* Perform delayed initialization of XU controls */
>  	ret = uvc_ctrl_init_xu_ctrl(dev, ctrl);
> @@ -1974,7 +1994,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain, atomic_dec(&dev->nmappings);
> 
>  done:
> -	mutex_unlock(&chain->ctrl_mutex);
> +	__uvc_ctrl_unlock(chain);
>  	return ret;
>  }
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 81695d4..d7ff707 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1215,6 +1215,36 @@ next_descriptor:
>   * UVC device scan
>   */
> 
> +static int uvc_add_chain_entry(struct uvc_video_chain *chain,
> +				struct uvc_entity *entity)
> +{
> +	struct uvc_chain_entry *chain_entry;
> +
> +	chain_entry = kzalloc(sizeof(struct uvc_chain_entry), GFP_KERNEL);
> +	if (!chain_entry)
> +		return -ENOMEM;
> +
> +	chain_entry->entity = entity;
> +	list_add_tail(&chain_entry->chain_entry, &chain->entities);
> +	if (!entity->chain)
> +		entity->chain = chain;
> +
> +	return 0;
> +}
> +
> +static void uvc_delete_chain(struct uvc_video_chain *chain)
> +{
> +	struct list_head *p, *n;
> +	struct uvc_chain_entry *entry;
> +
> +	list_for_each_safe(p, n, &chain->entities) {
> +		entry = list_entry(p, struct uvc_chain_entry, chain_entry);
> +		kfree(entry);
> +	}
> +
> +	kfree(chain);
> +}
> +
>  /*
>   * Scan the UVC descriptors to locate a chain starting at an Output
> Terminal * and containing the following units:
> @@ -1320,72 +1350,7 @@ static int uvc_scan_chain_entity(struct
> uvc_video_chain *chain, return -1;
>  	}
> 
> -	list_add_tail(&entity->chain, &chain->entities);
> -	return 0;
> -}
> -
> -static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
> -	struct uvc_entity *entity, struct uvc_entity *prev)
> -{
> -	struct uvc_entity *forward;
> -	int found;
> -
> -	/* Forward scan */
> -	forward = NULL;
> -	found = 0;
> -
> -	while (1) {
> -		forward = uvc_entity_by_reference(chain->dev, entity->id,
> -			forward);
> -		if (forward == NULL)
> -			break;
> -		if (forward == prev)
> -			continue;
> -
> -		switch (UVC_ENTITY_TYPE(forward)) {
> -		case UVC_VC_EXTENSION_UNIT:
> -			if (forward->bNrInPins != 1) {
> -				uvc_trace(UVC_TRACE_DESCR, "Extension unit %d "
> -					  "has more than 1 input pin.\n",
> -					  entity->id);
> -				return -EINVAL;
> -			}
> -
> -			list_add_tail(&forward->chain, &chain->entities);
> -			if (uvc_trace_param & UVC_TRACE_PROBE) {
> -				if (!found)
> -					printk(" (->");
> -
> -				printk(" XU %d", forward->id);
> -				found = 1;
> -			}
> -			break;
> -
> -		case UVC_OTT_VENDOR_SPECIFIC:
> -		case UVC_OTT_DISPLAY:
> -		case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
> -		case UVC_TT_STREAMING:
> -			if (UVC_ENTITY_IS_ITERM(forward)) {
> -				uvc_trace(UVC_TRACE_DESCR, "Unsupported input "
> -					"terminal %u.\n", forward->id);
> -				return -EINVAL;
> -			}
> -
> -			list_add_tail(&forward->chain, &chain->entities);
> -			if (uvc_trace_param & UVC_TRACE_PROBE) {
> -				if (!found)
> -					printk(" (->");
> -
> -				printk(" OT %d", forward->id);
> -				found = 1;
> -			}
> -			break;
> -		}
> -	}
> -	if (found)
> -		printk(")");
> -
> -	return 0;
> +	return uvc_add_chain_entry(chain, entity);
>  }
> 
>  static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
> @@ -1394,6 +1359,7 @@ static int uvc_scan_chain_backward(struct
> uvc_video_chain *chain, struct uvc_entity *entity = *_entity;
>  	struct uvc_entity *term;
>  	int id = -EINVAL, i;
> +	int ret;
> 
>  	switch (UVC_ENTITY_TYPE(entity)) {
>  	case UVC_VC_EXTENSION_UNIT:
> @@ -1425,8 +1391,9 @@ static int uvc_scan_chain_backward(struct
> uvc_video_chain *chain, if (uvc_trace_param & UVC_TRACE_PROBE)
>  				printk(" %d", term->id);
> 
> -			list_add_tail(&term->chain, &chain->entities);
> -			uvc_scan_chain_forward(chain, term, entity);
> +			ret = uvc_add_chain_entry(chain, term);
> +			if (ret)
> +				return ret;
>  		}
> 
>  		if (uvc_trace_param & UVC_TRACE_PROBE)
> @@ -1473,23 +1440,23 @@ static int uvc_scan_chain(struct uvc_video_chain
> *chain, prev = NULL;
> 
>  	while (entity != NULL) {
> -		/* Entity must not be part of an existing chain */
> -		if (entity->chain.next || entity->chain.prev) {
> -			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
> -				"entity %d already in chain.\n", entity->id);
> +		if (entity->chain == chain) {
> +			uvc_trace(UVC_TRACE_DESCR, "Found a cycle in the "
> +					"chain");
>  			return -EINVAL;
>  		}
> 
> +		/* If this entity is a part of an existing chain, the
> +		 * current chain belongs to the same pipeline.
> +		 */
> +		if (entity->chain)
> +			chain->pipeline = entity->chain->pipeline;
> +
>  		/* Process entity */
>  		if (uvc_scan_chain_entity(chain, entity) < 0)
>  			return -EINVAL;
> 
> -		/* Forward scan */
> -		if (uvc_scan_chain_forward(chain, entity, prev) < 0)
> -			return -EINVAL;
> -
>  		/* Backward scan */
> -		prev = entity;
>  		if (uvc_scan_chain_backward(chain, &entity) < 0)
>  			return -EINVAL;
>  	}
> @@ -1501,10 +1468,12 @@ static unsigned int uvc_print_terms(struct list_head
> *terms, u16 dir, char *buffer)
>  {
>  	struct uvc_entity *term;
> +	struct uvc_chain_entry *entry;
>  	unsigned int nterms = 0;
>  	char *p = buffer;
> 
> -	list_for_each_entry(term, terms, chain) {
> +	list_for_each_entry(entry, terms, chain_entry) {
> +		term = entry->entity;
>  		if (!UVC_ENTITY_IS_TERM(term) ||
>  		    UVC_TERM_DIRECTION(term) != dir)
>  			continue;
> @@ -1541,39 +1510,58 @@ static const char *uvc_print_chain(struct
> uvc_video_chain *chain) static int uvc_scan_device(struct uvc_device *dev)
>  {
>  	struct uvc_video_chain *chain;
> -	struct uvc_entity *term;
> +	struct uvc_entity *entity, *source;
> +	int ret;
> 
> -	list_for_each_entry(term, &dev->entities, list) {
> -		if (!UVC_ENTITY_IS_OTERM(term))
> +	list_for_each_entry(entity, &dev->entities, list) {
> +		if (!UVC_ENTITY_IS_OTERM(entity))
>  			continue;
> 
> -		/* If the terminal is already included in a chain, skip it.
> -		 * This can happen for chains that have multiple output
> -		 * terminals, where all output terminals beside the first one
> -		 * will be inserted in the chain in forward scans.
> +		/* Allow single-unit branches of Output Terminals to reside
> +		 * on the existing chains.
>  		 */
> -		if (term->chain.next || term->chain.prev)
> -			continue;
> +		source = uvc_entity_by_id(dev, entity->baSourceID[0]);
> +		if (entity == NULL) {
> +			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
> +				"unknown entity %d.\n", entity->baSourceID[0]);
> +			return -EINVAL;
> +		}
> 
>  		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
>  		if (chain == NULL)
>  			return -ENOMEM;
> 
>  		INIT_LIST_HEAD(&chain->entities);
> -		mutex_init(&chain->ctrl_mutex);
>  		chain->dev = dev;
>  		v4l2_prio_init(&chain->prio);
> 
> -		term->flags |= UVC_ENTITY_FLAG_DEFAULT;
> +		entity->flags |= UVC_ENTITY_FLAG_DEFAULT;
> 
> -		if (uvc_scan_chain(chain, term) < 0) {
> -			kfree(chain);
> +		if (uvc_scan_chain(chain, entity) < 0) {
> +			uvc_delete_chain(chain);
>  			continue;
>  		}
> 
>  		uvc_trace(UVC_TRACE_PROBE, "Found a valid video chain (%s).\n",
>  			  uvc_print_chain(chain));
> 
> +		/*
> +		 * If none of the entities are shared, allocate a new pipeline.
> +		 * Otherwise, the shared pipeline is already set up.
> +		 */
> +		if (!chain->pipeline) {
> +			chain->pipeline = kzalloc(sizeof(*chain->pipeline),
> +						  GFP_KERNEL);
> +			if (!chain->pipeline) {
> +				uvc_delete_chain(chain);
> +				return -ENOMEM;
> +			}
> +			mutex_init(&chain->pipeline->ctrl_mutex);
> +			atomic_set(&chain->pipeline->num_chains, 1);
> +		} else {
> +			atomic_inc(&chain->pipeline->num_chains);
> +		}
> +
>  		list_add_tail(&chain->list, &dev->chains);
>  	}
> 
> @@ -1582,6 +1570,38 @@ static int uvc_scan_device(struct uvc_device *dev)
>  		return -1;
>  	}
> 
> +	/* Find branches with no OTERMs (if any) by looking for entities not
> +	 * on any chain. Accept only branches with a single Extension Unit.
> +	 */
> +	list_for_each_entry(entity, &dev->entities, list) {
> +		if (entity->chain)
> +			continue;
> +
> +		if (UVC_ENTITY_TYPE(entity) != UVC_VC_EXTENSION_UNIT
> +			|| entity->bNrInPins != 1
> +			|| uvc_entity_by_reference(dev, entity->id, NULL)) {
> +			uvc_printk(KERN_INFO, "Found an invalid branch "
> +				"starting at entity id %d.\n", entity->id);
> +			return -1;
> +		}
> +
> +		/* Single-unit XU branch. */
> +		source = uvc_entity_by_id(dev, entity->baSourceID[0]);
> +		if (source == NULL) {
> +			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
> +				"unknown entity %d.\n", entity->baSourceID[0]);
> +			return -EINVAL;
> +		}
> +		if (!source->chain)
> +			continue;
> +
> +		ret = uvc_add_chain_entry(source->chain, entity);
> +		if (ret)
> +			return ret;
> +		uvc_trace(UVC_TRACE_DESCR, "XU %d <- (%d)\n",
> +				entity->id, source->id);
> +	}
> +
>  	return 0;
>  }
> 
> @@ -1619,7 +1639,9 @@ static void uvc_delete(struct uvc_device *dev)
>  	list_for_each_safe(p, n, &dev->chains) {
>  		struct uvc_video_chain *chain;
>  		chain = list_entry(p, struct uvc_video_chain, list);
> -		kfree(chain);
> +		if (atomic_dec_and_test(&chain->pipeline->num_chains))
> +			kfree(chain->pipeline);
> +		uvc_delete_chain(chain);
>  	}
> 
>  	list_for_each_safe(p, n, &dev->entities) {
> @@ -1763,9 +1785,11 @@ static int uvc_register_terms(struct uvc_device *dev,
> {
>  	struct uvc_streaming *stream;
>  	struct uvc_entity *term;
> +	struct uvc_chain_entry *entry;
>  	int ret;
> 
> -	list_for_each_entry(term, &chain->entities, chain) {
> +	list_for_each_entry(entry, &chain->entities, chain_entry) {
> +		term = entry->entity;
>  		if (UVC_ENTITY_TYPE(term) != UVC_TT_STREAMING)
>  			continue;
> 
> diff --git a/drivers/media/usb/uvc/uvc_entity.c
> b/drivers/media/usb/uvc/uvc_entity.c index dc56a59..657f49a 100644
> --- a/drivers/media/usb/uvc/uvc_entity.c
> +++ b/drivers/media/usb/uvc/uvc_entity.c
> @@ -104,9 +104,14 @@ static int uvc_mc_init_entity(struct uvc_entity
> *entity) int uvc_mc_register_entities(struct uvc_video_chain *chain)
>  {
>  	struct uvc_entity *entity;
> +	struct uvc_chain_entry *entry;
>  	int ret;
> 
> -	list_for_each_entry(entity, &chain->entities, chain) {
> +	list_for_each_entry(entry, &chain->entities, chain_entry) {
> +		entity = entry->entity;
> +		if (entity->registered)
> +			continue;
> +
>  		ret = uvc_mc_init_entity(entity);
>  		if (ret < 0) {
>  			uvc_printk(KERN_INFO, "Failed to initialize entity for "
> @@ -115,13 +120,19 @@ int uvc_mc_register_entities(struct uvc_video_chain
> *chain) }
>  	}
> 
> -	list_for_each_entry(entity, &chain->entities, chain) {
> +	list_for_each_entry(entry, &chain->entities, chain_entry) {
> +		entity = entry->entity;
> +		if (entity->registered)
> +			continue;
> +
>  		ret = uvc_mc_register_entity(chain, entity);
>  		if (ret < 0) {
>  			uvc_printk(KERN_INFO, "Failed to register entity for "
>  				   "entity %u\n", entity->id);
>  			return ret;
>  		}
> +
> +		entity->registered = true;
>  	}
> 
>  	return 0;
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 3afff92..a899159 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -713,6 +713,7 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) const struct uvc_entity *selector =
> chain->selector;
>  		struct v4l2_input *input = arg;
>  		struct uvc_entity *iterm = NULL;
> +		struct uvc_chain_entry *entry;
>  		u32 index = input->index;
>  		int pin = 0;
> 
> @@ -720,14 +721,18 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) (chain->dev->quirks &
> UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
>  			if (index != 0)
>  				return -EINVAL;
> -			list_for_each_entry(iterm, &chain->entities, chain) {
> +			list_for_each_entry(entry, &chain->entities,
> +						chain_entry) {
> +				iterm = entry->entity;
>  				if (UVC_ENTITY_IS_ITERM(iterm))
>  					break;
>  			}
>  			pin = iterm->id;
>  		} else if (index < selector->bNrInPins) {
>  			pin = selector->baSourceID[index];
> -			list_for_each_entry(iterm, &chain->entities, chain) {
> +			list_for_each_entry(entry, &chain->entities,
> +						chain_entry) {
> +				iterm = entry->entity;
>  				if (!UVC_ENTITY_IS_ITERM(iterm))
>  					continue;
>  				if (iterm->id == pin)
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 75e0153..731b378 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -229,8 +229,8 @@ struct uvc_format_desc {
> 
>  struct uvc_entity {
>  	struct list_head list;		/* Entity as part of a UVC device. */
> -	struct list_head chain;		/* Entity as part of a video device
> -					 * chain. */
> +	struct uvc_video_chain *chain;  /* Entity as a part of a video device
> +					   chain. */
>  	unsigned int flags;
> 
>  	__u8 id;
> @@ -243,6 +243,7 @@ struct uvc_entity {
>  	unsigned int num_pads;
>  	unsigned int num_links;
>  	struct media_pad *pads;
> +	bool registered;		/* True if already registered with MC */
> 
>  	union {
>  		struct {
> @@ -289,6 +290,12 @@ struct uvc_entity {
>  	struct uvc_control *controls;
>  };
> 
> +struct uvc_chain_entry {
> +	struct list_head chain_entry;
> +	struct uvc_entity *entity;
> +	struct uvc_video_chain *chain;
> +};
> +
>  struct uvc_frame {
>  	__u8  bFrameIndex;
>  	__u8  bmCapabilities;
> @@ -366,6 +373,12 @@ struct uvc_video_queue {
>  	struct list_head irqqueue;
>  };
> 
> +struct uvc_video_pipeline {
> +	struct mutex ctrl_mutex;                /* Protects controls in all
> +						   chains of this pipeline */
> +	atomic_t num_chains;
> +};
> +
>  struct uvc_video_chain {
>  	struct uvc_device *dev;
>  	struct list_head list;
> @@ -374,7 +387,8 @@ struct uvc_video_chain {
>  	struct uvc_entity *processing;		/* Processing unit */
>  	struct uvc_entity *selector;		/* Selector unit */
> 
> -	struct mutex ctrl_mutex;		/* Protects ctrl.info */
> +	struct uvc_video_pipeline *pipeline;    /* Pipeline this chain
> +						   belongs to */
> 
>  	struct v4l2_prio_state prio;		/* V4L2 priority state */
>  	u32 caps;				/* V4L2 chain-wide caps */
-- 
Regards,

Laurent Pinchart

