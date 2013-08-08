Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993Ab3HHQwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 12:52:08 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?q?Alfredo=20Jes=C3=BAs=20Delaiti?=
	<alfredodelaiti@netscape.net>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 0/3] Experimental patches for ISDB-T on Mygica X8502/X8507
Date: Thu,  8 Aug 2013 13:51:49 -0300
Message-Id: <1375980712-9349-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a first set of experimental patches for Mygica X8502/X8507.

The last patch is just a very dirty hack, for testing purposes. I intend
to get rid of it, but it is there to replace exactly the same changes that
Alfredo reported to work on Kernel 3.2.

I intend to remove it on a final series, eventually replacing by some
other changes at mb86a20s.

Alfredo,

Please test, and send your tested-by, if this works for you.

Thanks!
Mauro

Mauro Carvalho Chehab (3):
  cx23885-dvb: use a better approach to hook set_frontend
  cx23885: Add DTV support for Mygica X8502/X8507 boards
  mb86a20s: hack it to emulate what x8502 driver does

 drivers/media/dvb-frontends/mb86a20s.c    | 100 ++++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/Kconfig         |   1 +
 drivers/media/pci/cx23885/cx23885-cards.c |   4 +-
 drivers/media/pci/cx23885/cx23885-dvb.c   |  49 ++++++++++++---
 drivers/media/pci/cx23885/cx23885.h       |   2 +
 5 files changed, 147 insertions(+), 9 deletions(-)

-- 
1.8.3.1

