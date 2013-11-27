Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1045 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3K0KVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 05:21:39 -0500
Message-ID: <5295C755.3090904@xs4all.nl>
Date: Wed, 27 Nov 2013 11:20:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Valentine Barshak <valentine.barshak@cogentembedded.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: RFC: add FMT_CHANGE event and VIDIOC_G/S_EDID ioctls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC addresses some HDTV-related features that are missing in the API.
The reason they were missing is that there were no bridge drivers in the
kernel that needed them, but with the work done on soc_camera + adv7611/2
by Valentine this is now really needed.

The two missing pieces are how to inform the user that the format of an
input has changed, and how to get/set the EDID for simple pipelines
(i.e. one video node maps to one video receiver sub-device).

How does it work today: the subdev driver sends out a notification to
the bridge driver using v4l2_subdev_notify and a driver-specific notification
ID (see e.g. include/media/adv7604.h, ADV7604_FMT_CHANGE). This notification
needs to be standardized if this is to work for generic drivers like soc-camera.

When the bridge driver is notified it will pass it on as an event to the
application. This event needs to be standardized as well.

Note: there is also a notification if the hotplug pin needs to be pulled
up or down. Some receivers don't do that themselves, but rely on the
SoC to do that for them (usually through a gpio pin). The notification
for that should be standardized as well.

One question regarding the FMT_CHANGE event is if it should contain a
payload such as whether there is a video signal or not. Currently there
is no payload. I do not think a payload is useful. You do not know when
the application will finally dequeue the event, so any data you pass in
as payload might well be out of date. It is better to let the application
read the latest status directly.

The other issue is with setting and getting the EDID. There is an API to
set this through the v4l-subdev device node, which works fine, but it
is a hassle if you have just a simple pipeline and you want to avoid
having to open a v4l-subdev node just for the EDID. If you have a simple
pipeline, then it is unambiguous for which sub-device you set the EDID.

My proposal is the following:

Add two standard notifications to media/v4l2-subdev.h:

#define V4L2_SUBDEV_NOTIFY_HOTPLUG         _IO('v', 0)
#define V4L2_SUBDEV_NOTIFY_FMT_CHANGE      _IO('v', 1)

and switch adv7604 and adv7842 to use those new notifications.

Add a new event in videodev2.h:

#define V4L2_EVENT_FMT_CHANGE			5

and document it. When sent, the application should call QUERYSTD or
QUERY_DV_TIMINGS to find out the new format that is received.

For the EDID handling I propose to move the struct v4l2_subdev_edid
and VIDIOC_SUBDEV_G/S_EDID ioctl defines from v4l2-subdev.h to videodev2.h
and rename them to struct v4l2_edid and VIDIOC_G/S_EDID. The contents
remains the same, just the names change.

Currently there are no bridge drivers in the kernel that use these
ioctls, so I personally have no problem renaming it. It is possible
to add "#define v4l2_subdev_edid v4l2_edid" to v4l2-subdev.h (and
ditto for the ioctls) to, for the time being, keep backwards
compatibility. You can use the VIDIOC_G/S_EDID either through the
v4l-subdevX nodes or through the videoX nodes.

These additions would make it quite easy to support HDTV in soc-camera
and other bridge drivers in a standardized manner.

Regards,

	Hans
