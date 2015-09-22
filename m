Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34028 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbbIVJB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 05:01:56 -0400
Received: from [10.61.217.18] (unknown [173.38.220.33])
	by tschai.lan (Postfix) with ESMTPSA id D0D832A008E
	for <linux-media@vger.kernel.org>; Tue, 22 Sep 2015 11:00:29 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.4] More fixes/enhancements
Message-ID: <560118FF.3060301@xs4all.nl>
Date: Tue, 22 Sep 2015 11:01:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More fixes and enhancements.

Note the v4l2-ctrls fix that has a CC to stable for 3.17 and up.

Regards,

	Hans

The following changes since commit 9ddf9071ea17b83954358b2dac42b34e5857a9af:

  Merge tag 'v4.3-rc1' into patchwork (2015-09-13 11:10:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.4c

for you to fetch changes up to c8e88d026d67d33c427a9083a7762527a6b80d1c:

  media: v4l2-ctrls: Fix 64bit support in get_ctrl() (2015-09-22 10:23:37 +0200)

----------------------------------------------------------------
Andrzej Pietrasiewicz (2):
      s5p-jpeg: add support for 5433
      MAINTAINERS: add exynos jpeg codec maintainers

Benoit Parrot (1):
      media: v4l2-ctrls: Fix 64bit support in get_ctrl()

Hans Verkuil (1):
      cobalt: fix Kconfig dependency

Javier Martinez Canillas (1):
      tvp5150: add support for asynchronous probing

Joe Perches (1):
      s5p-mfc: Correct misuse of %0x<decimal>

Luis de Bethencourt (1):
      cx25821, cx88, tm6000: use SNDRV_DEFAULT_ENABLE_PNP

Marek Szyprowski (1):
      s5p-jpeg: generalize clocks handling

 Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt |   3 +-
 MAINTAINERS                                                   |   8 ++
 drivers/media/i2c/tvp5150.c                                   |  14 ++-
 drivers/media/pci/cobalt/Kconfig                              |   2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c                      |   2 +-
 drivers/media/pci/cx88/cx88-alsa.c                            |   2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c                   | 444 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/media/platform/s5p-jpeg/jpeg-core.h                   |  41 ++++++-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c             |  80 ++++++++++---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h             |  11 +-
 drivers/media/platform/s5p-jpeg/jpeg-regs.h                   |  85 +++++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c               |   2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c                        |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c                          |   6 +-
 14 files changed, 586 insertions(+), 116 deletions(-)
