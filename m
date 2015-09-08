Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34904 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbbIHPL3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2015 11:11:29 -0400
Date: Tue, 8 Sep 2015 12:11:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 49/55] [media] media-device: add support for
 MEDIA_IOC_G_TOPOLOGY ioctl
Message-ID: <20150908121123.60af5b19@recife.lan>
In-Reply-To: <20150908133459.GG3175@valkosipuli.retiisi.org.uk>
References: <8e914e59660fc35b074b72e39dc1b1200d52617b.1440902901.git.mchehab@osg.samsung.com>
	<2b36475229b2cbb574a03e7866bcbc7b04ff02cf.1441540862.git.mchehab@osg.samsung.com>
	<20150907221830.GC3175@valkosipuli.retiisi.org.uk>
	<20150907222357.60df5890@recife.lan>
	<20150908072628.GD3175@valkosipuli.retiisi.org.uk>
	<20150908074945.4358c9d7@recife.lan>
	<20150908133459.GG3175@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 08 Sep 2015 16:34:59 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Tue, Sep 08, 2015 at 07:49:45AM -0300, Mauro Carvalho Chehab wrote:
> > Em Tue, 8 Sep 2015 10:26:29 +0300
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > 
> > > Hi Mauro,
> > > 
> > > On Mon, Sep 07, 2015 at 10:23:57PM -0300, Mauro Carvalho Chehab wrote:
> > > > Em Tue, 8 Sep 2015 01:18:30 +0300
> > > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > > > 
> > > > > Hi Mauro,
> > > > > 
> > > > > A few comments below.
> > > > 
> > > > Thanks for review!
> > > 
> > > You're welcome!
> > > 
> > > > > 
> > > > > On Sun, Sep 06, 2015 at 09:03:09AM -0300, Mauro Carvalho Chehab wrote:
> > > > > > Add support for the new MEDIA_IOC_G_TOPOLOGY ioctl, according
> > > > > > with the RFC for the MC next generation.
> > > > > > 
> > > > > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > > > > 
> > > > > > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > > > > > index 5b2c9f7fcd45..96a476eeb16e 100644
> > > > > > --- a/drivers/media/media-device.c
> > > > > > +++ b/drivers/media/media-device.c
> > > > > > @@ -232,6 +232,156 @@ static long media_device_setup_link(struct media_device *mdev,
> > > > > >  	return ret;
> > > > > >  }
> > > > > >  
> > > > > > +static long __media_device_get_topology(struct media_device *mdev,
> > > > > > +				      struct media_v2_topology *topo)
> > > > > > +{
> > > > > > +	struct media_entity *entity;
> > > > > > +	struct media_interface *intf;
> > > > > > +	struct media_pad *pad;
> > > > > > +	struct media_link *link;
> > > > > > +	struct media_v2_entity uentity;
> > > > > > +	struct media_v2_interface uintf;
> > > > > > +	struct media_v2_pad upad;
> > > > > > +	struct media_v2_link ulink;
> > > > > > +	int ret = 0, i;
> > > > > 
> > > > > I think i wants to be unsigned.
> > > > 
> > > > Yes, "i" can be unsigned. I'll change that.
> > > > 
> > > > > 
> > > > > > +
> > > > > > +	topo->topology_version = mdev->topology_version;
> > > > > > +
> > > > > > +	/* Get entities and number of entities */
> > > > > > +	i = 0;
> > > > > > +	media_device_for_each_entity(entity, mdev) {
> > > > > > +		i++;
> > > > > > +
> > > > > > +		if (ret || !topo->entities)
> > > > > > +			continue;
> > > > > > +
> > > > > > +		if (i > topo->num_entities) {
> > > > > > +			ret = -ENOSPC;
> > > > > > +			continue;
> > > > > > +		}
> > > > > > +
> > > > > > +		/* Copy fields to userspace struct if not error */
> > > > > > +		memset(&uentity, 0, sizeof(uentity));
> > > > > > +		uentity.id = entity->graph_obj.id;
> > > > > > +		strncpy(uentity.name, entity->name,
> > > > > > +			sizeof(uentity.name));
> > > > > > +
> > > > > > +		if (copy_to_user(&topo->entities[i - 1], &uentity, sizeof(uentity)))
> > > > > > +			ret = -EFAULT;
> > > > > > +	}
> > > > > > +	topo->num_entities = i;
> > > > > > +
> > > > > > +	/* Get interfaces and number of interfaces */
> > > > > > +	i = 0;
> > > > > > +	media_device_for_each_intf(intf, mdev) {
> > > > > > +		i++;
> > > > > > +
> > > > > > +		if (ret || !topo->interfaces)
> > > > > > +			continue;
> > > > > > +
> > > > > > +		if (i > topo->num_interfaces) {
> > > > > > +			ret = -ENOSPC;
> > > > > > +			continue;
> > > > > > +		}
> > > > > > +
> > > > > > +		memset(&uintf, 0, sizeof(uintf));
> > > > > > +
> > > > > > +		/* Copy intf fields to userspace struct */
> > > > > > +		uintf.id = intf->graph_obj.id;
> > > > > > +		uintf.intf_type = intf->type;
> > > > > > +		uintf.flags = intf->flags;
> > > > > > +
> > > > > > +		if (media_type(&intf->graph_obj) == MEDIA_GRAPH_INTF_DEVNODE) {
> > > > > > +			struct media_intf_devnode *devnode;
> > > > > > +
> > > > > > +			devnode = intf_to_devnode(intf);
> > > > > > +
> > > > > > +			uintf.devnode.major = devnode->major;
> > > > > > +			uintf.devnode.minor = devnode->minor;
> > > > > > +		}
> > > > > > +
> > > > > > +		if (copy_to_user(&topo->interfaces[i - 1], &uintf, sizeof(uintf)))
> > > > > > +			ret = -EFAULT;
> > > > > > +	}
> > > > > > +	topo->num_interfaces = i;
> > > > > > +
> > > > > > +	/* Get pads and number of pads */
> > > > > > +	i = 0;
> > > > > > +	media_device_for_each_pad(pad, mdev) {
> > > > > > +		i++;
> > > > > > +
> > > > > > +		if (ret || !topo->pads)
> > > > > > +			continue;
> > > > > > +
> > > > > > +		if (i > topo->num_pads) {
> > > > > > +			ret = -ENOSPC;
> > > > > > +			continue;
> > > > > > +		}
> > > > > > +
> > > > > > +		memset(&upad, 0, sizeof(upad));
> > > > > > +
> > > > > > +		/* Copy pad fields to userspace struct */
> > > > > > +		upad.id = pad->graph_obj.id;
> > > > > 
> > > > > How about the pad index? Shouldn't that be also passed to the user space for
> > > > > every pad?
> > > > 
> > > > We've agreed to not pass the pad index to userspace at the MC workshop.
> > > > 
> > > > There are two aspects here to consider:
> > > > 
> > > > a) to properly represent the topology (e. g. TOPOLOGY)
> > > > 
> > > > Writing the userspace code to support it, I didn't find any need to
> > > > pass it to userspace, as the data links are connected via the PAD object 
> > > > ID.
> > > > 
> > > > The PAD index for userspace is just a number that it uses when
> > > > generating the dot graph. See:
> > > > 	https://mchehab.fedorapeople.org/mc-next-gen/au0828.png
> > > > 
> > > > This was generated by this tool:
> > > > 	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/tree/contrib/test/mc_nextgen_test.c
> > > > 
> > > > And no pad index was required at all. What the tool does is that it
> > > > generates the pad numbers just when the --dot option is used,
> > > > at the media_show_graphviz() function.
> > > > 
> > > > Also, please notice that having a pad index makes harder to support
> > > > dynamic PAD addition/removal, as the pad index numberspace will
> > > > be discontinued.
> > > > 
> > > > b) using the PAD index to setup a link.
> > > > 
> > > > As I argued with Hans on one of his reviews, I don't think that
> > > > an index is always the best way to refer to a PAD. 
> > > > 
> > > > See for example, the entity_1 on the au0828 (ATV decoder). It 
> > > > has 3 PADs:
> > > > 	- pad 0 - sink - receives an ATV signal [1]
> > > > 	- pad 1 - source - it outputs a Video stream
> > > > 	- pad 2 - source - it outputs a VBI stream
> > > > 
> > > > Pads 1 and 2 are not interchangeable, as they carry different
> > > > types of data.
> > > > 
> > > > [1] Actually, to be honest, pad 0 there is also wrong. In a matter
> > > > of fact, Composite, S-Video and Tuner interfaces are actually
> > > > supported by 3 different PADs on the hardware. On some hardware,
> > > > it is just a software configuration, but on others, different
> > > > pins are used for each different input type. We just don't need
> > > > to have all those details ATM on the Media Controller data flow,
> > > > as the V4L2 input selection API at the /dev/video0 devnode hides
> > > > those dirty details. Note however that, if we end by adding support
> > > > for ATV decoder subdevice nodes, such level of detail may be
> > > > required.
> > > > 
> > > > However some other ATV decoder could have mapped it on some
> > > > different order, like:
> > > > 	- pad 0 - sink - receives an ATV signal
> > > > 	- pad 1 - source - it outputs a VBI stream
> > > > 	- pad 2 - source - it outputs a Video stream
> > > > 
> > > > Any (generic) application would need to check the properties of
> > > > pads 1 and 2 in order to identify what of those pads has video
> > > > and what pad has VBI. The pad index is meaningless.
> > > > 
> > > > Ok, there are cases where the pad index are meaningful. I guess
> > > > that the best is to use properties to properly identify the
> > > > pad, or add some strings to them.
> > > > 
> > > > Anyway, I guess this should be covered via the properties API.
> > > 
> > > That's a good summary, however I believe we have to pay attention to the
> > > existing API in order not to break user space. The current expectation is
> > > that pad numbers start from zero, their range is contiguous and that they
> > > are also stable.
> > > 
> > > The documentation does not say all that, but that's what's currently
> > > offered. That's what I believe all hardware specific applications expect.
> > > Generic applications probably have no such limitations.
> > 
> > That's true, but there are two situations here to consider:
> > 
> > 1) existing drivers/applications:
> > - No dynamic support, so PAD numbers are stable. Index is provided
> >   via v1;
> 
> Agreed, in such cases it's fine as long as the pad indices will be
> essentially defined by the driver --- as they used to.

