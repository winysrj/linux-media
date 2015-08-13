Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45064 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbbHMPuB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 11:50:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: VIMC: API proposal, configuring the topology through user space
Date: Thu, 13 Aug 2015 18:50:58 +0300
Message-ID: <1561939.nv8DB4tR4d@avalon>
In-Reply-To: <55C9CFC6.90207@xs4all.nl>
References: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com> <20150811063626.76689791@recife.lan> <55C9CFC6.90207@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday 11 August 2015 12:34:46 Hans Verkuil wrote:
> On 08/11/15 11:36, Mauro Carvalho Chehab wrote:
> > Em Tue, 11 Aug 2015 11:28:25 +0200 Hans Verkuil escreveu:
> >> On 08/10/15 19:21, Helen Fornazier wrote:
> >>> On Mon, Aug 10, 2015 at 10:11 AM, Hans Verkuil wrote:
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
> >>>> And if there are multiple instances, then each instance gets its own
> >>>> entry in configfs: /configs/vimc0, /configs/vimc1, etc.
> >>> 
> >>> You are right, I'll add those
> >>> 
> >>>>> The vimc driver registers a subsystem in the configfs with the
> >>>>> 
> >>>>> following contents:
> >>>>>         > ls /configfs/vimc
> >>>>>         build_topology status
> >>>>> 
> >>>>> The build_topology attribute file will be used to tell the driver the
> >>>>> configuration is done and it can build the topology internally
> >>>>> 
> >>>>>         > echo -n "anything here" > /configfs/vimc/build_topology
> >>>>> 
> >>>>> Reading from the status attribute can have 3 different classes of
> >>>>> outputs
> >>>>> 1) deployed: the current configured tree is built
> >>>>> 2) undeployed: no errors, the user has modified the configfs tree thus
> >>>>> the topology was undeployed
> >>>>> 3) error error_message: the topology configuration is wrong
> >>>> 
> >>>> I don't see the status file in the filesystem tree links above.
> >>> 
> >>> Sorry, I forgot to add
> >>> 
> >>>> I actually wonder if we can't use build_topology for that: reading it
> >>>> will just return the status.
> >>> 
> >>> Yes we can, I was just wondering what should be the name of the file,
> >>> as getting the status from reading the build_topology file doesn't
> >>> seem much intuitive
> >> 
> >> I'm not opposed to a status file, but it would be good to know what
> >> Laurent thinks.

I'm fine with both solutions. What I'm wondering is 

> >>>> What happens if it is deployed and you want to 'undeploy' it? Instead
> >>>> of writing anything to build_topology it might be useful to write a
> >>>> real command to it. E.g. 'deploy', 'destroy'.
> >>>> 
> >>>> What happens when you make changes while a topology is deployed? Should
> >>>> such changes be rejected until the usecount of the driver goes to 0, or
> >>>> will it only be rejected when you try to deploy the new configuration?

I believe we should restrict the changes we allow to what can be found with 
real hardware. Hardware blocks can be removed and added at any time, or at 
least a subset of them. This doesn't mean than entities (in the sense of 
struct media_entity) will need to be deleted immediately, but I believe we 
should support hot-plug and hot-unplug in the API. The implementation will of 
course have to wait until we add support for dynamic graph modifications to 
the media controller core.

Removal of a complete device should work similarly but can already be 
implemented. I'm wondering how removal of a vimc device will be implemented 
though. Will it be triggered by an rmdir of the corresponding 
/configfs/vimc/vimc[0-9] directory, assuming configfs supports removing non-
empty directory ? Or would we need a separate way to signal hot-unplug using 
an attribute in /configfs/vimc/ (I'm thinking about something similar to 'echo 
vimc1 > /configfs/vimc/unplug') ?

> >>> I was thinking that if the user try changing the topology, or it will
> >>> fail (because the device instance is in use) or it will undeploy the
> >>> old topology (if the device is not in use). Then a 'destroy' command
> >>> won't be useful, the user can just unload the driver when it won't be
> >>> used anymore,
> > 
> > Well, we're planning to add support for dynamic addition/removal of
> > entities, interfaces, pads and links. So, instead of undeploy the
> > 
> > old topology, one could just do:
> > 	rm -rf <part of the tree>
> 
> Dynamic entities and interfaces yes, but dynamic pads? The entity defines
> the number of pads it has, which is related to the hardware or IP properties
> of the entity. I don't see how that can be dynamic.
> 
> I certainly wouldn't bother with that in vimc.

I wouldn't either. While we might have some use cases for dynamically adding 
and removing pads in the future (Mauro mentioned DVB might need this), the 
addition and removal should be performed from by the kernel, not by userspace. 
For instance, assuming a DVB demux could have dynamic pads, it would be the 
demux configuration changes that would result in pad addition/removal. I thus 
believe we should care about it in vimc for now.

-- 
Regards,

Laurent Pinchart

