Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:6215 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab2I0Ini (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 04:43:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] Two v4l2-ioctl.c fixes
Date: Thu, 27 Sep 2012 10:43:35 +0200
Cc: Dan Carpenter <dan.carpenter@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209271043.35254.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Two more patches for v4l2-ioctl.c: one adds an overflow check as reported
by Dan Carpenter, the other fixes the warnings you saw when compiling with
W=1.

Regards,

	Hans

The following changes since commit 12897dc37648ac48b2aa2b3bb2d7df69625b6de5:

  [media] af9033: sleep on attach (2012-09-27 04:27:30 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ioctlfixes

for you to fetch changes up to b9f1552f130756d53cdfe364e63b5d2a2f96a1bc:

  v4l2-ioctl: fix W=1 warnings (2012-09-27 09:57:39 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      v4l2-ioctl: add overflow check for VIDIOC_SUBDEV_G/S_EDID
      v4l2-ioctl: fix W=1 warnings

 drivers/media/v4l2-core/v4l2-ioctl.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
