Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:42566 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752070AbdIGXhp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 19:37:45 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23993950AbdIGXd6rVQhk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 01:33:58 +0200
Date: Fri, 8 Sep 2017 01:33:55 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 00/10] media: rc: gpio-ir-recv: driver update
Message-ID: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch serie brings driver closer to recently used APIs
and removes no longer used gpio_ir_recv_platform_data
support.

It was done as an excercise before writing similar driver using
FIQ and hw timers as this one gives too imprecise timing.

Serie was rebased on top of current linux.git, but something
happened there and my userspace decoder no longer works: driver
reports completely bogus timing such as (rc-5):
^427, _1342, ^945, _183, ^1128, _671, ^1586, _91, ^1189, _1525,
^1738, _1433, ^915, _1159, ^1464, _1525, ^213, _1067, ^793, _0
(^ used for pulse and _ for space)
As it has nothing to do with my changes, I'm sending it anyway
for review, which I do not expect to happen until merge window
ends.

Ladislav Michl (10):
  media: rc: gpio-ir-recv: use helper vaiable to acess device info
  media: rc: gpio-ir-recv: use devm_kzalloc
  media: rc: gpio-ir-recv: use devm_rc_allocate_device
  media: rc: gpio-ir-recv: use devm_gpio_request_one
  media: rc: gpio-ir-recv: use devm_rc_register_device
  media: rc: gpio-ir-recv: do not allow threaded interrupt handler
  media: rc: gpio-ir-recv: use devm_request_irq
  media: rc: gpio-ir-recv: use KBUILD_MODNAME
  media: rc: gpio-ir-recv: remove gpio_ir_recv_platform_data
  media: rc: gpio-ir-recv: use gpiolib API

 drivers/media/rc/Kconfig                         |   1 +
 drivers/media/rc/gpio-ir-recv.c                  | 194 ++++++-----------------
 include/linux/platform_data/media/gpio-ir-recv.h |  23 ---
 3 files changed, 53 insertions(+), 165 deletions(-)
 delete mode 100644 include/linux/platform_data/media/gpio-ir-recv.h

-- 
2.11.0
