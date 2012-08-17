Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52323 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199Ab2HQBfm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 21:35:42 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/6] DVB API LNA
Date: Fri, 17 Aug 2012 04:35:04 +0300
Message-Id: <1345167310-8738-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LNA API	and one	implementation as for example. 

Implementation relies Kernel GPIOLIB as	LNAs are typically controlled
by GPIO. Anyhow, GPIOLIB seems to be disabled by default thus I was
forced to add some glue macros to handle situation where GPIOLIB is
not available. But lets try to found out solution / reason later for
that GPIOLIB part.

Antti Palosaari (6):
  add LNA support for DVB API
  cxd2820r: switch to Kernel dev_* logging
  cxd2820r: use Kernel GPIO for GPIO access
  em28xx: implement FE set_lna() callback
  cxd2820r: use static GPIO config when GPIOLIB is undefined
  DVB API: LNA documentation

 Documentation/DocBook/media/dvb/dvbproperty.xml |  16 ++
 drivers/media/dvb-core/dvb_frontend.c           |   5 +
 drivers/media/dvb-core/dvb_frontend.h           |   1 +
 drivers/media/dvb-frontends/cxd2820r.h          |  14 +-
 drivers/media/dvb-frontends/cxd2820r_c.c        |  31 ++--
 drivers/media/dvb-frontends/cxd2820r_core.c     | 211 ++++++++++++++++++------
 drivers/media/dvb-frontends/cxd2820r_priv.h     |  22 +--
 drivers/media/dvb-frontends/cxd2820r_t.c        |  33 ++--
 drivers/media/dvb-frontends/cxd2820r_t2.c       |  31 ++--
 drivers/media/usb/dvb-usb-v2/anysee.c           |   2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c           |  51 +++++-
 include/linux/dvb/frontend.h                    |   4 +-
 include/linux/dvb/version.h                     |   2 +-
 13 files changed, 287 insertions(+), 136 deletions(-)

-- 
1.7.11.2

