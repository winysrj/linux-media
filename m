Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099AbaE2MUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 08:20:25 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: [PATCH 0/5] Partially fix a longstanding Kconfig issue with dib0700
Date: Thu, 29 May 2014 09:20:12 -0300
Message-Id: <1401366017-19874-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series partially fix a longstand Kconfig issue
with dib0700 and their frontend drivers: depending how
options are selected, build errors are generated.

This is partial because it only fixes the issues with
two frontends: dib7000p and dib8000 (the ones I have
devices here for testing). The very same approach can
be used by other devices, but I currently have no ways to
test. So, let's apply those changes first and hope that
someone could either do the patches or donte me some samples.

If none happen, I'll likely just replicate the same solution
on other frontends and post at the ML for others to test.

There's just one practical functional changes on this series:
now, devices will not load dib8000 and/or dib7000p if one
(or the two) frontends are not used by a particular device.

Except for that, no other change should be noticed.

Mauro Carvalho Chehab (5):
  dvbdev: add a dvb_detach() macro
  dib7000p: rename dib7000p_attach to dib7000p_init
  dib7000: export just one symbol
  dib8000: rename dib8000_attach to dib8000_init
  dib8000: export just one symbol

 drivers/media/dvb-core/dvb_frontend.c       |   8 +-
 drivers/media/dvb-core/dvbdev.h             |   4 +
 drivers/media/dvb-frontends/dib7000p.c      |  72 +++--
 drivers/media/dvb-frontends/dib7000p.h      | 131 ++------
 drivers/media/dvb-frontends/dib8000.c       |  88 +++---
 drivers/media/dvb-frontends/dib8000.h       | 150 ++-------
 drivers/media/pci/cx23885/cx23885-dvb.c     |   8 +-
 drivers/media/usb/dvb-usb/cxusb.c           |  39 ++-
 drivers/media/usb/dvb-usb/dib0700_devices.c | 464 ++++++++++++++++++----------
 9 files changed, 484 insertions(+), 480 deletions(-)

-- 
1.9.3

