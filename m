Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38897 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbbCUIle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2015 04:41:34 -0400
Message-ID: <550D2EB9.5090806@xs4all.nl>
Date: Sat, 21 Mar 2015 09:41:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC] Querycap for subdevs, finding MC from device nodes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been thinking about extending v4l2-compliance with v4l-subdev tests.

However, there are a few missing pieces that are needed before this can be done.

First of all is that there is no subdev equivalent to VIDIOC_QUERYCAP, i.e. an
ioctl that is guaranteed to always be available.

So I propose the following ioctl:

VIDIOC_SUBDEV_QUERYCAP(struct v4l2_subdev_capability);

struct v4l2_subdev_capability {
	char name[V4L2_SUBDEV_NAME_SIZE];
	__u32 version;			// same as KERNEL_VERSION like QUERYCAP does
	__u32 device_caps;
	__u32 pads;
	__u32 entity_id;
	__u32 reserved[40];
};

/* This v4l2_subdev is also a media entity and the entity_id field is valid */
#define V4L2_SUBDEV_CAP_ENTITY		(1 << 0)

This will allow v4l2-compliance to discover that this is a bona fide v4l2 subdevice.
All the information in the struct above can be filled in by v4l2-subdev.c, no need
to change drivers.

The reason I included 'pads' as well is that subdev drivers can have a devnode
without being an entity, but still support ioctls like VIDIOC_SUBDEV_ENUM_MBUS_CODE.
In that case v4l2-compliance needs to know the number of pads in order to properly
test. If it is an entity, then the entity information can be obtained from the MC,
see below how to find the MC.

Note: I think it makes sense to extend VIDIOC_QUERYCAP as well with a CAP_ENTITY
and an entity_id.

The next step is to be able to associate a media device with a v4l2-subdev.

Originally I though of adding the major and minor numbers of the media device
to the capability struct, but I'd like to do that for VIDIOC_QUERYCAP as well,
and there are only 3 reserved fields (2 after taking one for the entity_id).

Instead I think we can just implement the MEDIA_IOC_DEVICE_INFO ioctl: this
returns all info about the media_device, and it can easily be extended to
include the major and minor number of that device.

Again, supporting this is easily done in the core, both for regular video nodes
and for subdev nodes, so drivers do not need to be changed.

This way you can easily find whether a V4L2 device node is an entity and what
the associated media controller is. All the information is available, we just
need to expose it.

Comments?

Regards,

	Hans
