Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18221 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab0BSTVg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 14:21:36 -0500
Message-ID: <4B7EE4A4.3080202@maxwell.research.nokia.com>
Date: Fri, 19 Feb 2010 21:21:08 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: [PATCH v5 0/6] V4L2 file handles and event interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the seventh version of the V4L2 file handle and event interface
patchset.

The patchset has been tested with the OMAP 3 ISP driver. Patches for
OMAP 3 ISP are not part of this patchset but are available in Gitorious
(branch is called event):

	git://gitorious.org/omap3camera/mainline.git event

The patchset I'm posting now is against the v4l-dvb tree instead of
linux-omap (ouch!). The omap3camera tree thus has a slightly different
version of these patches.

Some more comments from Hans and Laurent. What has changed:

- Documentation for both file handles and events.
- Sequence number and event queue length patches have been combined with
the events backend patch.
- Only VIDIOC_DQEVENT is now unconditionally handled by V4L2 without
driver's involvement.
- __video_do_ioctl() checks that events have been initialised when
handling event ioctls.
- There is a chance of being able to allocate a few more events to an
event queue than intended. This is unlikely to be anyhow harmful, however.
- v4l2_event_subscribe_all() is now v4l2_event_subscribe_many().
- V4L2_FL_USES_V4L2_FH is set on video_device.flags in v4l2_fh_init()
when the driver initialises the first file handle.

- Possibly something else I don't happen to remember just now.

Comments are welcome as always.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

