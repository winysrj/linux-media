Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:58684 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbZJKWop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 18:44:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: Media controller: sysfs vs ioctl
Date: Mon, 12 Oct 2009 00:46:32 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Nathaniel Kim <dongsoo.kim@gmail.com>,
	linux-media@vger.kernel.org
References: <200909120021.48353.hverkuil@xs4all.nl> <200909131103.20202.hverkuil@xs4all.nl> <4AB7B6AA.3070404@maxwell.research.nokia.com>
In-Reply-To: <4AB7B6AA.3070404@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910120046.32597.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 21 September 2009 19:23:54 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > On Sunday 13 September 2009 08:13:04 Nathaniel Kim wrote:
> >> 2009. 9. 12., 오전 7:21, Hans Verkuil 작성:
> >>
> >> Hans,
> >>
> >> First of all I'm very sorry that I had not enough time to go through
> >> your new RFC. I'll checkout right after posting this mail.
> >>
> >> I think this is a good approach and I also had in my mind that sysfs
> >> might be a good method if we could control and monitor through this.
> >> Recalling memory when we had a talk in San Francisco, I was frustrated
> >> that there is no way to catch events from sort of sub-devices like
> >> lens actuator (I mean pizeo motors in camera module). As you know lens
> >> actuator is an extremely slow device in comparison with common v4l2
> >> devices we are using and we need to know whether it has succeeded or
> >> not in moving to expected position.
> >> So I considered sysfs and udev as candidates for catching events from
> >> sub-devices. events like success/failure of lens movement, change of
> >> status of subdevices.
> >> Does anybody experiencing same issue? I think I've seen a lens
> >> controller driver in omap3 kernel from TI but not sure how did they
> >> control that.
> >>
> >> My point is that we need a kind of framework to give and event to user
> >> space and catching them properly just like udev does.
> >
> > When I was talking to Laurent Pinchart and Sakari and his team at Nokia
> > we discussed just such a framework. It actually exists already, although
> > it is poorly implemented.
> >
> > Look at include/linux/dvb/video.h, struct video_event and ioctl
> > VIDEO_GET_EVENT. It is used in ivtv (ivtv-ioctl.c, look for
> > VIDEO_GET_EVENT).
> >
> > The idea is that you can either call VIDEO_GET_EVENT to wait for an event
> > or use select() and wait for an exception to arrive, and then call
> > VIDEO_GET_EVENT to find which event it was.
> >
> > This is ideal for streaming-related events. In ivtv it is used to report
> > VSYNCs and to report when the MPEG decoder stopped (there is a delay
> > between stopping sending new data to the decoder and when it actually
> > processed all its internal buffers).
> >
> > Laurent is going to look into this to clean it up and present it as a new
> > proper official V4L2 event mechanism.
> >
> > For events completely specific to a subdev I wonder whether it wouldn't
> > be a good idea to use the media controller device for that. I like the
> > select() mechanism since in an application you can just select() on a
> > whole bunch of filehandles. If you can't use select() then you are forced
> > to do awkward coding (e.g. make a separate thread just to handle that
> > other event mechanism).
> 
> Agree. There's no reasonable way to use video devices here since the
> events may be connected to non-video related issues --- like the
>  statistics.
> 
> One possible approach could be allocating a device node for each subdev
> and use them and leave the media controller device with just the media
> controller specific ioctls. Then there would be no need to set current
> subdev nor bind the subdev to file handle either.
> 
> Just an idea.
> 
> > So with the media controller we can easily let sub-devices notify the
> > media controller when an event is ready and the media controller can then
> > generate an exception. An application can just select() on the mc
> > filehandle.
> >
> > There are two ways of implementing this. One is that the media controller
> > keeps a global queue of pending events and subdevices just queue events
> > to that when they arrive (with some queue size limit to prevent run-away
> > events).
> 
> With the above arrangement, the events could be easily subdev specific.
> The mechanism should be generic still, though.
> 
> > So when you call some GET_EVENT type ioctl it should return the ID of the
> > subdevice (aka entity) as well. What makes me slightly uncomfortable is
> > that you still want to use that same ioctl on a normal video node. And
> > the subdev ID has really no meaning there. But making two different
> > ioctls doesn't sit well with me either.
> >
> > The alternative implementation is that the mc will only wait for events
> > from the currently selected sub-device. So if you want to wait on events
> > from different sub-devices, then you have to open the mc multiple times,
> > once for each subdev that you want to receive events from.
> >
> > I think I would probably go for the second implementation because it is
> > consistent with the way ioctls are passed to sub-devices. I like the idea
> > that you can just pass regular V4L2 ioctls to sub-devices. Not all ioctls
> > make sense, obviously (e.g. any of the streaming I/O ioctls), but a
> > surprisingly large number of ioctls can be used in that way.
> 
> I agree with this. There are just a few ioctls that probably don't make
> sense (e.g. the steaming related ones).
> 
> IMO even the format setting ioctls could be nice since the possible
> input and output formats of the subdevs should be enumerable, too.
> 
> ENUM_FRAMESIZES and ENUM_FRAMEINTERVALS are missing the v4l2_buf_type,
> but there are reserved fields...

Those two ioctls are still marked as experimental. Does that mean we could 
change them in an ABI incompatible way ?

-- 
Laurent Pinchart
