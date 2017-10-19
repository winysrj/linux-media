Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52253 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752635AbdJSUxb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 16:53:31 -0400
Date: Thu, 19 Oct 2017 21:53:30 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.15] More RC patches
Message-ID: <20171019205330.mbn3cecsva6qsibf@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Two new keymaps, convert the serial_ir to the new timer api and a fix
for the imon driver.

Thanks
Sean

The following changes since commit 61065fc3e32002ba48aa6bc3816c1f6f9f8daf55:

  Merge commit '3728e6a255b5' into patchwork (2017-10-17 17:22:20 -0700)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.15c

for you to fetch changes up to 1a2d258a6b10c7d275aa9064b6741c109b4f7422:

  media: rc/keymaps: add support for RC of hisilicon poplar board (2017-10-19 19:17:33 +0100)

----------------------------------------------------------------
Arvind Yadav (1):
      media: imon: Fix null-ptr-deref in imon_probe

Kees Cook (1):
      media: serial_ir: Convert timers to use timer_setup()

Younian Wang (2):
      media: rc/keymaps: add support for RC of hisilicon TV demo boards
      media: rc/keymaps: add support for RC of hisilicon poplar board

 drivers/media/rc/imon.c                    |  5 ++
 drivers/media/rc/keymaps/Makefile          |  2 +
 drivers/media/rc/keymaps/rc-hisi-poplar.c  | 69 +++++++++++++++++++++++++
 drivers/media/rc/keymaps/rc-hisi-tv-demo.c | 81 ++++++++++++++++++++++++++++++
 drivers/media/rc/serial_ir.c               |  5 +-
 5 files changed, 159 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-poplar.c
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-tv-demo.c