True. Well, the patches I made so far, meant for Kernel v4.4 don't change
them. We need to ensure that newer patches will do changes on a backward
compatible way.

> > 
> > 2) new drivers/applications:
> > - We need a way to provide stable equivalents to PAD indexes via
> >   v2.
> 
> I propose to only add them once we have the use case. This could be through
> the property API. My hands are pretty full of other work at the moment but
> this does not seem urgent either, which is good.

Agreed.

> I think that applications that are hardware specific would still often
> prefer hard-coding the pad number there, but instead use the new interface.
> Do you think we could guarantee the same pad number stability there, as long
> as no dynamic hardware changes affecting the pads are made? Such
> applications couldn't cope with those changes anyway.

I guess so. That will depend, of course, on how you'll be 
implementing the properties API ;)

I would map it as a series of PAD properties where the Kernelspace may
opt to have the ones that makes sense, like:
	- pad_index;
	- pad_data_type;
	- pad_name;
	...

For simple devices (no dynamic support, all pads carry on the same type of
data), it would just use pad index. More complex devices like hybrid TV ones
would use, instead pad_data_type and pad_name.

> > 
> > > The pad index is indeed just a number but it's an important one. If we
> > > provide the pad ID (i.e. the graph object ID) to the user space, it has none
> > > of the three properties, and missing even one would be enough to break the
> > > user space.
> > 
> > No userspace will be broken on v1 ioctls, as it will still be there.
> > 
> > > Then, it indeed becomes a naming issue. Names can be stable even if the
> > > index wouldn't be. The user would convert the names to integers that may not
> > > be stable.
> > 
> > Yes, I guess a name is the best alternative here, as it fits both the
> > cases where a simple number index is enough and cases where userspace
> > need to use some other criteria to detect the PAD he needs.
> 
> I think the names would have to be entity specific. Otherwise we'll have the
> same entity naming problem there.

