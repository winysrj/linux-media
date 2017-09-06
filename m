Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37710 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751938AbdIFIIB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 04:08:01 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990506AbdIFIH62l2v4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 10:07:58 +0200
Date: Wed, 6 Sep 2017 10:07:48 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 00/10] media: rc: gpio-ir-recv: driver update
Message-ID: <20170906080748.wgxbmunfsu33bd6x@lenoch>
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
 drivers/media/rc/gpio-ir-recv.c                  | 191 +++++++----------------
 include/linux/platform_data/media/gpio-ir-recv.h |  23 ---
 3 files changed, 58 insertions(+), 157 deletions(-)
 delete mode 100644 include/linux/platform_data/media/gpio-ir-recv.h

-- 
2.11.0
