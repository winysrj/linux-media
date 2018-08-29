Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55011 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbeH2OdK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 10:33:10 -0400
Date: Wed, 29 Aug 2018 11:36:53 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.20] RC changes
Message-ID: <20180829103653.q6rzbjn7v2f3vf4b@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes a change which depends on gcc 4.6, since mainline now
requires it. Also this removes the ir-rx51 for the Nokia N900, since
this is covered by the generic pwm-ir-tx driver.

Please pull. Thanks!

Sean


The following changes since commit 5b394b2ddf0347bef56e50c69a58773c94343ff3:

  Linux 4.19-rc1 (2018-08-26 14:11:59 -0700)

are available in the Git repository at:

  git://git.linuxtv.org/syoung/media_tree.git for-v4.20a

for you to fetch changes up to ee0364e9752bf2768389db4e8dc9e478e263bd7f:

  media: rc: ir-rc6-decoder: enable toggle bit for Kathrein RCU-676 remote (2018-08-28 23:27:55 +0100)

----------------------------------------------------------------
Matthias Reichl (1):
      media: rc: ir-rc6-decoder: enable toggle bit for Kathrein RCU-676 remote

Sean Young (5):
      media: dt-bindings: bind nokia, n900-ir to generic pwm-ir-tx driver
      media: rc: remove ir-rx51 in favour of generic pwm-ir-tx
      media: rc: nec keymaps should specify the nec variant they use
      media: rc: self test for IR encoders and decoders
      media: rc: Remove init_ir_raw_event and DEFINE_IR_RAW_EVENT macros

 arch/arm/boot/dts/omap3-n900.dts                  |   2 +-
 arch/arm/configs/omap2plus_defconfig              |   1 -
 drivers/hid/hid-picolcd_cir.c                     |   3 +-
 drivers/media/common/siano/smsir.c                |   8 +-
 drivers/media/i2c/cx25840/cx25840-ir.c            |   6 +-
 drivers/media/pci/cx23885/cx23888-ir.c            |   6 +-
 drivers/media/pci/cx88/cx88-input.c               |   3 +-
 drivers/media/rc/Kconfig                          |  10 -
 drivers/media/rc/Makefile                         |   1 -
 drivers/media/rc/ene_ir.c                         |  12 +-
 drivers/media/rc/fintek-cir.c                     |   3 +-
 drivers/media/rc/igorplugusb.c                    |   2 +-
 drivers/media/rc/iguanair.c                       |   4 +-
 drivers/media/rc/imon_raw.c                       |   2 +-
 drivers/media/rc/ir-hix5hd2.c                     |   2 +-
 drivers/media/rc/ir-rc6-decoder.c                 |   9 +-
 drivers/media/rc/ir-rx51.c                        | 305 ----------------------
 drivers/media/rc/ite-cir.c                        |   5 +-
 drivers/media/rc/keymaps/rc-behold.c              |   2 +-
 drivers/media/rc/keymaps/rc-delock-61959.c        |   2 +-
 drivers/media/rc/keymaps/rc-imon-rsc.c            |   2 +-
 drivers/media/rc/keymaps/rc-it913x-v1.c           |   2 +-
 drivers/media/rc/keymaps/rc-it913x-v2.c           |   2 +-
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c     |   2 +-
 drivers/media/rc/keymaps/rc-pixelview-002t.c      |   2 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c      |   2 +-
 drivers/media/rc/keymaps/rc-reddo.c               |   2 +-
 drivers/media/rc/keymaps/rc-terratec-slim.c       |   2 +-
 drivers/media/rc/keymaps/rc-tivo.c                |   2 +-
 drivers/media/rc/keymaps/rc-total-media-in-hand.c |   2 +-
 drivers/media/rc/mceusb.c                         |  15 +-
 drivers/media/rc/meson-ir.c                       |   2 +-
 drivers/media/rc/mtk-cir.c                        |   2 +-
 drivers/media/rc/nuvoton-cir.c                    |   2 +-
 drivers/media/rc/pwm-ir-tx.c                      |   1 +
 drivers/media/rc/rc-core-priv.h                   |   7 +-
 drivers/media/rc/rc-ir-raw.c                      |  12 +-
 drivers/media/rc/rc-loopback.c                    |   2 +-
 drivers/media/rc/redrat3.c                        |  10 +-
 drivers/media/rc/serial_ir.c                      |  10 +-
 drivers/media/rc/sir_ir.c                         |   2 +-
 drivers/media/rc/st_rc.c                          |   5 +-
 drivers/media/rc/streamzap.c                      |  12 +-
 drivers/media/rc/sunxi-cir.c                      |   2 +-
 drivers/media/rc/ttusbir.c                        |   4 +-
 drivers/media/rc/winbond-cir.c                    |  12 +-
 drivers/media/usb/au0828/au0828-input.c           |   5 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c           |   4 +-
 include/media/rc-core.h                           |  11 +-
 tools/testing/selftests/Makefile                  |   1 +
 tools/testing/selftests/ir/.gitignore             |   1 +
 tools/testing/selftests/ir/Makefile               |  19 ++
 tools/testing/selftests/ir/config                 |  12 +
 tools/testing/selftests/ir/ir-loopback.c          | 211 +++++++++++++++
 tools/testing/selftests/ir/ir-loopback.sh         |  28 ++
 55 files changed, 367 insertions(+), 433 deletions(-)
 delete mode 100644 drivers/media/rc/ir-rx51.c
 create mode 100644 tools/testing/selftests/ir/.gitignore
 create mode 100644 tools/testing/selftests/ir/Makefile
 create mode 100644 tools/testing/selftests/ir/config
 create mode 100644 tools/testing/selftests/ir/ir-loopback.c
 create mode 100755 tools/testing/selftests/ir/ir-loopback.sh
