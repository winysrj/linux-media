Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30897 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0BJO6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 09:58:20 -0500
Message-ID: <4B72C965.7040204@maxwell.research.nokia.com>
Date: Wed, 10 Feb 2010 16:57:41 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: [PATCH v4 0/7] V4L2 file handles and event interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the sixth version of the V4L2 file handle and event interface
patchset.

The first patch adds the V4L2 file handle support and the rest are for
V4L2 events.

The patchset has been tested with the OMAP 3 ISP driver. Patches for
OMAP 3 ISP are not part of this patchset but are available in Gitorious
(branch is called event):

	git://gitorious.org/omap3camera/mainline.git event

Some more comments from Hans. What has changed:

- Events are timestamped in v4l2_event_queue().
- No ioctl handler for vidioc_dqevent or vidioc_unsubscribe_event
anymore. The __video_do_ioctl() calls directly v4l2_event_dequeue() and
v4l2_event_unsubscribe().
- v4l2_event->navailable and v4l2_event->max_alloc (was max_events) are
now unsigned int instead of atomic_t. They are modified only when the
video_device->fh_lock is held.
- No longer possible to allocate any more events than the limit in
v4l2_event_alloc().

- Possibly something else I don't happen to remember just now.

Comments are welcome as always.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

