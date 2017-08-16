Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0110.outbound.protection.outlook.com ([104.47.38.110]:55120
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750827AbdHPEOC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 00:14:02 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v3 00/14] [dt-bindings] [media] Add document file and driver for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Wed, 16 Aug 2017 13:17:14 +0900
Message-ID: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

Hi,

This is the patch series (version 3) of Sony CXD2880 DVB-T2/T tuner + demodulator driver.
The driver supports DVB-API and interfaces through SPI.

We have tested the driver on Raspberry Pi 3 and got picture and sound from a media player.

The change history of this patch series is as below.

[Change list]
Changes in V3
(1)Total patch number was changed from 15 to 14,
   due to the all files of [PATCH v2 04/15] were removed.
       drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
          -Removed
       drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
          -Removed

(2)Removed another file.
       drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
          -Removed 

(3)The detail change items of each files are as below.
    [PATCH v3 01/14]
       Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
          -no change
    [PATCH v3 02/14]
       drivers/media/spi/cxd2880-spi.c
          -adjusted of indent spaces
          -removed unnecessary cast
          -changed debugging code
          -changed timeout method
          -modified coding style of if()
          -changed hexadecimal code to lower case. 
    [PATCH v3 03/14]
       drivers/media/dvb-frontends/cxd2880/cxd2880.h
          -no change
       drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
          -changed MASKUPPER/MASKLOWER with GENMASK 
       drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
          -removed definition NULL and SONY_SLEEP
          -changed CXD2880_SLEEP to usleep_range
          -changed cxd2880_atomic_set to atomic_set
          -removed cxd2880_atomic struct and cxd2880_atomic_read
          -changed stop-watch function
          -modified return code
       drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
          -removed unnecessary cast
          -modified return code
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
          -modified return code 
       drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
          -changed CXD2880_SLEEP to usleep_range
          -changed stop-watch function
          -modified return code
       #drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
          -cxd2880_stdlib.h file was removed from V3.
    [PATCH v3 04/14]
       drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
          -removed unnecessary cast
          -changed cxd2880_memcpy to memcpy
          -modified return code
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
          -modified return code
       drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
          -modified return code
       drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
          -removed unnecessary cast
          -modified return code
       drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
          -modified return code
    [PATCH v3 05/14]
       drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
          -removed code relevant to ISDB-T
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
          -removed unnecessary cast
          -removed code relevant to ISDB-T
          -changed CXD2880_SLEEP to usleep_range
          -changed cxd2880_memset to memset 
          -changed cxd2880_atomic_set to atomic_set
          -modified return code
          -modified coding style of if()
          -changed to use const values at writing a lot of registers 
           with a command. 
          -changed hexadecimal code to lower case. 
          -adjusted of indent spaces
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
          -removed code relevant to ISDB-T
          -changed cxd2880_atomic struct to atomic_t
          -modified return code
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
          -updated version information
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
          -changed CXD2880_SLEEP to usleep_range
          -removed unnecessary cast
          -modified return code
          -modified coding style of if() 
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
          -modified return code
    [PATCH v3 06/14]
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
          -changed cxd2880_atomic_read to atomic_read
          -changed cxd2880_atomic_set to atomic_set
          -modified return code
          -modified coding style of if() 
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
          -modified return code
    [PATCH v3 07/14]
       drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
          -adjusted indent spaces
          -modified debugging code
          -removed unnecessary cast
          -modified return code
          -modified coding style of if() 
          -modified about measurement period of PER/BER.
          -changed hexadecimal code to lower case. 
    [PATCH v3 08/14]
       drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
          -no change
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
          -modified return code
          -modified coding style of if() 
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
          -modified return code
    [PATCH v3 09/14]
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
          -changed CXD2880_SLEEP to usleep_range
          -chnaged cxd2880_atomic_set to atomic_set
          -modified return code
          -modified coding style of if() 
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
          -modified return code
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
          -removed unnecessary cast
          -changed cxd2880_math_log to intlog10
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
          -modified return code
    [PATCH v3 10/14]
       drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
          -modified return code
          -modified coding style of if() 
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
          -modified return code
    [PATCH v3 11/14]
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
          -changed CXD2880_SLEEP to usleep_range
          -replaced cxd2880_atomic_set to atomic_set
          -modified return code
          -modified coding style of if()  
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
          -modified return code
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
          -removed unnecessary cast
          -changed cxd2880_math_log to intlog10
          -modified return code
          -modified coding style of if() 
          -changed hexadecimal code to lower case. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
          -modified return code
    [PATCH v3 12/14]
       drivers/media/dvb-frontends/Makefile
          -no change
       drivers/media/dvb-frontends/cxd2880/Makefile
          -removed cxd2880_math.o \ 
       drivers/media/spi/Makefile
          -no change
    [PATCH v3 13/14]
       drivers/media/dvb-frontends/Kconfig
          -no change
       drivers/media/dvb-frontends/cxd2880/Kconfig
          -no change
       drivers/media/spi/Kconfig
          -no change
    [PATCH v3 14/14]
       MAINTAINERS
          -no change

