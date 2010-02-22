Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43138 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab0BVXBg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:01:36 -0500
Message-ID: <4B830CCA.8030909@maxwell.research.nokia.com>
Date: Tue, 23 Feb 2010 01:01:30 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: [PATCH v7 0/6] V4L2 file handles and event interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the ninth version of the V4L2 file handle and event interface
patchset.

The patchset has been tested with the OMAP 3 ISP driver. Patches for
OMAP 3 ISP are not part of this patchset but are available in Gitorious
(branch is called event):

	git://gitorious.org/omap3camera/mainline.git event

The patchset I'm posting now is against the v4l-dvb tree instead of
linux-omap. The omap3camera tree thus has a slightly different
version of these patches due to different baselines.

Some more comments from Hans and Sergio. What has changed:

- Proper ioctl numbers!
- v4l2_fh_init() may now fail as v4l2_event_init() may also.
- Fixed copyright years.
- Fixed file names in file headings.
- Removed WARN_ON() in v4l2_event_init(). This function is only called
from v4l2_fh_init() and it also initialises the field related to WARN_ON().
- Documentation fixes suggested by Hans.

Comments are welcome as always.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

