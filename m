Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab3DQAnA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:43:00 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0h05A002419
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:43:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 00/31] Add r820t support at rtl28xxu
Date: Tue, 16 Apr 2013 21:42:11 -0300
Message-Id: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a tuner driver for Rafael Micro R820T silicon tuner.

This tuner seems to be popular those days. Add support for it
at rtl28xxu.

This tuner was written from scratch, based on rtl-sdr driver.

Mauro Carvalho Chehab (31):
  [media] r820t: Add a tuner driver for Rafael Micro R820T silicon tuner
  [media] rtl28xxu: add support for Rafael Micro r820t
  [media] r820t: Give a better estimation of the signal strength
  [media] r820t: Set gain mode to auto
  [media] rtl28xxu: use r820t to obtain the signal strength
  [media] r820t: proper lock and set the I2C gate
  [media] rtl820t: Add a debug msg when PLL gets locked
  [media] r820t: Fix IF scale
  [media] rtl2832: add code to bind r820t on it
  [media] r820t: use the right IF for the selected TV standard
  [media] rtl2832: properly set en_bbin for r820t
  [media] r820t: Invert bits for read ops
  [media] r820t: use the second table for 7MHz
  [media] r820t: Show the read data in the bit-reversed order
  [media] r820t: add support for diplexer
  [media] r820t: better report signal strength
  [media] r820t: split the function that read cached regs
  [media] r820t: fix prefix of the r820t_read() function
  [media] r820t: use usleep_range()
  [media] r820t: proper initialize the PLL register
  [media] r820t: add IMR calibrate code
  [media] r820t: add a commented code for GPIO
  [media] r820t: Allow disabling IMR callibration
  [media] r820t: avoid rewrite all regs when not needed
  [media] r820t: Don't put it in standby if not initialized yet
  [media] r820t: fix PLL calculus
  [media] r820t: Fix hp_cor filter mask
  [media] r820t: put it into automatic gain mode
  [media] rtl2832: Fix IF calculus
  [media] r820t: disable auto gain/VGA setting
  [media] r820t: Don't divide the IF by two

 drivers/media/dvb-frontends/rtl2832.c      |   85 +-
 drivers/media/dvb-frontends/rtl2832.h      |    1 +
 drivers/media/dvb-frontends/rtl2832_priv.h |   28 +
 drivers/media/tuners/Kconfig               |    7 +
 drivers/media/tuners/Makefile              |    1 +
 drivers/media/tuners/r820t.c               | 2352 ++++++++++++++++++++++++++++
 drivers/media/tuners/r820t.h               |   58 +
 drivers/media/usb/dvb-usb-v2/Kconfig       |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |   34 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h    |    1 +
 10 files changed, 2548 insertions(+), 20 deletions(-)
 create mode 100644 drivers/media/tuners/r820t.c
 create mode 100644 drivers/media/tuners/r820t.h

-- 
1.8.1.4

