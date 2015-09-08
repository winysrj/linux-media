Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36883 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753448AbbIHH0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2015 03:26:35 -0400
Date: Tue, 8 Sep 2015 10:26:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 49/55] [media] media-device: add support for
 MEDIA_IOC_G_TOPOLOGY ioctl
Message-ID: <20150908072628.GD3175@valkosipuli.retiisi.org.uk>
References: <8e914e59660fc35b074b72e39dc1b1200d52617b.1440902901.git.mchehab@osg.samsung.com>
 <2b36475229b2cbb574a03e7866bcbc7b04ff02cf.1441540862.git.mchehab@osg.samsung.com>
 <20150907221830.GC3175@valkosipuli.retiisi.org.uk>
 <20150907222357.60df5890@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150907222357.60df5890@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Sep 07, 2015 at 10:23:57PM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 8 Sep 2015 01:18:30 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > A few comments below.
> 
> Thanks for review!

You're welcome!

> > 
> > On Sun, Sep 06, 2015 at 09:03:09AM -0300, Mauro Carvalho Chehab wrote:
> > > Add support for the new MEDIA_IOC_G_TOPOLOGY ioctl, according
> > > with the RFC for the MC next generation.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > 
> > > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > > index 5b2c9f7fcd45..96a476eeb16e 100644
> > > --- a/drivers/media/media-device.c
> > > +++ b/drivers/media/media-device.c
> > > @@ -232,6 +232,156 @@ static long media_device_setup_link(struct media_device *mdev,
> > >  	return ret;
> > >  }
> > >  
> > > +static long __media_device_get_topology(struct media_device *mdev,
> > > +				      struct media_v2_topology *topo)
> > > +{
> > > +	struct media_entity *entity;
> > > +	struct media_interface *intf;
> > > +	struct media_pad *pad;
> > > +	struct media_link *link;
> > > +	struct media_v2_entity uentity;
> > > +	struct media_v2_interface uintf;
> > > +	struct media_v2_pad upad;
> > > +	struct media_v2_link ulink;
> > > +	int ret = 0, i;
> > 
> > I think i wants to be unsigned.
> 
> Yes, "i" can be unsigned. I'll change that.
> 
> > 
> > > +
> > > +	topo->topology_version = mdev->topology_version;
> > > +
> > > +	/* Get entities and number of entities */
> > > +	i = 0;
> > > +	media_device_for_each_entity(entity, mdev) {
> > > +		i++;
> > > +
> > > +		if (ret || !topo->entities)
> > > +			continue;
> > > +
> > > +		if (i > topo->num_entities) {
> > > +			ret = -ENOSPC;
> > > +			continue;
> > > +		}
> > > +
> > > +		/* Copy fields to userspace struct if not error */
> > > +		memset(&uentity, 0, sizeof(uentity));
> > > +		uentity.id = entity->graph_obj.id;
> > > +		strncpy(uentity.name, entity->name,
> > > +			sizeof(uentity.name));
> > > +
> > > +		if (copy_to_user(&topo->entities[i - 1], &uentity, sizeof(uentity)))
> > > +			ret = -EFAULT;
> > > +	}
> > > +	topo->num_entities = i;
> > > +
> > > +	/* Get interfaces and number of interfaces */
> > > +	i = 0;
> > > +	media_device_for_each_intf(intf, mdev) {
> > > +		i++;
> > > +
> > > +		if (ret || !topo->interfaces)
> > > +			continue;
> > > +
> > > +		if (i > topo->num_interfaces) {
> > > +			ret = -ENOSPC;
> > > +			continue;
> > > +		}
> > > +
> > > +		memset(&uintf, 0, sizeof(uintf));
> > > +
> > > +		/* Copy intf fields to userspace struct */
> > > +		uintf.id = intf->graph_obj.id;
> > > +		uintf.intf_type = intf->type;
> > > +		uintf.flags = intf->flags;
> > > +
> > > +		if (media_type(&intf->graph_obj) == MEDIA_GRAPH_INTF_DEVNODE) {
> > > +			struct media_intf_devnode *devnode;
> > > +
> > > +			devnode = intf_to_devnode(intf);
> > > +
> > > +			uintf.devnode.major = devnode->major;
> > > +			uintf.devnode.minor = devnode->minor;
> > > +		}
> > > +
> > > +		if (copy_to_user(&topo->interfaces[i - 1], &uintf, sizeof(uintf)))
> > > +			ret = -EFAULT;
> > > +	}
> > > +	topo->num_interfaces = i;
> > > +
> > > +	/* Get pads and number of pads */
> > > +	i = 0;
> > > +	media_device_for_each_pad(pad, mdev) {
> > > +		i++;
> > > +
> > > +		if (ret || !topo->pads)
> > > +			continue;
> > > +
> > > +		if (i > topo->num_pads) {
> > > +			ret = -ENOSPC;
> > > +			continue;
> > > +		}
> > > +
> > > +		memset(&upad, 0, sizeof(upad));
> > > +
> > > +		/* Copy pad fields to userspace struct */
> > > +		upad.id = pad->graph_obj.id;
> > 
> > How about the pad index? Shouldn't that be also passed to the user space for
> > every pad?
> 
> We've agreed to not pass the pad index to userspace at the MC workshop.
> 
> There are two aspects here to consider:
> 
> a) to properly represent the topology (e. g. TOPOLOGY)
> 
> Writing the userspace code to support it, I didn't find any need to
> pass it to userspace, as the data links are connected via the PAD object 
> ID.
> 
> The PAD index for userspace is just a number that it uses when
> generating the dot graph. See:
> 	https://mchehab.fedorapeople.org/mc-next-gen/au0828.png
> 
> This was generated by this tool:
> 	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/tree/contrib/test/mc_nextgen_test.c
> 
> And no pad index was required at all. What the tool does is that it
> generates the pad numbers just when the --dot option is used,
> at the media_show_graphviz() function.
> 
> Also, please notice that having a pad index makes harder to support
> dynamic PAD addition/removal, as the pad index numberspace will
> be discontinued.
> 
> b) using the PAD index to setup a link.
> 
> As I argued with Hans on one of his reviews, I don't think that
> an index is always the best way to refer to a PAD. 
> 
> See for example, the entity_1 on the au0828 (ATV decoder). It 
> has 3 PADs:
> 	- pad 0 - sink - receives an ATV signal [1]
> 	- pad 1 - source - it outputs a Video stream
> 	- pad 2 - source - it outputs a VBI stream
> 
> Pads 1 and 2 are not interchangeable, as they carry different
> types of data.
> 
> [1] Actually, to be honest, pad 0 there is also wrong. In a matter
> of fact, Composite, S-Video and Tuner interfaces are actually
> supported by 3 different PADs on the hardware. On some hardware,
> it is just a software configuration, but on others, different
> pins are used for each different input type. We just don't need
> to have all those details ATM on the Media Controller data flow,
> as the V4L2 input selection API at the /dev/video0 devnode hides
> those dirty details. Note however that, if we end by adding support
> for ATV decoder subdevice nodes, such level of detail may be
> required.
> 
> However some other ATV decoder could have mapped it on some
> different order, like:
> 	- pad 0 - sink - receives an ATV signal
> 	- pad 1 - source - it outputs a VBI stream
> 	- pad 2 - source - it outputs a Video stream
> 
> Any (generic) application would need to check the properties of
> pads 1 and 2 in order to identify what of those pads has video
> and what pad has VBI. The pad index is meaningless.
> 
> Ok, there are cases where the pad index are meaningful. I guess
> that the best is to use properties to properly identify the
> pad, or add some strings to them.
> 
> Anyway, I guess this should be covered via the properties API.

That's a good summary, however I believe we have to pay attention to the
existing API in order not to break user space. The current expectation is
that pad numbers start from zero, their range is contiguous and that they
are also stable.

The documentation does not say all that, but that's what's currently
offered. That's what I believe all hardware specific applications expect.
Generic applications probably have no such limitations.

The pad index is indeed just a number but it's an important one. If we
provide the pad ID (i.e. the graph object ID) to the user space, it has none
of the three properties, and missing even one would be enough to break the
user space.

Then, it indeed becomes a naming issue. Names can be stable even if the
index wouldn't be. The user would convert the names to integers that may not
be stable.

Do you have a use case for dynamically adding or removing pads --- wouldn't
it take a change in hardware topology to do that? If it's software only, I'd
definitely favour solutions that didn't involve changes in topology ---
software changes are generally very fast, and changing the media device
topology for that could also affect the device nodes, forcing the user space
to wait for udev to create them. That's very inconvenient when you want to
take a photo, for instance.

-- 
Best regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
