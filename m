Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2252 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0LXNmw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 08:42:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Removal of V4L1 drivers
Date: Fri, 24 Dec 2010 14:42:39 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012241442.39702.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans, Mauro,

The se401, vicam, ibmcam and konicawc drivers are the only V4L1 drivers left in
2.6.37. The others are either converted or moved to staging (stradis and cpia),
ready to be removed.

Hans, what is the status of those four drivers? How likely is it that they will be
converted to V4L2?

If we can't convert them to V4L2 for 2.6.38, then we can at least remove the
V4L1_COMPAT code throughout the v4l drivers and move those four drivers to staging.

For 2.6.39 we either remove them or when they are converted to V4L2 they are moved
out of staging again (probably to gspca).

As an illustration I have removed the V4L1_COMPAT mode in this branch:

http://git.linuxtv.org/hverkuil/media_tree.git?a=shortlog;h=refs/heads/v4l1

There are two drivers that need more work: stk-webcam has some controls under sysfs
that are enabled when CONFIG_VIDEO_V4L1_COMPAT is set. These controls should be
rewritten as V4L2 controls. Hans, didn't you have hardware to test this driver?
I should be able to make a patch that you can test.

The other driver is the zoran driver which has a bunch of zoran-specific ioctls
under CONFIG_VIDEO_V4L1_COMPAT. I think I can just delete the lot since they are
all replaced by V4L2 counterparts AFAIK. But it would be good if someone else can
also take a look at that.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
