Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-cys01nam02on0130.outbound.protection.outlook.com ([104.47.37.130]:5531
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932201AbdDQFKO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 01:10:14 -0400
Subject: Re: [PATCH v2 0/15] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
CC: "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
        <yasunari.takiguchi@sony.com>
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Message-ID: <5188b958-9a34-4519-5845-a318273592e0@sony.com>
Date: Mon, 17 Apr 2017 14:09:53 +0900
MIME-Version: 1.0
In-Reply-To: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017/04/14 10:50, Takiguchi, Yasunari wrote:
> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> Hi,
> 
> This is the patch series (version 2) of Sony CXD2880 DVB-T2/T tuner + demodulator driver.
> The driver supports DVB-API and interfaces through SPI.
> 
> We have tested the driver on Raspberry Pi 3 and got picture and sound from a media player.
> 
> Thanks,
> Takiguchi
> ---
>  Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt        |   14 ++++++++++++++
>  drivers/media/spi/cxd2880-spi.c                                     | 728 ++++++++++++++++++++++++++++++++++++++++
>  drivers/media/dvb-frontends/cxd2880/cxd2880.h                       |   46 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_common.c                |   84 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_common.h                |   86 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_io.c                    |   68 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_io.h                    |   62 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h                |   35 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c        |   71 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_math.c                  |   89 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_math.h                  |   40 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c             |  147 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h             |   40 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h                   |   51 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c            |  130 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h            |   45 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h                   |   50 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c                | 3925 ++++++++++++++++++++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h                |  395 ++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h |   29 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c            |  207 ++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h            |   52 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c                 |   99 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h                 |   44 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_top.c                   | 1550 ++++++++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h                  |   91 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c           | 1072 +++++++++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h           |   62 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c            |  197 ++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h            |   58 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c       | 1190 +++++++++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h       |  106 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h                 |  402 ++++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c          | 1309 ++++++++++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h          |   82 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c           |  311 +++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h           |   64 +
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c      | 2523 ++++++++++++++++++++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h      |  170 ++
>  drivers/media/dvb-frontends/Makefile                                |    1 +
>  drivers/media/dvb-frontends/cxd2880/Makefile                        |   21 +++++++++++++++++++++
>  drivers/media/spi/Makefile                                          |    5 +++++
>  drivers/media/dvb-frontends/Kconfig                                 |    2 ++
>  drivers/media/dvb-frontends/cxd2880/Kconfig                         |    6 ++++++
>  drivers/media/spi/Kconfig                                           |   14 ++++++++++++++
>  MAINTAINERS                                                         |    9 +++++++++
> 
>  46 files changed, 15782 insertions(+)
> 
>  create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
>  create mode 100644 drivers/media/spi/cxd2880-spi.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_stdlib.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/Makefile
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/Kconfig

I added change patches information from Version 1 to Version 2.

[Change list]
<V1->V2>
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
