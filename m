Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:48582 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab2AKKBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 05:01:01 -0500
Received: from cobaltpc1.localnet (dhcp-10-54-92-32.cisco.com [10.54.92.32])
	by ams-core-1.cisco.com (8.14.3/8.14.3) with ESMTP id q0BA10jp030499
	for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 10:01:00 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.3] Add per-device-node capabilities
Date: Wed, 11 Jan 2012 11:00:57 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111100.57356.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is an updated version of RFCv3 (http://patchwork.linuxtv.org/patch/8834/)
of this patch series. No changes, other than some documentation modifications
to prevent a merge problem.

There have been no comments since RFCv3, so this is the official pull request.

I think it is fine to go into 3.3, but it's not a high prio thing, so if you
want to delay this to 3.4 then that's OK with me as well.

Regards,

	Hans

The following changes since commit 240ab508aa9fb7a294b0ecb563b19ead000b2463:

  [media] [PATCH] don't reset the delivery system on DTV_CLEAR (2012-01-10 23:44:07 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git capsv4

Hans Verkuil (3):
      V4L2: Add per-device-node capabilities
      vivi: set device_caps.
      ivtv: setup per-device caps.

 Documentation/DocBook/media/v4l/compat.xml         |    4 ++
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 ++++-
 .../DocBook/media/v4l/vidioc-querycap.xml          |   36 ++++++++++++++++++--
 drivers/media/video/cx231xx/cx231xx-417.c          |    1 -
 drivers/media/video/ivtv/ivtv-driver.h             |    1 +
 drivers/media/video/ivtv/ivtv-ioctl.c              |    7 +++-
 drivers/media/video/ivtv/ivtv-streams.c            |   14 ++++++++
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    1 -
 drivers/media/video/v4l2-ioctl.c                   |    6 ++-
 drivers/media/video/vivi.c                         |    5 ++-
 include/linux/videodev2.h                          |   29 +++++++++++-----
 11 files changed, 92 insertions(+), 21 deletions(-)
