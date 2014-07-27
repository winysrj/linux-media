Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaG0T1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 15:27:39 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 0/6] cx231xx: don't OOPS when probe fails
Date: Sun, 27 Jul 2014 16:27:26 -0300
Message-Id: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx231xx relies on a code that detects the possible PCB
settings. However, there are several troubles there:

1) The number of interfaces are read from the wrong place;
2) The code doesn't check if the interface is past the data;
3) If the code that read the PCB config fails, it keeps
   running using some random data.

All of those issues can happen when a bad cabling is used,
causing the Kernel to OOPS.

Mauro Carvalho Chehab (6):
  cx231xx: Fix the max number of interfaces
  cx231xx: Don't let an interface number to go past the array
  cx231xx: use devm_ functions to allocate memory
  cx231xx: handle errors at read_eeprom()
  cx231xx: move analog init code to a separate function
  cx231xx: return an error if it can't read PCB config

 drivers/media/usb/cx231xx/cx231xx-cards.c   | 265 +++++++++++++++-------------
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c |  10 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h |   2 +-
 3 files changed, 150 insertions(+), 127 deletions(-)

-- 
1.9.3

