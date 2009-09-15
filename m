Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3921 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZIOTDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 15:03:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: RFCv2.1: Media controller proposal
Date: Tue, 15 Sep 2009 21:03:39 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200909131235.13787.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE401551567E5@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401551567E5@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909152103.39154.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 15 September 2009 18:40:11 Karicheri, Muralidharan wrote:
> >
> >2) Some of the newer SoC devices can connect or disconnect internal
> >components
> >dynamically. As an example, the omap3 can either connect a sensor output to
> >a
> >CCDC module to a previewer module to a resizer module and finally to a
> >capture
> >device node. But it is also possible to capture the sensor output directly
> >after the CCDC module. The previewer can get its input from another video
> >device node and output either to the resizer or to another video capture
> >device node. The same is true for the resizer, that too can get its input
> >from
> >a device node.
> >
> >So there are lots of connections here that can be modified at will
> >depending
> >on what the application wants. And in real life there are even more links
> >than
> >I mentioned here. And it will only get more complicated in the future.
> >
> >All this requires that there has to be a way to connect and disconnect
> >parts
> >of the internal topology of a video board at will.
> >
> 1)
> For example, on DaVinci DM365, I could think of a connection of following to do capture, format covertion, and resize. Here each arrow is a connection
> 
> sensor (mt9t031)-> CCDC       -> IPIPE IF    -> IPIPE       -> resizer1 ->
> (sub device)    (future        (future       (future        -> resizer2
>                     sub device)     sub device)  sub device)      (future
>                                                                                    sub device)
> Or
> 
> Decoder(tvp514x)-> CCDC       -> IPIPE IF  -> resizer1
>                                                          -> resizer2
> 
> So in this configuration, capture node can be attached to CCDC output or
> IPIPE output or resizer output for on the fly mode of operation. For one
> shot mode (doing memory to memory operation), input for IPIPE can be from
> memory, output could be to memory to resizer and so forth.

Right.

> If application has to make a choice of making a specific connection it must know what the data formats are at each of the link along with other information such as polarities etc. These information are available only
> at the driver level at present. For example you have an RFC for bus parameter settings which is defined at board specific level and is used
> by bridge driver to set the bus output at sub device output and bridge device input. I can think of same thing at each of the above links. So how
> application will be able to make this decision unless, each of the sub device enumerates the available output data formats and input data formats and other parameters to the application? Or is it that the bridge driver just reports the possible connections or links and the bridge driver
> activates the links (here it setup one of the several possible link type
> based on board/platform configuration) and attach itself to one of the sub device output and start streaming? What are all the ioctls involved here to
> setup the link?

See this RFC I posted later that addresses this (at least in part):

http://www.mail-archive.com/linux-media%40vger.kernel.org/msg09644.html

The big question here is how much will you do in the bridge driver and how
much in an external library? I would prefer to move away from trying to do it
all in the driver and do more in a library on top of that. Of course, the
bridge driver has to set up some basic functionality and check for wrong settings,
but I think it is better to move the more precise control of it to userspace.

We are not talking about a consumer market tv capture card or webcam where you
want to hide the complexity in a driver, we are talking about embedded systems
where the developer knows best what he wants. A media controller gives him
that control at the expense of a bit more work to set things up. But a library
will solve that.

My philosophy is that we should not try to be smart in the driver. That will
just lead to a lot of difficult to understand code, and it scales pretty badly
to even more complex hardware. It is better to move part of that 'intelligence'
to userspace and just provide an API to control it from there.

> 
> 2) There may be multiple applications/threads using the media control nodes and doing things independently. For example there could be two independent process/thread trying to grab the resizer, one using it in one shot mode and
> make a sensor->ccdc->resizer link to do this and another using resizer node
> for one shot operation. As the hardware is common, only one of them should succeed. How is this mutual exclusion done?

If e.g. a resizer is in use, then obviously any attempt to change it will
result in an EBUSY error. Besides that we should probably adopt the priority
ioctls for the media controller. That should be sufficient. Of course, any
application developer that tries to do something stupid like that should go
back to class :-)
 
> 3) When streaming, there will be a particular order in which each of the
> sub device should be started. So I understand, it is up to the capture node
> to do this since media controller is not doing any streaming, right?

Correct.

> 4) Since the link management is moved to user space, I would like to have the board name as a parameter in the MC node. This will allow development
> of user space libraries tailored to a specific board.

I agree completely. The same is true for subdev entities as well: I want to
be able to detect what sort of device it is from userspace. There exists a
debugging API for that but the media controller can do a much better job.

