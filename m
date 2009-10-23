Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:41359 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZJWOZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 10:25:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [RFC] Restructure video_device
Date: Fri, 23 Oct 2009 16:25:40 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910231625.40822.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

while working on device node support for subdevs I ran into an issue with the 
way v4l2 objects are structured.

We currently have the following structure:

- video_device represents a device that complies with the V4L1 or V4L2 API. 
Every video_device has a corresponding device node.

- v4l2_device represents a high-level media device that handles sub-devices. 
With the new media controller infrastructure a v4l2_device will have a device 
node as well.

- v4l2_subdev represents a sub-device. As for v4l2_device's, the new media 
controller infrastructure will give a device node for every sub-device.

- v4l2_entity is the structure that both v4l2_subdev and video_device derive 
from. Most of the media controller code will deal with entities rather than 
sub-devices or video devices, as most operations (such as discovering the 
topology and create links) do not depend on the exact nature of the entity. 
New types of entities could be introduced later.

Both the video_device and v4l2_subdev structure inherit from v4l2_entity, so 
both of them have a v4l2_entity field. With v4l2_device and v4l2_subdev now 
needing to devices to have device nodes created, the v4l2_device and 
v4l2_subdev structure both have a video_device field.

This isn't clean for two reasons:

- v4l2_device isn't a v4l2_entity, so it should inherit from a structure 
(video_device) that itself inherits from v4l2_entity. 

- v4l2_subdev shouldn't inherit twice from v4l2_entity, once directly and once 
through video_device.

To fix this I would like to refactor the video_device structure and cut it in 
two pieces. One of them will deal with device node related tasks, being mostly 
V4L1/V4L2 agnostic, and the other will inherit from the first and add 
V4L1/V4L2 support (tvnorms/current_norm/ioctl_ops fields from the current 
video_device structure), as well as media controller support (inheriting from 
v4l2_entity).

My plan was to create a video_devnode structure for the low-level device node 
related structure, and keeping the video_device name for the higher level 
structure. v4l2_device, v4l2_subdev and video_device would then all have a 
video_devnode field.

While this isn't exactly difficult, it would require changing a lot of 
drivers, as some field will be moved from video_device to 
video_device::video_devnode. Some of those fields are internal, some of them 
are accessed by drivers while they shouldn't in most cases (the minor field 
for instance), and some are public (name, parent).

I would like to have your opinion on whether you think this proposal is 
acceptable or whether you see a better and cleaner way to restructure the 
video device code structures.

-- 
Regards,

Laurent Pinchart