Agreed.

> 
> > 
> > > Do you have a use case for dynamically adding or removing pads --- wouldn't
> > > it take a change in hardware topology to do that? If it's software only, I'd
> > > definitely favour solutions that didn't involve changes in topology ---
> > > software changes are generally very fast, and changing the media device
> > > topology for that could also affect the device nodes, forcing the user space
> > > to wait for udev to create them. That's very inconvenient when you want to
> > > take a photo, for instance.
> > 
> > I'm pretty sure we'll need dynamic pad addition/removal in some future,
> > but they're not of the first use cases I want to address.
> > 
> > There are some hardware that allows to dynamically reconfigure it to
> > provide more PADs. I've seen two different cases of that, at the DVB
> > side:
> > 
> > 1) One hardware with a fixed number of pads (like 4 sink pads and
> >    40 source pads), where it is capable of being dynamically
> >    configured to become 4 independent hardware entities, each one with
> >    one sink pad and a number of source pads. So, it could start like
> >    4 entities, with one sink and 10 sources. However, if user needs
> >    more than 10 sources, it can send a command to the hardware to get
> >    some unused PADs from the other entities;
> 
> This is not completely unlike many CSI-2 receivers which can share the lanes
> found in the receiver block between different receivers, say dividing five
> receiver lanes in 4:1:0 or 2:2:1 configuration among three receivers
> depending on the connected sensors. Those are not shown to the user space at
> all.
> 
> Althrough that's configuration made in board design time whereas yours is
> runtime if I understand you correctly.

