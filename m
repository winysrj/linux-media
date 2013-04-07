Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933981Ab3DGQKh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Apr 2013 12:10:37 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r37GAawC023269
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 7 Apr 2013 12:10:36 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH 0/2] rtl28xxu: add experimental support for r820t
Date: Sun,  7 Apr 2013 13:10:29 -0300
Message-Id: <1365351031-22079-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several rtl28xxu are currently shipped with a r820t tuner.
Add experimental suppor for it.

NOTE: I don't have DVB-T signal here, so I couldn't fully test the
driver. By sniffing the USB traffic from rtl-sdr and comparing with
this driver's traffic, it seems to be working fine, at least up to
tuner callibration. After that, I would need a DVB-T lock to test
the rest of the driver.

Mauro Carvalho Chehab (2):
  r820t: Add a tuner driver for Rafael Micro R820T silicon tuner
  rtl28xxu: add support for Rafael Micro r820t

 drivers/media/tuners/Kconfig            |    7 +
 drivers/media/tuners/Makefile           |    1 +
 drivers/media/tuners/r820t.c            | 1486 +++++++++++++++++++++++++++++++
 drivers/media/tuners/r820t.h            |   55 ++
 drivers/media/usb/dvb-usb-v2/Kconfig    |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |   30 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |    1 +
 7 files changed, 1581 insertions(+)
 create mode 100644 drivers/media/tuners/r820t.c
 create mode 100644 drivers/media/tuners/r820t.h

-- 
1.8.1.4

