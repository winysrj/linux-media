Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:51937 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753120AbeEKPI7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:08:59 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.18] Various fixes
Message-ID: <12a6d65e-9162-4bc8-4a6e-7e057080324d@xs4all.nl>
Date: Fri, 11 May 2018 17:08:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 901b9dd5e31e8c58e30bf81ea4ab12641fb3ea76:

  media: update/fix my e-mail on some places (2018-05-10 07:27:15 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.18c

for you to fetch changes up to d5309ae73cd67bae5c2b8815ede91b72523cf9e2:

  lgdt330x.h: fix compiler warning (2018-05-11 17:01:08 +0200)

----------------------------------------------------------------
Anders Roxell (1):
      media: usb: cx231xx-417: include linux/slab.h header

Brad Love (6):
      cx23885: Handle additional bufs on interrupt
      cx23885: Use PCI and TS masks in irq functions
      cx23885: Ryzen DMA related RiSC engine stall fixes
      cx23885: Expand registers in dma tsport reg dump
      cx23885: Add some missing register documentation
      em28xx: Demote several dev_err to dev_info

Christophe JAILLET (1):
      media: i2c: tda1997: Fix an error handling path 'tda1997x_probe()'

Colin Ian King (2):
      cx231xx: Fix spelling mistake: "senario" -> "scenario"
      media: dvb_frontends: fix spelling mistake: "unexpcted" -> "unexpected"

Gustavo Padovan (2):
      xilinx: regroup caps on querycap
      hackrf: group device capabilities

Hans Verkuil (2):
      v4l2-device.h: always expose mdev
      lgdt330x.h: fix compiler warning

Julia Lawall (1):
      staging: media: use relevant lock

Niklas Söderlund (2):
      Revert "media: rcar-vin: enable field toggle after a set number of lines for Gen3"
      rcar-vin: fix crop and compose handling for Gen3

Peter Rosin (1):
      saa7146: fix error return from master_xfer

Sami Tolvanen (1):
      media: v4l2-ioctl: replace IOCTL_INFO_STD with stub functions

Wei Yongjun (1):
      rcar_jpu: Add missing clk_disable_unprepare() on error in jpu_open()

 drivers/media/common/saa7146/saa7146_i2c.c         |   4 +-
 drivers/media/dvb-frontends/l64781.c               |   4 +-
 drivers/media/dvb-frontends/lgdt330x.h             |   2 +-
 drivers/media/i2c/tda1997x.c                       |   2 +-
 drivers/media/pci/cx23885/cx23885-core.c           | 132 +++++++++++++++++++++++++++++++++++++++-------
 drivers/media/pci/cx23885/cx23885-reg.h            |  14 +++++
 drivers/media/platform/rcar-vin/rcar-dma.c         |  20 ++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   6 +++
 drivers/media/platform/rcar_jpu.c                  |   4 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |  10 ++--
 drivers/media/usb/cx231xx/cx231xx-417.c            |   1 +
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c        |   2 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   4 +-
 drivers/media/usb/hackrf/hackrf.c                  |  11 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c               | 245 ++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   2 +-
 include/media/v4l2-device.h                        |   4 +-
 17 files changed, 294 insertions(+), 173 deletions(-)
