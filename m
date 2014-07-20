Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53790 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaGTQlK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jul 2014 12:41:10 -0400
Message-ID: <53CBF123.5090204@iki.fi>
Date: Sun, 20 Jul 2014 19:41:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] SDR stuff
References: <53C874F8.3020300@iki.fi>
In-Reply-To: <53C874F8.3020300@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2014 04:14 AM, Antti Palosaari wrote:
> * AirSpy SDR driver
> * all SDR drivers moved out of staging
> * few new SDR stream formats

Added few patches more.

Antti

The following changes since commit 3445857b22eafb70a6ac258979e955b116bfd2c6:

   [media] hdpvr: fix two audio bugs (2014-07-04 15:13:02 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git sdr_pull

for you to fetch changes up to 57c6d1bcea459f50bfe1b8a47f575655deca888a:

   airspy: fill FMT buffer size (2014-07-20 19:37:34 +0300)

----------------------------------------------------------------
Antti Palosaari (28):
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
       v4l: videodev2: add buffer size to SDR format
       rtl2832_sdr: fill FMT buffer size
       DocBook media: v4l2_sdr_format buffersize field
       msi2500: fill FMT buffer size
       airspy: fill FMT buffer size

  Documentation/DocBook/media/v4l/dev-sdr.xml 
        |   18 +-
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
media/dvb-frontends}/rtl2832_sdr.c    |   48 +++--
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
        | 1134 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/usb/dvb-usb-v2/Kconfig 
        |    1 +
  drivers/media/usb/msi2500/Kconfig 
        |    5 +
  drivers/media/usb/msi2500/Makefile 
        |    1 +
  drivers/{staging/media/msi3101/sdr-msi3101.c => 
media/usb/msi2500/msi2500.c} |   78 ++++---
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
        |    7 +-
  30 files changed, 1444 insertions(+), 84 deletions(-)
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml
  rename drivers/{staging/media/rtl2832u_sdr => 
media/dvb-frontends}/rtl2832_sdr.c (96%)
  rename drivers/{staging/media/rtl2832u_sdr => 
media/dvb-frontends}/rtl2832_sdr.h (100%)
  rename drivers/{staging/media/msi3101 => media/tuners}/msi001.c (100%)
  create mode 100644 drivers/media/usb/airspy/Kconfig
  create mode 100644 drivers/media/usb/airspy/Makefile
  create mode 100644 drivers/media/usb/airspy/airspy.c
  create mode 100644 drivers/media/usb/msi2500/Kconfig
  create mode 100644 drivers/media/usb/msi2500/Makefile
  rename drivers/{staging/media/msi3101/sdr-msi3101.c => 
media/usb/msi2500/msi2500.c} (96%)
  delete mode 100644 drivers/staging/media/msi3101/Kconfig
  delete mode 100644 drivers/staging/media/msi3101/Makefile
  delete mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
  delete mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile


-- 
http://palosaari.fi/
