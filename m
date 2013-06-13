Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3966 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3FMGeG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 02:34:06 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5D6XssT052839
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:33:57 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id EA0EB35E005E
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:33:52 +0200 (CEST)
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates Part 4
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 13 Jun 2013 08:33:53 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306130833.53951.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro prefers to have the original large pull request split up in smaller pieces.

So this is the fourth patch set.

This pulls in these two patch series:

QUERYSTD fixes (particularly in the case of 'no signal'):
http://www.spinics.net/lists/linux-media/msg64131.html

saa7134 cleanup:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg62863.html

Note that the pull requests need to be done in order since there are dependencies
between them.

Regards,

	Hans

The following changes since commit 992df036e18da2333d10be0d8451592502f4d3cd:

  v4l2: remove deprecated current_norm support completely. (2013-06-13 08:16:51 +0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11d

for you to fetch changes up to e8f0e37498734d20a1ac500e13db0aedf023650d:

  ths8200: fix two compiler warnings (2013-06-13 08:17:36 +0200)

----------------------------------------------------------------
Hans Verkuil (32):
      adv7183: fix querystd
      bt819: fix querystd
      ks0127: fix querystd
      saa7110: fix querystd
      saa7115: fix querystd
      saa7191: fix querystd
      tvp514x: fix querystd
      vpx3220: fix querystd
      bttv: fix querystd
      zoran: remove bogus autodetect mode in set_norm
      v4l2-ioctl: clarify querystd comment.
      DocBook/media/v4l: clarify the QUERYSTD documentation.
      tvp5150: fix s_std support
      media: i2c: ths8200: driver for TI video encoder.
      saa7134: remove radio/type field from saa7134_fh
      saa7134: move the overlay fields from saa7134_fh to saa7134_dev.
      saa7134: move fmt/width/height from saa7134_fh to saa7134_dev
      saa7134: move qos_request from saa7134_fh to saa7134_dev.
      saa7134: move the queue data from saa7134_fh to saa7134_dev.
      saa7134: fix format-related compliance issues.
      saa7134: convert to the control framework.
      saa7134: cleanup radio/video/empress ioctl handling
      saa7134: fix empress format compliance bugs.
      saa7134: remove dev from saa7134_fh, use saa7134_fh for empress node
      saa7134: share resource management between normal and empress nodes.
      saa7134: add support for control events.
      saa7134: use V4L2_IN_ST_NO_SIGNAL instead of NO_SYNC
      saa6752hs: drop compat control code.
      saa6752hs: move to media/i2c
      saa6752hs.h: drop empty header.
      saa7134: drop log_status for radio.
      ths8200: fix two compiler warnings

Ismael Luceno (1):
      solo6x10: reimplement SAA712x setup routine

 Documentation/DocBook/media/v4l/vidioc-querystd.xml |    3 +-
 drivers/media/i2c/Kconfig                           |   23 +-
 drivers/media/i2c/Makefile                          |    2 +
 drivers/media/i2c/adv7183.c                         |   16 +-
 drivers/media/i2c/bt819.c                           |    8 +-
 drivers/media/i2c/ks0127.c                          |   17 +-
 drivers/media/{pci/saa7134 => i2c}/saa6752hs.c      |   77 +++----
 drivers/media/i2c/saa7110.c                         |    4 +-
 drivers/media/i2c/saa7115.c                         |    5 +-
 drivers/media/i2c/saa7191.c                         |   14 +-
 drivers/media/i2c/ths8200.c                         |  556 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/ths8200_regs.h                    |  161 ++++++++++++++
 drivers/media/i2c/tvp514x.c                         |   12 +-
 drivers/media/i2c/tvp5150.c                         |    8 +-
 drivers/media/i2c/vpx3220.c                         |   10 +-
 drivers/media/pci/bt8xx/bttv-driver.c               |    4 +-
 drivers/media/pci/saa7134/Kconfig                   |    1 +
 drivers/media/pci/saa7134/Makefile                  |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c            |   10 +-
 drivers/media/pci/saa7134/saa7134-empress.c         |  374 +++++++++------------------------
 drivers/media/pci/saa7134/saa7134-vbi.c             |   11 +-
 drivers/media/pci/saa7134/saa7134-video.c           | 1015 +++++++++++++++++++++++++++++++++++-----------------------------------------------------
 drivers/media/pci/saa7134/saa7134.h                 |   83 +++++---
 drivers/media/pci/zoran/zoran_driver.c              |   23 --
 drivers/media/v4l2-core/v4l2-ioctl.c                |    8 +-
 drivers/staging/media/solo6x10/solo6x10-tw28.c      |  112 ++++++----
 include/media/saa6752hs.h                           |   26 ---
 include/uapi/linux/v4l2-controls.h                  |    4 +
 28 files changed, 1498 insertions(+), 1091 deletions(-)
 rename drivers/media/{pci/saa7134 => i2c}/saa6752hs.c (97%)
 create mode 100644 drivers/media/i2c/ths8200.c
 create mode 100644 drivers/media/i2c/ths8200_regs.h
 delete mode 100644 include/media/saa6752hs.h
