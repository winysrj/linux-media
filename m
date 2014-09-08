Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3994 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaIHIlR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 04:41:17 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s888fCsk081464
	for <linux-media@vger.kernel.org>; Mon, 8 Sep 2014 10:41:15 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E595B2A03DA
	for <linux-media@vger.kernel.org>; Mon,  8 Sep 2014 10:41:10 +0200 (CEST)
Message-ID: <540D6BA6.4080102@xs4all.nl>
Date: Mon, 08 Sep 2014 10:41:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes for 3.18.

Regards,

	Hans

The following changes since commit 89fffac802c18caebdf4e91c0785b522c9f6399a:

  [media] drxk_hard: fix bad alignments (2014-09-03 19:19:18 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.18b

for you to fetch changes up to fa25ee4f45e712847caf678a63438c5311768ad8:

  media: davinci: remove unneeded dependency ARCH_OMAP3 (2014-09-08 10:23:30 +0200)

----------------------------------------------------------------
Axel Lin (1):
      tvp7002: Don't update device->streaming if write to register fails

Hans Verkuil (1):
      videobuf2-core: take mmap_sem before calling __qbuf_userptr

Hans de Goede (1):
      videobuf: Allow reqbufs(0) to free current buffers

Himangi Saraogi (1):
      radio-si470x-usb: use USB API functions rather than constants

Prabhakar Lad (6):
      media: davinci: vpif_display: drop setting of vb2 buffer state to ACTIVE
      media: davinci: vpif_capture: drop setting of vb2 buffer state to ACTIVE
      media: videobuf2-core.h: add a helper to get status of start_streaming()
      media: davinci: vpif_display: fix the check on suspend/resume callbacks
      media: davinci: vpif_capture: fix the check on suspend/resume callbacks
      media: davinci: remove unneeded dependency ARCH_OMAP3

Rasmus Villemoes (2):
      drivers: media: b2c2: flexcop.h: Fix typo in include guard
      drivers: media: i2c: adv7343_regs.h: Fix typo in #ifndef

 drivers/media/common/b2c2/flexcop.h           |  2 +-
 drivers/media/i2c/adv7343_regs.h              |  2 +-
 drivers/media/i2c/tvp7002.c                   | 21 ++++++++-------------
 drivers/media/platform/Makefile               |  2 --
 drivers/media/platform/davinci/Kconfig        |  2 +-
 drivers/media/platform/davinci/vpif_capture.c |  7 ++-----
 drivers/media/platform/davinci/vpif_display.c |  8 ++------
 drivers/media/radio/si470x/radio-si470x-usb.c |  4 +---
 drivers/media/v4l2-core/videobuf-core.c       | 11 ++++++-----
 drivers/media/v4l2-core/videobuf2-core.c      |  2 ++
 include/media/videobuf2-core.h                |  9 +++++++++
 11 files changed, 33 insertions(+), 37 deletions(-)
