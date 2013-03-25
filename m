Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4947 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab3CYMKU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 08:10:20 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id r2PCAGaQ086472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 13:10:19 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id C00AB11E0192
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 13:10:14 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] Add VIDIOC_DBG_G_CHIP_NAME
Date: Mon, 25 Mar 2013 13:10:15 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251310.15271.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request is identical to:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg59894.html

except for rebasing and adding the last DocBook change that documents that
this ioctl was added.

The first two patches in that patch series are in their own pull request,
since those two have nothing to do with adding VIDIOC_DBG_G_CHIP_NAME.

This pull request implements this proposal:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/61539

and allows us to simplify the debugging support in drivers, and to eventually
get rid of v4l2-chip-ident.h, which is pretty ugly.

The other major advantage is that it allows us to access subdevices directly,
without requiring code in the bridge driver. And to access non-i2c subdevices,
which is something that was not possible before.

Once this is in drivers can be simplified until chip_ident is no longer used
and everything related to that can be removed.

Regards,

	Hans

The following changes since commit c535cc6c714bd21b3afad35baa926b3b9eb51361:

  [media] staging: lirc_sir: remove dead code (2013-03-25 08:21:20 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git chipid

for you to fetch changes up to 8573013a20e83e68a420d68779eca96cac0cf2c4:

  DocBook media: document 3.10 changes. (2013-03-25 13:04:07 +0100)

----------------------------------------------------------------
Hans Verkuil (5):
      v4l2: add new VIDIOC_DBG_G_CHIP_NAME ioctl.
      stk1160: remove V4L2_CHIP_MATCH_AC97 placeholder.
      em28xx: add support for g_chip_name.
      DocBook media: add VIDIOC_DBG_G_CHIP_NAME documentation
      DocBook media: document 3.10 changes.

 Documentation/DocBook/media/v4l/compat.xml                  |    4 ++
 Documentation/DocBook/media/v4l/v4l2.xml                    |    8 +--
 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml |   14 +++-
 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml  |  234 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml   |   42 +++++++++---
 drivers/media/usb/em28xx/em28xx-video.c                     |   41 ++++++++++--
 drivers/media/usb/stk1160/stk1160-v4l.c                     |    7 +-
 drivers/media/v4l2-core/v4l2-common.c                       |    5 +-
 drivers/media/v4l2-core/v4l2-dev.c                          |    5 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                        |  115 ++++++++++++++++++++++++++++++--
 include/media/v4l2-ioctl.h                                  |    3 +
 include/uapi/linux/videodev2.h                              |   34 +++++++---
 12 files changed, 467 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
