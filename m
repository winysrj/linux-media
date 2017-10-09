Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40319 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdJILuD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:50:03 -0400
Date: Mon, 9 Oct 2017 12:50:01 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.15] RC fixes
Message-ID: <20171009115001.lxz35g2mqr2lbnqb@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is the new tango driver and some fixes to ensure drivers which depend
on device tree, only build if device tree is enabled (or test compile). 

Please note that MAINTAINERS already has an entry for tango, which matches
the new driver.

Thanks,
Sean

The following changes since commit c1301077213d4dca34f01fc372b64d3c4a49a437:

  [media] media: rc: fix gpio-ir-receiver build failure (2017-10-05 10:16:21 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.15b

for you to fetch changes up to d4218fbb8c47457c172a60ccc7f0baec7ce1f6f6:

  media: rc: ir-spi needs OF (2017-10-09 11:27:29 +0100)

----------------------------------------------------------------
David Härdeman (1):
      media: lirc_dev: remove min_timeout and max_timeout

Mans Rullgard (1):
      media: rc: Add driver for tango HW IR decoder

Marc Gonzalez (2):
      media: rc: Add tango keymap
      media: dt: bindings: Add binding for tango HW IR decoder

Sean Young (6):
      media: rc: nec decoder should not send both repeat and keycode
      media: rc: gpio-ir-tx does not work without devicetree or gpiolib
      media: rc: pwm-ir-tx needs OF
      media: rc: hix5hd2 drivers needs OF
      media: rc: check for integer overflow
      media: rc: ir-spi needs OF

 .../devicetree/bindings/media/tango-ir.txt         |  21 ++
 drivers/media/rc/Kconfig                           |  14 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/ir-lirc-codec.c                   |   9 +-
 drivers/media/rc/ir-nec-decoder.c                  |  29 ++-
 drivers/media/rc/keymaps/Makefile                  |   1 +
 drivers/media/rc/keymaps/rc-tango.c                |  92 +++++++
 drivers/media/rc/lirc_dev.c                        |  18 --
 drivers/media/rc/tango-ir.c                        | 281 +++++++++++++++++++++
 include/media/lirc_dev.h                           |   6 -
 include/media/rc-map.h                             |   1 +
 11 files changed, 434 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/tango-ir.txt
 create mode 100644 drivers/media/rc/keymaps/rc-tango.c
 create mode 100644 drivers/media/rc/tango-ir.c
