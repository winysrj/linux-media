Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57385 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932627AbeAOJ61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 04:58:27 -0500
From: Sean Young <sean@mess.org>
To: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 0/5] new driver for Ahanix D.Vine 5 IR/VFD
Date: Mon, 15 Jan 2018 09:58:19 +0000
Message-Id: <cover.1516008708.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a newer driver for this device. It originally supported by the
lirc_sasem.c staging driver, which was removed in kernel v4.12.

Here a some more information about the hardware and my attempts to
understand it:

http://www.mess.org/2018/01/17/Ahanix-D-Vine-5-IR-VFD-module/

Sean Young (5):
  auxdisplay: charlcd: no need to call charlcd_gotoxy() if nothing
    changes
  auxdisplay: charlcd: add flush function
  auxdisplay: charlcd: add escape sequence for brightness on NEC
    µPD16314
  media: rc: add keymap for Dign Remote
  media: rc: new driver for Sasem Remote Controller VFD/IR

 MAINTAINERS                        |   6 +
 drivers/auxdisplay/charlcd.c       |  33 ++++-
 drivers/media/rc/Kconfig           |  16 ++
 drivers/media/rc/Makefile          |   1 +
 drivers/media/rc/keymaps/Makefile  |   1 +
 drivers/media/rc/keymaps/rc-dign.c |  70 +++++++++
 drivers/media/rc/sasem_ir.c        | 297 +++++++++++++++++++++++++++++++++++++
 include/media/rc-map.h             |   1 +
 include/misc/charlcd.h             |   1 +
 9 files changed, 421 insertions(+), 5 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-dign.c
 create mode 100644 drivers/media/rc/sasem_ir.c

-- 
2.14.3
