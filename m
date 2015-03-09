Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:35467 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbbCINoM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 09:44:12 -0400
Message-ID: <54FDA380.8030405@linutronix.de>
Date: Mon, 09 Mar 2015 14:43:28 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
MIME-Version: 1.0
To: linux-i2c@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Mike Rapoport <mike@compulab.co.il>,
	Jean Delvare <khali@linux-fr.org>
Subject: rt-mutex usage in i2c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have two questions:

- em28xx_i2c_xfer() in drivers/media/usb/em28xx/em28xx-i2c.c takes a
  rt_mutex lock. This struct i2c_algorithm's ->master_xfer callback.
  Why does it take an extra lock since it looks to me that it is
  protected by struct i2c_adapter's bus_lock already.

- i2c_transfer() has this piece:
  2091                 if (in_atomic() || irqs_disabled()) {
  2092                         ret = i2c_trylock_adapter(adap);

  is this irqs_disabled() is what bothers me and should not be there.
  pxa does a spin_lock_irq() which would enable interrupts on return /
  too early.
  mxs has a wait_for_completion() which needs irqs enabled _and_ makes
  in_atomic() problematic, too. I have't checked other drivers but the
  commit, that introduced it, does not explain why it is required.
  So _should_ this be invoked from an interrupt handler (for instance),
  then it would record the wrong process as the lock owner. This isn't
  problematic unless on SMP the owner gets boosted because a process
  with a higher priority needs the lock.

Sebastian

