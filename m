Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:30850 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0G1JGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 05:06:46 -0400
Date: Wed, 28 Jul 2010 11:04:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv2 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <201007271827.02606.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	'Hiremath Vaibhav' <hvaibhav@ti.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	'Mark Brown' <broonie@opensource.wolfsonmicro.com>,
	'Daniel Walker' <dwalker@codeaurora.org>,
	'Jonathan Corbet' <corbet@lwn.net>,
	'FUJITA Tomonori' <fujita.tomonori@lab.ntt.co.jp>,
	'Zach Pfeffer' <zpfeffer@codeaurora.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>
Message-id: <005801cb2e33$f8dec570$ea9c5050$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <cover.1280151963.git.m.nazarewicz@samsung.com>
 <201007262228.42358.hverkuil@xs4all.nl>
 <002801cb2d5f$2b288550$81798ff0$%szyprowski@samsung.com>
 <201007271827.02606.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, July 27, 2010 6:27 PM Hans Verkuil wrote:

> On Tuesday 27 July 2010 09:41:40 Marek Szyprowski wrote:
> > On Monday, July 26, 2010 10:29 PM Hans Verkuil wrote:
> > > On Monday 26 July 2010 16:40:30 Michal Nazarewicz wrote:
> > > > The Contiguous Memory Allocator framework is a set of APIs for
> > > > allocating physically contiguous chunks of memory.
> > > >
> > > > Various chips require contiguous blocks of memory to operate.  Those
> > > > chips include devices such as cameras, hardware video decoders and
> > > > encoders, etc.
> > > >
> > > > The code is highly modular and customisable to suit the needs of
> > > > various users.  Set of regions reserved for CMA can be configured on
> > > > run-time and it is easy to add custom allocator algorithms if one
> > > > has such need.
> > > >
> > > > For more details see Documentation/contiguous-memory.txt.
> > > >
> > > > Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> > > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > > Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
> > > > ---
> > > >  Documentation/00-INDEX                             |    2 +
> > > >  .../ABI/testing/sysfs-kernel-mm-contiguous         |    9 +
> > > >  Documentation/contiguous-memory.txt                |  646
> +++++++++++
> > > >  Documentation/kernel-parameters.txt                |    4 +
> > > >  include/linux/cma.h                                |  445 ++++++++
> > > >  mm/Kconfig                                         |   34 +
> > > >  mm/Makefile                                        |    3 +
> > > >  mm/cma-best-fit.c                                  |  407 +++++++
> > > >  mm/cma.c                                           | 1170
> > > ++++++++++++++++++++
> > > >  9 files changed, 2720 insertions(+), 0 deletions(-)
> > > >  create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-
> contiguous
> > > >  create mode 100644 Documentation/contiguous-memory.txt
> > > >  create mode 100644 include/linux/cma.h
> > > >  create mode 100644 mm/cma-best-fit.c
> > > >  create mode 100644 mm/cma.c
> > > >
> > > > diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> > > > index 5405f7a..bb50209 100644
> > > > --- a/Documentation/00-INDEX
> > > > +++ b/Documentation/00-INDEX
> > > > @@ -94,6 +94,8 @@ connector/
> > > >  	- docs on the netlink based userspace<->kernel space
> communication
> > > mod.
> > > >  console/
> > > >  	- documentation on Linux console drivers.
> > > > +contiguous-memory.txt
> > > > +	- documentation on physically-contiguous memory allocation
> framework.
> > > >  cpu-freq/
> > > >  	- info on CPU frequency and voltage scaling.
> > > >  cpu-hotplug.txt
> > > > diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-contiguous
> > > b/Documentation/ABI/testing/sysfs-kernel-mm-contiguous
> > > > new file mode 100644
> > > > index 0000000..05e2f6a
> > > > --- /dev/null
> > > > +++ b/Documentation/ABI/testing/sysfs-kernel-mm-contiguous
> > > > @@ -0,0 +1,9 @@
> > > > +What:		/sys/kernel/mm/contiguous/
> > > > +Date:		July 2008
> > > > +Contact:	Michal Nazarewicz <m.nazarewicz@samsung.com>
> > > > +Description:
> > > > +		/sys/kernel/mm/contiguous/ contains two files: asterisk
> and
> > > > +		map.  They are used to configure the Contiguous Memory
> > > > +		Allocator framework.
> > > > +
> > > > +		For details see Documentation/contiguous-memory.txt.
> > > > diff --git a/Documentation/contiguous-memory.txt
> > > b/Documentation/contiguous-memory.txt
> > > > new file mode 100644
> > > > index 0000000..6eb1295
> > > > --- /dev/null
> > > > +++ b/Documentation/contiguous-memory.txt
> > > > @@ -0,0 +1,646 @@
> > > > +                                                             -*- org
> -*-
> > > > +
> > > > +* Contiguous Memory Allocator
> > > > +
> > > > +   The Contiguous Memory Allocator (CMA) is a framework, which
> allows
> > > > +   setting up a machine-specific configuration for physically-
> contiguous
> > > > +   memory management. Memory for devices is then allocated according
> > > > +   to that configuration.
> > > > +
> > > > +   The main role of the framework is not to allocate memory, but to
> > > > +   parse and manage memory configurations, as well as to act as an
> > > > +   in-between between device drivers and pluggable allocators. It is
> > > > +   thus not tied to any memory allocation method or strategy.
> > > > +
> > > > +** Why is it needed?
> > > > +
> > > > +    Various devices on embedded systems have no scatter-getter
> and/or
> > > > +    IO map support and as such require contiguous blocks of memory
> to
> > > > +    operate.  They include devices such as cameras, hardware video
> > > > +    decoders and encoders, etc.
> > > > +
> > > > +    Such devices often require big memory buffers (a full HD frame
> is,
> > > > +    for instance, more then 2 mega pixels large, i.e. more than 6 MB
> > > > +    of memory), which makes mechanisms such as kmalloc() ineffective.
> > > > +
> > > > +    Some embedded devices impose additional requirements on the
> > > > +    buffers, e.g. they can operate only on buffers allocated in
> > > > +    particular location/memory bank (if system has more than one
> > > > +    memory bank) or buffers aligned to a particular memory boundary.
> > > > +
> > > > +    Development of embedded devices have seen a big rise recently
> > > > +    (especially in the V4L area) and many such drivers include their
> > > > +    own memory allocation code. Most of them use bootmem-based
> methods.
> > > > +    CMA framework is an attempt to unify contiguous memory
> allocation
> > > > +    mechanisms and provide a simple API for device drivers, while
> > > > +    staying as customisable and modular as possible.
> > > > +
> > > > +** Design
> > > > +
> > > > +    The main design goal for the CMA was to provide a customisable
> and
> > > > +    modular framework, which could be configured to suit the needs
> of
> > > > +    individual systems.  Configuration specifies a list of memory
> > > > +    regions, which then are assigned to devices.  Memory regions can
> > > > +    be shared among many device drivers or assigned exclusively to
> > > > +    one.  This has been achieved in the following ways:
> > >
> > > OK, I like the idea of regions, i.e. defining memory areas with
> specific
> > > properties or uses.
> > >
> > > But why should it be possible to define regions through kernel
> parameters?
> > > Regions are typically fixed for a particular platform and can be setup
> in
> > > the
> > > platform specific code. Actually, one region could be setup by default:
> > > DMA-able memory. That would be very handy in fact for many PCI-based TV
> > > capture drivers.
> >
> > IMHO this is a just desktop-point-of-view. In embedded world things are
> > a bit different. Most SoCs have a some kind of common system memory and
> > usually all build-in peripherals are able to DMA to any part of it (there
> is
> > no DMA specific hardware zone).
> 
> There are still desktops in the world, you know :-) It's nice if cma can
> also be used there. Having a region called 'dma' or something like that
> would be useful for drivers. And yes, for most embedded systems that would
> be the equivalent of common memory.

