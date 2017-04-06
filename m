Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0109.outbound.protection.outlook.com ([104.47.40.109]:52148
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753930AbdDFHjp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 03:39:45 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Masayuki.Yamamoto@sony.com>, <Hideki.Nozawa@sony.com>,
        <Kota.Yonezawa@sony.com>, <Toshihiko.Matsumoto@sony.com>,
        <Satoshi.C.Watanabe@sony.com>, <Yasunari.Takiguchi@jp.sony.com>,
        "Yasunari Takiguchi" <Yasunari.Takiguchi@sony.com>
Subject: [PATCH 0/5] dt-bindings: media: Add document file and driver 
Date: Thu, 6 Apr 2017 16:42:18 +0900
Message-ID: <1491464538-7651-1-git-send-email-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

Hi,

This is the patch series of Sony CXD2880 DVB-T2/T tuner + demodulator driver.
The driver supports DVB-API and interfaces through SPI.

We have tested the driver on Raspberry Pi 3 and got picture and sound from a media player.

Thanks,
Takiguchi
---
 Documentation//devicetree/bindings/media/spi/sony-cxd2880.txt        |   14 ++++++++++++++
 drivers/media/spi/Kconfig                                            |   14 +
 drivers/media/spi/Makefile                                           |    5 +
 drivers/media/spi/cxd2880-spi.c                                      |  727 +++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/Kconfig                                  |    2 +
 drivers/media/dvb-frontends/Makefile                                 |    1 +
 drivers/media/dvb-frontends/cxd2880/Kconfig                          |    6 +
 drivers/media/dvb-frontends/cxd2880/Makefile                         |   22 +
 drivers/media/dvb-frontends/cxd2880/cxd2880.h                        |   46 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c                 |   84 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h                 |   86 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c              |  147 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h              |   40 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h                    |   50 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c                  |   99 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h                  |   44 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c                     |   68 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h                     |   62 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_math.c                   |   89 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_math.h                   |   40 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h                    |   51 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c             |  130 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h             |   45 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h                 |   35 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c         |   71 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c                 | 3925 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h                 |  395 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h  |   29 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c             |  207 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h             |   52 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c                    | 1550 ++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h                   |   91 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h                  |  402 ++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c             |  197 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h             |   58 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c            |  311 +++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h            |   64 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c            | 1072 +++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h            |   62 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c           | 1309 ++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h           |   82 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c       | 2523 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h       |  170 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c        | 1190 +++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h        |  106 +
 MAINTAINERS                                                          |    9 +++++++++
 46 files changed, 15782 insertions(+)

 create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
 create mode 100644 drivers/media/spi/cxd2880-spi.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Kconfig
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Makefile
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
-- 
1.7.9.5
