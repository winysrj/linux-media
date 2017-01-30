Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:46679 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753146AbdA3WPa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 17:15:30 -0500
Date: Mon, 30 Jan 2017 22:05:21 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.11] More RC updates
Message-ID: <20170130220521.GB20904@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes a fix for my embarrassing ir-rx51 build failure, the mediatek
IR driver, a keymap and some important fixes for tx-only drivers.

Thanks,

Sean


The following changes since commit a052af2a548decf1da5cccf9e777aa02321e3ffb:

  [media] staging/media/s5p-cec/exynos_hdmi_cecctrl.c Fixed blank line before closing brace '}' (2017-01-30 15:48:54 -0200)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.11b

for you to fetch changes up to 7813bce59dca0eb7f9af1626fc9cd6ef1ddea9a5:

  [media] rx51: broken build (2017-01-30 21:38:30 +0000)

----------------------------------------------------------------
Martin Blumenstingl (1):
      [media] rc/keymaps: add a keytable for the GeekBox remote control

Sean Wang (3):
      [media] rc: add driver for IR remote receiver on MT7623 SoC
      [media] Documentation: devicetree: move shared property used by rc into a common place
      [media] Documentation: devicetree: Add document bindings for mtk-cir

Sean Young (5):
      [media] lirc: fix transmit-only read features
      [media] rc: remove excessive spaces from error message
      [media] lirc: LIRC_GET_MIN_TIMEOUT should be in range
      [media] lirc: fix null dereference for tx-only devices
      [media] rx51: broken build

 .../devicetree/bindings/media/gpio-ir-receiver.txt |   3 +-
 .../devicetree/bindings/media/hix5hd2-ir.txt       |   2 +-
 .../devicetree/bindings/media/mtk-cir.txt          |  24 ++
 Documentation/devicetree/bindings/media/rc.txt     | 116 +++++++
 .../devicetree/bindings/media/sunxi-ir.txt         |   2 +-
 arch/arm/mach-omap2/pdata-quirks.c                 |   2 +-
 drivers/media/rc/Kconfig                           |  11 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/ir-lirc-codec.c                   |   7 +-
 drivers/media/rc/keymaps/Makefile                  |   1 +
 drivers/media/rc/keymaps/rc-geekbox.c              |  55 ++++
 drivers/media/rc/lirc_dev.c                        |   2 +-
 drivers/media/rc/mtk-cir.c                         | 335 +++++++++++++++++++++
 drivers/media/rc/rc-main.c                         |   3 +-
 include/media/rc-map.h                             |   1 +
 15 files changed, 555 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/mtk-cir.txt
 create mode 100644 Documentation/devicetree/bindings/media/rc.txt
 create mode 100644 drivers/media/rc/keymaps/rc-geekbox.c
 create mode 100644 drivers/media/rc/mtk-cir.c
