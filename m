Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41972 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaCABRf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 20:17:35 -0500
Message-ID: <53113529.6020205@iki.fi>
Date: Sat, 01 Mar 2014 03:17:29 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL] SDR API 2nd part
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
These patches are based top of:
http://git.linuxtv.org/media-tree.git/shortlog/refs/heads/sdr

I am not able to make development during next week, so if there is any 
issues, please wait to week 12 I could fix, or do what ever is best 
required by situation.

Both SDR drivers are in staging and API is market as experimental. I 
think the quality is more than enough for merging that stuff (to staging).

regards
Antti


The following changes since commit 11532660e6f5b6b3a74a03f999d878f35d2cc668:

   Add Antti at the V4L2 revision list (2014-02-07 12:19:37 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git sdr_review_v2

for you to fetch changes up to 674c092d32e840243fa9f63b9da23ace364a2af7:

   MAINTAINERS: add rtl2832_sdr driver (2014-02-27 02:01:51 +0200)

----------------------------------------------------------------
Antti Palosaari (42):
       xc2028: silence compiler warnings
       rtl28xxu: add module parameter to disable IR
       rtl2832: remove unused if_dvbt config parameter
       rtl2832: style changes and minor cleanup
       rtl2832: provide muxed I2C adapter
       rtl2832: add muxed I2C adapter for demod itself
       rtl2832: implement delayed I2C gate close
       v4l: add RF tuner gain controls
       v4l: add RF tuner channel bandwidth control
       v4l: reorganize RF tuner control ID numbers
       v4l: uapi: add SDR formats CU8 and CU16LE
       v4l: add enum_freq_bands support to tuner sub-device
       v4l: add control for RF tuner PLL lock flag
       DocBook: V4L: add V4L2_SDR_FMT_CU8 - 'CU08'
       DocBook: V4L: add V4L2_SDR_FMT_CU16LE - 'CU16'
       DocBook: document RF tuner gain controls
       DocBook: media: document V4L2_CTRL_CLASS_RF_TUNER
       DocBook: document RF tuner bandwidth controls
       DocBook: media: document PLL lock control
       DocBook: media: add some general info about RF tuners
       msi3101: convert to SDR API
       msi001: Mirics MSi001 silicon tuner driver
       msi3101: use msi001 tuner driver
       MAINTAINERS: add msi001 driver
       MAINTAINERS: add msi3101 driver
       msi3101: clamp mmap buffers to reasonable level
       e4000: convert DVB tuner to I2C driver model
       e4000: implement controls via v4l2 control framework
       e4000: fix PLL calc to allow higher frequencies
       e4000: implement PLL lock v4l control
       e4000: get rid of DVB i2c_gate_ctrl()
       e4000: convert to Regmap API
       e4000: rename some variables
       rtl2832_sdr: Realtek RTL2832 SDR driver module
       rtl28xxu: constify demod config structs
       rtl28xxu: attach SDR extension module
       rtl28xxu: fix switch-case style issue
       rtl28xxu: use muxed RTL2832 I2C adapters for E4000 and RTL2832_SDR
       rtl2832_sdr: expose e4000 controls to user
       r820t: add manual gain controls
       rtl2832_sdr: expose R820T controls to user
       MAINTAINERS: add rtl2832_sdr driver

Luis Alves (1):
       rtl2832: Fix deadlock on i2c mux select function.

  Documentation/DocBook/media/v4l/controls.xml           |  138 +++++++++++
  Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml    |   44 ++++
  Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml  |   46 ++++
  Documentation/DocBook/media/v4l/pixfmt.xml             |    3 +
  Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml |    7 +-
  MAINTAINERS                                            |   30 +++
  drivers/media/dvb-frontends/Kconfig                    |    2 +-
  drivers/media/dvb-frontends/rtl2832.c                  |  191 
+++++++++++++--
  drivers/media/dvb-frontends/rtl2832.h                  |   34 ++-
  drivers/media/dvb-frontends/rtl2832_priv.h             |   54 +++--
  drivers/media/tuners/Kconfig                           |    1 +
  drivers/media/tuners/e4000.c                           |  598 
+++++++++++++++++++++++++++++------------------
  drivers/media/tuners/e4000.h                           |   21 +-
  drivers/media/tuners/e4000_priv.h                      |   86 ++++++-
  drivers/media/tuners/r820t.c                           |  137 ++++++++++-
  drivers/media/tuners/r820t.h                           |   10 +
  drivers/media/tuners/tuner-xc2028.c                    |    3 +
  drivers/media/usb/dvb-usb-v2/Makefile                  |    1 +
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c                |   99 ++++++--
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h                |    2 +
  drivers/media/v4l2-core/v4l2-ctrls.c                   |   24 ++
  drivers/staging/media/Kconfig                          |    2 +
  drivers/staging/media/Makefile                         |    2 +
  drivers/staging/media/msi3101/Kconfig                  |    7 +-
  drivers/staging/media/msi3101/Makefile                 |    1 +
  drivers/staging/media/msi3101/msi001.c                 |  499 
+++++++++++++++++++++++++++++++++++++++
  drivers/staging/media/msi3101/sdr-msi3101.c            | 1560 
++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------
  drivers/staging/media/rtl2832u_sdr/Kconfig             |    7 +
  drivers/staging/media/rtl2832u_sdr/Makefile            |    6 +
  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c       | 1476 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h       |   51 ++++
  include/media/v4l2-subdev.h                            |    1 +
  include/uapi/linux/v4l2-controls.h                     |   14 ++
  include/uapi/linux/videodev2.h                         |    4 +
  34 files changed, 3845 insertions(+), 1316 deletions(-)
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
  create mode 100644 drivers/staging/media/msi3101/msi001.c
  create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
  create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h

-- 
http://palosaari.fi/
