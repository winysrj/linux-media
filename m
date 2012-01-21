Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4g7o021347
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/35] Add a driver for Terratec H7
Date: Sat, 21 Jan 2012 14:04:02 -0200
Message-Id: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terratec H7 is a Cypress FX2 device with a mt2063 tuner and a drx-k
demod. This series add support for it. It started with a public
tree found at:
	 http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz

The driver were almost completely re-written, and it is now working,
at least with DVB-C. I don't have a DVB-T signal here for testing,
but I suspect it should also work fine.

The FX2 firmware has a NEC IR decoder. The driver has support for
it. The default keytable has support for the black Terratec IR
and for the grey IR with orange keys.

The CI support inside the driver is similar to the one found at the
az6027 driver. I don't have a CI module here, so it is not tested.

Tests and feedback are welcome.

Mauro Carvalho Chehab (35):
  [media] dvb: Add a new driver for az6007
  [media] az6007: Fix compilation troubles at az6007
  [media] az6007: Fix it to allow loading it without crash
  [media] az6007: Fix the I2C code in order to handle mt2063
  [media] az6007: Comment the gate_ctl mutex
  [media] az6007: Remove some dead code that doesn't seem to be needed
  [media] az6007: CodingStyle cleanup
  [media] az6007: Get rid of az6007.h
  [media] az6007: Replace the comments at the beginning of the driver
  [media] az6007: move device PID's to the proper place
  [media] az6007: make driver less verbose
  [media] drxk: Don't assume a default firmware name
  [media] az6007: need to define drivers name before including dvb-usb.h
  [media] az6007: Fix some init sequences and use the right firmwares
  [media] az6007: Change the az6007 read/write routine parameter
  [media] az6007: Simplify the read/write logic
  [media] az6007: Simplify the code by removing an uneeded function
  [media] az6007: Fix IR receive code
  [media] az6007: improve the error messages for az6007 read/write calls
  [media] az6007: Use the new MFE support at dvb-usb
  [media] az6007: Change it to use the MFE solution adopted at dvb-usb
  [media] az6007: Use a per device private struct
  [media] drxk: Allow setting it on dynamic_clock mode
  [media] az6007: Use DRX-K dynamic clock mode
  [media] drxk: add support for Mpeg output clock drive strength config
  [media] drxk: Allow enabling MERR/MVAL cfg
  [media] az6007: code cleanups and fixes
  [media] az6007: Driver cleanup
  [media] az6007: Protect read/write calls with a mutex
  [media] az6007: Be sure to use kmalloc'ed buffer for transfers
  [media] az6007: Fix IR handling
  [media] az6007: Convert IR to use the rc_core logic
  [media] az6007: Use the right keycode for Terratec H7
  [media] az6007: Enable the driver at the building system
  [media] az6007: CodingStyle fixes

 drivers/media/common/tuners/mt2063.c               |    2 +-
 drivers/media/dvb/ddbridge/ddbridge-core.c         |    1 +
 drivers/media/dvb/dvb-usb/Kconfig                  |    8 +
 drivers/media/dvb/dvb-usb/Makefile                 |    4 +-
 drivers/media/dvb/dvb-usb/az6007.c                 |  581 ++++++++++++++++++++
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    2 +
 drivers/media/dvb/frontends/drxk.h                 |   23 +-
 drivers/media/dvb/frontends/drxk_hard.c            |   41 +-
 drivers/media/dvb/frontends/drxk_hard.h            |    1 +
 drivers/media/dvb/ngene/ngene-cards.c              |    1 +
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |   52 ++
 11 files changed, 690 insertions(+), 26 deletions(-)
 create mode 100644 drivers/media/dvb/dvb-usb/az6007.c

-- 
1.7.8

