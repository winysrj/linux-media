Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2927 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2D2L5k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 07:57:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.5] cpia2: major overhaul to get it in a working state again.
Date: Sun, 29 Apr 2012 13:57:36 +0200
Cc: andrea.merello@gmail.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204291357.36484.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I managed to get hold of a cpia2-based Hanse USB microscope almost a year
ago after reports from Andrea that the driver didn't work properly.

I finally had time to take a really good look at the driver and it was
broken in many respects. This patch brings the driver up to speed with
respect to the v4l2 framework and it now works as expected, including
disconnect handling and suspend/resume handling.

The only thing left to do some day is to convert it to the videobuf2
framework.

Regards,

	Hans

The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

  [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cpia2

for you to fetch changes up to 14a3d232eb5d25c768f40fbd6a87db48a249a391:

  cpia2: major overhaul to get it in a working state again. (2012-04-29 13:44:44 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      cpia2: major overhaul to get it in a working state again.

 drivers/media/video/cpia2/cpia2.h      |   34 ++-
 drivers/media/video/cpia2/cpia2_core.c |  142 +++---------
 drivers/media/video/cpia2/cpia2_usb.c  |   78 +++++--
 drivers/media/video/cpia2/cpia2_v4l.c  |  846 +++++++++++++++++++++------------------------------------------------
 drivers/media/video/cpia2/cpia2dev.h   |   50 -----
 5 files changed, 363 insertions(+), 787 deletions(-)
 delete mode 100644 drivers/media/video/cpia2/cpia2dev.h