I really see no problem using CMA on desktops, although in most cases only
a few drivers will be able to make use of it.

> > > I think that the only thing that you want to set in the kernel params
> is
> > > the size of each region.
> >
> > Keeping it as a kernel parameter is very handy for development. But I
> agree
> > that we might make it dependent on some Kconfig entry. This way a
> platform
> > setup code would provide default region description just as an array of
> the
> > region structures and we will get rid of the parsing code in the release
> > versions.
> 
> I think that would help, yes.
> 
> > > The same with assigning regions to drivers: why would you want to do
> that?
> > > The driver should know which regions it can use (with possible
> fallbacks).
> >
> > I'm sorry, but this is again a little 'desktop-centric point-of-view'. On
> > desktop it is perfectly acceptable to have a separate memory region for
> each
> > device. In embedded world memory is a precious resource. Of course we can
> go
> > the 'separate memory region for each device' way, but we observed that at
> > least some memory can be recovered if we decide to share memory regions
> for
> > some of the devices.
> >
> > Assigning regions to the drivers is a way to describe how memory can be
> > shared. This is something that is independent from the actual drivers.
> > Device drivers cannot and mustn't have such knowledge.
> 
> You misunderstand me. I wasn't promoting separate memory regions for each
> device.  Quite the opposite: initially I would make regions shared by default.
> I actually do not see why device drivers can't have the knowledge to allocate
> their memory from particular regions. We are talking about embedded systems 
> where these types of memory allocations tend to be well defined. E.g. the
> video capture driver needs to allocate X video buffers at boot time. For
> most devices that will be the dma region, in the case of samsung devices
> that will be regions for particular memory banks.

