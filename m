Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43666 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbbFLHvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 03:51:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id F31AA2A00AA
	for <linux-media@vger.kernel.org>; Fri, 12 Jun 2015 09:50:58 +0200 (CEST)
Message-ID: <557A8F62.3000902@xs4all.nl>
Date: Fri, 12 Jun 2015 09:50:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit e42c8c6eb456f8978de417ea349eef676ef4385c:

  [media] au0828: move dev->boards atribuition to happen earlier (2015-06-10 12:39:35 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2n

for you to fetch changes up to 5361c68bdc76a5cf8beaaa19d7b18000bd4bbc34:

  v4l2-dv-timings: log if the timing is reduced blanking V2 (2015-06-12 09:39:40 +0200)

----------------------------------------------------------------
Fabian Frederick (5):
      v4l2-dv-timings: use swap() in v4l2_calc_aspect_ratio()
      wl128x: use swap() in fm_rdsparse_swapbytes()
      saa7146: use swap() in sort_and_eliminate()
      saa6588: use swap() in saa6588_i2c_poll()
      btcx-risc: use swap() in btcx_sort_clips()

Hans Verkuil (4):
      stk1160: fix sequence handling
      rc/Kconfig: fix indentation problem
      mantis: fix unused variable compiler warning
      v4l2-dv-timings: log if the timing is reduced blanking V2

Jan Roemisch (1):
      radio-bcm2048: Fix region selection

Krzysztof Hałasa (4):
      SOLO6x10: Fix G.723 minimum audio period count.
      SOLO6x10: unmap registers only after free_irq().
      SOLO6x10: remove unneeded register locking and barriers.
      SOLO6x10: Remove dead code.

Prashant Laddha (1):
      v4l2-dv-timings: add support for reduced blanking v2

 drivers/media/common/saa7146/saa7146_hlp.c    |  9 +++-----
 drivers/media/i2c/adv7604.c                   |  2 +-
 drivers/media/i2c/adv7842.c                   |  2 +-
 drivers/media/i2c/saa6588.c                   |  4 +---
 drivers/media/pci/bt8xx/btcx-risc.c           |  5 +----
 drivers/media/pci/mantis/mantis_i2c.c         |  3 +--
 drivers/media/pci/solo6x10/solo6x10-core.c    | 18 ++--------------
 drivers/media/pci/solo6x10/solo6x10-g723.c    | 13 ++++++------
 drivers/media/pci/solo6x10/solo6x10.h         | 26 +----------------------
 drivers/media/platform/vivid/vivid-vid-cap.c  |  2 +-
 drivers/media/radio/wl128x/fmdrv_common.c     |  5 +----
 drivers/media/rc/Kconfig                      | 26 +++++++++++------------
 drivers/media/usb/stk1160/stk1160-v4l.c       |  2 ++
 drivers/media/usb/stk1160/stk1160-video.c     |  4 +---
 drivers/media/usb/stk1160/stk1160.h           |  3 +--
 drivers/media/v4l2-core/v4l2-dv-timings.c     | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------
 drivers/staging/media/bcm2048/radio-bcm2048.c | 20 ++++++++++--------
 include/media/v4l2-dv-timings.h               |  6 +++++-
 18 files changed, 116 insertions(+), 123 deletions(-)
