Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaG1SH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 14:07:28 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/4] au0828: add support for IR decoding
Date: Mon, 28 Jul 2014 15:07:18 -0300
Message-Id: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828 chipset have a built-in IR decoder, at au8522. Add
support for it to decode both NEC and RC5 protocols.

Unfortunately, it is not possible to have a fully generic
IR decode, as this chipset is not able to detect the initial
pulse.

Mauro Carvalho Chehab (4):
  au0828: improve I2C speed
  rc-main: allow raw protocol drivers to restrict the allowed protos
  au0828: add support for IR on HVR-950Q
  ir-rc5-decoder: print the failed count

 drivers/media/rc/ir-rc5-decoder.c       |   4 +-
 drivers/media/rc/rc-main.c              |   5 +-
 drivers/media/usb/au0828/Kconfig        |   7 +
 drivers/media/usb/au0828/Makefile       |   4 +
 drivers/media/usb/au0828/au0828-cards.c |   7 +-
 drivers/media/usb/au0828/au0828-core.c  |  25 +-
 drivers/media/usb/au0828/au0828-i2c.c   |  23 +-
 drivers/media/usb/au0828/au0828-input.c | 391 ++++++++++++++++++++++++++++++++
 drivers/media/usb/au0828/au0828.h       |  11 +
 9 files changed, 455 insertions(+), 22 deletions(-)
 create mode 100644 drivers/media/usb/au0828/au0828-input.c

-- 
1.9.3

