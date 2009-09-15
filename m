Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2792 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbZIOVLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 17:11:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: RFCv2.1: Media controller proposal
Date: Tue, 15 Sep 2009 23:11:38 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200909131235.13787.hverkuil@xs4all.nl> <200909152103.39154.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40155156A29@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155156A29@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909152311.38220.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 15 September 2009 22:28:26 Karicheri, Muralidharan wrote:
> Hans,
> 
> Thanks for your response...
> >
> >> If application has to make a choice of making a specific connection it
> >must know what the data formats are at each of the link along with other
> >information such as polarities etc. These information are available only
> >> at the driver level at present. For example you have an RFC for bus
> >parameter settings which is defined at board specific level and is used
> >> by bridge driver to set the bus output at sub device output and bridge
> >device input. I can think of same thing at each of the above links. So how
> >> application will be able to make this decision unless, each of the sub
> >device enumerates the available output data formats and input data formats
> >and other parameters to the application? Or is it that the bridge driver
> >just reports the possible connections or links and the bridge driver
> >> activates the links (here it setup one of the several possible link type
> >> based on board/platform configuration) and attach itself to one of the
> >sub device output and start streaming? What are all the ioctls involved
> >here to
> >> setup the link?
> >
> >See this RFC I posted later that addresses this (at least in part):
> >
> >http://www.mail-archive.com/linux-media%40vger.kernel.org/msg09644.html
> >
> >The big question here is how much will you do in the bridge driver and how
> >much in an external library? I would prefer to move away from trying to do
> >it
> >all in the driver and do more in a library on top of that. Of course, the
> >bridge driver has to set up some basic functionality and check for wrong
> >settings,
> >but I think it is better to move the more precise control of it to
> >userspace.
> >
> >We are not talking about a consumer market tv capture card or webcam where
> >you
> >want to hide the complexity in a driver, we are talking about embedded
> >systems
> >where the developer knows best what he wants. A media controller gives him
> >that control at the expense of a bit more work to set things up. But a
> >library
> >will solve that.
> >
> >My philosophy is that we should not try to be smart in the driver. That
> >will
> >just lead to a lot of difficult to understand code, and it scales pretty
> >badly
> >to even more complex hardware. It is better to move part of that
> >'intelligence'
> >to userspace and just provide an API to control it from there.
> >
> 
> Application can make a link. But driver will know if that link is possible only after selecting a sub device that is connected to the output
> connector or input connector. Once sub device is selected, driver knows
> what other sub device can be connected at it's output before the data goes to a capture node. So that means, link can be set up only S_OUTPUT or S_INPUT is called. If this is true, this has to be a pre-condition for accepting a link connection request from user space.

I don't follow (perhaps it is too late in the evening to answer mails like
this :-) ). Just in case it wasn't clear: not all links can be changed. Some
links are just fixed. S_OUTPUT and S_INPUT refer to physical connectors, and
not to the input/output links of a sub-device. 

