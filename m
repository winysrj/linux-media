Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49464 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbbDQPHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2015 11:07:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] Querycap for subdevs, finding MC from device nodes
Date: Fri, 17 Apr 2015 18:07:22 +0300
Message-ID: <1768917.5uFxr7arIJ@avalon>
In-Reply-To: <550D2EB9.5090806@xs4all.nl>
References: <550D2EB9.5090806@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Saturday 21 March 2015 09:41:29 Hans Verkuil wrote:
> I've been thinking about extending v4l2-compliance with v4l-subdev tests.
> 
> However, there are a few missing pieces that are needed before this can be
> done.
> 
> First of all is that there is no subdev equivalent to VIDIOC_QUERYCAP, i.e.
> an ioctl that is guaranteed to always be available.
> 
> So I propose the following ioctl:
> 
> VIDIOC_SUBDEV_QUERYCAP(struct v4l2_subdev_capability);
> 
> struct v4l2_subdev_capability {
> 	char name[V4L2_SUBDEV_NAME_SIZE];
> 	__u32 version;			// same as KERNEL_VERSION like QUERYCAP does
> 	__u32 device_caps;
> 	__u32 pads;
> 	__u32 entity_id;
> 	__u32 reserved[40];
> };
> 
> /* This v4l2_subdev is also a media entity and the entity_id field is valid
> */ #define V4L2_SUBDEV_CAP_ENTITY		(1 << 0)
> 
> This will allow v4l2-compliance to discover that this is a bona fide v4l2
> subdevice. All the information in the struct above can be filled in by
> v4l2-subdev.c, no need to change drivers.

This looks quite good to me. There's a prerequisite though, we need to 
formally define the naming scheme for subdevs, otherwise we'll expose yet 
another ill-defined name that will cause issues later.

> The reason I included 'pads' as well is that subdev drivers can have a
> devnode without being an entity, but still support ioctls like
> VIDIOC_SUBDEV_ENUM_MBUS_CODE. In that case v4l2-compliance needs to know
> the number of pads in order to properly test. If it is an entity, then the
> entity information can be obtained from the MC, see below how to find the
> MC.

Shouldn't we make it mandatory for subdevs to be entities if they want to 
expose a subdev node ? Otherwise applications won't be able to find out how 
the subdev relates to other subdevs and v4l2 devices, making the API quite 
shaky in my opinion.

> Note: I think it makes sense to extend VIDIOC_QUERYCAP as well with a
> CAP_ENTITY and an entity_id.
> 
> The next step is to be able to associate a media device with a v4l2-subdev.
> 
> Originally I though of adding the major and minor numbers of the media
> device to the capability struct, but I'd like to do that for
> VIDIOC_QUERYCAP as well, and there are only 3 reserved fields (2 after
> taking one for the entity_id).
> 
> Instead I think we can just implement the MEDIA_IOC_DEVICE_INFO ioctl: this
> returns all info about the media_device, and it can easily be extended to
> include the major and minor number of that device.

Hmmm... I'm not too found of that approach. Can't userspace find the 
corresponding media device through sysfs ? I'd like to point that the common 
use case is to start from the media device and find the entities. Finding the 
media device from a subdev is useful mostly for test tools, but it's not the 
main use case.

> Again, supporting this is easily done in the core, both for regular video
> nodes and for subdev nodes, so drivers do not need to be changed.
> 
> This way you can easily find whether a V4L2 device node is an entity and
> what the associated media controller is. All the information is available,
> we just need to expose it.
> 
> Comments?

Please see above :-)

-- 
Regards,

Laurent Pinchart

