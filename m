Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:40773 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752208AbeDHRWH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 13:22:07 -0400
Received: by mail-pl0-f65.google.com with SMTP id x4-v6so3707283pln.7
        for <linux-media@vger.kernel.org>; Sun, 08 Apr 2018 10:22:07 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        crope@iki.fi
Subject: [PATCH v5 0/5] dvb-usb-friio: decompose friio and merge with gl861
Date: Mon,  9 Apr 2018 02:21:33 +0900
Message-Id: <20180408172138.9974-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This series decomposes dvb-usb-friio into sub drivers
and merge the bridge driver with dvb-usb-gl861.
As to the demod & tuner drivers, existing drivers are re-used.

Changes since v4:
- dvb-pll,gl861: do not #define chip name constants
- i2c algo of gl861 is not (yet?) changed as proposed by Antti,
  (which is to move the special case handling to demod driver),
  since I do not yet understand
  whether it should/can be really moved or not.

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

 drivers/media/dvb-frontends/dvb-pll.c |  86 +++++
 drivers/media/dvb-frontends/dvb-pll.h |   5 +
 drivers/media/usb/dvb-usb-v2/Kconfig  |   5 +-
 drivers/media/usb/dvb-usb-v2/gl861.c  | 485 +++++++++++++++++++++++-
 drivers/media/usb/dvb-usb-v2/gl861.h  |   1 +
 drivers/media/usb/dvb-usb/Kconfig     |   6 -
 drivers/media/usb/dvb-usb/Makefile    |   3 -
 drivers/media/usb/dvb-usb/friio-fe.c  | 441 ----------------------
 drivers/media/usb/dvb-usb/friio.c     | 522 --------------------------
 drivers/media/usb/dvb-usb/friio.h     |  99 -----
 10 files changed, 570 insertions(+), 1083 deletions(-)
 delete mode 100644 drivers/media/usb/dvb-usb/friio-fe.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.h

-- 
2.17.0