> 
> >3) There is an increasing demand to be able to control e.g. sensors or
> >video
> >encoders/decoders at a much more precise manner. Currently the V4L2 API
> >provides only limited support in the form of a set of controls. But when
> >building a high-end camera the developer of the application controlling it
> >needs very detailed control of the sensor and image processing devices.
> >On the other hand, you do not want to have all this polluting the V4L2 API
> >since there is absolutely no sense in exporting this as part of the
> >existing
> >controls, or to allow for a large number of private ioctls.
> >
> 
> 
> So I assume, the v4l2 core look at the entity id and match it with that of
> a resizer or previewer or sensor and pass it to the ioctl() function which
> process the command, right?

You can take a look at my test implementation in my v4l-dvb-mc tree: I added
a new VIDIOC_S_ENTITY that takes an entity ID and looks it up. After that
any ioctls that are not handled by the media controller itself are passed to
the entity's ioctl.
 
 
> >What would be a good solution is to give access to the various components
> >of
> >the board and allow the application to send component-specific ioctls or
> >controls to it. Any application that will do this is by default tailored to
> >that board. In addition, none of these new controls or commands will
> >pollute
> >the namespace of V4L2.
> >
> >A media controller can solve all these problems: it will provide a window
> >into
> >the architecture of the board and all its device nodes. Since it is already
> >enumerating the nodes and components of the board and how they are linked
> >up,
> >it is only a small step to also use it to change links and to send commands
> >to
> 
> Could you please add details of the ioctls required to setup these links?
> Also details how the link commands flows to various nodes and what happens at each node (sub device or bridge device) in the link.

This is not set in stone. In part this will depend on experimentation to see
what works and what doesn't. Currently I added two ioctls MAKE_LINK and
DELETE_LINK. Each defines the link by the entity IDs of the beginning and end
of the link. It's very generic, but I'm not sure whether it is also easy to
use. If you have a switch (so only one of X links is active), then making a
link should automatically break the existing one. But if you have more freedom
in setting up links, then it may not be that simple. In some cases (actually
ivtv is a good example of that) making a single link will break a whole bunch
of others and vice versa.

Anyway, these ioctls go to the bridge driver that can implement it anyway it
likes. Generally it is only bridge internal settings, but it may be more
involved. The bridge should definitely do some checking: e.g. if two sub
devices have incompatible data formats, then it should perhaps refuse to make
the link. Alternatively, perhaps that check should only be done the moment
you try to actually stream. That allows you to setup everything without fear
of making a wrong choice.

> 
> >specific components.
> >
> >
> >Restrictions
> >============
> >
> >1) These API additions should not affect existing applications.
> >
> >2) The new API should not attempt to be too smart. All it should do it to
> >give
> >the application full control of the board and to provide some initial
> >support
> >for existing applications. E.g. in the case of omap3 you will have an
> >initial
> >setup where the sensor is connected through all components to a capture
> >device
> >node. This will provide sufficient support for a standard webcam
> >application,
> >but if you want something more advanced then the application will have to
> >set
> >it up explicitly. It may even be too complicated to use the resizer in this
> >case, and instead only a few resolutions optimal for the sensor are
> >reported.
> >
> >3) Provide automatic media controller support for drivers that do not
> >create
> >one themselves. This new functionality should become available to all
> >drivers,
> >not just new ones. Otherwise it will take a long time before applications
> >like
> >MythTV will start to use it.
> >
> >4) All APIs specific to sub-devices MUST BE DOCUMENTED! And it should NEVER
> >be
> >allowed that those APIs can be abused to do direct register reads/writes!
> >Everyone should be able to use those APIs, not just those with access to
> >datasheets.
> >
> >
> >Implementation
> >==============
> >
> >Many of the building blocks needed to implement a media controller already
> >exist: the v4l core can easily be extended with a media controller type,
> >the
> >media controller device node can be held by the v4l2_device top-level
> >struct,
> >and to represent an internal component we have the v4l2_subdev struct.
> >
> >The v4l2_subdev struct can be extended with a mc_ioctl callback that can be
> >used by the media controller to pass custom ioctls to the subdev. There is
> >also a 'core ops' ioctl, but that is better left to internal usage only.
> >
> 
> 
> Why can't we use ioctl() method in core ops in sub device to pass the command? Since sub device is known to core, it can just call it based on the entity id being used by the sub device.

I did that at first, but I realized that the core ioctl is for internal use
within the bridge and subdevice drivers only. In particular: there are no
kernelspace to userspace copies needed. While this new ioctl will only be
called from userspace.

