Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51351 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbZJTVjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 17:39:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: Why doesn't video_ioctl2 reuse video_usercopy ?
Date: Tue, 20 Oct 2009 23:39:23 +0200
Cc: linux-media@vger.kernel.org
References: <200910201617.25206.laurent.pinchart@ideasonboard.com> <bed24489d25a4039aa189d8f10e97a05.squirrel@webmail.xs4all.nl>
In-Reply-To: <bed24489d25a4039aa189d8f10e97a05.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910202339.23725.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 20 October 2009 23:09:56 Hans Verkuil wrote:
> > Hi everybody,
> >
> > while working on subdevs device node implementation noticed that
> > video_ioctl2 doesn't use video_usercopy but has its own (slightly
> > modified) copy of the code. As I need to perform a similar operation for
> > subdevs ioctls I was wondering if we could have a single video_usercopy
> > implementation that could be used by both video_ioctl2 and the subdevs
> > ioctl handler.
> 
> The idea was that video_usercopy would eventually be completely replaced
> by video_ioctl2. However, for the subdevs ioctls video_ioctl2 might be
> less suitable and we may want to keep video_usercopy.
> 
> An alternative solution is to use video_ioctl2 for subdev ioctls as well.
> In that case any private subdev ioctls would end up in the default ioctl
> handler. This is actually quite an interesting solution since I'm sure
> some of the subdev ioctls will be identical to the 'regular' ioctls (this
> will certainly be the case for the v4l2 control ioctls).

I've thought about it but I'm not sure if that's a good approach. For one 
thing all the v4l2_ioctl_ops callback functions will just be wrappers around 
subdev operations. Furthermore, while many ioctls will be shared with V4L2, 
the default ioctl handler will probably grow quite big soon.

We also have a very good opportunity with the subdev ioctls to force 
applications to set all reserved fields to zero. We might want to explicitly 
check that in the subdev ioctls handler.
 
> The problem is that that will saddle each subdev driver with this huge
> struct. One solution for that might be to split up this big struct into a
> bunch of smaller ones in exactly the same way that I did for the
> v4l2_subdev ops.

That's a useful optimization for v4l2 drivers as well, but we will still have 
a bunch of mostly empty callback functions that just act as wrappers around 
the subdev operations.

> For this initial prototyping I would suggest that you use video_ioctl2 for
> the time being. The additional functionality that is has over
> video_usercopy makes it the best choice and the overhead in the size of
> the struct isn't an issue while prototyping and can be fixed later.

I've already started using video_usercopy so I'll keep the code as-is and I'll 
change it later if required (this is playground code, so nothing set into 
stone).

DVB has its own implementation of video_usercopy in order not to depend on 
videodev.ko. For the future I was thinking about moving video_usercopy to some 
kind of mediadev.ko and use it for the v4l2, dvb and subdev ioctls handlers. 
Splitting v4l2_ioctl_ops into several structures like done for the subdevs 
also needs to be done.

This goes in the direction of a videodev refactoring that will be needed 
sometimes. The code is getting a bit messy with the introduction of the media 
controller (think about v4l2_subdev that inherits from v4l2_entity that has a 
video_device field that, in turn inherits from v4l2_entity...). We should at 
some point split videodev into a generic media framework (media controller + 
entities, generic media nodes, ...) and a video framework (video devices). Not 
a very complex job, but it might touch lots of drivers (in an easily testable 
way fortunately). I'm not sure at what point we should tackle that task.

-- 
Regards,

Laurent Pinchart
