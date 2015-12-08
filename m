Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47738 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbbLHUFj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 15:05:39 -0500
Date: Tue, 8 Dec 2015 18:05:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH v8 48/55] [media] media_device: add a topology version
 field
Message-ID: <20151208180533.48c606fa@recife.lan>
In-Reply-To: <2524858.zcGD9LHCc4@avalon>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<55E4582A.5050205@xs4all.nl>
	<20150904140827.424c6d81@recife.lan>
	<2524858.zcGD9LHCc4@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 24 Nov 2015 00:18:07 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Friday 04 September 2015 14:08:27 Mauro Carvalho Chehab wrote:
> > Em Mon, 31 Aug 2015 15:35:38 +0200 Hans Verkuil escreveu:
> > > On 08/31/2015 02:52 PM, Mauro Carvalho Chehab wrote:
> > >> Em Mon, 31 Aug 2015 14:29:28 +0200 Hans Verkuil escreveu:
> > >>> On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> > >>>> Every time a graph object is added or removed, the version
> > >>>> of the topology changes. That's a requirement for the new
> > >>>> MEDIA_IOC_G_TOPOLOGY, in order to allow userspace to know
> > >>>> that the topology has changed after a previous call to it.
> > >>>> 
> > >>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > >>> 
> > >>> I think this should be postponed until we actually have dynamic
> > >>> reconfigurable graphs.
> > >> 
> > >> So far, we're using the term "dynamic" to mean partial graph object
> > >> removal.
> > >> 
> > >> But even today, MC does support "dynamic" in the sense of graph object
> > >> additions.
> > >> 
> > >> You should notice that having a topology_version is something that IMHO,
> > >> it is needed since the beginning, even without dynamic reconfigurable
> > >> graphs, because the graph may grow in runtime.
> > >> 
> > >> That will happen, for example, if usb-snd-audio is blacklisted at
> > >> /etc/modprobe*, and someone connects an au0828.
> > >> 
> > >> New entities/links will be created (after Shuah patches) if one would
> > >> modprobe latter snd-usb-audio.
> > > 
> > > latter -> later :-)
> > > 
> > > You are right, this would trigger a topology change. I hadn't thought
> > > about that.
> 
> First of all it won't be very useful without a topology change notification, 
> so until we have them it doesn't matter too much.

I'm not sure if we need an explicit topology change notification. The
way I see, we just need to add a topology_version at SET_LINK_V2. The
topology should be filled by userspace, based on the last topology from
G_TOPOLOGY.

If topology_version is different than the one at Kernelspace, Kernel
will return an error that would cause userspace to call G_TOPOLOGY
again.

Ok, a topology notification could be added in order to help userspace
to detect changes, but this is an unrelated.

> Then, the code is full of 
> race conditions when it comes to dynamic updates, and I'm afraid Shua's 
> patches can't go in before we fix them.

The race conditions are related to dynamic removal. Dynamic creation
should be OK.

We'll review the locks to be sure that this would work fine.

> 
> > >>> I would also like to reserve version 0: if 0 is returned, then the graph
> > >>> is static.
> > >> 
> > >> Why? Implementing this would be really hard, as that would mean that
> > >> G_TOPOLOGY would need to be blocked until all drivers and subdevices get
> > >> probed.
> > >> 
> > >> In order to implement that, some logic would be needed at the drivers to
> > >> identify if everything was set and unlock G_TOPOLOGY.
> > > 
> > > That wouldn't be needed if the media device node was created last. Which I
> > > think is a good idea anyway.
> > 
> > Creating the media device node last won't work. It should be the first thing
> > to be created, as all objects should be added to media_device linked lists.
> 
> I disagree with that. The media_device needs to be initialized first, but can 
> be registered with userspace last. We don't want to generate a topology update 
> event for every new entity, link or pad during the device probe sequence. 
> Drivers should be in control and tell when they're done with initialization.

This comment is outdated ;)

Javier wrote a patch series already addressing this: it basically splits
the internal registration from the userspace API registration. 

See:
	[PATCH v4 0/2] [media] Fix race between graph enumeration and entities registration


The idea is to postpone the latter to happen after having all 
entitites/links/subdevices created.

It is unrelated to the MC next gen, so he submitted in separate. I guess Sakari
already acked his patches.

I'll be merging his series after finishing the merge of MC next gen.

> 
> > Also, the numberspace should be local to a given media_device, as the graph
> > traversal algorithm relies on having the number of entities <= 64,
> > currently, in order to be able to detect loops. We should increase that
> > number, but removing an "as low as possible" entity number limit is not
> > trivial.
> > 
> > > > What would be the gain for that? I fail to see any.
> > > 
> > > It would tell userspace that it doesn't have to cope with dynamically
> > > changing graphs.
> > > 
> > > Even though with the au0828 example you can expect to see cases like that,
> > > I can pretty much guarantee that no generic v4l2 applications will ever
> > > support dynamic changes.
> > 
> > Well, my test app supports it and it is generic ;) My plan is to use it as a
> > basis for the library to be used on userspace for generic apps, extending it
> > to be used by other tools like xawtv, qv4l2 and the dvbv5 apps.
> > 
> > I don't think it is hard to handle it on a generic app,
> 
> I'll quote you later on that :-)
> 
> > and this should be done anyway if we want dynamic support.
> >
> > The logic seems actually be simple:
> > 
> > at G_TOPOLOGY, if the topology changes, reload the objects;
> 
> And update everything in userspace. That's a very hard task if you don't 
> design your applications extremely carefully.

True.

> 
> > at SETUP_LINK_V2, the topology will be sent. if the driver detects that
> > topology changed, it returns an error.
> > 
> > The caller will then need to reload the topology and re-apply the
> > transaction to select the links, if the entities affected still exists. In
> > other words, if the user's intent were to change the pipeline to receive the
> > data at /dev/video2, e. g. something like:
> > 	./yavta/yavta -f UYVY -s 720x312 -n 1 --capture=1 -F /dev/video2
> > 
> > What userspace would do is to reload everything, check if /dev/video2 still
> > exists and then redo the function that it is equivalent to the above
> > command, failing otherwise. That doesn't sound hard to implement.
> > 
> > > Those that will support it will be custom-made.
> > > 
> > > Being able to see that graphs can change dynamically would allow such apps
> > > to either refuse to use the device, or warn the user.
> > 
> > The way I see is that applications that will assume that the graph
> > is static will be the custom-made ones.
> 
> Or (some of) the generic ones.

If the app doesn't support dynamic changes, it is not generic, as it
will only support simple graphs that are provided by just a single driver.

> 
> > As they know the hardware, they can just either ignore the topology_version
> > or wait for it to stabilize when the hardware is still being probed.
> > 
> > In any case, if we end by needing to have an explicit way for the
> > Kernelspace to tell userspace that a graph is static, that could be done via
> > an extra flag at MEDIA_INFO.
> 
> Why ? I don't see anything wrong with reversing version 0 for that purpose, as 
> Hans proposed.

Well, we can do that: we can zero the topology_version at
media_device_register() (see Javier's patch "media-device: split media
initialization and registration")

This way, topology_version will be zero if the topology never changed
after registering the media controller userspace API.

That doesn't warrant that the topology will never change. Such change
will happen, for example, during driver (or sub-driver) removal
or unbind. Taking this into account, I doubt that we have any driver
that has a static topology, because the driver can be removed and/or
unbind from the hardware.

> 
> > Enabling this flag could be as easy as waiting for all graph elements to be
> > created (where the topology is still dynamic), and raise such flag after
> > finishing the probe sequence.
> 
