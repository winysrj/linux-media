Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:38032 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbeC1RBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 13:01:24 -0400
Received: by mail-pl0-f65.google.com with SMTP id m22-v6so1961735pls.5
        for <linux-media@vger.kernel.org>; Wed, 28 Mar 2018 10:01:24 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        crope@iki.fi
Subject: [PATCH v4 0/5] dvb-usb-friio: decompose friio and merge with gl861
Date: Thu, 29 Mar 2018 02:00:56 +0900
Message-Id: <20180328170101.29385-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This series decomposes dvb-usb-friio into sub drivers
and merge the bridge driver with dvb-usb-gl861.
As to the demod & tuner drivers, existing drivers are re-used.

Changes since v3:
- dvb-pll,gl681: use i2c_device_id/i2c_board_info to specify pll_desc

Changes since v2:
- used the new i2c binding helpers instead of my own one
- extends dvb-pll instead of creating a new tuner driver
- merged gl861-friio.c with gl861.c
- improved module counting
- made i2c communications on USB robust (regarding DMA)

Replaces:
patch #27927, dvb: tua6034: add a new driver for Infineon tua6034 tuner
patch #27928, dvb-usb-friio: split and merge into dvb-usbv2-gl861

Akihiro Tsukada (5):
  dvb-frontends/dvb-pll: add i2c driver support
  dvb-frontends/dvb-pll: add tua6034 ISDB-T tuner used in Friio
  dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and merge with gl861
  dvb-usb-v2/gl861: use usleep_range() for short delay
  dvb-usb-v2/gl861: ensure  USB message buffers DMA'able

 drivers/media/dvb-frontends/dvb-pll.c |  86 ++++++
 drivers/media/dvb-frontends/dvb-pll.h |  26 ++
 drivers/media/usb/dvb-usb-v2/Kconfig  |   5 +-
 drivers/media/usb/dvb-usb-v2/gl861.c  | 485 ++++++++++++++++++++++++++++++-
 drivers/media/usb/dvb-usb-v2/gl861.h  |   1 +
 drivers/media/usb/dvb-usb/Kconfig     |   6 -
 drivers/media/usb/dvb-usb/Makefile    |   3 -
 drivers/media/usb/dvb-usb/friio-fe.c  | 441 ----------------------------
 drivers/media/usb/dvb-usb/friio.c     | 522 ----------------------------------
 drivers/media/usb/dvb-usb/friio.h     |  99 -------
 10 files changed, 591 insertions(+), 1083 deletions(-)
 delete mode 100644 drivers/media/usb/dvb-usb/friio-fe.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.h

-- 
2.16.3
