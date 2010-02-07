Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41827 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab0BGSjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 13:39:39 -0500
Message-ID: <4B6F0922.9070206@maxwell.research.nokia.com>
Date: Sun, 07 Feb 2010 20:40:34 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: [PATCH v2 0/7] V4L2 file handles and event interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the fourth version of the V4L2 file handle and event interface
patchset.

The first patch adds the V4L2 file handle support and the rest are for
V4L2 events.

The patchset has been tested with the OMAP 3 ISP driver. Patches for
OMAP 3 ISP are not part of this patchset but are available in Gitorious
(branch is called event):

	git://gitorious.org/omap3camera/mainline.git event

What's changed since the last set is that Hans' comments have been
factored in. The locking is more simple; there's just one lock in
v4l2_fhs. Also the reference counting has been removed. struct v4l2_fh
has pointer to struct video_device. Freeing up the events has been
compacted.

Comments are welcome as always.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

