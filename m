Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:63561 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab2AKOEI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 09:04:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.3] Make tuner 'type' check more strict for S_FREQUENCY
Date: Wed, 11 Jan 2012 15:04:03 +0100
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111504.03358.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is another patch series that's been on hold for some time.

The pull request is for 3.3 but it's low prio, so if you prefer to do this
for 3.4 then that's no problem.

Regards,

	Hans

The following changes since commit 240ab508aa9fb7a294b0ecb563b19ead000b2463:

  [media] [PATCH] don't reset the delivery system on DTV_CLEAR (2012-01-10 23:44:07 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git ivtvcx18

Hans Verkuil (5):
      v4l2-ioctl: make tuner 'type' check more strict for S_FREQUENCY.
      ivtv: remove exclusive radio open.
      cx18: remove exclusive open of radio device.
      ivtv: switch to the v4l core lock.
      ivtv: remove open_id/id from the filehandle code.

 .../DocBook/media/v4l/vidioc-g-frequency.xml       |    7 +-
 Documentation/feature-removal-schedule.txt         |   11 --
 drivers/media/video/cx18/cx18-fileops.c            |   41 +++-----
 drivers/media/video/ivtv/ivtv-driver.c             |    3 -
 drivers/media/video/ivtv/ivtv-driver.h             |    3 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |  118 +++++++------------
 drivers/media/video/ivtv/ivtv-ioctl.c              |   22 +---
 drivers/media/video/ivtv/ivtv-irq.c                |    4 +-
 drivers/media/video/ivtv/ivtv-streams.c            |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c                |   22 +++-
 drivers/media/video/v4l2-ioctl.c                   |    8 +-
 11 files changed, 98 insertions(+), 143 deletions(-)
