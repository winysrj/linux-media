Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34805 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbeCZSIQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 14:08:16 -0400
Received: by mail-pf0-f193.google.com with SMTP id q9so1108925pff.1
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2018 11:08:16 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 0/5] dvb-usb-friio: decompose friio and merge with gl861
Date: Tue, 27 Mar 2018 03:06:47 +0900
Message-Id: <20180326180652.5385-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This series decomposes dvb-usb-friio into sub drivers
and merge the bridge driver with dvb-usb-gl861.
As to the demod & tuner drivers, existing drivers are re-used.

Changes since v2
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

 drivers/media/dvb-frontends/dvb-pll.c |  67 +++++
 drivers/media/dvb-frontends/dvb-pll.h |   7 +
 drivers/media/usb/dvb-usb-v2/Kconfig  |   5 +-
 drivers/media/usb/dvb-usb-v2/gl861.c  | 488 ++++++++++++++++++++++++++++++-
 drivers/media/usb/dvb-usb-v2/gl861.h  |   1 +
 drivers/media/usb/dvb-usb/Kconfig     |   6 -
 drivers/media/usb/dvb-usb/Makefile    |   3 -
 drivers/media/usb/dvb-usb/friio-fe.c  | 441 ----------------------------
 drivers/media/usb/dvb-usb/friio.c     | 522 ----------------------------------
 drivers/media/usb/dvb-usb/friio.h     |  99 -------
 10 files changed, 556 insertions(+), 1083 deletions(-)
 delete mode 100644 drivers/media/usb/dvb-usb/friio-fe.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.h

-- 
2.16.2