Let me introduce one more example. As you may know we have 3 video-processor
capture devices (Samsung FIMC) and a hardware codec (like Samsung MFC). FIMC
can capture video data from camera sensor and accelerate common video
processing tasks (like up/down scaling and color space conversion). Two FIMC
and MFC are require for things like HD video encoding or decoding with
online display/preview. This task require huge video buffers that are
usually allocated and freed at the same time. The third FIMC can be used for
gfx acceleration (color space conversion and scaling are quite common tasks
in GUI). This latter task usually introduces a lot of memory fragmentation,
as gfx surfaces are usually quite small (definitely smaller than HD frames
or 8MPix picture from camera). It would be really wise to get that third
FIMC device to use memory buffer that will be shared with 3D accelerator
(which has quite similar usage scenarios and suffers from similar memory
fragmentation).

> The only time reserving regions for specific devices might be necessary is
> if you can get memory fragmentation if multiple drivers use the same region.
> But if drivers just allocate the memory at boot, then shared regions work
> fine.
> >
> > > And it can know that provided regions are setup by the platform code
> and
> > > not created dynamically. This will simplify things enormously.
> > >
> > > > +    1. The core of the CMA does not handle allocation of memory and
> > > > +       management of free space.  Dedicated allocators are used for
> > > > +       that purpose.
> > > > +
> > > > +       This way, if the provided solution does not match demands
> > > > +       imposed on a given system, one can develop a new algorithm
> and
> > > > +       easily plug it into the CMA framework.
> > > > +
> > > > +       The presented solution includes an implementation of a best-
> fit
> > > > +       algorithm.
> > >
> > > Again, do we really need user-settable per-region allocators? Just
> provide
> > > one with the option to later choose others through the kernel Kconfig
> files.
> >
> > From our experience, yes. Different allocators can cope with different
> memory
> > usage scenarios better or worse. This results in higher or lower memory
> > fragmentation. System use cases are something that kernel or drivers are
> > definitely not aware, so only user space can tune this parameter to get
> the
> > best possible system behavior.
> 
> Can you describe some of those usage scenarios? The cases I am familiar
> with
> are the standard: 'need to allocate X buffers of Y MB memory each on boot'
> and these buffers are only freed when the module is unloaded. While you can
> get fragmentation in that case if you creatively load and unload modules,
> this is not the normal usage in a deployed system.

