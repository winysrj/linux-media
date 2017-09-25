Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:37260 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936221AbdIYPoW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 11:44:22 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.15] Fixes, cleanups
Message-ID: <49f88e8e-3093-7428-727d-7b5b3518783f@xs4all.nl>
Date: Mon, 25 Sep 2017 17:44:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d5426f4c2ebac8cf05de43988c3fccddbee13d28:

  media: staging: atomisp: use clock framework for camera clocks (2017-09-23 15:09:37 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.15c

for you to fetch changes up to 8abdfc1cc7b288aeb50ade41d42d16338682be97:

  v4l2-ctrls.c: allow empty control handlers (2017-09-25 15:07:56 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      rcar_drif: fix potential uninitialized variable use

Bhumika Goyal (1):
      saa7146: make saa7146_use_ops const

Christophe JAILLET (1):
      media: v4l2-pci-skeleton: Fix error handling path in 'skeleton_probe()'

Colin Ian King (1):
      gspca: make arrays static, reduces object code size

Hans Verkuil (4):
      v4l2-tpg: add Y10 and Y12 support
      vivid: add support for Y10 and Y12
      cec-gpio: don't generate spurious HPD events
      v4l2-ctrls.c: allow empty control handlers

Johan Hovold (1):
      cx231xx-cards: fix NULL-deref on missing association descriptor

Kees Cook (1):
      media/i2c/tc358743: Initialize timer

Simon Yuan (1):
      media: i2c: adv748x: Map v4l2_std_id to the internal reg value

 drivers/media/common/saa7146/saa7146_vbi.c      |  2 +-
 drivers/media/common/saa7146/saa7146_video.c    |  2 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 12 ++++++++++++
 drivers/media/i2c/adv748x/adv748x-afe.c         |  7 ++++++-
 drivers/media/i2c/tc358743.c                    |  4 ++--
 drivers/media/platform/cec-gpio/cec-gpio.c      |  5 ++++-
 drivers/media/platform/rcar_drif.c              |  2 +-
 drivers/media/platform/vivid/vivid-vid-common.c | 16 ++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-cards.c       |  2 +-
 drivers/media/usb/gspca/ov519.c                 | 22 +++++++++++-----------
 drivers/media/v4l2-core/v4l2-ctrls.c            |  2 +-
 include/media/drv-intf/saa7146_vv.h             |  4 ++--
 samples/v4l/v4l2-pci-skeleton.c                 |  6 ++++--
 13 files changed, 62 insertions(+), 24 deletions(-)
