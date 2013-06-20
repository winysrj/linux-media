Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1970 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965307Ab3FTOVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 10:21:47 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5KELZtV027927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 16:21:38 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id BB34C35E0143
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 16:21:34 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Removal of g_chip_ident
Date: Thu, 20 Jun 2013 16:21:34 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201621.34924.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request removes the last usages of g_chip_ident.

It was originally posted here:

http://www.spinics.net/lists/linux-media/msg64081.html

Most of those patches have already been merged, but due to merge conflicts
I postponed the cx88 change and the actual g_chip_ident removal until the
3.10 cx88 bug fix was merged back into the master branch.

The patch series has now been rebased (affecting only the cx88 patch, as
predicted) and is ready for merging.

Regards,

	Hans

The following changes since commit 37c1d2e4098e48d9107858246027510efcfd7774:

  Merge branch 'linus' into patchwork (2013-06-20 05:19:09 -0300)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git chipident

for you to fetch changes up to 3684f2014178cf5a4e54fe33f6473b4e2d5005b4:

  cx88: fix register mask. (2013-06-20 16:03:58 +0200)

----------------------------------------------------------------
Hans Verkuil (8):
      cx88: remove g_chip_ident.
      v4l2: remove obsolete v4l2_chip_match_host().
      v4l2-common: remove unused v4l2_chip_match/ident_i2c_client functions
      v4l2-int-device: remove unused chip_ident reference.
      v4l2-core: remove support for obsolete VIDIOC_DBG_G_CHIP_IDENT.
      DocBook: remove references to the dropped VIDIOC_DBG_G_CHIP_IDENT ioctl.
      DocBook: remove obsolete note from the dbg_g_register doc.
      cx88: fix register mask.

 Documentation/DocBook/media/v4l/compat.xml                  |  14 ++-
 Documentation/DocBook/media/v4l/v4l2.xml                    |  11 ++-
 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml | 271 -----------------------------------------------------
 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml  |  17 +---
 Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml   |  49 +---------
 drivers/media/pci/cx88/cx88-cards.c                         |  12 +--
 drivers/media/pci/cx88/cx88-video.c                         |  25 +----
 drivers/media/pci/cx88/cx88.h                               |   8 +-
 drivers/media/usb/usbvision/usbvision-video.c               |   4 -
 drivers/media/v4l2-core/v4l2-common.c                       |  58 +-----------
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c               |   1 -
 drivers/media/v4l2-core/v4l2-dev.c                          |   1 -
 drivers/media/v4l2-core/v4l2-ioctl.c                        |  28 ------
 include/media/v4l2-chip-ident.h                             | 354 ---------------------------------------------------------------------
 include/media/v4l2-common.h                                 |  10 --
 include/media/v4l2-int-device.h                             |   3 -
 include/media/v4l2-ioctl.h                                  |   2 -
 include/media/v4l2-subdev.h                                 |   4 +-
 include/uapi/linux/videodev2.h                              |  17 +---
 19 files changed, 45 insertions(+), 844 deletions(-)
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
 delete mode 100644 include/media/v4l2-chip-ident.h
