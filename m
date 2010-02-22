Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17486 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0BVPvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 10:51:43 -0500
Message-ID: <4B82A7FB.50505@maxwell.research.nokia.com>
Date: Mon, 22 Feb 2010 17:51:23 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: [PATCH v6 0/6] V4L2 file handles and event interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the eighth version of the V4L2 file handle and event interface
patchset.

The patchset has been tested with the OMAP 3 ISP driver. Patches for
OMAP 3 ISP are not part of this patchset but are available in Gitorious
(branch is called event):

	git://gitorious.org/omap3camera/mainline.git event

The patchset I'm posting now is against the v4l-dvb tree instead of
linux-omap. The omap3camera tree thus has a slightly different
version of these patches due to different baselines.

Some more comments from Hans and Laurent. What has changed:

- Improved documentation.
- V4L2_EVENT_ALL only valid in unsubscribing.
- Events are initialised in v4l2_fh_init() if
video_device->ioctl_ops->vidioc_subscribe_event is defined.
- Event ioctl handlers are called in __video_do_ioctl() iff
video_device->ioctl_ops->vidioc_subscribe_event is defined, no other
constraints.
- Blocking operation for VIDIOC_DQEVENT.
- v4l2_event_subscribe_many() is gone.
- Fixed memory leak in v4l2_event_subscribe()

Comments are welcome as always.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