> >What is missing is that device nodes should be registered with struct
> >v4l2_device. All that is needed to do that is to ensure that when
> >registering
> >a video node you always pass a pointer to the v4l2_device struct. A lot of
> >drivers do this already. In addition one should also be able to register
> >non-video device nodes (alsa, fb, etc.), so that they can be enumerated.
> >
> >Since sub-devices are already registered with the v4l2_device there is not
> >much to do there.
> >
> >Topology
> >--------
> >
> >The topology is represented by entities. Each entity has 0 or more inputs
> >and
> >0 or more outputs. Each input or output can be linked to 0 or more possible
> >outputs or inputs from other entities. This is either mutually exclusive
> >(i.e. an input/output can be connected to only one output/input at a time)
> >or it can be connected to multiple inputs/outputs at the same time.
> >
> >A device node is a special kind of entity with just one input (video
> >capture)
> >or output (video display). It may have both if it does some in-place
> >operation.
> >
> >Each entity has a unique numerical ID (unique for the board). Each input or
> >output has a unique numerical ID as well, but that ID is only unique to the
> >entity. To specify a particular input or output of an entity one would give
> >an <entity ID, input/output ID> tuple. Note: to simplify the implementation
> >it is a good idea to encode this into a u32. The top 20 bits for the entity
> >ID, the bottom 12 bits for the pad ID.
> 
> What about current video nodes like vpfe capture that can have multiple inputs? Will mc driver will call enum_inputs and maps this to a enity id/ input pair to user application using existing API? I think doing that will be required as per your restriction #1.

I don't follow you. Entity IDs are only valid in the media controller context.
They are independent from what enum_inputs reports.

