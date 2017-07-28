Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44102 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbdG1O2l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 10:28:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [RFCv2 PATCH 0/2] add VIDIOC_SUBDEV_QUERYCAP ioctl
Date: Fri, 28 Jul 2017 17:28:51 +0300
Message-ID: <5652381.J6V3Mkh0f4@avalon>
In-Reply-To: <625cbe4e-7ebd-c995-b4f3-4e1bf892aac9@xs4all.nl>
References: <20170728110529.4057-1-hverkuil@xs4all.nl> <1925879.q3PoFGT7lz@avalon> <625cbe4e-7ebd-c995-b4f3-4e1bf892aac9@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 28 Jul 2017 16:04:48 Hans Verkuil wrote:
> On 07/28/2017 03:25 PM, Laurent Pinchart wrote:
> > On Friday 28 Jul 2017 13:05:27 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> I tried to get this in back in 2015, but that effort stalled.
> >> 
> >> Trying again, since I really need this in order to add proper v4l-subdev
> >> support to v4l2-ctl and v4l2-compliance. There currently is no way of
> >> unique identifying that the device really is a v4l-subdev device other
> >> than the device name (which can be changed by udev).
> >> 
> >> So this patch series adds a VIDIOC_SUBDEV_QUERYCAP ioctl that is in
> >> the core so it's guaranteed to be there.
> >> 
> >> If the subdev is part of an MC then it also gives the corresponding
> >> entity ID of the subdev and the major/minor numbers of the MC device
> >> so v4l2-compliance can relate the subdev device directly to the right
> >> MC device. The reserved array has room enough for more strings should
> >> we need them later, although I think what we have here is sufficient.
> > 
> > I still think this is not correct for two reasons.
> > 
> > First of all, the new querycap ioctl uses the same ioctl number as
> > VIDIOC_QUERYCAP. The full 32-bit number is different as the structures
> > used for the two ioctls currently have different sizes, but that's not
> > guaranteed going forward when we'll extend the structures used by the two
> > ioctls with new fields.
> 
> I think it is extraordinarily unlikely that these two will ever become
> identical. And anyway, we control that ourselves.
> 
> > To solve this, if you really want to identify the type of device node at
> > runtime, we should have a single ioctl supported by the two device nodes.
> > Given that we"re running out of capabilities bits for VIDIOC_QUERYCAP,
> > this could be a good occasion to introduce a new ioctl to query
> > capabilities.
> 
> This makes more sense :-)
> 
> > The second reason is that I don't think we should report the media device
> > node associated with the subdev. Userspace really needs to become
> > MC-centric, starting with the MC device, and going to the video nodes and
> > subdev nodes. The other way around just doesn't make sense to me.
> 
> It's not for 'regular' applications. It's to easily find out to which media
> device a /dev/v4l-subdevX belongs. Primarily for applications like
> v4l2-compliance.
> 
> We have the information, and right now there is no way to take a v4l-subdevX
> device and determine of which media device it is part other than scanning
> the topologies of all media devices. That's nuts. This is cheap and makes
> life for a certain class of applications much easier. Creating good
> compliance tests is critical and this is a small but important contribution
> to that.

I fully agree with the need for compliance tools, but I believe they should go 
from MC to subdev, not the other way around. Let's discuss this below.

> > For MC-enabled devices, specifying subdev or video nodes by /dev node name
> > is painful. When you have multiple video devices on the system, or even
> > when you're modifying initialization order in a driver, the devnode names
> > will not be stable across boots. I used to type them out manually in the
> > very beginning and very quickly switched to retrieving them from the
> > subdev entity name in my test scripts.
> > 
> > What I'd like the compliance tools to do is to test all video nodes and
> > subdev nodes for a given MC device, with an option to restrict the tests
> > to a subset of the video devices and subdevs specified by media entity
> > name. We obviously need to keep support for addressing video nodes
> > manually as not all devices are MC-enabled, but for subdev we don't have
> > to care about such a backward compatibility issue as there's currently no
> > compliance tool.
> 
> I want two things:
> 
> 1) v4l2-compliance to be able to test a v4l-subdevX, just in isolation. And
> to be able to find the corresponding media device and make sure that what
> the v4l-subdev does is compatible with the entity/link information from the
> MC.

Why do you want to test /dev/v4l-subdev$(random) instead of /dev/mediaX + 
"subdev entity name" ?

Furthermore, if you want to test a subdev in complete isolation, why do you 
need to know which media device it belongs to ?

By the way, I'd like Sakari to join the discussion, but he won't be back 
before the end of next week.

> 2) make a media-compliance to look at the media topology as a whole.
> 
> Having the major/minor numbers are specifically for 1.
> 
> Actually, I really want to have the major/minor numbers of the media device
> for /dev/videoX as well, but entity ID +  major + minor number would use up
> the available space in struct v4l2_capability, so your suggestion of making
> a new VIDIOC_EXT_QUERYCAP has merit.
> 
> > On a side note, I believe subdev nodes should depend on MC. It has been a
> > historical mistake not to do so, and as far as I can see only three
> > drivers register subdev nodes without registering a media device. They
> > should be fixed if they want to benefit from the compliance tool.
> 
> Which ones?

atmel-isc, cobalt and rcar_drif.

> I'm not opposed to that. It would simplify matters quite a bit.
> 
> But I very, very strongly believe that a VIDIOC_EXT_QUERYCAP should return
> the corresponding entity ID and /dev/mediaX major and minor numbers. It's
> very useful information for a certain class of applications.

Do you have any application in mind other than the compliance tools ?

> Heck, I want to do 'v4l2-ctl -d /dev/video0 -D' or 'v4l2-ctl -d
> /dev/v4l-subdev0' and see not only the device capabilities, but also the
> corresponding entity information. Without having to scan through all
> /dev/media devices or requiring the user to pass the /dev/mediaX device
> separately.
> 
> This information is very cheap and I see no reason whatsoever not to
> implement this. It also feels much more symmetrical if I have what is
> effectively a backlink to the media device to which the subdev belongs.
> 
> And yes, normally applications will never need this since they use the media
> device and never reference a /dev/v4l-subdevX by name. But for v4l2-ctl and
> v4l2-compliance it is very useful indeed.

-- 
Regards,

Laurent Pinchart
