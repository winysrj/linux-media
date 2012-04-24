Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:39875 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2DXNsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 09:48:10 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFCv3 PATCH 0/6] Improved/New timings API
Date: Tue, 24 Apr 2012 15:47:59 +0200
Message-Id: <1335275285-13333-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the third version of this RFC. The first can be found here:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/44285

The second was never posted.

Changes since RFCv1:

Incorporated comments from Mauro:

- Renamed V4L2_DV_FL_NTSC_COMPATIBLE to V4L2_DV_FL_CAN_REDUCE_FPS
- Renamed V4L2_DV_FL_DIVIDE_CLOCK_BY_1_001 to V4L2_DV_FL_REDUCED_FPS
- Use kernel-doc-nano comments
- Added a feature-removal document for the invalid DV presets

Others:

- I removed the patch adding format matching functions to v4l2-common.c.
  That's postponed until there is a driver that actually needs it.

If there are no more comments, then this can be merged for v3.5. Once that's
done I'll work on adding support for this to drivers that use the preset
API so that we can deprecate and eventually remove the preset API.


The text of the original RFCv1 follows:

------------------------------------------------------------------------

This is an implementation of this RFC:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg38168.html

The goal is that with these additions the existing DV_PRESET API can be
removed eventually. It's always painful to admit, but that wasn't the best
API ever :-)

To my dismay I discovered that some of the preset defines were even impossible:
there are no interlaced 1920x1080i25/29.97/30 formats.

I have been testing this new code with the adv7604 HDMI receiver as used here:

http://git.linuxtv.org/hverkuil/cisco.git/shortlog/refs/heads/test-timings

This is my development/test branch, so the code is a bit messy.

One problem that I always had with the older proposals is that there was no
easy way to just select a specific standard (e.g. 720p60). By creating the
linux/v4l2-dv-timings.h header this is now very easy to do, both for drivers
and applications.

I also took special care on how to distinguish between e.g. 720p60 and 720p59.94.
See the documentation for more information.

Note that the QUERY_DV_TIMINGS and DV_TIMINGS_CAP ioctls will be marked
experimental. Particularly the latter ioctl might well change in the future as
I do not have enough experience to tell whether DV_TIMINGS_CAP is sufficiently
detailed.

I would like to get some feedback on this approach, just to make sure I don't
need to start over.

In the meantime I will be working on code to detect CVT and GTF video timings
since that is needed to verify that that part works correctly as well.

And once everyone agrees to the API, then I will try and add this API to all
drivers that currently use the preset API. That way there will be a decent
path forward to eventually remove the preset API (sooner rather than later
IMHO).

Regards,

        Hans

