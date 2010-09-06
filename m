Return-path: <mchehab@gaivota>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56426 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0IFQ1S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 12:27:18 -0400
Received: by qwh6 with SMTP id 6so3946886qwh.19
        for <linux-media@vger.kernel.org>; Mon, 06 Sep 2010 09:27:18 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Sep 2010 12:27:18 -0400
Message-ID: <AANLkTimzWfh3v8+MN2nQBQ-p_K=pc+xLYhGAoBtJO424@mail.gmail.com>
Subject: [GIT PULL REQUEST] IR updates for 2.6.36
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

Please pull the streamzap in-kernel decoding support patch and a
trivial mceusb driver patch that just adds two new device IDs in for
2.6.36.

The following changes since commit 67ac062a5138ed446a821051fddd798a01478f85:

  V4L/DVB: Fix regression for BeholdTV Columbus (2010-08-24 10:39:32 -0300)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-lirc.git staging

Jarod Wilson (2):
      IR/streamzap: functional in-kernel decoding
      mceusb: add two new ASUS device IDs

 drivers/media/IR/Kconfig                    |   12 +
 drivers/media/IR/Makefile                   |    1 +
 drivers/media/IR/ir-core-priv.h             |    6 +
 drivers/media/IR/ir-rc5-sz-decoder.c        |  153 ++++++++++++
 drivers/media/IR/ir-sysfs.c                 |    1 +
 drivers/media/IR/keymaps/Makefile           |    2 +-
 drivers/media/IR/keymaps/rc-rc5-streamzap.c |   81 ------
 drivers/media/IR/keymaps/rc-streamzap.c     |   82 ++++++
 drivers/media/IR/mceusb.c                   |    4 +
 drivers/media/IR/streamzap.c                |  358 +++++++--------------------
 include/media/rc-map.h                      |    5 +-
 11 files changed, 356 insertions(+), 349 deletions(-)
 create mode 100644 drivers/media/IR/ir-rc5-sz-decoder.c
 delete mode 100644 drivers/media/IR/keymaps/rc-rc5-streamzap.c
 create mode 100644 drivers/media/IR/keymaps/rc-streamzap.c


-- 
Jarod Wilson
jarod@wilsonet.com
