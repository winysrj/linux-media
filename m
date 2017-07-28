Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44012 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751633AbdG1NZd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 09:25:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [RFCv2 PATCH 0/2] add VIDIOC_SUBDEV_QUERYCAP ioctl
Date: Fri, 28 Jul 2017 16:25:43 +0300
Message-ID: <1925879.q3PoFGT7lz@avalon>
In-Reply-To: <20170728110529.4057-1-hverkuil@xs4all.nl>
References: <20170728110529.4057-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patches.

On Friday 28 Jul 2017 13:05:27 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I tried to get this in back in 2015, but that effort stalled.
> 
> Trying again, since I really need this in order to add proper v4l-subdev
> support to v4l2-ctl and v4l2-compliance. There currently is no way of
> unique identifying that the device really is a v4l-subdev device other
> than the device name (which can be changed by udev).
> 
> So this patch series adds a VIDIOC_SUBDEV_QUERYCAP ioctl that is in
> the core so it's guaranteed to be there.
> 
> If the subdev is part of an MC then it also gives the corresponding
> entity ID of the subdev and the major/minor numbers of the MC device
> so v4l2-compliance can relate the subdev device directly to the right
> MC device. The reserved array has room enough for more strings should
> we need them later, although I think what we have here is sufficient.

I still think this is not correct for two reasons.

First of all, the new querycap ioctl uses the same ioctl number as 
VIDIOC_QUERYCAP. The full 32-bit number is different as the structures used 
for the two ioctls currently have different sizes, but that's not guaranteed 
going forward when we'll extend the structures used by the two ioctls with new 
fields.

To solve this, if you really want to identify the type of device node at 
runtime, we should have a single ioctl supported by the two device nodes. 
Given that we"re running out of capabilities bits for VIDIOC_QUERYCAP, this 
could be a good occasion to introduce a new ioctl to query capabilities.

The second reason is that I don't think we should report the media device node 
associated with the subdev. Userspace really needs to become MC-centric, 
starting with the MC device, and going to the video nodes and subdev nodes. 
The other way around just doesn't make sense to me.

For MC-enabled devices, specifying subdev or video nodes by /dev node name is 
painful. When you have multiple video devices on the system, or even when 
you're modifying initialization order in a driver, the devnode names will not 
be stable across boots. I used to type them out manually in the very beginning 
and very quickly switched to retrieving them from the subdev entity name in my 
test scripts.

What I'd like the compliance tools to do is to test all video nodes and subdev 
nodes for a given MC device, with an option to restrict the tests to a subset 
of the video devices and subdevs specified by media entity name. We obviously 
need to keep support for addressing video nodes manually as not all devices 
are MC-enabled, but for subdev we don't have to care about such a backward 
compatibility issue as there's currently no compliance tool.

On a side note, I believe subdev nodes should depend on MC. It has been a 
historical mistake not to do so, and as far as I can see only three drivers 
register subdev nodes without registering a media device. They should be fixed 
if they want to benefit from the compliance tool.

> Changes since v1:
> - Add name field. Without that it is hard to figure out which subdev
>   it is since the entity ID is not very human readable.
> 
> Hans Verkuil (2):
>   v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
>   v4l: document VIDIOC_SUBDEV_QUERYCAP
> 
>  Documentation/media/uapi/v4l/user-func.rst         |   1 +
>  .../media/uapi/v4l/vidioc-subdev-querycap.rst      | 121 +++++++++++++++++
>  drivers/media/v4l2-core/v4l2-subdev.c              |  27 +++++
>  include/uapi/linux/v4l2-subdev.h                   |  31 ++++++
>  4 files changed, 180 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-querycap.rst

-- 
Regards,

Laurent Pinchart
