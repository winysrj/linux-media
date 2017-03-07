Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0091.outbound.protection.outlook.com ([104.47.32.91]:15638
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754299AbdCGBWe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 20:22:34 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Subject: [RFC PATCH 0/5] Document: Add document file for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Tue, 7 Mar 2017 10:05:08 +0900
Message-ID: <1488848708-8358-1-git-send-email-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

Hi,

This is a patch series of Sony CXD2880 DVB-T2/T tuner + demodulator driver.  
It supports DVB-API and interfaces through SPI.  

We have tested the driver on Raspberry Pi 3 and got picture and sound from a media player.  


Regarding this third Beta Release, the status is:
- Tested on Raspberry Pi 3.
- Compiled on Linux 4.10.
- The DVB-API operates under dvbv5 tools.
- No error/warning from checkpatch.pl

Feedback is appreciated.  


Thanks,
Takiguchi

---
 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt               |   16 ++++++++++++++++
 drivers/media/spi/Kconfig                                                  |   14 +
 drivers/media/spi/Makefile                                                 |    5 +
 drivers/media/spi/cxd2880-spi.c                                            |  737 +++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/Kconfig                                        |    2 +
 drivers/media/dvb-frontends/Makefile                                       |    1 +
 drivers/media/dvb-frontends/cxd2880/Kconfig                                |    6 +
 drivers/media/dvb-frontends/cxd2880/Makefile                               |   22 +
 drivers/media/dvb-frontends/cxd2880/cxd2880.h                              |   37 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c                       |   84 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h                       |   85 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c                    |  145 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h                    |   40 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h                          |   50 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c                        |  101 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h                        |   44 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c                           |   68 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h                           |   62 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_math.c                         |   89 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_math.h                         |   40 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h                          |   51 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c                   |  130 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h                   |   45 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h                       |   35 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c               |   73 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c                       | 3936 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h                       |  395 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h        |   29 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c                   |  207 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h                   |   52 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c                          | 1558 ++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h                         |   91 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h                        |  402 ++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c                   |  197 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h                   |   58 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c                  |  311 +++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h                  |   64 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c                  | 1074 +++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h                  |   62 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c                 | 1312 ++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h                 |   82 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c             | 2545 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h             |  170 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c              | 1192 +++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h              |  106 +
 MAINTAINERS                                                                |    9 +++++++++
 46 files changed, 15834 insertions(+)
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
1.7.9.5
