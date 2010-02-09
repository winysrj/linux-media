Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22909 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0BIS1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 13:27:03 -0500
Message-ID: <4B71A8DF.8070907@maxwell.research.nokia.com>
Date: Tue, 09 Feb 2010 20:26:39 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: [PATCH v3 0/7] V4L2 file handles and event interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the fifth version of the V4L2 file handle and event interface
patchset.

The first patch adds the V4L2 file handle support and the rest are for
V4L2 events.

The patchset has been tested with the OMAP 3 ISP driver. Patches for
OMAP 3 ISP are not part of this patchset but are available in Gitorious
(branch is called event):

	git://gitorious.org/omap3camera/mainline.git event

So, for this patchset I've baked in comments from Hans. What has changed:

- v4l2_fh_init -> v4l2_fhs_init
- v4l2_fh_add has been split to v4l2_fh_init and v4l2_fh_add. Similarly
for del/exit.
- Forward declaration for struct v4l2_event in v4l2_fh.h
- No more struct v4l2_fhs. The fields are directly in struct
video_device now.
- v4l2_event_alloc now returns an error code if it fails for some reason.
- The number of maximum events allocatable by the driver is now limited
by events->max_events.

- Possibly something else I don't happen to remember just now.

Comments are welcome as always.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

