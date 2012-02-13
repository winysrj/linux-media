Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46271 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab2BMRCj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 12:02:39 -0500
Message-ID: <4F39422B.9080307@iki.fi>
Date: Mon, 13 Feb 2012 19:02:35 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.4] Realtek RTL2831U
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Mauro,

That is driver for the old Realtek RTL2831U chip. RTL2831U integrates 
RTL2830 DVB-T demodulator and USB-bridge. Same USB-bridge driver can be 
used for new RTL2832U but new demodulator driver is needed.

regards
Antti


The following changes since commit 38bd588789243b0bd66706cda2e970f213710def:

   anysee: repeat failed USB control messages (2012-01-21 20:00:37 +0200)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git realtek

Antti Palosaari (9):
       Realtek RTL2830 DVB-T demodulator driver
       Realtek RTL28xxU serie DVB USB interface driver
       rtl28xx: fix rtl2831u with tuner mxl5005s
       rtl28xx: initial support for rtl2832u
       rtl28xx: reimplement I2C adapter
       rtl2830: correct I2C functionality
       rtl28xxu: make it compile against current Kernel
       rtl28xxu: many small tweaks
       rtl2830: prevent .read_status() when sleeping

  drivers/media/dvb/dvb-usb/Kconfig          |   10 +
  drivers/media/dvb/dvb-usb/Makefile         |    3 +
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |    4 +
  drivers/media/dvb/dvb-usb/rtl28xxu.c       |  978 
++++++++++++++++++++++++++++
  drivers/media/dvb/dvb-usb/rtl28xxu.h       |  264 ++++++++
  drivers/media/dvb/frontends/Kconfig        |    7 +
  drivers/media/dvb/frontends/Makefile       |    1 +
  drivers/media/dvb/frontends/rtl2830.c      |  562 ++++++++++++++++
  drivers/media/dvb/frontends/rtl2830.h      |   97 +++
  drivers/media/dvb/frontends/rtl2830_priv.h |   57 ++
  10 files changed, 1983 insertions(+), 0 deletions(-)
  create mode 100644 drivers/media/dvb/dvb-usb/rtl28xxu.c
  create mode 100644 drivers/media/dvb/dvb-usb/rtl28xxu.h
  create mode 100644 drivers/media/dvb/frontends/rtl2830.c
  create mode 100644 drivers/media/dvb/frontends/rtl2830.h
  create mode 100644 drivers/media/dvb/frontends/rtl2830_priv.h


-- 
http://palosaari.fi/