Changes in V2
(1)[PATCH 2/5], [PATCH 3/5] and [PATCH 4/5] of version 1 were divided to change order and be small size patch.
    Total patch number was changed from 5 to 15

   <Previous>
   The changed or created files of version 1 [PATCH 2/5], [PATCH 3/5] and [PATCH 4/5]:
      [PATCH 2/5]
      drivers/media/spi/Kconfig
      drivers/media/spi/Makefile
      drivers/media/spi/cxd2880-spi.c
      [PATCH 3/5]
      drivers/media/dvb-frontends/Kconfig
      drivers/media/dvb-frontends/Makefile
      drivers/media/dvb-frontends/cxd2880/Kconfig
      drivers/media/dvb-frontends/cxd2880/Makefile
      drivers/media/dvb-frontends/cxd2880/cxd2880.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
    [PATCH 4/5]
      drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h

   <New>
   The changed or created files of version 2 from [PATCH v2 02/15] to [PATCH v2 14/15]:
    [PATCH v2 02/15]
      drivers/media/spi/cxd2880-spi.c
    [PATCH v2 03/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
    [PATCH v2 04/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
    [PATCH v2 05/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
    [PATCH v2 06/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
    [PATCH v2 07/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
    [PATCH v2 08/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
    [PATCH v2 09/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
    [PATCH v2 10/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
    [PATCH v2 11/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
    [PATCH v2 12/15]
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
      drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
    [PATCH v2 13/15]
      drivers/media/dvb-frontends/Makefile
      drivers/media/dvb-frontends/cxd2880/Makefile
      drivers/media/spi/Makefile
    [PATCH v2 14/15]
      drivers/media/dvb-frontends/Kconfig
      drivers/media/dvb-frontends/cxd2880/Kconfig
      drivers/media/spi/Kconfig

(2)Modified PID filter setting.
    drivers/media/spi/cxd2880-spi.c in [PATCH v2 02/15]

(3)Driver version up
    drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h in [PATCH v2 06/15]

Thanks,
Takiguchi
---
 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt        | 14 ++++++++++++++
 drivers/media/spi/cxd2880-spi.c                                     | 697 ++++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880.h                       | 46 +++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c                | 38 ++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h                | 50 ++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c                    | 68 ++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h                    | 62 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c        | 60 +++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c             | 146 +++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h             |  40 ++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h                   |  51 +++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c            | 130 ++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h            |  43 ++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h                   |   46 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c                | 4030 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h                |  391 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h |   29 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c            |  221 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h            |   52 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c                 | 98 ++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h                 | 44 ++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c                   | 1879 +++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h                  |   91 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c           | 1115 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h           |   62 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c            |  198 ++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h            |   58 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c       | 1227 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h       |  106 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h                 |  402 ++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c          | 1359 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h          |   82 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c           |  312 +++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h           |   64 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c      | 2622 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h      |  170 ++
 drivers/media/dvb-frontends/Makefile                                |  1 +
 drivers/media/dvb-frontends/cxd2880/Makefile                        | 20 ++++++++++++++++++++
 drivers/media/spi/Makefile                                          |  5 +++++
 drivers/media/dvb-frontends/Kconfig                                 |  2 ++
 drivers/media/dvb-frontends/cxd2880/Kconfig                         |  6 ++++++
 drivers/media/spi/Kconfig                                           | 14 ++++++++++++++
 MAINTAINERS                                                         | 9 +++++++++

 43 files changed, 16160 insertions(+)

 create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
 create mode 100644 drivers/media/spi/cxd2880-spi.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Makefile
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Kconfig
2.11.0