Yes, this is a runtime decision on the case I mentioned.

> 
> What are these 40 pads in your example? Is it a DVB demux or something else?

Yes, DVB demux.

As I explained on IRC, the DVB demux works by setting one filter per PAD.
This filter has either the first 16 bytes of a DVB package or a set of
PIDs.

For each packet a DVB demux receives, it checks the header against one
of the filters there and outputs it to one (or more) output ports.

On a real case example for DVB-C (cable), one single physical channel
has 17 logical channels inside, each with at least one audio and one
video channel, and sometimes other PIDs for interactive contents.
There are some PIDs there with the programming guide, CATV internet,
interactive content and data channels for firmware upgrades.

Some of those channels:

[TNT]
	SERVICE_ID = 48
	VIDEO_PID = 336
	AUDIO_PID = 337 338 849
	PID_86 = 816
	FREQUENCY = 573000000

[Boomerang]
	SERVICE_ID = 57
	VIDEO_PID = 352
	AUDIO_PID = 353 354
	FREQUENCY = 573000000

[Cartoon]
	SERVICE_ID = 104
	VIDEO_PID = 320
	AUDIO_PID = 321 322
	PID_86 = 1840
	PID_05 = 3295
	FREQUENCY = 573000000

[Games]
	SERVICE_ID = 252
	PID_05 = 3047 3046 3045 3044 3042
	FREQUENCY = 573000000

[Soundtracks]
	SERVICE_ID = 342
	AUDIO_PID = 104
	PID_05 = 204
	FREQUENCY = 573000000

It is possible to record one (or more) logical channel(s) while some
logical channel is being displayed, using just one frontend, as all
those 17 channels are at the same frequency.

So, a typical usage would be an user that wants to listen to
the TNT channel, record everything from Boomerang and only
record audio and video from Cartoon. On such use case, the
applications started by the user would be setting:

Demux output#0: filter PID 336 and route to GPU (DRM domain);
Demux output#1: filter PID 337 (or all 3 audio pids) routing to the audio
		IP blocks (ALSA domain);
Demux output#2: filter PID 48 and route to ringbuffer#0
Demux output#3: filter PID 816 and route to ringbuffer #1
Demux output#4: filter PIDs 57, 352 to 354 and route to ringbuffer #2
		ringbuffer#2 will be routed to disk by userspace app.
Demux output#5: filter PIDs 320 to 322 and route to ringbuffer #3
		ringbuffer#3 will be routed to disk by userspace app.

Depending on the program, some of those outputs may need to be
dynamically routed in runtime to a CA module, in order to decrypt the
data. The applications should be able to do that, if needed.

There will be also some other filters set to get the programming
guide, CATV, firmware upgrades, emergency broadcast messages (to
announce events like earthquakes, tsunamis, and other calamity
events at the area), etc. Those filters are configured by some
other applications that are designed specifically to handle those
stuff.

FYI, 40 there is just a random number. The actual number is usually
a power of 2.

A cheap hardware has 16 or 32 such hardware filters on their demux.
Hardware used on STB or TV sets typically have 64 or more filters.
The software implementation usually has 256 filters (the number is
actually defined by the driver, but most just use 256).

The way the DVB core works is that if all hardware filters at the
demux are exhausted, it will implement software filtering/demux 
for the remaining filters.

> I'm not that much worried about the number alone, but if the pads are
> indistinguishable from each other,

All pads work at the same way, but they're not indistinguishible.
They map different ringbuffers used to do I/O via the read()
interface (or, in the future, also via mmap and DMABUF), as explained
above.

