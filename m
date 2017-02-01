Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49066 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752904AbdBAQrV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 11:47:21 -0500
Received: from [82.128.187.92] (helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <crope@iki.fi>)
        id 1cYy3u-0007Am-Gf
        for linux-media@vger.kernel.org; Wed, 01 Feb 2017 18:47:14 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.11] zd1301 usb interface + dvb-t demod driver
Message-ID: <3abc8f62-de05-25a0-64eb-e4c1f0880e9c@iki.fi>
Date: Wed, 1 Feb 2017 18:47:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c739c0a7c3c2472d7562b8f802cdce44d2597c8b:

   [media] s5k4ecgx: select CRC32 helper (2016-12-21 07:33:40 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git zd1301

for you to fetch changes up to 3b58fcff6d2578f83be4eb018274d6e82fcef426:

   mt2060: implement sleep (2017-01-27 18:44:37 +0200)

----------------------------------------------------------------
Antti Palosaari (7):
       mt2060: add i2c bindings
       mt2060: add param to split long i2c writes
       zd1301_demod: ZyDAS ZD1301 DVB-T demodulator driver
       MAINTAINERS: add zd1301_demod driver
       zd1301: ZyDAS ZD1301 DVB USB interface driver
       MAINTAINERS: add zd1301 DVB USB interface driver
       mt2060: implement sleep

  MAINTAINERS                                |  18 +++++
  drivers/media/dvb-core/dvb-usb-ids.h       |   1 +
  drivers/media/dvb-frontends/Kconfig        |   7 ++
  drivers/media/dvb-frontends/Makefile       |   1 +
  drivers/media/dvb-frontends/zd1301_demod.c | 551 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/dvb-frontends/zd1301_demod.h |  55 ++++++++++++++
  drivers/media/tuners/mt2060.c              | 125 
++++++++++++++++++++++++++++++--
  drivers/media/tuners/mt2060.h              |  23 ++++++
  drivers/media/tuners/mt2060_priv.h         |  11 +++
  drivers/media/usb/dvb-usb-v2/Kconfig       |   8 +++
  drivers/media/usb/dvb-usb-v2/Makefile      |   3 +
  drivers/media/usb/dvb-usb-v2/zd1301.c      | 294 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  12 files changed, 1093 insertions(+), 4 deletions(-)
  create mode 100644 drivers/media/dvb-frontends/zd1301_demod.c
  create mode 100644 drivers/media/dvb-frontends/zd1301_demod.h
  create mode 100644 drivers/media/usb/dvb-usb-v2/zd1301.c

-- 
http://palosaari.fi/
