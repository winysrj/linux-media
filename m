Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43884 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759367AbaGRBOh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 21:14:37 -0400
Message-ID: <53C874F8.3020300@iki.fi>
Date: Fri, 18 Jul 2014 04:14:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL] SDR stuff
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* AirSpy SDR driver
* all SDR drivers moved out of staging
* few new SDR stream formats

regards
Antti


The following changes since commit 3445857b22eafb70a6ac258979e955b116bfd2c6:

   [media] hdpvr: fix two audio bugs (2014-07-04 15:13:02 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git sdr_pull

for you to fetch changes up to 1c3378e1c17d6acd9b6d392ff75addad4c63cc6c:

   MAINTAINERS: add airspy driver (2014-07-18 04:12:27 +0300)

----------------------------------------------------------------
Antti Palosaari (23):
       v4l: uapi: add SDR format RU12LE
       DocBook: V4L: add V4L2_SDR_FMT_RU12LE - 'RU12'
       airspy: AirSpy SDR driver
       v4l: uapi: add SDR format CS8
       DocBook: V4L: add V4L2_SDR_FMT_CS8 - 'CS08'
       v4l: uapi: add SDR format CS14
       DocBook: V4L: add V4L2_SDR_FMT_CS14LE - 'CS14'
       msi001: move out of staging
       MAINTAINERS: update MSI001 driver location
       Kconfig: add SDR support
       Kconfig: sub-driver auto-select SPI bus
       msi2500: move msi3101 out of staging and rename
       MAINTAINERS: update MSI3101 / MSI2500 driver location
       msi2500: change supported formats
       msi2500: print notice to point SDR API is not 100% stable yet
       rtl2832_sdr: move from staging to media
       rtl2832_sdr: put complex U16 format behind module parameter
       rtl2832_sdr: print notice to point SDR API is not 100% stable yet
       MAINTAINERS: update RTL2832_SDR location
       airspy: remove v4l2-compliance workaround
       airspy: move out of staging into drivers/media/usb
       airspy: print notice to point SDR API is not 100% stable yet
       MAINTAINERS: add airspy driver

  Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml 
        |   44 ++++
  Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml 
        |   47 +++++
  Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml 
        |   40 ++++
  Documentation/DocBook/media/v4l/pixfmt.xml 
        |    3 +
  MAINTAINERS 
        |   18 +-
  drivers/media/Kconfig 
        |   12 +-
  drivers/media/dvb-frontends/Kconfig 
        |    9 +
  drivers/media/dvb-frontends/Makefile 
        |    6 +
  drivers/{staging/media/rtl2832u_sdr => 
media/dvb-frontends}/rtl2832_sdr.c    |   21 +-
  drivers/{staging/media/rtl2832u_sdr => 
media/dvb-frontends}/rtl2832_sdr.h    |    0
  drivers/media/tuners/Kconfig 
        |    6 +
  drivers/media/tuners/Makefile 
        |    1 +
  drivers/{staging/media/msi3101 => media/tuners}/msi001.c 
        |    0
  drivers/media/usb/Kconfig 
        |    6 +
  drivers/media/usb/Makefile 
        |    2 +
  drivers/media/usb/airspy/Kconfig 
        |   10 +
  drivers/media/usb/airspy/Makefile 
        |    1 +
  drivers/media/usb/airspy/airspy.c 
        | 1122 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/usb/dvb-usb-v2/Kconfig 
        |    1 +
  drivers/media/usb/msi2500/Kconfig 
        |    5 +
  drivers/media/usb/msi2500/Makefile 
        |    1 +
  drivers/{staging/media/msi3101/sdr-msi3101.c => 
media/usb/msi2500/msi2500.c} |   47 +++--
  drivers/staging/media/Kconfig 
        |    4 -
  drivers/staging/media/Makefile 
        |    2 -
  drivers/staging/media/msi3101/Kconfig 
        |   10 -
  drivers/staging/media/msi3101/Makefile 
        |    2 -
  drivers/staging/media/rtl2832u_sdr/Kconfig 
        |    7 -
  drivers/staging/media/rtl2832u_sdr/Makefile 
        |    6 -
  include/uapi/linux/videodev2.h 
        |    3 +
  29 files changed, 1375 insertions(+), 61 deletions(-)
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml
  rename drivers/{staging/media/rtl2832u_sdr => 
media/dvb-frontends}/rtl2832_sdr.c (98%)
  rename drivers/{staging/media/rtl2832u_sdr => 
media/dvb-frontends}/rtl2832_sdr.h (100%)
  rename drivers/{staging/media/msi3101 => media/tuners}/msi001.c (100%)
  create mode 100644 drivers/media/usb/airspy/Kconfig
  create mode 100644 drivers/media/usb/airspy/Makefile
  create mode 100644 drivers/media/usb/airspy/airspy.c
  create mode 100644 drivers/media/usb/msi2500/Kconfig
  create mode 100644 drivers/media/usb/msi2500/Makefile
  rename drivers/{staging/media/msi3101/sdr-msi3101.c => 
media/usb/msi2500/msi2500.c} (98%)
  delete mode 100644 drivers/staging/media/msi3101/Kconfig
  delete mode 100644 drivers/staging/media/msi3101/Makefile
  delete mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
  delete mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile

-- 
http://palosaari.fi/
