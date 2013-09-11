Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1446 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab3IKNsd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 09:48:33 -0400
Message-ID: <523074A3.407@xs4all.nl>
Date: Wed, 11 Sep 2013 15:48:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	sylvester.nawrocki@gmail.com, sakari.ailus@iki.fi
Subject: Re: [PATCH/RFC v3 06/19] video: display: OF support
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1376089398-13322-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1378304498.5721.42.camel@pizza.hi.pengutronix.de> <2263372.8nCBHctlWT@avalon>
In-Reply-To: <2263372.8nCBHctlWT@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/11/2013 01:33 PM, Laurent Pinchart wrote:
> Hi Philipp,
> 
> On Wednesday 04 September 2013 16:21:38 Philipp Zabel wrote:
>> Am Samstag, den 10.08.2013, 01:03 +0200 schrieb Laurent Pinchart:
>>> Extend the notifier with DT node matching support, and add helper
>>> functions to build the notifier and link entities based on a graph
>>> representation in DT.
>>>
>>> Signed-off-by: Laurent Pinchart
>>> <laurent.pinchart+renesas@ideasonboard.com>
>>> ---
>>>
>>>  drivers/video/display/display-core.c     | 334 ++++++++++++++++++++++++++
>>>  drivers/video/display/display-notifier.c | 187 +++++++++++++++++
>>>  include/video/display.h                  |  45 +++++
>>>  3 files changed, 566 insertions(+)
>>>
>>> diff --git a/drivers/video/display/display-core.c
>>> b/drivers/video/display/display-core.c index c3b47d3..328ead7 100644
>>> --- a/drivers/video/display/display-core.c
>>> +++ b/drivers/video/display/display-core.c
>>
>> [...]
>>
>>> @@ -420,6 +599,161 @@ int display_entity_link_graph(struct device *dev,
>>> struct list_head *entities)> 
>>>  }
>>>  EXPORT_SYMBOL_GPL(display_entity_link_graph);
>>>
>>> +#ifdef CONFIG_OF
>>> +
>>> +static int display_of_entity_link_entity(struct device *dev,
>>> +					 struct display_entity *entity,
>>> +					 struct list_head *entities,
>>> +					 struct display_entity *root)
>>> +{
>>> +	u32 link_flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
>>> +	const struct device_node *node = entity->dev->of_node;
>>
>> the current device tree matching implementation only allows one display
>> entity per linux device. How about adding an of_node pointer to struct
>> display_entity directly and allow multiple display entity nodes below in a
>> single device node in the device tree?
> 
> That's a very good point. We had a similar issues in V4L2, with sensors that 
> would create several entities. However, in those cases, the sensors would be 
> connected to the rest of the pipeline through a single entity :
> 
> Sensor Entity 1 -> ... -> Sensor Entity N -> V4L2 pipeline ...
> 
> The core code thus had to care about a single sensor entity when building the 
> pipeline. We could solve the problem in a similar way for panels, but encoders 
> need a more elaborate solution.

Why? Sorry, I don't see why an encoder is different in this respect than a panel.
I'm sure I'm missing something here.

> 
> I see (at least) two possibilities here, either explicitly describing all 
> entities that make the device in DT (as you have proposed below), or creating 
> a hierarchy of entities, with parent entities that can contain several child 
> entities. I've CC'ed Guennadi, Hans, Sylwester and Sakari to get their opinion 
> on the matter.

I think the way this is done today in complex devices is that the driver just
exposes itself as a single sub-device, but internally it has its own pipeline of
sub-devices. The only one that I know of (platform/s5p-tv/hdmi_drv) doesn't expose
them to a media controller, they are completely hidden inside the hdmi driver.

The ability to support hierarchies of entities would be very nice. However, I
don't know how much work that would be to implement and if it is worth the
effort.

Regards,

	Hans

> 
>> lvds-encoder {
>> 	channel@0 {
> 
> If I understand this correctly, your LVDS encoder has two independent 
> channels. In the general case a device made of multiple entities might have 
> those entities chained, so "channel" might not be the best term. "entity" 
> might be a better choice.
> 
>> 		port@0 {
>> 			lvds0_input: endpoint {
>> 			};
>> 		};
>> 		port@1 {
>> 			lvds0_output: endpoint {
>> 			};
>> 		};
>> 	};
>> 	channel@1 {
>> 		port@0 {
>> 			lvds1_input: endpoint {
>> 			};
>> 		};
>> 		lvds1: port@1 {
>> 			lvds1_output: endpoint {
>> 			};
>> 		};
>> 	};
>> };
>>
>>> +	struct media_entity *local = &entity->entity;
>>> +	struct device_node *ep = NULL;
>>> +	int ret = 0;
>>> +
>>> +	dev_dbg(dev, "creating links for entity %s\n", local->name);
>>> +
>>> +	while (1) {
>>> +		struct media_entity *remote = NULL;
>>> +		struct media_pad *remote_pad;
>>> +		struct media_pad *local_pad;
>>> +		struct display_of_link link;
>>> +		struct display_entity *ent;
>>> +		struct device_node *next;
>>> +
>>> +		/* Get the next endpoint and parse its link. */
>>> +		next = display_of_get_next_endpoint(node, ep);
>>> +		if (next == NULL)
>>> +			break;
>>> +
>>> +		of_node_put(ep);
>>> +		ep = next;
>>> +
>>> +		dev_dbg(dev, "processing endpoint %s\n", ep->full_name);
>>> +
>>> +		ret = display_of_parse_link(ep, &link);
>>> +		if (ret < 0) {
>>> +			dev_err(dev, "failed to parse link for %s\n",
>>> +				ep->full_name);
>>> +			continue;
>>> +		}
>>> +
>>> +		/* Skip source pads, they will be processed from the other end of
>>> +		 * the link.
>>> +		 */
>>> +		if (link.local_port >= local->num_pads) {
>>> +			dev_err(dev, "invalid port number %u on %s\n",
>>> +				link.local_port, link.local_node->full_name);
>>> +			display_of_put_link(&link);
>>> +			ret = -EINVAL;
>>> +			break;
>>> +		}
>>> +
>>> +		local_pad = &local->pads[link.local_port];
>>> +
>>> +		if (local_pad->flags & MEDIA_PAD_FL_SOURCE) {
>>> +			dev_dbg(dev, "skipping source port %s:%u\n",
>>> +				link.local_node->full_name, link.local_port);
>>> +			display_of_put_link(&link);
>>> +			continue;
>>> +		}
>>> +
>>> +		/* Find the remote entity. If not found, just skip the link as
>>> +		 * it goes out of scope of the entities handled by the notifier.
>>> +		 */
>>> +		list_for_each_entry(ent, entities, list) {
>>> +			if (ent->dev->of_node == link.remote_node) {
>>> +				remote = &ent->entity;
>>> +				break;
>>> +			}
>>> +		}
>>> +
>>> +		if (root->dev->of_node == link.remote_node)
>>> +			remote = &root->entity;
>>> +
>>> +		if (remote == NULL) {
>>> +			dev_dbg(dev, "no entity found for %s\n",
>>> +				link.remote_node->full_name);
>>> +			display_of_put_link(&link);
>>> +			continue;
>>> +		}
>>> +
>>> +		if (link.remote_port >= remote->num_pads) {
>>> +			dev_err(dev, "invalid port number %u on %s\n",
>>> +				link.remote_port, link.remote_node->full_name);
>>> +			display_of_put_link(&link);
>>> +			ret = -EINVAL;
>>> +			break;
>>> +		}
>>> +
>>> +		remote_pad = &remote->pads[link.remote_port];
>>> +
>>> +		display_of_put_link(&link);
>>> +
>>> +		/* Create the media link. */
>>> +		dev_dbg(dev, "creating %s:%u -> %s:%u link\n",
>>> +			remote->name, remote_pad->index,
>>> +			local->name, local_pad->index);
>>> +
>>> +		ret = media_entity_create_link(remote, remote_pad->index,
>>> +					       local, local_pad->index,
>>> +					       link_flags);
>>> +		if (ret < 0) {
>>> +			dev_err(dev,
>>> +				"failed to create %s:%u -> %s:%u link\n",
>>> +				remote->name, remote_pad->index,
>>> +				local->name, local_pad->index);
>>> +			break;
>>> +		}
>>> +	}
>>> +
>>> +	of_node_put(ep);
>>> +	return ret;
>>> +}
>>
>> [...]
>>
>> For example like this:
>>
>> diff --git a/drivers/video/display/display-core.c
>> b/drivers/video/display/display-core.c index 7910c23..a04feed 100644
>> --- a/drivers/video/display/display-core.c
>> +++ b/drivers/video/display/display-core.c
>> @@ -302,6 +302,9 @@ int display_entity_init(struct display_entity *entity,
>> unsigned int num_sinks, kref_init(&entity->ref);
>>  	entity->state = DISPLAY_ENTITY_STATE_OFF;
>>
>> +	if (!entity->of_node && entity->dev)
>> +		entity->of_node = entity->dev->of_node;
>> +
>>  	num_pads = num_sinks + num_sources;
>>  	pads = kzalloc(sizeof(*pads) * num_pads, GFP_KERNEL);
>>  	if (pads == NULL)
>> @@ -665,7 +668,7 @@ static int display_of_entity_link_entity(struct device
>> *dev, struct display_entity *root)
>>  {
>>  	u32 link_flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
>> -	const struct device_node *node = entity->dev->of_node;
>> +	const struct device_node *node = entity->of_node;
>>  	struct media_entity *local = &entity->entity;
>>  	struct device_node *ep = NULL;
>>  	int num_sink, ret = 0;
>> @@ -727,13 +730,13 @@ static int display_of_entity_link_entity(struct device
>> *dev, * it goes out of scope of the entities handled by the notifier. */
>>  		list_for_each_entry(ent, entities, list) {
>> -			if (ent->dev->of_node == link.remote_node) {
>> +			if (ent->of_node == link.remote_node) {
>>  				remote = &ent->entity;
>>  				break;
>>  			}
>>  		}
>>
>> -		if (root && root->dev->of_node == link.remote_node)
>> +		if (root && root->of_node == link.remote_node)
>>  			remote = &root->entity;
>>
>>  		if (remote == NULL) {
>> diff --git a/drivers/video/display/display-notifier.c
>> b/drivers/video/display/display-notifier.c index a3998c7..d0da6e5 100644
>> --- a/drivers/video/display/display-notifier.c
>> +++ b/drivers/video/display/display-notifier.c
>> @@ -28,28 +28,30 @@ static DEFINE_MUTEX(display_entity_mutex);
>>   * Notifiers
>>   */
>>
>> -static bool match_platform(struct device *dev,
>> +static bool match_platform(struct display_entity *entity,
>>  			   struct display_entity_match *match)
>>  {
>>  	pr_debug("%s: matching device '%s' with name '%s'\n", __func__,
>> -		 dev_name(dev), match->match.platform.name);
>> +		 dev_name(entity->dev), match->match.platform.name);
>>
>> -	return !strcmp(match->match.platform.name, dev_name(dev));
>> +	return !strcmp(match->match.platform.name, dev_name(entity->dev));
>>  }
>>
>> -static bool match_dt(struct device *dev, struct display_entity_match
>> *match) +static bool match_dt(struct display_entity *entity,
>> +		     struct display_entity_match *match)
>>  {
>>  	pr_debug("%s: matching device node '%s' with node '%s'\n", __func__,
>> -		 dev->of_node->full_name, match->match.dt.node->full_name);
>> +		 entity->of_node->full_name, match->match.dt.node->full_name);
>>
>> -	return match->match.dt.node == dev->of_node;
>> +	return match->match.dt.node == entity->of_node;
>>  }
>>
>>  static struct display_entity_match *
>>  display_entity_notifier_match(struct display_entity_notifier *notifier,
>>  			      struct display_entity *entity)
>>  {
>> -	bool (*match_func)(struct device *, struct display_entity_match *);
>> +	bool (*match_func)(struct display_entity *,
>> +			   struct display_entity_match *);
>>  	struct display_entity_match *match;
>>
>>  	pr_debug("%s: matching entity '%s' (ptr 0x%p dev '%s')\n", __func__,
>> @@ -66,7 +68,7 @@ display_entity_notifier_match(struct
>> display_entity_notifier *notifier, break;
>>  		}
>>
>> -		if (match_func(entity->dev, match))
>> +		if (match_func(entity, match))
>>  			return match;
>>  	}
>>
>> diff --git a/include/video/display.h b/include/video/display.h
>> index 4c402bee..d1f8833 100644
>> --- a/include/video/display.h
>> +++ b/include/video/display.h
>> @@ -228,6 +228,7 @@ struct display_entity {
>>  	struct list_head list;
>>  	struct device *dev;
>>  	struct module *owner;
>> +	struct device_node *of_node;
>>  	struct kref ref;
>>
>>  	char name[32];
