Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50221 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751983AbdKFKkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 05:40:22 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] lirc improvements
Date: Mon,  6 Nov 2017 10:40:15 +0000
Message-Id: <cover.1509964131.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series depend on the lirc scancode and lirc kapi removal
series.

This implements correct locking for lirc and allows the chardev to be
opened more than once.

Sean Young (5):
  media: rc: move ir-lirc-codec.c contents into lirc_dev.c
  media: rc: include <uapi/linux/lirc.h> rather than <media/lirc.h>
  media: lirc: allow lirc device to opened more than once
  media: lirc: improve locking
  media: rc: iguanair: remove unnecessary locking

 drivers/media/rc/Makefile        |   2 +-
 drivers/media/rc/iguanair.c      |  28 --
 drivers/media/rc/ir-lirc-codec.c | 637 --------------------------------
 drivers/media/rc/lirc_dev.c      | 771 ++++++++++++++++++++++++++++++++++++---
 drivers/media/rc/rc-core-priv.h  |   2 -
 include/media/lirc.h             |   1 -
 include/media/rc-core.h          |  56 +--
 7 files changed, 760 insertions(+), 737 deletions(-)
 delete mode 100644 drivers/media/rc/ir-lirc-codec.c
 delete mode 100644 include/media/lirc.h

-- 
2.13.6
