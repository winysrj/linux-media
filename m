Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45160 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbcBNCcL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 21:32:11 -0500
Received: from dyn3-82-128-190-33.psoas.suomi.net ([82.128.190.33] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1aUmTp-0008Io-Tb
	for linux-media@vger.kernel.org; Sun, 14 Feb 2016 04:32:09 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: mn88473: move out of staging
Message-ID: <56BFE729.2000608@iki.fi>
Date: Sun, 14 Feb 2016 04:32:09 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 210bd104c6acd31c3c6b8b075b3f12d4a9f6b60d:

   [media] xc2028: unlock on error in xc2028_set_config() (2016-02-04 
09:30:31 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git mn88473_pull

for you to fetch changes up to 05886118dd140b4d96cf4de5c76b4fb6155316f5:

   rtl2832: move stats polling to read status (2016-02-14 04:29:33 +0200)

----------------------------------------------------------------
Antti Palosaari (4):
       mn88473: move out of staging
       mn88473: finalize driver
       rtl2832: improve slave TS control
       rtl2832: move stats polling to read status

  MAINTAINERS 
|   4 +-
  drivers/media/dvb-frontends/Kconfig 
|   8 +++
  drivers/media/dvb-frontends/Makefile 
|   1 +
  drivers/{staging/media/mn88473 => media/dvb-frontends}/mn88473.c 
| 388 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------
  drivers/media/dvb-frontends/mn88473.h 
|  14 ++---
  drivers/{staging/media/mn88473 => media/dvb-frontends}/mn88473_priv.h 
|   7 +--
  drivers/media/dvb-frontends/rtl2832.c 
| 151 +++++++++++++++++++++-----------------------
  drivers/media/dvb-frontends/rtl2832.h 
|   4 +-
  drivers/media/dvb-frontends/rtl2832_priv.h 
|   1 -
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c 
|  24 +++----
  drivers/staging/media/Kconfig 
|   2 -
  drivers/staging/media/Makefile 
|   1 -
  drivers/staging/media/mn88473/Kconfig 
|   7 ---
  drivers/staging/media/mn88473/Makefile 
|   5 --
  drivers/staging/media/mn88473/TODO 
|  21 -------
  15 files changed, 340 insertions(+), 298 deletions(-)
  rename drivers/{staging/media/mn88473 => 
media/dvb-frontends}/mn88473.c (61%)
  rename drivers/{staging/media/mn88473 => 
media/dvb-frontends}/mn88473_priv.h (89%)
  delete mode 100644 drivers/staging/media/mn88473/Kconfig
  delete mode 100644 drivers/staging/media/mn88473/Makefile
  delete mode 100644 drivers/staging/media/mn88473/TODO


-- 
http://palosaari.fi/
