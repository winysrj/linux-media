Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:33274 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752218AbdHDLkU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 07:40:20 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Fixes, fixes, ever more fixes :-)
Message-ID: <9307321b-6fff-2102-b1af-4f73b7199e2b@xs4all.nl>
Date: Fri, 4 Aug 2017 13:40:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lots of constify patches and some random other fixes. Except for the solo patch
which is an actual feature enhancement.

Regards,

	Hans


The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14e

for you to fetch changes up to 09408627c4d001f4df6ede6d22eb27c2945c455c:

  v4l2-compat-ioctl32: Fix timespec conversion (2017-08-04 13:27:18 +0200)

----------------------------------------------------------------
Anton Sviridenko (1):
      solo6x10: export hardware GPIO pins 8:31 to gpiolib interface

Arvind Yadav (27):
      marvell-ccic: constify pci_device_id.
      netup_unidvb: constify pci_device_id.
      cx23885: constify pci_device_id.
      meye: constify pci_device_id.
      pluto2: constify pci_device_id.
      dm1105: constify pci_device_id.
      zoran: constify pci_device_id.
      bt8xx: constify pci_device_id.
      bt8xx: bttv: constify pci_device_id.
      ivtv: constify pci_device_id.
      cobalt: constify pci_device_id.
      b2c2: constify pci_device_id.
      saa7164: constify pci_device_id.
      pt1: constify pci_device_id.
      mantis: constify pci_device_id.
      mantis: hopper_cards: constify pci_device_id.
      cx18: constify pci_device_id.
      radio: constify pci_device_id.
      drv-intf: saa7146: constify pci_device_id.
      ttpci: budget: constify pci_device_id.
      ttpci: budget-patch: constify pci_device_id.
      ttpci: budget-ci: constify pci_device_id.
      ttpci: budget-av: constify pci_device_id.
      ttpci: av7110: constify pci_device_id.
      saa7146: mxb: constify pci_device_id.
      saa7146: hexium_orion: constify pci_device_id.
      saa7146: hexium_gemini: constify pci_device_id.

Dan Carpenter (1):
      adv7604: Prevent out of bounds access

Daniel Mentz (2):
      v4l2-compat-ioctl32: Copy v4l2_window->global_alpha
      v4l2-compat-ioctl32: Fix timespec conversion

Julia Lawall (1):
      DaVinci-VPBE: constify vpbe_dev_ops

Peter Rosin (3):
      cx231xx: fail probe if i2c_add_adapter fails
      cx231xx: drop return value of cx231xx_i2c_unregister
      cx231xx: only unregister successfully registered i2c adapters

 drivers/media/i2c/adv7604.c                        |  4 +--
 drivers/media/pci/b2c2/flexcop-pci.c               |  2 +-
 drivers/media/pci/bt8xx/bt878.c                    |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |  2 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |  2 +-
 drivers/media/pci/cx18/cx18-driver.c               |  2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  2 +-
 drivers/media/pci/dm1105/dm1105.c                  |  2 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |  2 +-
 drivers/media/pci/mantis/hopper_cards.c            |  2 +-
 drivers/media/pci/mantis/mantis_cards.c            |  2 +-
 drivers/media/pci/meye/meye.c                      |  2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  2 +-
 drivers/media/pci/pluto2/pluto2.c                  |  2 +-
 drivers/media/pci/pt1/pt1.c                        |  2 +-
 drivers/media/pci/saa7146/hexium_gemini.c          |  2 +-
 drivers/media/pci/saa7146/hexium_orion.c           |  2 +-
 drivers/media/pci/saa7146/mxb.c                    |  2 +-
 drivers/media/pci/saa7164/saa7164-core.c           |  2 +-
 drivers/media/pci/solo6x10/solo6x10-gpio.c         | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/solo6x10/solo6x10.h              |  5 +++
 drivers/media/pci/ttpci/av7110.c                   |  2 +-
 drivers/media/pci/ttpci/budget-av.c                |  2 +-
 drivers/media/pci/ttpci/budget-ci.c                |  2 +-
 drivers/media/pci/ttpci/budget-patch.c             |  2 +-
 drivers/media/pci/ttpci/budget.c                   |  2 +-
 drivers/media/pci/zoran/zoran_card.c               |  2 +-
 drivers/media/platform/davinci/vpbe.c              |  2 +-
 drivers/media/platform/marvell-ccic/cafe-driver.c  |  2 +-
 drivers/media/radio/radio-maxiradio.c              |  2 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |  3 ++
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |  8 ++---
 drivers/media/usb/cx231xx/cx231xx.h                |  4 +--
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      | 10 ++++--
 include/media/drv-intf/saa7146.h                   |  2 +-
 35 files changed, 148 insertions(+), 39 deletions(-)
