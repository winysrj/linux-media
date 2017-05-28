Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35947 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750851AbdE1RKk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 13:10:40 -0400
Date: Sun, 28 May 2017 18:10:38 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.13] RC fixes
Message-ID: <20170528171038.GA20281@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just minor cleanups and fixes this time round.

Thanks,
Sean

The following changes since commit 36bcba973ad478042d1ffc6e89afd92e8bd17030:

  [media] mtk_vcodec_dec: return error at mtk_vdec_pic_info_update() (2017-05-19 07:12:05 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.13a

for you to fetch changes up to 2ff5552b1cdb5b07a8adc5dee08db17aceaa673a:

  [media] staging: remove todo and replace with lirc_zilog todo (2017-05-27 10:44:44 +0100)

----------------------------------------------------------------
A Sun (4):
      [media] mceusb: sporadic RX truncation corruption fix
      [media] mceusb: fix inaccurate debug buffer dumps, and misleading debug messages
      [media] mceusb: RX -EPIPE (urb status = -32) lockup failure fix
      [media] mceusb: TX -EPIPE (urb status = -32) lockup fix

Alex Deryskyba (1):
      [media] rc: meson-ir: switch config to NEC decoding on shutdown

Andi Shyti (1):
      [media] rc: ir-spi: remove unnecessary initialization

David Härdeman (17):
      [media] lirc_dev: remove pointless functions
      [media] lirc_dev: remove unused set_use_inc/set_use_dec
      [media] lirc_dev: remove sampling kthread
      [media] lirc_dev: clarify error handling
      [media] lirc_dev: make fops mandatory
      [media] lirc_dev: merge lirc_register_driver() and lirc_allocate_driver()
      [media] lirc_zilog: remove module parameter minor
      [media] lirc_dev: remove lirc_irctl_init() and lirc_cdev_add()
      [media] lirc_dev: remove superfluous get/put_device() calls
      [media] lirc_dev: remove unused module parameter
      [media] lirc_dev: return POLLHUP and POLLERR when device is gone
      [media] lirc_dev: cleanup includes
      [media] lirc_dev: cleanup header
      [media] rc-core: ati_remote - leave the internals of rc_dev alone
      [media] rc-core: img-ir - leave the internals of rc_dev alone
      [media] rc-core: cx231xx - leave the internals of rc_dev alone
      [media] tm6000: key_addr is unused

Devin Heitmueller (1):
      [media] rc: fix breakage in "make menuconfig" for media_build

Heiner Kallweit (5):
      [media] rc: meson-ir: remove irq from struct meson_ir
      [media] rc: meson-ir: make use of the bitfield macros
      [media] rc: meson-ir: switch to managed rc device allocation / registration
      [media] rc: meson-ir: use readl_relaxed in the interrupt handler
      [media] rc: meson-ir: change irq name to to of node name

Jonas Karlman (1):
      [media] rc: meson-ir: store raw event without processing

Ricardo Silva (5):
      [media] lirc_zilog: Fix whitespace style checks
      [media] lirc_zilog: Fix NULL comparisons style
      [media] lirc_zilog: Use __func__ for logging function name
      [media] lirc_zilog: Use sizeof(*p) instead of sizeof(struct P)
      [media] lirc_zilog: Fix unbalanced braces around if/else

Sean Young (5):
      [media] sir_ir: attempt to free already free_irq
      [media] sir_ir: use dev managed resources
      [media] sir_ir: remove init_port and drop_port functions
      [media] sir_ir: remove init_chrdev and init_sir_ir functions
      [media] staging: remove todo and replace with lirc_zilog todo

 drivers/media/rc/Kconfig                   |   8 +-
 drivers/media/rc/ati_remote.c              |   3 -
 drivers/media/rc/img-ir/img-ir-hw.c        |   4 -
 drivers/media/rc/ir-lirc-codec.c           |  12 --
 drivers/media/rc/ir-spi.c                  |   2 +-
 drivers/media/rc/lirc_dev.c                | 253 ++++-------------------------
 drivers/media/rc/mceusb.c                  | 153 +++++++++++++----
 drivers/media/rc/meson-ir.c                |  91 ++++++-----
 drivers/media/rc/sir_ir.c                  |  90 ++++------
 drivers/media/usb/cx231xx/cx231xx-input.c  |   5 +-
 drivers/media/usb/tm6000/tm6000-input.c    |   4 -
 drivers/staging/media/lirc/TODO            |  47 ++++--
 drivers/staging/media/lirc/TODO.lirc_zilog |  36 ----
 drivers/staging/media/lirc/lirc_zilog.c    | 136 +++++++---------
 include/media/lirc_dev.h                   |  32 ----
 15 files changed, 341 insertions(+), 535 deletions(-)
 delete mode 100644 drivers/staging/media/lirc/TODO.lirc_zilog
