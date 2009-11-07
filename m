Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4353 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZKGMge (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 07:36:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Restructure video_device
Date: Sat, 7 Nov 2009 13:36:33 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <200910231625.40822.laurent.pinchart@ideasonboard.com> <200911051519.06843.hverkuil@xs4all.nl> <200911061123.59977.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200911061123.59977.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911071336.33364.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 06 November 2009 11:23:59 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 05 November 2009 15:19:06 Hans Verkuil wrote:
> > On Friday 23 October 2009 16:25:40 Laurent Pinchart wrote:
> > > Hi everybody,
> > >
> > > while working on device node support for subdevs I ran into an issue with
> > > the way v4l2 objects are structured.
> > >
> > > We currently have the following structure:
> > >
> > > - video_device represents a device that complies with the V4L1 or V4L2
> > > API. Every video_device has a corresponding device node.
> > >
> > > - v4l2_device represents a high-level media device that handles
> > > sub-devices. With the new media controller infrastructure a v4l2_device
> > > will have a device node as well.
> > >
> > > - v4l2_subdev represents a sub-device. As for v4l2_device's, the new
> > > media controller infrastructure will give a device node for every
> > > sub-device.
> > >
> > > - v4l2_entity is the structure that both v4l2_subdev and video_device
> > > derive from. Most of the media controller code will deal with entities
> > > rather than sub-devices or video devices, as most operations (such as
> > > discovering the topology and create links) do not depend on the exact
> > > nature of the entity. New types of entities could be introduced later.
> > >
> > > Both the video_device and v4l2_subdev structure inherit from v4l2_entity,
> > > so both of them have a v4l2_entity field. With v4l2_device and
> > > v4l2_subdev now needing to devices to have device nodes created, the
> > > v4l2_device and v4l2_subdev structure both have a video_device field.
> > >
> > > This isn't clean for two reasons:
> > >
> > > - v4l2_device isn't a v4l2_entity, so it should inherit from a structure
> > > (video_device) that itself inherits from v4l2_entity.
> > >
> > > - v4l2_subdev shouldn't inherit twice from v4l2_entity, once directly and
> > > once through video_device.
> > 
> > I agree.
> > 
> > > To fix this I would like to refactor the video_device structure and cut
> > > it in two pieces. One of them will deal with device node related tasks,
> > > being mostly V4L1/V4L2 agnostic, and the other will inherit from the
> > > first and add V4L1/V4L2 support (tvnorms/current_norm/ioctl_ops fields
> > > from the current video_device structure), as well as media controller
> > > support (inheriting from v4l2_entity).
> > >
> > > My plan was to create a video_devnode structure for the low-level device
> > > node
> > 
> > Let's call it v4l2_devnode to be consistent with the current naming
> >  convention.
> 
> Ok.
> 
> > > related structure, and keeping the video_device name for the higher level
> > > structure. v4l2_device, v4l2_subdev and video_device would then all have
> > > a video_devnode field.
> > >
> > > While this isn't exactly difficult, it would require changing a lot of
> > > drivers, as some field will be moved from video_device to
> > > video_device::video_devnode. Some of those fields are internal, some of
> > > them are accessed by drivers while they shouldn't in most cases (the
> > > minor field for instance), and some are public (name, parent).
> > >
> > > I would like to have your opinion on whether you think this proposal is
> > > acceptable or whether you see a better and cleaner way to restructure the
> > > video device code structures.
> > 
> > I have two issues with this:
> > 
> > 1) Is it really necessary to do this now? We are still in the prototyping
> > phase and I think it is probably more efficient right now to hack around
> >  this and postpone the real fix (as described above) until we are sure that
> >  the mc concept is working correctly.
> 
> The media controller prototyping code is, as usual with prototyping codes, a 
> bit messy. Splitting the device node management part from video_device into 
> v4l2_devnode will make the media controller code easier to understand for 
> outsiders (by outsider I mean every person who haven't been actively working 
> on the code, so that includes pretty much everybody). I think it's worth it, 
> especially given that I've already written the patches. They can live in the 
> media controller tree of course, we don't have to apply them to mainline at 
> the moment.

Ah, it's only for the mc tree. I was getting the impression that you wanted to
do this for the mainline tree as well. But if it is just for the mc tree, then
go ahead. You can just do it in your own tree; as far as I am concerned your
tree is leading for now.

> > 2) I'm not sure whether the final media controller will and should be part
> > of the v4l framework at all. I think that this is something that can be
> >  used separately from the v4l subsystem.
> 
> I think it should not be part of the v4l subsystem. ALSA will benefit from the 
> media controller, and so might other subsystems such as GPU. A media_ prefix 
> would be much nicer.

I agree, but let's postpone such decisions until later.

> >  So we should be very careful about integrating this too closely in v4l.
> >  Again, this is not much of an issue while prototyping, but it definitely
> >  will need some careful thinking when we do the final implementation.
> 
> Agreed. Let's rename v4l2_devnode to media_devnode in the future then :-)
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
