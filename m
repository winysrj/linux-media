Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33733 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbdIXKWQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 06:22:16 -0400
Date: Sun, 24 Sep 2017 11:22:15 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 FOR v4.15] RC cleanup fixes
Message-ID: <20170924102215.b72emfkjofsv7q7d@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for your comments on the first PR. You are right, removing the
LIRC_GET_{MIN,MAX}_TIMEOUT ioctls from the non-rc-core lirc drivers had
no reason to be merged.

The changes to use file->private_data should not break imon since the imon
driver uses it for the lcd chardev, not lirc. The patch is needed to move
to lirc ida minor allocation, rather that the self-coded one.

The patches have been tested in varous ways with lots of IR hardware
plugged in, unfortunately I don't have an imon device to test.

Thanks,

Sean


The following changes since commit d5426f4c2ebac8cf05de43988c3fccddbee13d28:

  media: staging: atomisp: use clock framework for camera clocks (2017-09-23 15:09:37 -0400)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.15a

for you to fetch changes up to 025911a68db868dff7d383fac11d804744d9e79f:

  imon: Improve a size determination in two functions (2017-09-24 10:42:44 +0100)

----------------------------------------------------------------
Arvind Yadav (1):
      media: rc: constify usb_device_id

Bhumika Goyal (1):
      media: rc: make device_type const

Colin Ian King (1):
      media: imon: make two const arrays static, reduces object code size

David Härdeman (14):
      media: lirc_dev: clarify error handling
      media: lirc_dev: remove support for manually specifying minor number
      media: lirc_dev: use cdev_device_add() helper function
      media: lirc_dev: make better use of file->private_data
      media: lirc_dev: make chunk_size and buffer_size mandatory
      media: lirc_dev: remove kmalloc in lirc_dev_fop_read()
      media: lirc_dev: change irctl->attached to be a boolean
      media: lirc_dev: sanitize locking
      media: lirc_dev: use an IDA instead of an array to keep track of registered devices
      media: rename struct lirc_driver to struct lirc_dev
      media: lirc_dev: introduce lirc_allocate_device and lirc_free_device
      media: lirc_zilog: add a pointer to the parent device to struct IR
      media: lirc_zilog: use a dynamically allocated lirc_dev
      media: lirc_dev: merge struct irctl into struct lirc_dev

Ladislav Michl (10):
      media: rc: gpio-ir-recv: use helper variable to access device info
      media: rc: gpio-ir-recv: use devm_kzalloc
      media: rc: gpio-ir-recv: use devm_rc_allocate_device
      media: rc: gpio-ir-recv: use devm_gpio_request_one
      media: rc: gpio-ir-recv: use devm_rc_register_device
      media: rc: gpio-ir-recv: do not allow threaded interrupt handler
      media: rc: gpio-ir-recv: use devm_request_irq
      media: rc: gpio-ir-recv: use KBUILD_MODNAME
      media: rc: gpio-ir-recv: remove gpio_ir_recv_platform_data
      media: rc: gpio-ir-recv: use gpiolib API

Marc Gonzalez (1):
      media: rc: Delete duplicate debug message

Markus Elfring (3):
      media: imon: delete an error message for a failed memory allocation
      media: img-ir: delete an error message for a failed memory allocation
      imon: Improve a size determination in two functions

Sean Young (7):
      media: dvb: a800: port to rc-core
      media: rc: avermedia keymap for a800
      media: rc: ensure that protocols are enabled for scancode drivers
      media: rc: dvb: use dvb device name for rc device
      media: rc: if protocols can't be changed, don't be writable
      media: rc: include device name in rc udev event
      media: vp7045: port TwinhanDTV Alpha to rc-core

Stephen Hemminger (1):
      media: default for RC_CORE should be n

Thomas Meyer (1):
      media: rc: Use bsearch library function

 drivers/media/cec/cec-core.c                     |   1 -
 drivers/media/i2c/ir-kbd-i2c.c                   |   1 -
 drivers/media/rc/Kconfig                         |   1 -
 drivers/media/rc/ati_remote.c                    |   2 +-
 drivers/media/rc/gpio-ir-recv.c                  | 190 +++------
 drivers/media/rc/igorplugusb.c                   |   2 +-
 drivers/media/rc/img-ir/img-ir-core.c            |   5 +-
 drivers/media/rc/imon.c                          |  18 +-
 drivers/media/rc/ir-lirc-codec.c                 |  56 ++-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c    |   3 +-
 drivers/media/rc/keymaps/rc-twinhan1027.c        |   2 +-
 drivers/media/rc/lirc_dev.c                      | 511 +++++++++--------------
 drivers/media/rc/mceusb.c                        |   2 +-
 drivers/media/rc/rc-core-priv.h                  |   2 +-
 drivers/media/rc/rc-main.c                       |  72 ++--
 drivers/media/rc/redrat3.c                       |   2 +-
 drivers/media/rc/streamzap.c                     |   2 +-
 drivers/media/usb/dvb-usb/a800.c                 |  65 +--
 drivers/media/usb/dvb-usb/dvb-usb-remote.c       |   3 +-
 drivers/media/usb/dvb-usb/dvb-usb.h              |   1 +
 drivers/media/usb/dvb-usb/vp7045.c               |  88 +---
 drivers/staging/media/lirc/lirc_zilog.c          | 231 +++++-----
 include/linux/platform_data/media/gpio-ir-recv.h |  23 -
 include/media/lirc_dev.h                         |  94 ++---
 24 files changed, 527 insertions(+), 850 deletions(-)
 delete mode 100644 include/linux/platform_data/media/gpio-ir-recv.h
