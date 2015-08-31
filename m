Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33100 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbbHaNku (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 09:40:50 -0400
Date: Mon, 31 Aug 2015 10:40:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 49/55] [media] media-device: add support for
 MEDIA_IOC_G_TOPOLOGY ioctl
Message-ID: <20150831104045.58119a87@recife.lan>
In-Reply-To: <55E44CC7.2020801@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<8e914e59660fc35b074b72e39dc1b1200d52617b.1440902901.git.mchehab@osg.samsung.com>
	<55E44CC7.2020801@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2015 14:47:03 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/30/2015 05:07 AM, Mauro Carvalho Chehab wrote:
> > Add support for the new MEDIA_IOC_G_TOPOLOGY ioctl, according
> > with the RFC for the MC next generation.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 5b2c9f7fcd45..a91e1ec076a6 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -232,6 +232,136 @@ static long media_device_setup_link(struct media_device *mdev,
> >  	return ret;
> >  }
> >  
> > +static long __media_device_get_topology(struct media_device *mdev,
> > +				      struct media_v2_topology *topo)
> > +{
> > +	struct media_entity *entity;
> > +	struct media_interface *intf;
> > +	struct media_pad *pad;
> > +	struct media_link *link;
> > +	struct media_v2_entity uentity;
> > +	struct media_v2_interface uintf;
> > +	struct media_v2_pad upad;
> > +	struct media_v2_link ulink;
> > +	int ret = 0, i;
> > +
> > +	topo->topology_version = mdev->topology_version;
> > +
> > +	/* Get entities and number of entities */
> > +	i = 0;
> > +	media_device_for_each_entity(entity, mdev) {
> > +		i++;
> > +
> > +		if (ret || !topo->entities)
> > +			continue;
> 
> I would add:
> 
> 		if (i > topo->num_entities)
> 			continue;
> 
> The copy_to_user can succeed, even if i > num_entities depending on how the
> memory was allocated. So I would always check num_entities and refuse to go
> beyond it.

I think that the best is:

	if (i > topo->num_entities) {
		ret = -ENOSPC;
		continue;
	}

> 
> > +
> > +		/* Copy fields to userspace struct if not error */
> > +		memset(&uentity, 0, sizeof(uentity));
> > +		uentity.id = entity->graph_obj.id;
> > +		strncpy(uentity.name, entity->name,
> > +			sizeof(uentity.name));
> > +
> > +		if (copy_to_user(&topo->entities[i - 1], &uentity, sizeof(uentity)))
> > +			ret = -EFAULT;
> 
> I would just return here. If the user gives bogus values for this, then just
> give up.

With the above change, yes, we can just return -EFAULT here.

> 
> > +	}
> > +	topo->num_entities = i;
> 
> What to do if topo->entities != NULL and i > topo->num_entities? Just return 0
> or return ENOSPC? I'm in favor of ENOSPC since a partial topology result is
> useless. But if ENOSPC is returned, then all num_foo values should be updated
> with the current number of elements.
> 
> This behavior would be consistent with e.g. VIDIOC_G_EXT_CTRLS.

Ok. See above.

> > +
> > +	/* Get interfaces and number of interfaces */
> > +	i = 0;
> > +	media_device_for_each_intf(intf, mdev) {
> > +		i++;
> > +
> > +		if (ret || !topo->interfaces)
> > +			continue;
> > +
> > +		memset(&uintf, 0, sizeof(uintf));
> > +
> > +		/* Copy intf fields to userspace struct */
> > +		uintf.id = intf->graph_obj.id;
> > +		uintf.intf_type = intf->type;
> > +		uintf.flags = intf->flags;
> > +
> > +		if (media_type(&intf->graph_obj) == MEDIA_GRAPH_INTF_DEVNODE) {
> > +			struct media_intf_devnode *devnode;
> > +
> > +			devnode = intf_to_devnode(intf);
> > +
> > +			uintf.devnode.major = devnode->major;
> > +			uintf.devnode.minor = devnode->minor;
> > +		}
> > +
> > +		if (copy_to_user(&topo->interfaces[i - 1], &uintf, sizeof(uintf)))
> > +			ret = -EFAULT;
> > +	}
> > +	topo->num_interfaces = i;
> > +
> > +	/* Get pads and number of pads */
> > +	i = 0;
> > +	media_device_for_each_pad(pad, mdev) {
> > +		i++;
> > +
> > +		if (ret || !topo->pads)
> > +			continue;
> > +
> > +		memset(&upad, 0, sizeof(upad));
> > +
> > +		/* Copy pad fields to userspace struct */
> > +		upad.id = pad->graph_obj.id;
> > +		upad.entity_id = pad->entity->graph_obj.id;
> > +		upad.flags = pad->flags;
> > +
> > +		if (copy_to_user(&topo->pads[i - 1], &upad, sizeof(upad)))
> > +			ret = -EFAULT;
> > +	}
> > +	topo->num_pads = i;
> > +
> > +	/* Get links and number of links */
> > +	i = 0;
> > +	media_device_for_each_link(link, mdev) {
> > +		i++;
> > +
> > +		if (ret || !topo->links)
> > +			continue;
> > +
> > +		memset(&ulink, 0, sizeof(ulink));
> > +
> > +		/* Copy link fields to userspace struct */
> > +		ulink.id = link->graph_obj.id;
> > +		ulink.source_id = link->gobj0->id;
> > +		ulink.sink_id = link->gobj1->id;
> > +		ulink.flags = link->flags;
> > +
> > +		if (media_type(link->gobj0) != MEDIA_GRAPH_PAD)
> > +			ulink.flags |= MEDIA_NEW_LNK_FL_INTERFACE_LINK;
> > +
> > +		if (copy_to_user(&topo->links[i - 1], &ulink, sizeof(ulink)))
> > +			ret = -EFAULT;
> > +	}
> > +	topo->num_links = i;
> > +
> > +	return ret;
> > +}
> > +
> > +static long media_device_get_topology(struct media_device *mdev,
> > +				      struct media_v2_topology __user *utopo)
> > +{
> > +	struct media_v2_topology ktopo;
> > +	int ret;
> > +
> > +	ret = copy_from_user(&ktopo, utopo, sizeof(ktopo));
> > +
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = __media_device_get_topology(mdev, &ktopo);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = copy_to_user(utopo, &ktopo, sizeof(*utopo));
> > +
> > +	return ret;
> > +}
> > +
> >  static long media_device_ioctl(struct file *filp, unsigned int cmd,
> >  			       unsigned long arg)
> >  {
> > @@ -264,6 +394,13 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
> >  		mutex_unlock(&dev->graph_mutex);
> >  		break;
> >  
> > +	case MEDIA_IOC_G_TOPOLOGY:
> > +		mutex_lock(&dev->graph_mutex);
> > +		ret = media_device_get_topology(dev,
> > +				(struct media_v2_topology __user *)arg);
> > +		mutex_unlock(&dev->graph_mutex);
> > +		break;
> > +
> >  	default:
> >  		ret = -ENOIOCTLCMD;
> >  	}
> > @@ -312,6 +449,7 @@ static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
> >  	case MEDIA_IOC_DEVICE_INFO:
> >  	case MEDIA_IOC_ENUM_ENTITIES:
> >  	case MEDIA_IOC_SETUP_LINK:
> > +	case MEDIA_IOC_G_TOPOLOGY:
> >  		return media_device_ioctl(filp, cmd, arg);
> >  
> >  	case MEDIA_IOC_ENUM_LINKS32:
> > 
> 
> Note that this will need compat32 code eventually. Should probably be added to the
> todo list in the cover letter.

Ok.

> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
