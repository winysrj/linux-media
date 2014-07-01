Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55531 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbaGATzk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jul 2014 15:55:40 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, crope@iki.fi
Subject: [PATCH 0/4] wintv 930c-hd: Add basic support
Date: Tue,  1 Jul 2014 21:55:14 +0200
Message-Id: <1404244518-8636-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is the third version of my si2165 driver.
It supports only DVB-T and was tested on 8MHz channels in germany.

Maybe the si2165 driver also works on other si2165/si2163/si2161 based cards.

Regards
Matthias



 Documentation/dvb/get_dvb_firmware         |   33 +-
 drivers/media/dvb-frontends/Kconfig        |    9 +
 drivers/media/dvb-frontends/Makefile       |    1 +
 drivers/media/dvb-frontends/si2165.c       | 1036 ++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/si2165.h       |   61 ++
 drivers/media/dvb-frontends/si2165_priv.h  |   23 +
 drivers/media/pci/cx23885/Kconfig          |    1 +
 drivers/media/pci/cx23885/cx23885-cards.c  |   17 +-
 drivers/media/pci/cx23885/cx23885-dvb.c    |   43 +-
 drivers/media/usb/cx231xx/Kconfig          |    1 +
 drivers/media/usb/cx231xx/cx231xx-avcore.c |    1 +
 drivers/media/usb/cx231xx/cx231xx-cards.c  |   92 +++
 drivers/media/usb/cx231xx/cx231xx-core.c   |    3 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c    |   32 +
 drivers/media/usb/cx231xx/cx231xx.h        |    1 +
 15 files changed, 1345 insertions(+), 9 deletions(-)

