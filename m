Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57264 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbbC0XuT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 19:50:19 -0400
Received: from dyn3-82-128-186-254.psoas.suomi.net ([82.128.186.254] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1Ybe12-0000Jh-IL
	for linux-media@vger.kernel.org; Sat, 28 Mar 2015 01:50:16 +0200
Message-ID: <5515ECB7.3050702@iki.fi>
Date: Sat, 28 Mar 2015 01:50:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 4.1] TS2020 / TS2022
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add TS2022 support to TS2020 driver. Relative small changes were
needed. Add I2C binding to TS2020. Switch TS2022 users to TS2020
and finally drop obsolete TS2022.

Antti

The following changes since commit 8a56b6b5fd6ff92b7e27d870b803b11b751660c2:

   [media] v4l2-subdev: remove enum_framesizes/intervals (2015-03-23 
12:02:41 -0700)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git ts2020_pull

for you to fetch changes up to 23e73a15c8056b6a2a923a8fe6b9a20141b6274d:

   ts2020: do not use i2c_transfer() on sleep() (2015-03-27 02:17:23 +0200)

----------------------------------------------------------------
Antti Palosaari (8):
       ts2020: add support for TS2022
       ts2020: implement I2C client bindings
       em28xx: switch PCTV 461e to ts2020 driver
       cx23885: switch ts2022 to ts2020 driver
       smipcie: switch ts2022 to ts2020 driver
       dvbsky: switch ts2022 to ts2020 driver
       m88ts2022: remove obsolete driver
       ts2020: do not use i2c_transfer() on sleep()

  MAINTAINERS                             |  10 ---
  drivers/media/dvb-frontends/ts2020.c    | 302 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
  drivers/media/dvb-frontends/ts2020.h    |  25 ++++++-
  drivers/media/pci/cx23885/Kconfig       |   1 -
  drivers/media/pci/cx23885/cx23885-dvb.c |  30 ++++-----
  drivers/media/pci/smipcie/Kconfig       |   2 +-
  drivers/media/pci/smipcie/smipcie.c     |  12 ++--
  drivers/media/tuners/Kconfig            |   8 ---
  drivers/media/tuners/m88ts2022.c        | 579 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
  drivers/media/tuners/m88ts2022.h        |  54 ----------------
  drivers/media/tuners/m88ts2022_priv.h   |  35 ----------
  drivers/media/usb/dvb-usb-v2/Kconfig    |   2 +-
  drivers/media/usb/dvb-usb-v2/dvbsky.c   |  26 ++++----
  drivers/media/usb/em28xx/Kconfig        |   2 +-
  drivers/media/usb/em28xx/em28xx-dvb.c   |  13 ++--
  15 files changed, 331 insertions(+), 770 deletions(-)
  delete mode 100644 drivers/media/tuners/m88ts2022.c
  delete mode 100644 drivers/media/tuners/m88ts2022.h
  delete mode 100644 drivers/media/tuners/m88ts2022_priv.h
[
-- 
http://palosaari.fi/
