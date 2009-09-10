Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4044 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZIJV7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 17:59:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: RFCv2: Media controller proposal
Date: Thu, 10 Sep 2009 23:59:20 +0200
Cc: linux-media@vger.kernel.org
References: <200909100913.09065.hverkuil@xs4all.nl> <Pine.LNX.4.64.0909102252190.4458@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909102252190.4458@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909102359.20249.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 10 September 2009 23:28:40 Guennadi Liakhovetski wrote:
> Hi Hans
> 
> a couple of comments / questions from the first glance
> 
> On Thu, 10 Sep 2009, Hans Verkuil wrote:
> 
> [snip]
> 
> > Topology
> > --------
> > 
> > The topology is represented by entities. Each entity has 0 or more inputs and
> > 0 or more outputs. Each input or output can be linked to 0 or more possible
> > outputs or inputs from other entities. This is either mutually exclusive 
> > (i.e. an input/output can be connected to only one output/input at a time)
> > or it can be connected to multiple inputs/outputs at the same time.
> > 
> > A device node is a special kind of entity with just one input (capture node)
> > or output (video node). It may have both if it does some in-place operation.
> > 
> > Each entity has a unique numerical ID (unique for the board). Each input or
> > output has a unique numerical ID as well, but that ID is only unique to the
> > entity. To specify a particular input or output of an entity one would give
> > an <entity ID, input/output ID> tuple.
> > 
> > When enumerating over entities you will need to retrieve at least the
> > following information:
> > 
> > - type (subdev or device node)
> > - entity ID
> > - entity description (can be quite long)
> > - subtype (what sort of device node or subdev is it?)
> > - capabilities (what can the entity do? Specific to the subtype and more
> > precise than the v4l2_capability struct which only deals with the board
> > capabilities)
> > - addition subtype-specific data (union)
> > - number of inputs and outputs. The input IDs should probably just be a value
> > of 0 - (#inputs - 1) (ditto for output IDs).
> > 
> > Another ioctl is needed to obtain the list of possible links that can be made
> > for each input and output.
> 
> Shall we not just let the user try? and return an error if the requested 
> connection is impossible? Remember, media-controller users are 
> board-tailored, so, they will not be very dynamic.

True, but it will be sooo nice to make a GUI that will visualize all these
connections and allow the developer to change then dynamically. And I expect
this to be nothing more than simple static const arrays.

What I didn't mention in the RFC, but probably should, is that my intention
is that the driver will just pass some data structure to the v4l core with
all these connections, and that the core will handle all the enumerations etc.
Only making or breaking links will involve a call to the driver (probably
through v4l2_device).

> > It is good to realize that most applications will just enumerate e.g. capture
> > device nodes. Few applications will do a full scan of the whole topology.
> > Instead they will just specify the unique entity ID and if needed the
> > input/output ID as well. These IDs are declared in the board or sub-device
> > specific header.
> > 
> > A full enumeration will typically only be done by some sort of generic
> > application like v4l2-ctl.
> 
> Well, is this the reason why you wanted to enumerate possible connections? 
> Should v4l2-ctrl be able to manipulate those connections? What is it for 
> actually?

Yes, v4l2-ctl should be able to change connections.
 
> > In addition, most entities will have only one or two inputs/outputs at most.
> > So we might optimize the data structures for this. We probably will have to
> > see how it goes when we implement it.
> > 
> > We obviously need ioctls to make and break links between entities. It
> > shouldn't be hard to do this.
> > 
> > Access to sub-devices
> > ---------------------
> > 
> > What is a bit trickier is how to select a sub-device as the target for ioctls.
> > Normally ioctls like S_CTRL are sent to a /dev/v4l/videoX node and the driver
> > will figure out which sub-device (or possibly the bridge itself) will receive
> > it. There is no way of hijacking this mechanism to e.g. specify a specific
> > entity ID without also having to modify most of the v4l2 structs by adding
> > such an ID field. But with the media controller we can at least create an
> > ioctl that specifies a 'target entity' that will receive any non-media
> > controller ioctl. Note that for now we only support sub-devices as the target
> > entity.
> > 
> > The idea is this:
> > 
> > // Select a particular target entity
> > ioctl(mc, VIDIOC_S_SUBDEV, &entityID);
> > // Send S_FMT directly to that entity
> > ioctl(mc, VIDIOC_S_FMT, &fmt);
> 
> is this really a "mc" fd or the respective video-devive fd?

It's a filehandle to the media controller. I've added an explicit open()
to make this clear.

> > // Send a custom ioctl to that entity
> > ioctl(mc, VIDIOC_OMAP3_G_HISTOGRAM, &hist);
> > 
> > This requires no API changes and is very easy to implement. One problem is
> > that this is not thread-safe. We can either supply some sort of locking
> > mechanism, or just tell the application programmer to do the locking in the
> > application. I'm not sure what is the correct approach here. A reasonable
> > compromise would be to store the target entity as part of the filehandle.
> > So you can open the media controller multiple times and each handle can set
> > its own target entity.
> > 
> > This also has the advantage that you can have a filehandle 'targeted' at a
> > resizer and a filehandle 'targeted' at the previewer, etc. If you want to use
> > the same filehandle from multiple threads, then you have to implement locking
> > yourself.
> 
> You mean the driver should only care about internal consistency, and the 
> user is allowed to otherwise shoot herself in the foot? Makes sense to 
> me:-)