We don't want to allocate X buffers of Y MB memory each on boot. Instead we
want to just reserve XX MB memory and then dynamically allocate buffers from
it. This enables us to perform the following 2 tasks:
1. movie decoding in HD-quality (only one instance)
2. two instances of SD-quality movie decoding and SD-quality move encoding 
   (example: video conference)

We know that these two use cases are exclusive, so they can use the same
reserved memory.

> We already have several 'normal' memory allocators (slab, slub, slob, sleb,
> whatever. I've lost track there.) and I'm not very enthusiastic about the
> idea of adding another bunch of them. Especially not in a first release.
>
> Keep it simple. Just fix the core problem first, even if you are not yet
> able to squeeze the last byte of memory from your system. Later you can 
> always add features as needed and optimize it further.

We are trying to keep it as simple as possible :)
 
> > > We can always add more complex scenarios later, but for an initial
> version
> > > I'd keep it simple.
> > >
> > > > +
> > > > +    2. CMA allows a run-time configuration of the memory regions it
> > > > +       will use to allocate chunks of memory from.  The set of
> memory
> > > > +       regions is given on command line so it can be easily changed
> > > > +       without the need for recompiling the kernel.
> > > > +
> > > > +       Each region has it's own size, alignment demand, a start
> > > > +       address (physical address where it should be placed) and an
> > > > +       allocator algorithm assigned to the region.
> > > > +
> > > > +       This means that there can be different algorithms running at
> > > > +       the same time, if different devices on the platform have
> > > > +       distinct memory usage characteristics and different algorithm
> > > > +       match those the best way.
> > >
> > > Seems overengineering to me. Just ensure that the code can be extended
> > > later to such hypothetical scenarios. They are hypothetical, right?
> >
> > Not really. Having the possibility to reconfigure memory configuration
> > without kernel recompilation is very handy when one is tuning the
> > configuration for the specific use case.
> >
> > > > +    3. When requesting memory, devices have to introduce themselves.
> > > > +       This way CMA knows who the memory is allocated for.  This
> > > > +       allows for the system architect to specify which memory
> regions
> > > > +       each device should use.
> > > > +
> > > > +       3a. Devices can also specify a "kind" of memory they want.
> > > > +           This makes it possible to configure the system in such
> > > > +           a way, that a single device may get memory from different
> > > > +           memory regions, depending on the "kind" of memory it
> > > > +           requested.  For example, a video codec driver might want
> to
> > > > +           allocate some shared buffers from the first memory bank
> and
> > > > +           the other from the second to get the highest possible
> > > > +           memory throughput.
> > >
> > > Not sure I understand this. Isn't this just two regions, one for each
> > > memory bank,
> > > and the driver requests some buffers from one region and some from the
> > > other?
> >
> > Right.
> >
> > > Not sure how a 'kind of memory' features in this.
> >
> > This 'kind' is a just cookie or a label used by the driver to distinguish
> > requests for both memory banks. This functionality is essential for our
> > hardware (just for hardware video codec we have 3 'kinds' of memory:
> memory
> > bank A, memory bank B and special region for the firmware).
> 
> Let me see if I understand: driver D needs memory from bank A, so it
> specifies
> e.g. label "a" when requesting memory. And the kernel parameters are then
> supposed
> to define a region for memory bank A (say region "bank-a" and tell the cma
> that
> requests from driver D for memory of kind "a" should go to region "bank-a".
> 
> Of course, the driver can also just request memory from the platform-
> defined
> region "bank-a" directly rather than having to rely on userspace provided
> parameters.

Right. Regions provided by kernel command line are considered to be alternative
to the default configuration for tuning/debugging purposes.

> > > > +    4. For greater flexibility and extensibility, the framework
> allows
> > > > +       device drivers to register private regions of reserved memory
> > > > +       which then may be used only by them.
> > > > +
> > > > +       As an effect, if a driver would not use the rest of the CMA
> > > > +       interface, it can still use CMA allocators and other
> > > > +       mechanisms.
> > >
> > > Why would you? Is there an actual driver that will need this?
> >
> > This feature has been added after posting v1 of this rfc/patch. Jonathan
> > Corbet suggested in
> <http://article.gmane.org/gmane.linux.kernel.mm/50689>
> > that viafb driver might register its own private memory and use cma just
> > as an allocator. IMHO this is a good idea, this way we might remove a
> bunch
> > of custom allocators from the drivers (yes, there are such all over the
> > kernel).
> 
> It goes back to whether we want per-device (or per-driver) regions or just
> have global regions.

IMHO both types of regions can coexist and we can make use of their
advantages. I see no point in limiting CMA only to one type of the regions.

> What I have seen in practice is that these drivers just
> need X amount of contiguous memory on boot. Having just a single region (as
> it will be for most systems) to carve the buffers from is just as efficient
> if not more than creating separate regions for each driver. Only if you
> start freeing and reallocating memory later on will you get into trouble.

> But if you do that, then you are trying to duplicate the behavior of the
> normal allocators in my opinion. I really don't think we want to go there.

Well, then why some drivers like viafb or omapfb have custom memory
allocators? This case shows that there is still a need for another one.

> > > > +       4a. Early in boot process, device drivers can also request
> the
> > > > +           CMA framework to a reserve a region of memory for them
> > > > +           which then will be used as a private region.
> > > > +
> > > > +           This way, drivers do not need to directly call bootmem,
> > > > +           memblock or similar early allocator but merely register
> an
> > > > +           early region and the framework will handle the rest
> > > > +           including choosing the right early allocator.
> > >
> > > The whole concept of private regions seems unnecessary to me.
> > >
> > > <big snip>
> > >
> > > It looks to me as if you tried to think of all possible hypothetical
> > > situations
> > > and write a framework for that. Of course, you may know more than I do,
> > > and some of these situations actually happen.
> >
> > Not exactly. We tried to design a solution that would cover all
> requirements
> > for OUR (quite specific) embedded hardware. However we didn't want to tie
> it
> > only to our platform. We just generalized most of our requirements so
> they can
> > be reused for other systems.
> >
> > > The basic design ideas are solid, I think. But you should get rid of
> all
> > > the fancy features and go back to basics. We can always add those
> features
> > > later should that become necessary. But removing features is much, much
> > harder.
> >
> > Well, please keep in mind that we cannot remove features that are
> essential
> > for our solution. We know that a simple framework have some advantages
> > (well, the most important one is the fact that it is easy to understand),
> > but making it too simple would render it useless from our point of view
> > (if it would not provide functionality required by our drivers and
> hardware).
> 
> Why not give a list of the requirements that your hardware has? The only
> requirement unique to your hardware that I am aware of is the need for
> buffers in specific memory banks (and apparently a special memory area for
> firmware).

Yes, this is a real hardware requirement that cannot be dropped. Other
requirements come from the system design (software).

> So besides a 'dma' region (which is probably sufficient for most systems)
> you would also have a 'banka' and 'bankb' region and perhaps a 'fw' region.

Actually this DMA region is either just a 'banka' or 'bankb'. There is no
special requirements for the common dma memory and no need for the separate
'dma' region in our case. We just want to make it shared with at least camera
capture buffers.

> In the kernel parameters the user can specify the sizes for these regions
> that are reserved at boot time and drivers will use cma to get their memory
> from the relevant region using a simple allocator.
> 
> If there are other requirements in your hardware (or other hardware) that
> should be taken into account for an initial version of the cma, then I'm
> interested in hearing about it.

We will try to summarize our requirements again and repost them soon.
 
> One note: since the first version of the patch wasn't posted to linux-media
> I didn't follow the replies to that. If there are things in that thread
> that I should read, then just mail me some links.

I'm very sorry that the first version has been posted only to linux-mm.
The discussion was mainly about the way how the memory configuration and
device mapping should be provided (first version used only kernel parameters
for that). We should probably also CC a few more kernel subsystems that might
benefit from a common memory allocator, but we already were a bit scared by
the number of people and lists in this series. We really don't want to get
a 'spammer' label ;)

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



