Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56641 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752182AbZLCWMA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 17:12:00 -0500
Message-ID: <4B1837B5.2010508@gmx.net>
Date: Thu, 03 Dec 2009 23:12:05 +0100
From: Ivo Steinmann <ivo_steinmann@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Endless loop with error messages
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all

After some uptime, I allways get an endless loop of these messages:

Dec  3 21:55:21 mediaserv kernel: [118604.764577] saa7146:
interrupt_hw(): warning: interrupt enabled, but not handled
properly.(0xe7fcfbb7)
Dec  3 21:55:21 mediaserv kernel: [118604.764580] saa7146:
interrupt_hw(): disabling interrupt source(s)!
Dec  3 21:55:21 mediaserv kernel: [118604.764591] saa7146 (1):
unexpected i2c irq: isr e7fffbb7 psr ffffffff ssr ffffffff
Dec  3 21:55:21 mediaserv kernel: [118604.764594] saa7146:
interrupt_hw(): warning: interrupt enabled, but not handled
properly.(0xe7fcfbb7)
Dec  3 21:55:21 mediaserv kernel: [118604.764597] saa7146:
interrupt_hw(): disabling interrupt source(s)!
Dec  3 21:55:21 mediaserv kernel: [118604.765299] saa7146 (1):
unexpected i2c irq: isr e7fffbb7 psr ffffffff ssr ffffffff
Dec  3 21:55:21 mediaserv kernel: [118604.765302] saa7146:
interrupt_hw(): warning: interrupt enabled, but not handled
properly.(0xe7fcfbb7)
Dec  3 21:55:21 mediaserv kernel: [118604.765305] saa7146:
interrupt_hw(): disabling interrupt source(s)!
Dec  3 21:55:21 mediaserv kernel: [118604.767852] saa7146 (3):
unexpected i2c irq: isr e7fffbb7 psr ffffffff ssr ffffffff
Dec  3 21:55:21 mediaserv kernel: [118604.767855] saa7146:
interrupt_hw(): warning: interrupt enabled, but not handled
properly.(0xe7fcfbb7)
Dec  3 21:55:21 mediaserv kernel: [118604.767858] saa7146:
interrupt_hw(): disabling interrupt source(s)!
Dec  3 21:55:21 mediaserv kernel: [118604.775192] saa7146 (1):
unexpected i2c irq: isr e7fffbb7 psr ffffffff ssr ffffffff
Dec  3 21:55:21 mediaserv kernel: [118604.775194] saa7146:
interrupt_hw(): warning: interrupt enabled, but not handled
properly.(0xe7fcfbb7)
Dec  3 21:55:21 mediaserv kernel: [118604.775197] saa7146:
interrupt_hw(): disabling interrupt source(s)!
Dec  3 21:55:21 mediaserv kernel: [118604.777377] saa7146 (3):
unexpected i2c irq: isr e7fffbb7 psr ffffffff ssr ffffffff


The CPU usage is 100% in both cores, and the machine is really locked.
Login in console takes about 5minutes. Each keystroke around 20sec.

I unloaded these modules
budget_av
budget_ci
budget_core
saa7146_vv
saa7146

The the machine is usable again.

Linux xxxxx 2.6.31.4 #3 SMP Mon Nov 16 12:29:18 CET 2009 x86_64 GNU/Linux

-Ivo Steinmann