Basically, yes :-)

You can easily make something like a VIDIOC_MC_LOCK and VIDIOC_MC_UNLOCK ioctl
that can be used to get exclusive access to the MC. Or we could reuse the
G/S_PRIORITY ioctls. The first just feels like a big hack to me, the second has
some merit, I think.

> 
> > 
> > 
> > Open issues
> > ===========
> > 
> > In no particular order:
> > 
> > 1) How to tell the application that this board uses an audio loopback cable
> > to the PC's audio input?
> > 
> > 2) There can be a lot of device nodes in complicated boards. One suggestion
> > is to only register them when they are linked to an entity (i.e. can be
> > active). Should we do this or not?
> 
> Really a lot of device nodes? not sub-devices? What can this be? Isn't the 
> decision when to register them board-specific?

Sub-devices do not in general have device nodes (note that i2c sub-devices
will have an i2c device node, of course).

When to register device nodes is in the end driver-specific, but what to do
when enumerating input device nodes and the device node doesn't exist yet?

I can't put my finger on it, but my intuition says that doing this is
dangerous. I can't oversee all the consequences.

> 
> > 
> > 3) Format and bus configuration and enumeration. Sub-devices are connected
> > together by a bus. These busses can have different configurations that will
> > influence the list of possible formats that can be received or sent from
> > device nodes. This was always pretty straightforward, but if you have several
> > sub-devices such as scalers and colorspace converters in a pipeline then this
> > becomes very complex indeed. This is already a problem with soc-camera, but
> > that is only the tip of the iceberg.
> > 
> > How to solve this problem is something that requires a lot more thought.
> > 
> > 4) One interesting idea is to create an ioctl with an entity ID as argument
> > that returns a timestamp of frame (audio or video) it is processing. That
> > would solve not only sync problems with alsa, but also when reading a stream
> > in general (read/write doesn't provide for a timestamp as streaming I/O does).
> > 
> > 5) I propose that we return -ENOIOCTLCMD when an ioctl isn't supported by the
> > media controller. Much better than -EINVAL that is currently used in V4L2.
> > 
> > 6) For now I think we should leave enumerating input and output connectors
> > to the bridge drivers (ENUMINPUT/ENUMOUTPUT). But as a future step it would
> > make sense to also enumerate those in the media controller. However, it is
> > not entirely clear what the relationship will be between that and the
> > existing enumeration ioctls.
> 
> Why should a bridge driver care? This isn't board-specific, is it?

I don't follow you. What input and output connectors a board has is by
definition board specific. If you can enumerate them through the media
controller, then you can be more precise how they are hooked up. E.g. an
antenna input is connected to a tuner sub-device, while the composite video-in
is connected to a video decoder and the audio inputs to an audio mixer
sub-device. All things that cannot be represented by ENUMINPUT. But do we
really care about that?

My opinion is that we should leave this alone for now. There is enough to do
and we can always add it later.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