For this specific usecase, a pad index could make sense. Another
way to expose it to userspace would be to expose the PID filter
associated with the DEMUX port to userspace.

> I'd look for other ways to expose (or
> avoid exposing) them to the user.

Why avoid exposing? That would break the use case. As explained
earlier, the user applications need to be able to dynamically route
each output of the Demux to the right place, e. g. either to a 
hardware entity (a GPU, ALSA or CA entity) or to an output ringbuffer.

Am I understanding wrong or are you seriously proposing to fork the
Media Controller? Why? This is no different from what the MC already
does. We don't need a duplicated subsystem to do the same thing.

> > 
> > 2) Firmware or FPGA-based devices, where you can dynamically
> >    reconfigure the hardware any time. We have one such driver
> >    merged for 4.3 whose vendor is promising to release the
> >    FPGA code as an Open Source, in order to allow users to
> >    change the hardware in real time.
> 
> If you replace the FPGA configuration with another, it's essentially a new
> piece of hardware which will require its own driver. Of course you could do
> that with some limitations, but you have to take it into account in the
> driver in that case.

Sure. It doesn't make much sense to change the FPGA configuration
to turn a DVB device into a software radio while streaming. Yet,
it could make sense to add more demux filters or CA entities in
runtime, without stopping streaming.

> > The first case could actually be handled by always creating 4
> > entities, each with 40 source pads, and adding a new flag to tell
> > that a pad was not actually created yet, but this sounds hacky
> > and would allocate 4 times more memory for the PADs than actually
> > needed. Btw, the memory allocation is already a problem on one of
> > the hardwares I know that uses this device, as the DVB core doesn't
> > support dynamic filter reconfiguration neither. The amount of memory
> > required there to handle each source PAD on a demux is not small,
> > as one ringbuffer to handle the I/O transfer is needed for each
> > PAD source. We're working to fix it at the DVB side, but having
> > the DVB to use a different number of PADs than what's there at
> > the MC would be really messy.
> > 
> > For the second case, I don't know any alternative but to support
> > dynamic PAD changes.
> > 
> > Please notice that, on DVB, I don't see any usage for subdevs, so 
> > there's no need to wait for udev to create new devices to address 
> > those new entities/pads.
> > 
> > The second case, e. g. a Firmware/FPGA-based device can also work at
> > the V4L2 side. I remember someone (from Intel - I guess) commenting
> > about one such hardware on one of our media workshops, but it was
> > for some hardware he was not allowed to upstream.
> > 
> > Yeah, assuming that someone would upstream such driver and we would
> > need to find a solution, yeah, reconfiguration while taking a photo
> > can be very inconvenient.
> 
> Yes. As the "hardware topology" of such a device is essentially defined by
> software, I wouldn't try to represent it as hardware.

Well, we don't represent hardware at MC. We represent entities. Most
DVB hardware nowadays actually have software embedded there somehow.
Some allow changes in runtime, most don't. We don't and should not
deny an entity to represent something that it is internally implemented
by a FPGA or firmware. We also should not implement the pipelines using
a different framework if the entities are implemented inside a FPGA
or not.

> There's a subtle but
> significant difference to FPGA devices: FPGAs are essentially hardware,
> albeit you can change the layout to whatever you like, whereas the devices
> running software require software frameworks to support the device on both
> sides (the CPU and the device firmware). They more resemble programmable
> GPUs in that sense: even if what the device does (computes) changes, the
> drivers do not (and should not).

Sorry, didn't got what you're meaning here. Drivers/userspace should
not change, but it should be aware of the changes, in order to do
the right thing.

> > Perhaps the solution for such case would be to create the new
> > pads/entities when the camera software would be loaded, and not
> > when the user takes a photo.
> > 
> > I don't expect us to solve all issues related to dynamic PAD
> > addition this year, but we should be sure that no API changes
> > will be needed at G_TOPOLOGY when we add support for it, and
> > I guess that the right thing here is to provide properties that
> > would allow userspace to retrieve what's needed to uniquely
> > identify a PAD on a stable manner. Eventually, some devices
> > could just use an u32 pad_index properties, while others may
> > use strings.
> 
> New properties (such as the name) could be added later on without affecting
> the existing users that depend on the index.

True, and this is also true for pad index.

We need to solve this before adding the SETUP_LINK_V2, and before
start converting apps that sets links to use G_TOPOLOGY as such
apps will need to be able to uniquely identify a PAD.

Regards,
Mauro
