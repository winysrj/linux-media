Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42590 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932594AbdKPAdv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 19:33:51 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC 0/2] V4L2: Handle the race condition between device access and unbind
Date: Thu, 16 Nov 2017 02:33:47 +0200
Message-Id: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This small RFC is an attempt to handle the race condition that exists between
device access and device unbind.

Devices can be unbound from drivers in three different ways:

- When the driver module is unloaded, the driver is unregistered and unbound
  from all devices it was bound to. As module unloading can't happen as long
  as the module reference count is not zero, no concurrent access to the
  device from userspace access can be ongoing. This patch series isn't needed
  to address this case.

- When the device is removed either physically (for instance with USB or
  hotpluggable PCI) or logically (for instance by unloading a DT overlay), the
  device is unbound from its driver.

- When userspace initiates a manual unbind through the driver sysfs unbind
  file the device is also unbound from its driver.

The last two cases can occur at any time and are not synchronized with device
access from userspace through video device nodes. This is the race that the
patch series tries to address.

Drivers need to ensure that no access to internal resources can occur before
freeing those resources in the unbind handler. To do so, we need to both block
all new accesses to device resources, and wait for all ongoing accesses to
complete before freeing resources.

This series achieves this by marking code sections that access device
resources with the new video_device_enter() and video_device_exit() functions.
The function internally keep a count of the number of such sections currently
being executed in order to delay device unbind. Driver must call the
video_device_unplug() function in their unbind handler before cleaning up any
resource that can be accessed through the function marked with enter/exit. The
video_device_unplug() function marks the device is being unbound, preventing
subsequent calls to video_device_enter() from succeeding, and then waits for
all device access code sections to be exited before returning.

Several issues haven't been addressed yet, hence the RFC status of the series:

- Only the video_device ioctl handler is currently protected by
  video_device_enter() and video_device_exit(). This needs to be extended to
  other file operations.

- Blocking operations (such a VIDIOC_DQBUF for instance) need to be unblocked
  at unbind time. Whether this can be handled entirely inside
  video_device_unplug() needs to be researched.

- While the above mechanism should be usable for subdevs too as the
  v4l2_subdev structure contains a video_device structure, the subdev
  .release() file operation handler subdev_close() accesses the v4l2_subdev
  structure, which is currently freed by drivers at unbind time due to the
  lack of a structure release operation in the v4l2_subdev structure. Fixing
  this will likely require major refactoring of the subdev registration API,
  which might not be considered worth it as the long term goal is to replace
  subdev device nodes with the request API anyway.

I would like to receive feedback on this initial version, and will then work
on a second version that addresses at least the first two problems listed
above.

Laurent Pinchart (2):
  v4l: v4l2-dev: Add infrastructure to protect device unplug race
  v4l: rcar-vin: Wait for device access to complete before unplugging

 drivers/media/platform/rcar-vin/rcar-core.c |  1 +
 drivers/media/v4l2-core/v4l2-dev.c          | 57 +++++++++++++++++++++++++++++
 include/media/v4l2-dev.h                    | 47 ++++++++++++++++++++++++
 3 files changed, 105 insertions(+)

-- 
Regards,

Laurent Pinchart
