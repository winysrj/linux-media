Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:32878 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbdDITic (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:32 -0400
Received: by mail-wr0-f195.google.com with SMTP id l28so1779890wre.0
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:32 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 00/19] cxd2841er/ddbridge: support Sony CXD28xx hardware
Date: Sun,  9 Apr 2017 21:38:09 +0200
Message-Id: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Important note: This series depends on the stv0367/ddbridge series posted
earlier (patches 12 [1] and 13 [2], depending on the I2C functions and the
TDA18212 attach function).

This series improves the cxd2841er demodulator driver and adds some bits
to make it more versatile to be used in more scenarios. Also, the ddbridge
code is updated to recognize all hardware (PCIe cards/bridges and DuoFlex
modules) with Sony CXD28xx tuners, including the newly introduced MaxA8
eight-tuner C2T2 cards.

The series has been tested (together with the STV0367 series) on a wide
variety of cards, including CineCTv7, DuoFlex C(2)T2 modules and MaxA8
cards without any issues. Testing was done with TVHeadend, VDR and MythTV.

Note that the i2c_gate_ctrl() flag is needed in this series aswell since
the i2c_gate_ctrl function needs to be remapped and mutex_lock protected
for the same reasons as in the STV0367 series.

Besides printk() warnings, checkpatch.pl doesn't complain.

Comments and reviews appreciated.

[1] https://patchwork.linuxtv.org/patch/40398/
[2] https://patchwork.linuxtv.org/patch/40399/

Daniel Scheller (19):
  [media] dvb-frontends/cxd2841er: remove kernel log spam in non-debug
    levels
  [media] dvb-frontends/cxd2841er: do I2C reads in one go
  [media] dvb-frontends/cxd2841er: immediately unfreeze regs when done
  [media] dvb-frontends/cxd2841er: support CXD2837/38/43ER demods/Chip
    IDs
  [media] dvb-frontends/cxd2841er: replace IFFREQ calc macros into
    functions
  [media] dvb-frontends/cxd2841er: add variable for configuration flags
  [media] dvb-frontends/cxd2841er: make call to i2c_gate_ctrl optional
  [media] dvb-frontends/cxd2841er: support IF speed calc from tuner
    values
  [media] dvb-frontends/cxd2841er: TS_SERIAL config flag
  [media] dvb-frontends/cxd2841er: make ASCOT use optional
  [media] dvb-frontends/cxd2841er: optionally tune earlier in
    set_frontend()
  [media] dvb-frontends/cxd2841er: make lock wait in set_fe_tc()
    optional
  [media] dvb-frontends/cxd2841er: configurable IFAGCNEG
  [media] dvb-frontends/cxd2841er: more configurable TSBITS
  [media] dvb-frontends/cxd2841er: improved snr reporting
  [media] ddbridge: board control setup, ts quirk flags
  [media] ddbridge: add I2C functions, add XO2 module support
  [media] ddbridge: support for Sony CXD28xx C/C2/T/T2 tuner modules
  [media] ddbridge: hardware IDs for new C2T2 cards and other devices

 drivers/media/dvb-frontends/cxd2841er.c            | 302 +++++++++++------
 drivers/media/dvb-frontends/cxd2841er.h            |  10 +
 drivers/media/dvb-frontends/cxd2841er_priv.h       |   3 +
 drivers/media/pci/ddbridge/Kconfig                 |   3 +
 drivers/media/pci/ddbridge/ddbridge-core.c         | 356 ++++++++++++++++++++-
 drivers/media/pci/ddbridge/ddbridge-regs.h         |   4 +
 drivers/media/pci/ddbridge/ddbridge.h              |  40 ++-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |   3 +-
 8 files changed, 615 insertions(+), 106 deletions(-)

-- 
2.10.2