> 
> >
> >When enumerating over entities you will need to retrieve at least the
> >following information:
> >
> >- type (subdev or device node)
> >- entity ID
> >- entity name (a short name)
> >- entity description (can be quite long)
> >- subtype (what sort of device node or subdev is it?)
> >- capabilities (what can the entity do? Specific to the subtype and more
> >precise than the v4l2_capability struct which only deals with the board
> >capabilities)
> >- addition subtype-specific data (union)
> >- number of inputs and outputs. The input IDs should probably just be a
> >value
> >of 0 - (#inputs - 1) (ditto for output IDs). Note: it looks like it might
> >be more efficient to just have the number of pads, and use the capabilities
> >field to determine whether this entity is a source and/or sink.
> >
> 
> How about adding board name since mc is board specific? This will allow writing user space libraries tailored to a board. For example configuring
> AF/AEWB would require different parameter sets on various platform. So we
> library will be able to conceal this detail and use different structures to
> configure the af/aewb module.

We definitely want this.

> >Another ioctl is needed to obtain the list of pads and the possible links
> >that
> >can be made from/to each pad for an entity. That way two ioctl calls should
> >be
> >sufficient to get all the information about an entity and how it can be
> >hooked
> >up.
> >
> >It is good to realize that most applications will just enumerate e.g.
> >capture
> >device nodes. Few applications will do a full scan of the whole topology.
> >Instead they will just specify the unique entity ID and if needed the
> >input/output ID as well. These IDs are declared in the board or sub-device
> >specific header.
> >
> 
> In that case, probably don't need board name as suggested earlier since entity id will be different on two different platforms for AF/AEWB. But I can't imagine all cases. So better to add it.
> 
> >A full enumeration will typically only be done by some sort of generic
> >application like v4l2-ctl.
> >
> >In addition, most entities will have only one or two inputs/outputs at most.
> >So we might optimize the data structures for this. We probably will have to
> >see how it goes when we implement it. Note: based on the current test
> >implementation such an optimization would be a good idea.
> >
> >We obviously need ioctls to make and break links between entities. It
> >shouldn't be hard to do this.
> 
> Need to know more details on the ioctl to know if there are issues in this approach.

I have no doubts about the concept of links and that you should be able to
make or break them, but the actual implementation is a different matter. This
should really be tried first on a few platforms. Just working on it with ivtv
already showed some shortcomings in the internal link data structures that I
used. During the LPC this is definitely a worthwhile topic, but the proof of
the pudding is in the eating. Just starting to implement it is often the
fastest way of discovering the strengths and weaknesses of an API.
 
> >
> >Access to sub-devices
> >---------------------
> >
> >What is a bit trickier is how to select a sub-device as the target for
> >ioctls.
> >Normally ioctls like S_CTRL are sent to a /dev/v4l/videoX node and the
> >driver
> >will figure out which sub-device (or possibly the bridge itself) will
> >receive
> >it. There is no way of hijacking this mechanism to e.g. specify a specific
> >entity ID without also having to modify most of the v4l2 structs by adding
> >such an ID field. But with the media controller we can at least create an
> >ioctl that specifies a 'target entity' that will receive any non-media
> >controller ioctl. Note that for now we only support sub-devices as the
> >target
> >entity.
> >
> >The idea is this:
> >
> >mc = open("/dev/v4l/mc0", O_RDWR);
> >// Select a particular target entity
> >ioctl(mc, VIDIOC_S_ENTITY, &histogramID);
> >// Send a custom ioctl to that entity
> >ioctl(mc, VIDIOC_OMAP3_G_HISTOGRAM, &hist);
> >
> >This requires no API changes and is very easy to implement. One problem is
> >that this is not thread-safe. A good and simple solution is to store the
> >target entity as part of the filehandle. So you can open the media
> >controller
> >multiple times and each handle can set its own target entity.
> >
> >This also has the advantage that you can have a filehandle 'targeted' at a
> >resizer and a filehandle 'targeted' at the previewer, etc. If you want to
> >use
> >the same filehandle from multiple threads, then you have to implement
> >locking
> >yourself.
> >
> >
> >Open issues
> >===========
> >
> >In no particular order:
> >
> >1) How to tell the application that this board uses an audio loopback cable
> >to the PC's audio input?
> >
> >2) There can be a lot of device nodes in complicated boards. One suggestion
> >is to only register them when they are linked to an entity (i.e. can be
> >active). Should we do this or not? Note: I fear that this will lead to
> >quite
> >complex drivers. I do not plan on adding such functionality for the first
> >version of the media controller.
> >
> >3) Format and bus configuration and enumeration. Sub-devices are connected
> >together by a bus. These busses can have different configurations that will
> >influence the list of possible formats that can be received or sent from
> >device nodes. This was always pretty straightforward, but if you have
> >several
> >sub-devices such as scalers and colorspace converters in a pipeline then
> >this
> >becomes very complex indeed. This is already a problem with soc-camera, but
> >that is only the tip of the iceberg.
> >
> >How to solve this problem is something that requires a lot more thought.
> >
> 
> I am alluding to this in my earlier comments above. By using sub device approach for implementing resizer, I will hit this issue right away :(
> 
> For example, ccdc will get different data formats/polarities from the sub device bus depending on which is the source of the data. Now if application choose to make the connection, it should be aware of these details or let the driver decide if they are compatible and then returns an error to application for setup link command. I am assuming these commands finally go to both the sub devices (source and sink). But who will read the static bus configuration from board/platform code and do the compatibility check? Bridge device is the best place IMO. So these link command should go to bridge device (capture or output node) and then to the sub device.

I agree that this should be handled by the bridge driver. While in theory an
application can also setup the bus configuration (polarities etc.) I do not
feel comfortable with that. I prefer if that is the domain of the bridge
driver together with a bit of platform code if needed.
 
> >4) One interesting idea is to create an ioctl with an entity ID as argument
> >that returns a timestamp of frame (audio or video) it is processing. That
> >would solve not only sync problems with alsa, but also when reading a
> >stream
> >in general (read/write doesn't provide for a timestamp as streaming I/O
> >does).
> >
> >5) I propose that we return -ENOIOCTLCMD when an ioctl isn't supported by
> >the
> >media controller. Much better than -EINVAL that is currently used in V4L2.
> >
> >6) For now I think we should leave enumerating input and output connectors
> >to the bridge drivers (ENUMINPUT/ENUMOUTPUT). But as a future step it would
> >make sense to also enumerate those in the media controller. However, it is
> >not entirely clear what the relationship will be between that and the
> >existing enumeration ioctls.
> >
> >7) Monitoring: the media controller can also be used very effectively to
> >monitor a board. Events can be passed up from sub-devices to the media
> >controller and through select() to the application. So a sub-device
> 
> Yes. We had a customer requesting to let application know when carrier is lost at the input of a tvp5147 or tvp7002. Also when this happens, probably bridge driver might also want to monitor this and re-sync the capture. So you might want to consider passing events from sub device to bridge device
> as well.

It's already possible to pass notifications from a sub-device to a bridge
device, but we need that extra step to pass it to an application.

Regards,

	Hans
 
> >controlling a camera motor can signal the application through the media
> >controller when the motor has reached its final destination. Using the
> >media controller for this is more appropriate than a streaming video node,
> >since it is not always clear to which video node an event should be sent.
> >
> >Of course, some events (e.g. signalling when an MPEG decoder finished
> >processing the pending buffers) are clearly video node specific.
> >
> >8) The media controller is currently part of the v4l2 framework. But
> >perhaps
> >it should be split off as a separate media device with its own major device
> >number. The internal data structures are v4l2-agnostic. It would probably
> >require some rework to achieve this, but it would make this something that
> >can easily be extended to other subsystems.
> >
> >9) Use of sysfs. It is no secret that I see sysfs in a supporting role only.
> >In my opinion sysfs is too cumbersome and simply not powerful enough
> >compared
> >to ioctls. There are some cases where it can be useful to expose certain
> >data
> >to sysfs as well (e.g. controls), but that should be in addition to the
> >main
> >ioctl API and it should not replace it.
> >
> >Regards,
> >
> >       Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
