Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:60419 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2GKMVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 08:21:15 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q6BCLEiu011908
	for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 12:21:14 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.5] VIDIOC_DV_TIMINGS_CAP fixes
Date: Wed, 11 Jul 2012 14:21:02 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111421.02219.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

In 3.5 the VIDIOC_DV_TIMINGS_CAP doesn't work at the moment due to a missing line
in v4l2-dev.c. I hope this can still be fixed before 3.5 is released.

If not, then it has to go to stable. Luckily nobody is really using this ioctl at
the moment, which is why it wasn't noticed until I added test code for this ioctl
to v4l2-compliance.

Regards,

	Hans

The following changes since commit b7e386360922a15f943b2fbe8d77a19bb86f2e6f:

  media: Revert "[media] Terratec Cinergy S2 USB HD Rev.2" (2012-07-07 00:19:20 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git fixes

for you to fetch changes up to 8f8487266893eadf99a4198889fbec3c301213e9:

  v4l2-ioctl.c: zero the v4l2_dv_timings_cap struct. (2012-07-11 14:15:06 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      v4l2-dev: forgot to add VIDIOC_DV_TIMINGS_CAP.
      v4l2-ioctl.c: zero the v4l2_dv_timings_cap struct.

 drivers/media/video/v4l2-dev.c   |    1 +
 drivers/media/video/v4l2-ioctl.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)
