Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:61674 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbcEDLYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 07:24:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [PATCH v2 0/5] Refactor media IOCTL handling, add variable length arguments
Date: Wed,  4 May 2016 14:20:50 +0300
Message-Id: <1462360855-23354-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

I've updated my patchset for refactoring the media device IOCTL handling.

The original set is here:

<URL:http://www.spinics.net/lists/linux-media/msg100041.html>

The patches themselves have been reworked so I don't detail the changes
in this set. What's noteworthy however is that the set adds support for
variable length IOCTL arguments.

The patches have been tested on x86_64 and ARM and compat code has been
tested on x86_64. The variable length argument support (in case a struct
grows due to added fields) has been tested, including returning
-ENOIOCTLCMD on bad argument length, on x86_64 with the request API
patches I'll post in the near future.

(The motivation for these patches is having found myself pondering whether
to have nine or thirteen reserved fields for the request IOCTL. I decided
to address the problem instead. If this is found workable on the media
controller we could follow the same model on V4L2.)

Reviews would be very welcome.

-- 
Kind regards,
Sakari

