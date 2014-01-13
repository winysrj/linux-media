Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaAMVgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 16:36:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/7] Multiple arch trivial fixups
Date: Mon, 13 Jan 2014 16:32:31 -0200
Message-Id: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a series of trivial fixups, solving a bunch of bugs reported
when compiling the media tree with allmodconfig/allyesconfig with
several architectures (47 archs).

There is one patch fixing up a compilation bug with ARCH=c6x:

	 lirc_parallel: avoid name conflict on mn10300 arch

The remaining patches are warning fixups. Two of them fixes
real bugs:
	dib8000: Properly represent long long integers
	go7007-usb: only use go->dev after allocated

The others just make the compiler shut up.

Mauro Carvalho Chehab (7):
  [media] sh_vou: comment unused vars
  [media] radio-usb-si4713: make si4713_register_i2c_adapter static
  [media] dib8000: Properly represent long long integers
  [media] dib8000: Fix a few warnings when compiled for avr32
  [media] go7007-usb: only use go->dev after allocated
  [media] lirc_parallel: avoid name conflict on mn10300 arch
  [media] tea575x: Fix build with ARCH=c6x

 drivers/media/dvb-frontends/dib8000.c         | 10 +++++-----
 drivers/media/platform/sh_vou.c               |  9 ++++-----
 drivers/media/radio/si4713/radio-usb-si4713.c |  2 +-
 drivers/media/radio/tea575x.c                 |  2 +-
 drivers/staging/media/go7007/go7007-usb.c     | 14 +++++++++-----
 drivers/staging/media/lirc/lirc_parallel.c    |  4 ++--
 drivers/staging/media/lirc/lirc_serial.c      |  4 ++--
 7 files changed, 24 insertions(+), 21 deletions(-)

-- 
1.8.3.1

