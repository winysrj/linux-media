Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1854 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZIMJDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 05:03:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Nathaniel Kim <dongsoo.kim@gmail.com>
Subject: Re: Media controller: sysfs vs ioctl
Date: Sun, 13 Sep 2009 11:03:20 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@skynet.be>
References: <200909120021.48353.hverkuil@xs4all.nl> <1BD4D6CB-4CEC-40D2-B168-BE5F8494189F@gmail.com>
In-Reply-To: <1BD4D6CB-4CEC-40D2-B168-BE5F8494189F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="euc-kr"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909131103.20202.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 13 September 2009 08:13:04 Nathaniel Kim wrote:
> 
> 2009. 9. 12., 오전 7:21, Hans Verkuil 작성:
> 
> > Hi all,
> >
> > I've started this as a new thread to prevent polluting the  
> > discussions of the
> > media controller as a concept.
> >
> > First of all, I have no doubt that everything that you can do with  
> > an ioctl,
> > you can also do with sysfs and vice versa. That's not the problem  
> > here.
> >
> > The problem is deciding which approach is the best.
> >
> > What is sysfs? (taken from http://lwn.net/Articles/31185/)
> >
> > "Sysfs is a virtual filesystem which provides a userspace-visible  
> > representation
> > of the device model. The device model and sysfs are sometimes  
> > confused with each
> > other, but they are distinct entities. The device model functions  
> > just fine
> > without sysfs (but the reverse is not true)."
> >
> > Currently both a v4l driver and the device nodes are all represented  
> > in sysfs.
> > This is handled automatically by the kernel.
> >
> > Sub-devices are not represented in sysfs since they are not based on  
> > struct
> > device. They are v4l-internal structures. Actually, if the subdev  
> > represents
> > an i2c device, then that i2c device will be present in sysfs, but  
> > not all
> > subdevs are i2c devices.
> >
> > Should we make all sub-devices based on struct device? Currently  
> > this is not
> > required. Doing this would probably mean registering a virtual bus,  
> > then
> > attaching the sub-device to that. Of course, this only applies to  
> > sub-devices
> > that represent something that is not an i2c device (e.g. something  
> > internal
> > to the media board like a resizer, or something connected to GPIO  
> > pins).
> >
> > If we decide to go with sysfs, then we have to do this. This part  
> > shouldn't
> > be too difficult to implement. And also if we do not go with sysfs  
> > this might
> > be interesting to do eventually.
> >
> > The media controller topology as I see it should contain the device  
> > nodes
> > since the application has to know what device node to open to do the  
> > streaming.
> > It should also contain the sub-devices so the application can  
> > control them.
> > Is this enough? I think that eventually we also want to show the  
> > physical
> > connectors. I left them out (mostly) from the initial media  
> > controller proposal,
> > but I suspect that we want those as well eventually. But connectors  
> > are
> > definitely not devices. In that respect the entity concept of the  
> > media
> > controller is more abstract than sysfs.
> >
> > However, for now I think we can safely assume that sub-devices can  
> > be made
> > visible in sysfs.
> >
> 
> Hans,
> 
> First of all I'm very sorry that I had not enough time to go through  
> your new RFC. I'll checkout right after posting this mail.
> 
> I think this is a good approach and I also had in my mind that sysfs  
> might be a good method if we could control and monitor through this.  
> Recalling memory when we had a talk in San Francisco, I was frustrated  
> that there is no way to catch events from sort of sub-devices like  
> lens actuator (I mean pizeo motors in camera module). As you know lens  
> actuator is an extremely slow device in comparison with common v4l2  
> devices we are using and we need to know whether it has succeeded or  
> not in moving to expected position.
> So I considered sysfs and udev as candidates for catching events from  
> sub-devices. events like success/failure of lens movement, change of  
> status of subdevices.
> Does anybody experiencing same issue? I think I've seen a lens  
> controller driver in omap3 kernel from TI but not sure how did they  
> control that.
> 
> My point is that we need a kind of framework to give and event to user  
> space and catching them properly just like udev does.

When I was talking to Laurent Pinchart and Sakari and his team at Nokia
we discussed just such a framework. It actually exists already, although
it is poorly implemented.

Look at include/linux/dvb/video.h, struct video_event and ioctl VIDEO_GET_EVENT.
It is used in ivtv (ivtv-ioctl.c, look for VIDEO_GET_EVENT).

The idea is that you can either call VIDEO_GET_EVENT to wait for an event
or use select() and wait for an exception to arrive, and then call
VIDEO_GET_EVENT to find which event it was.

This is ideal for streaming-related events. In ivtv it is used to report
VSYNCs and to report when the MPEG decoder stopped (there is a delay between
stopping sending new data to the decoder and when it actually processed all
its internal buffers).

Laurent is going to look into this to clean it up and present it as a new
proper official V4L2 event mechanism.

For events completely specific to a subdev I wonder whether it wouldn't be
a good idea to use the media controller device for that. I like the select()
mechanism since in an application you can just select() on a whole bunch of
filehandles. If you can't use select() then you are forced to do awkward coding
(e.g. make a separate thread just to handle that other event mechanism).

So with the media controller we can easily let sub-devices notify the media
controller when an event is ready and the media controller can then generate
an exception. An application can just select() on the mc filehandle.

There are two ways of implementing this. One is that the media controller
keeps a global queue of pending events and subdevices just queue events to
that when they arrive (with some queue size limit to prevent run-away events).

So when you call some GET_EVENT type ioctl it should return the ID of the
subdevice (aka entity) as well. What makes me slightly uncomfortable is that
you still want to use that same ioctl on a normal video node. And the subdev
ID has really no meaning there. But making two different ioctls doesn't sit
well with me either.

The alternative implementation is that the mc will only wait for events from
the currently selected sub-device. So if you want to wait on events from
different sub-devices, then you have to open the mc multiple times, once for
each subdev that you want to receive events from.

I think I would probably go for the second implementation because it is
consistent with the way ioctls are passed to sub-devices. I like the idea that
you can just pass regular V4L2 ioctls to sub-devices. Not all ioctls make
sense, obviously (e.g. any of the streaming I/O ioctls), but a surprisingly
large number of ioctls can be used in that way.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