> >>
> >> 2) There may be multiple applications/threads using the media control
> >nodes and doing things independently. For example there could be two
> >independent process/thread trying to grab the resizer, one using it in one
> >shot mode and
> >> make a sensor->ccdc->resizer link to do this and another using resizer
> >node
> >> for one shot operation. As the hardware is common, only one of them
> >should succeed. How is this mutual exclusion done?
> >
> >If e.g. a resizer is in use, then obviously any attempt to change it will
> >result in an EBUSY error. Besides that we should probably adopt the
> >priority
> >ioctls for the media controller. That should be sufficient. Of course, any
> >application developer that tries to do something stupid like that should go
> >back to class :-)
> >
> 
> Ok.
> 
> >>
> >> Could you please add details of the ioctls required to setup these links?
> >> Also details how the link commands flows to various nodes and what
> >happens at each node (sub device or bridge device) in the link.
> >
> >This is not set in stone. In part this will depend on experimentation to
> >see
> >what works and what doesn't. Currently I added two ioctls MAKE_LINK and
> >DELETE_LINK. Each defines the link by the entity IDs of the beginning and
> >end
> >of the link. It's very generic, but I'm not sure whether it is also easy to
> >use. If you have a switch (so only one of X links is active), then making a
> >link should automatically break the existing one. But if you have more
> >freedom
> >in setting up links, then it may not be that simple. In some cases
> >(actually
> >ivtv is a good example of that) making a single link will break a whole
> >bunch
> >of others and vice versa.
> >
> 
> I will check your posting.....
> 
> >
> >I did that at first, but I realized that the core ioctl is for internal use
> >within the bridge and subdevice drivers only. In particular: there are no
> >kernelspace to userspace copies needed. While this new ioctl will only be
> >called from userspace.
> >
> 
> 
> Got it.
> 
> >> >Topology
> >> >--------
> >> >
> >> >The topology is represented by entities. Each entity has 0 or more
> >inputs
> >> >and
> >> >0 or more outputs. Each input or output can be linked to 0 or more
> >possible
> >> >outputs or inputs from other entities. This is either mutually exclusive
> >> >(i.e. an input/output can be connected to only one output/input at a
> >time)
> >> >or it can be connected to multiple inputs/outputs at the same time.
> >> >
> >> >A device node is a special kind of entity with just one input (video
> >> >capture)
> >> >or output (video display). It may have both if it does some in-place
> >> >operation.
> >> >
> >> >Each entity has a unique numerical ID (unique for the board). Each input
> >or
> >> >output has a unique numerical ID as well, but that ID is only unique to
> >the
> >> >entity. To specify a particular input or output of an entity one would
> >give
> >> >an <entity ID, input/output ID> tuple. Note: to simplify the
> >implementation
> >> >it is a good idea to encode this into a u32. The top 20 bits for the
> >entity
> >> >ID, the bottom 12 bits for the pad ID.
> >>
> >> What about current video nodes like vpfe capture that can have multiple
> >inputs? Will mc driver will call enum_inputs and maps this to a enity id/
> >input pair to user application using existing API? I think doing that will
> >be required as per your restriction #1.
> >
> >I don't follow you. Entity IDs are only valid in the media controller
> >context.
> >They are independent from what enum_inputs reports. 
> 
> 
> In issue #6, you are talking about ENUM_INPUT/OUTPUT. You made the following
> statement above. 
> 
> >Each input or output has a unique numerical ID as well, but that ID is only unique to the entity. To specify a particular input or output of an entity one would give an <entity ID, input/output ID>
> 
> So when mc enumerates input/output, it has to call the enum_input() or enum_output() of the capture or output node, right? You also say "To specify a particular input or output of an entity". In this case why mc is referring to the particular input or output. I thought that application could enumerate/set/get input of an entity through the mc node. Not clear why mc needs to do the mapping that you are explaining unless it does enumerate/set/get through mc. Please clarify.

ENUM_INPUT/OUTPUT refer to physical connectors. The mc enumerates possible
links between device nodes and/or sub-devices, but not physical connectors.
Although perhaps we should, but that is a different story. Enumerating those
links is done through completely separate ioctls. Look at my v4l-dvb-mc tree
for a working example on how to do that.

Regards,

	Hans

> 
> >> >
> >> >We obviously need ioctls to make and break links between entities. It
> >> >shouldn't be hard to do this.
> >>
> >> Need to know more details on the ioctl to know if there are issues in
> >this approach.
> >
> >I have no doubts about the concept of links and that you should be able to
> >make or break them, but the actual implementation is a different matter.
> >This
> >should really be tried first on a few platforms. Just working on it with
> >ivtv
> >already showed some shortcomings in the internal link data structures that
> >I
> >used. During the LPC this is definitely a worthwhile topic, but the proof
> >of
> >the pudding is in the eating. Just starting to implement it is often the
> >fastest way of discovering the strengths and weaknesses of an API.
> 
> True. 
> 
> >Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
