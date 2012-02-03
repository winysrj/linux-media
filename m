Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4732 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab2BCKGO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 05:06:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFCv1 PATCH 0/6] Improved/New timings API
Date: Fri,  3 Feb 2012 11:06:00 +0100
Message-Id: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

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

