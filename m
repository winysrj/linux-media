Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57130 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934115AbbHKLDM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 07:03:12 -0400
Date: Tue, 11 Aug 2015 08:03:06 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: VIMC: API proposal, configuring the topology through user space
Message-ID: <20150811080306.087c89ce@recife.lan>
In-Reply-To: <55C9CFC6.90207@xs4all.nl>
References: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com>
	<55C8A305.9010509@xs4all.nl>
	<CAPW4XYarvYDfQa7iCY9fNMHLb7zFGXE2dzu-cr3Z1oLVBHTjtg@mail.gmail.com>
	<55C9C039.6000200@xs4all.nl>
	<20150811063626.76689791@recife.lan>
	<55C9CFC6.90207@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Aug 2015 12:34:46 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/11/15 11:36, Mauro Carvalho Chehab wrote:
> > Em Tue, 11 Aug 2015 11:28:25 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> Hi Helen,
> >>
> >> On 08/10/15 19:21, Helen Fornazier wrote:
> >>> Hi, thanks for your reviews
> >>>
> >>> On Mon, Aug 10, 2015 at 10:11 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>>> Hi Helen!
> >>>>
> >>>> On 08/08/2015 03:55 AM, Helen Fornazier wrote:
> >>>>> Hi!
> >>>>>
> >>>>> I've made a first sketch about the API of the vimc driver (virtual
> >>>>> media controller) to configure the topology through user space.
> >>>>> As first suggested by Laurent Pinchart, it is based on configfs.
> >>>>>
> >>>>> I would like to know you opinion about it, if you have any suggestion
> >>>>> to improve it, otherwise I'll start its implementation as soon as
> >>>>> possible.
> >>>>> This API may change with the MC changes and I may see other possible
> >>>>> configurations as I implementing it but here is the first idea of how
> >>>>> the API will look like.
> >>>>>
> >>>>> vimc project link: https://github.com/helen-fornazier/opw-staging/
> >>>>> For more information: http://kernelnewbies.org/LaurentPinchart
> >>>>>
> >>>>> /***********************
> >>>>> The API:
> >>>>> ************************/
> >>>>>
> >>>>> In short, a topology like this one: http://goo.gl/Y7eUfu
> >>>>> Would look like this filesystem tree: https://goo.gl/tCZPTg
> >>>>> Txt version of the filesystem tree: https://goo.gl/42KX8Y
> >>>>>
> >>>>> * The /configfs/vimc subsystem
> >>>>
> >>>> I haven't checked the latest vimc driver, but doesn't it support
> >>>> multiple instances, just like vivid? I would certainly recommend that.
> >>>
> >>> Yes, it does support
> >>>
> >>>>
> >>>> And if there are multiple instances, then each instance gets its own
> >>>> entry in configfs: /configs/vimc0, /configs/vimc1, etc.
> >>>
> >>> You are right, I'll add those
> >>>
> >>>>
> >>>>> The vimc driver registers a subsystem in the configfs with the
> >>>>> following contents:
> >>>>>         > ls /configfs/vimc
> >>>>>         build_topology status
> >>>>> The build_topology attribute file will be used to tell the driver the
> >>>>> configuration is done and it can build the topology internally
> >>>>>         > echo -n "anything here" > /configfs/vimc/build_topology
> >>>>> Reading from the status attribute can have 3 different classes of outputs
> >>>>> 1) deployed: the current configured tree is built
> >>>>> 2) undeployed: no errors, the user has modified the configfs tree thus
> >>>>> the topology was undeployed
> >>>>> 3) error error_message: the topology configuration is wrong
> >>>>
> >>>> I don't see the status file in the filesystem tree links above.
> >>>
> >>> Sorry, I forgot to add
> >>>
> >>>>
> >>>> I actually wonder if we can't use build_topology for that: reading it
> >>>> will just return the status.
> >>>
> >>> Yes we can, I was just wondering what should be the name of the file,
> >>> as getting the status from reading the build_topology file doesn't
> >>> seem much intuitive
> >>
> >> I'm not opposed to a status file, but it would be good to know what Laurent
> >> thinks.
> >>
> >>>
> >>>>
> >>>> What happens if it is deployed and you want to 'undeploy' it? Instead of
> >>>> writing anything to build_topology it might be useful to write a real
> >>>> command to it. E.g. 'deploy', 'destroy'.
> >>>>
> >>>> What happens when you make changes while a topology is deployed? Should
> >>>> such changes be rejected until the usecount of the driver goes to 0, or
> >>>> will it only be rejected when you try to deploy the new configuration?
> >>>
> >>> I was thinking that if the user try changing the topology, or it will
> >>> fail (because the device instance is in use) or it will undeploy the
> >>> old topology (if the device is not in use). Then a 'destroy' command
> >>> won't be useful, the user can just unload the driver when it won't be
> >>> used anymore,
> > 
> > Well, we're planning to add support for dynamic addition/removal of
> > entities, interfaces, pads and links. So, instead of undeploy the
> > old topology, one could just do:
> > 	rm -rf <part of the tree>
> 
> Dynamic entities and interfaces yes, but dynamic pads? The entity defines
> the number of pads it has, which is related to the hardware or IP properties
> of the entity. I don't see how that can be dynamic.

It can be dynamic. DVB has usages for that, on two different situations:

1) DVB demux

There are some hardware that has an IP block that provides more than one
demuxes, but they share a number of TS filters. The amount of TS filters
per demux can be dynamically changed.

For example, such hardware may have 2 demuxes and 32 shared TS filters.

At DVB driver init, let's assume that each demux will have 16 filters.
So:
	demux 0 - 16 TS filters = 16 pads
	demux 1 - 16 TS buffers = 16 pads

On a given time, let's assume that the first demux has all 16 filters
already in usage, but the second demux is using only 4 filters. It is
possible to dynamically change the hardware to move, let's say, 4
buffers from the second demux to the first one. After such change,
we'll have:
	demux 0 - 20 TS filters = 20 pads
	demux 1 - 12 TS filters = 12 pads

Ok, one might think on initializing both with 32 pads, and create
32 ringbuffers at the Kernelspace for each demux, but if the number
of TS filters is big, this will mean lots of wasted memory to store
data that will never be used. The amount of memory spent is really
big, as each ringbuffer will allocate several data pages, in order
to prepare to receive the DMA data from the hardware filters
(or do emulate in software).

2) DVB network

The DVB net core will likely need dynamic pads as well, as the output
will be  different for each different network interface, as each output
is associated to a different TS. As the DVB core allows dynamic creation
of network interfaces, the number of PADs at the demux will also change,
as we create new ringbuffers and new ULE/MPE decap filters for each
different network traffic.

> I certainly wouldn't bother with that in vimc.

Allowing dynamic removal? Well, if we want the vimc driver to be able
to test the MC functionalities, it should support at least all MC core
features.

Regards,
Mauro
