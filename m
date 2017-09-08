Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:34730 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754879AbdIHOfB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 10:35:01 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.15] Cleanup fixes
Message-ID: <7f18a823-3827-5a9c-053d-61f113a2d36f@xs4all.nl>
Date: Fri, 8 Sep 2017 16:34:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

coccinelle, checkpatch, coverity, etc. etc.

Regards,

	Hans

The following changes since commit 1efdf1776e2253b77413c997bed862410e4b6aaf:

  media: leds: as3645a: add V4L2_FLASH_LED_CLASS dependency (2017-09-05 16:32:45 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.15a

for you to fetch changes up to d50cd4ba25f6a9b5cfd7012cbe0d8c146212cda1:

  media: cx23885: make const array buf static, reduces object code size (2017-09-08 16:13:36 +0200)

----------------------------------------------------------------
Bhumika Goyal (2):
      usb: make i2c_client const
      pci: make i2c_client const

Colin Ian King (5):
      rtl28xxu: make array rc_nec_tab static const
      cx25840: make array stds static const, reduces object code size
      cobalt: remove redundant zero check on retval
      ov9640: make const arrays res_x/y static const, reduces object code size
      media: cx23885: make const array buf static, reduces object code size

Daniel Scheller (1):
      dvb-frontends/mxl5xx: declare LIST_HEAD(mxllist) static

Markus Elfring (62):
      Cypress: Delete an error message for a failed memory allocation in cypress_load_firmware()
      Cypress: Improve a size determination in cypress_load_firmware()
      Siano: Delete an error message for a failed memory allocation in three functions
      Siano: Improve a size determination in six functions
      Siano: Adjust five checks for null pointers
      zr364xx: Delete an error message for a failed memory allocation in two functions
      zr364xx: Improve a size determination in zr364xx_probe()
      zr364xx: Adjust ten checks for null pointers
      as102_fe: Delete an error message for a failed memory allocation in as102_attach()
      as102_fe: Improve a size determination in as102_attach()
      cx24113: Delete an error message for a failed memory allocation in cx24113_attach()
      cx24113: Return directly after a failed kzalloc() in cx24113_attach()
      cx24113: Improve a size determination in cx24113_attach()
      cx24116: Delete an error message for a failed memory allocation in cx24116_writeregN()
      cx24116: Return directly after a failed kmalloc() in cx24116_writeregN()
      cx24116: Delete an unnecessary variable initialisation in cx24116_writeregN()
      cx24116: Improve a size determination in cx24116_attach()
      cx24116: Delete an unnecessary variable initialisation in cx24116_attach()
      cx24116: Delete jump targets in cx24116_attach()
      drxd: Delete an error message for a failed memory allocation in load_firmware()
      drxd: Adjust a null pointer check in three functions
      ds3000: Delete an error message for a failed memory allocation in two functions
      ds3000: Improve a size determination in ds3000_attach()
      ds3000: Delete an unnecessary variable initialisation in ds3000_attach()
      ds3000: Delete jump targets in ds3000_attach()
      mb86a20s: Delete an error message for a failed memory allocation in mb86a20s_attach()
      mb86a20s: Improve a size determination in mb86a20s_attach()
      mb86a20s: Delete a jump target in mb86a20s_attach()
      si2168: Delete an error message for a failed memory allocation in si2168_probe()
      sp2: Delete an error message for a failed memory allocation in sp2_probe()
      sp2: Improve a size determination in sp2_probe()
      sp2: Adjust three null pointer checks in sp2_exit()
      adv7604: Delete an error message for a failed memory allocation in adv76xx_probe()
      adv7604: Adjust a null pointer check in three functions
      adv7842: Delete an error message for a failed memory allocation in adv7842_probe()
      adv7842: Improve a size determination in adv7842_probe()
      cx18: Delete an error message for a failed memory allocation in cx18_probe()
      cx18: Improve a size determination in cx18_probe()
      cx18: Adjust ten checks for null pointers
      Hopper: Delete an error message for a failed memory allocation in hopper_pci_probe()
      Hopper: Improve a size determination in hopper_pci_probe()
      Hopper: Adjust a null pointer check in two functions
      Hopper: Delete an unnecessary variable initialisation in hopper_pci_probe()
      Mantis: Delete an error message for a failed memory allocation in mantis_pci_probe()
      Mantis: Improve a size determination in mantis_pci_probe()
      Mantis: Delete an unnecessary variable initialisation in mantis_pci_probe()
      meye: Delete three error messages for a failed memory allocation in meye_probe()
      meye: Adjust two function calls together with a variable assignment
      saa7164: Delete an error message for a failed memory allocation in saa7164_buffer_alloc()
      saa7164: Improve a size determination in two functions
      Hexium Gemini: Delete an error message for a failed memory allocation in hexium_attach()
      Hexium Gemini: Improve a size determination in hexium_attach()
      Hexium Orion: Delete an error message for a failed memory allocation in hexium_probe()
      Hexium Orion: Improve a size determination in hexium_probe()
      Hexium Orion: Adjust one function call together with a variable assignment
      atmel-isc: Delete an error message for a failed memory allocation in isc_formats_init()
      atmel-isc: Improve a size determination in isc_formats_init()
      atmel-isc: Adjust three checks for null pointers
      atmel-isi: Delete an error message for a failed memory allocation in two functions
      atmel-isi: Improve three size determinations
      atmel-isi: Adjust a null pointer check in three functions
      blackfin: Delete an error message for a failed memory allocation in ppi_create_instance()

Thomas Meyer (1):
      lgdt3306a: Use ARRAY_SIZE macro

 drivers/media/common/cypress_firmware.c    |  6 ++----
 drivers/media/common/siano/smscoreapi.c    | 39 ++++++++++++++++-----------------------
 drivers/media/dvb-frontends/as102_fe.c     |  7 +++----
 drivers/media/dvb-frontends/cx24113.c      | 10 ++++------
 drivers/media/dvb-frontends/cx24116.c      | 22 ++++++++--------------
 drivers/media/dvb-frontends/drxd_hard.c    |  7 +++----
 drivers/media/dvb-frontends/ds3000.c       | 22 +++++++---------------
 drivers/media/dvb-frontends/lgdt3306a.c    |  3 ++-
 drivers/media/dvb-frontends/mb86a20s.c     | 23 +++++++----------------
 drivers/media/dvb-frontends/mxl5xx.c       |  2 +-
 drivers/media/dvb-frontends/si2168.c       |  1 -
 drivers/media/dvb-frontends/sp2.c          |  9 ++++-----
 drivers/media/i2c/adv7604.c                | 10 ++++------
 drivers/media/i2c/adv7842.c                |  6 ++----
 drivers/media/i2c/cx25840/cx25840-core.c   |  2 +-
 drivers/media/i2c/soc_camera/ov9640.c      |  4 ++--
 drivers/media/pci/cobalt/cobalt-driver.c   |  2 --
 drivers/media/pci/cx18/cx18-driver.c       | 28 +++++++++++++---------------
 drivers/media/pci/cx23885/cx23885-cards.c  |  2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c    |  2 +-
 drivers/media/pci/cx25821/cx25821-i2c.c    |  2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c          |  2 +-
 drivers/media/pci/mantis/hopper_cards.c    |  9 ++++-----
 drivers/media/pci/mantis/mantis_cards.c    |  8 +++-----
 drivers/media/pci/meye/meye.c              | 20 ++++++++------------
 drivers/media/pci/saa7134/saa7134-i2c.c    |  2 +-
 drivers/media/pci/saa7146/hexium_gemini.c  |  7 +++----
 drivers/media/pci/saa7146/hexium_orion.c   | 10 +++++-----
 drivers/media/pci/saa7164/saa7164-buffer.c |  8 +++-----
 drivers/media/pci/saa7164/saa7164-i2c.c    |  2 +-
 drivers/media/platform/atmel/atmel-isc.c   | 12 +++++-------
 drivers/media/platform/atmel/atmel-isi.c   | 20 ++++++++------------
 drivers/media/platform/blackfin/ppi.c      |  1 -
 drivers/media/usb/au0828/au0828-i2c.c      |  2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |  2 +-
 drivers/media/usb/em28xx/em28xx-i2c.c      |  2 +-
 drivers/media/usb/stk1160/stk1160-i2c.c    |  2 +-
 drivers/media/usb/zr364xx/zr364xx.c        | 32 ++++++++++++++------------------
 38 files changed, 142 insertions(+), 208 deletions(-)
