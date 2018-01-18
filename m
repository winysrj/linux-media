Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03hn0240.outbound.protection.outlook.com ([104.47.40.240]:6048
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750841AbeARIbR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 03:31:17 -0500
From: Yasunari@vger.kernel.org, Takiguchi@vger.kernel.org
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v5 00/12] [dt-bindings] [media] Add document file and driver for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Thu, 18 Jan 2018 17:34:36 +0900
Message-ID: <20180118083436.20632-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

Hi,

This is the patch series (version 5) of Sony CXD2880 DVB-T2/T tuner + 
demodulator driver.The driver supports DVB-API and interfaces through 
SPI.

We have tested the driver on Raspberry Pi 3 and got picture and sound 
from a media player.

The change history of this patch series is as below.

[Change list]
Changes in V5
(1)Using SPDX-License-Identifier instead of 
   repeating the copyright notes.

(2)Removed a file.
    This below file is removed because we changed stop_watch 
   function to ktime.

   [PATCH v5 03/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
          -removed

(3)The detail change items of each files are as below.
    [PATCH v5 02/12]
       Using SPDX-License-Identifier
       drivers/media/spi/cxd2880-spi.c
         -modified typo about "ivnalid" -> "invalid"
         -modified typo about "drvier" -> "driver"
         -removed unnecessary if() 
         -modified return error code
         -reduction of valiable names
         -removed unnecessary parentheses 
         -changed members of struct cxd2880_ts_buf_info

    [PATCH v5 03/12]
       Using SPDX-License-Identifier
       drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
         -modified return not to use ret parameter. 
       drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
         -removed unnecessary parentheses
       drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
         -removed function proto type about cxd2880_stopwatch
         -removed CXD2880_ARG_UNUSED
       #drivers/media/dvb-frontends/cxd2880/cxd2880_stopwatch_port.c
         -cxd2880_stopwatch_port.c file was removed from V5.

    [PATCH v5 04/12]
       Using SPDX-License-Identifier
       drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
         -modified return error code
         -removed unnecessary parentheses 
       drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
         -removed unnecessary parentheses

    [PATCH v5 05/12]
       Using SPDX-License-Identifier
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
         -removed unnecessary if()
         -modified if (ret) return ret;
         -modified return error code
         -removed unnecessary parentheses
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
         -removed struct cxd2880_tnrdmd_ts_buf_info
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
         -removed unnecessary if()        
         -modified return error code
         -removed unnecessary parentheses
         -removed cxd2880_tnrdmd_mon_ts_buf_info() 
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
         -removed cxd2880_tnrdmd_mon_ts_buf_info()  
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
          -updated version information

    [PATCH v5 06/12]
       Using SPDX-License-Identifier
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
         -removed unnecessary if() 
         -changed timer function from stop_watch to ktime
   
    [PATCH v5 07/12]
       Using SPDX-License-Identifier
       drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
         -changed define position of cxd2880_dvbt_t2_ops
         -modified typo about "drvier" -> "driver"
         -removed unnecessary cast
         -removed unnecessary if() 
         -modified return error code
         -removed unnecessary parentheses 
         -modified for "Lines should not end with a '(' "
         -modified to return constant 0 from read_ber function

    [PATCH v5 08/12]
       Using SPDX-License-Identifier
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
         -removed unnecessary if()        
         -modified return error code
         -removed unnecessary parentheses 

    [PATCH v5 09/12]
       Using SPDX-License-Identifier
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
         -removed unnecessary if()        
         -modified return error code
         -removed unnecessary parentheses 
         -modified for "Lines should not end with a '(' "
         -removed unnecessary functions
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
         -removed unnecessary functions

    [PATCH v5 10/12]
       Using SPDX-License-Identifier
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
         -removed unnecessary if()        
         -modified return error code
         -removed unnecessary parentheses 

    [PATCH v5 11/12]
       Using SPDX-License-Identifier
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
         -removed unnecessary if()        
         -modified return error code
         -removed unnecessary parentheses 
         -modified for "Lines should not end with a '(' "
         -removed unnecessary functions
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
         -removed unnecessary functions

    [PATCH v5 12/12]
       drivers/media/dvb-frontends/cxd2880/Makefile
          -Using SPDX-License-Identifier
          -removed cxd2880_stopwatch_port.o
       drivers/media/dvb-frontends/cxd2880/Kconfig
          -Using SPDX-License-Identifier

Changes in V4
(1)Total patch number was changed from 14 to 12.
     We put [PATCH v3 12/14], [PATCH v3 13/14] and [PATCH v3 14/14]
   in [PATCH v4 12/12].

(2)Removed another file.
     These below files were removed because we changed it so that
   demodulator does not wait for locking the signal.

    [PATCH v4 09/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
          -removed
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
          -removed
    [PATCH v4 11/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
          -removed
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
          -removed

(3)The detail change items of each files are as below.
    [PATCH v4 02/12]
       drivers/media/spi/cxd2880-spi.c
          -removed Camel case
          -removed unnecessary initialization at variable declaration
          -removed unnecessary brace {}

    [PATCH v4 03/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
          -removed unnecessary initialization at variable declaration
          -modified how to write consecutive registers

    [PATCH v4 04/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
          -removed unnecessary initialization at variable declaration

    [PATCH v4 05/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
          -used over 80 columns limit, it makes fine to read codes
          -removed unnecessary initialization at variable declaration
          -modified how to write consecutive registers
          -removed unnecessary brace {}
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
          -adjusted of indent spaces of macro
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
          -updated version information
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
          -removed unnecessary brace {}

    [PATCH v4 06/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
          -removed unnecessary initialization at variable declaration

    [PATCH v4 07/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
          -modified typo "inavlid" to "invalid" at pr_err
          -removed unnecessary initialization at variable declaration
          -removed unnecessary brace {}
          -changed to use cxd2880_dvbt_tune and cxd2880_dvbt2_tune 
           instead of cxd2880_integ_dvbt_tune and cxd2880_integ_dvbt2_tune
            (because we changed it so that demodulator does not 
             wait for locking the signal.) 

    [PATCH v4 08/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
          -used over 80 columns limit, it makes fine to read codes
          -removinteed unnecessary initialization at variable declaration
          -removed unnecessary brace {}
          -modified how to write consecutive registers

    [PATCH v4 09/12]
       #drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
          -cxd2880_integ_dvbt.c file was removed from V4.
       #drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
          -cxd2880_integ_dvbt.h file was removed from V4.
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
          -removed unnecessary initialization at variable declaration
          -removed unnecessary brace {}
          -changed position of static const (to top part of the file)

    [PATCH v4 10/12]
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
          -removed unnecessary initialization at variable declaration
          -removed unnecessary brace {}
          -modified how to write consecutive registers

    [PATCH v4 11/12]
       #drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
          -cxd2880_integ_dvbt2.c file was removed from V4.
       #drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
          -cxd2880_integ_dvbt2.h file was removed from V4.
       drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
          -removed unnecessary initialization at variable declaration
          -removed unnecessary brace {}
          -changed position of static const (to top part of the file)

    [PATCH v4 12/12]
       drivers/media/dvb-frontends/cxd2880/Makefile
          -removed cxd2880_integ_dvbt2.o and cxd2880_integ_dvbt.o 

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
          -removed cxd2880_math.o 
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
(1)[PATCH 2/5], [PATCH 3/5] and [PATCH 4/5] of version 1 
   were divided to change order and be small size patch.
    Total patch number was changed from 5 to 15

   <Previous>
   The changed or created files of version 1 
   [PATCH 2/5], [PATCH 3/5] and [PATCH 4/5]:
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
   The changed or created files of version 2 
   from [PATCH v2 02/15] to [PATCH v2 14/15]:
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
    drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
    in [PATCH v2 06/15]

Thanks,
Takiguchi
---
 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt        | 14 ++++++++++++++
 drivers/media/spi/cxd2880-spi.c                                     | 670 ++++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880.h                       | 29 ++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c                | 21 +++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h                | 19 +++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c                    | 66 ++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h                    | 54 ++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c             | 129 +++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h             |  23 ++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h                   |  34 ++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c            | 113 ++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h            |  26 +++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h                   |   29 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c                | 3519 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h                |  365 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h |   12 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c            |  150 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h            |   29 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c                 | 72 ++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h                 | 27 ++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c                   | 1954 +++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h                  |  74 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c           | 919 +++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h           |  45 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c       | 775 +++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h       |  77 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h                 |  385 +++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c          | 1217 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h          |   65 ++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c      | 1878 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h      |  135 ++
 MAINTAINERS                                                         |  9 +++++++++
 drivers/media/dvb-frontends/Kconfig                                 |  2 ++
 drivers/media/dvb-frontends/Makefile                                |  1 +
 drivers/media/dvb-frontends/cxd2880/Kconfig                         |  8 ++++++++
 drivers/media/dvb-frontends/cxd2880/Makefile                        | 19 +++++++++++++++++++
 drivers/media/spi/Kconfig                                           | 14 ++++++++++++++
 drivers/media/spi/Makefile                                          |  5 +++++

 38 files changed, 12983 insertions(+)

 create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
 create mode 100644 drivers/media/spi/cxd2880-spi.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
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
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Kconfig
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Makefile
2.11.0
