Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45976 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbaCJTiV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 15:38:21 -0400
Received: from dyn3-82-128-190-236.psoas.suomi.net ([82.128.190.236] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WN61k-0007Rn-Fz
	for linux-media@vger.kernel.org; Mon, 10 Mar 2014 21:38:20 +0200
Message-ID: <531E14AB.4060309@iki.fi>
Date: Mon, 10 Mar 2014 21:38:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] SDR API
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That is just same set I sent earlier too, but rebased to latest 
media/master and 6 small compliance fix.


The following changes since commit f2d7313534072a5fe192e7cf46204b413acef479:

   [media] drx-d: add missing braces in drxd_hard.c:DRXD_init 
(2014-03-09 09:20:50 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git sdr_review_v3

for you to fetch changes up to 2a02f2e9cf67c2e083950ea4b1d03a2756c1ee94:

   msi3101: fix v4l2-compliance issues (2014-03-10 21:30:44 +0200)

----------------------------------------------------------------
Antti Palosaari (37):
       v4l: add RF tuner channel bandwidth control
       v4l: reorganize RF tuner control ID numbers
       v4l: uapi: add SDR formats CU8 and CU16LE
       v4l: add enum_freq_bands support to tuner sub-device
       v4l: add control for RF tuner PLL lock flag
       DocBook: V4L: add V4L2_SDR_FMT_CU8 - 'CU08'
       DocBook: V4L: add V4L2_SDR_FMT_CU16LE - 'CU16'
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
       v4l: rename v4l2_format_sdr to v4l2_sdr_format
       rtl2832_sdr: clamp bandwidth to nearest legal value in automode
       rtl28xxu: depends on I2C_MUX
       msi001: fix v4l2-compliance issues
       msi3101: fix v4l2-compliance issues

Hans Verkuil (1):
       rtl2832u_sdr: fixing v4l2-compliance issues

  Documentation/DocBook/media/v4l/controls.xml          |   51 +++-
  Documentation/DocBook/media/v4l/dev-sdr.xml           |    2 +-
  Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml   |   44 ++++
  Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml |   46 ++++
  Documentation/DocBook/media/v4l/pixfmt.xml            |    3 +
  MAINTAINERS                                           |   30 +++
  drivers/media/tuners/Kconfig                          |    1 +
  drivers/media/tuners/e4000.c                          |  598 
+++++++++++++++++++++++++++++------------------
  drivers/media/tuners/e4000.h                          |   21 +-
  drivers/media/tuners/e4000_priv.h                     |   86 ++++++-
  drivers/media/tuners/r820t.c                          |  137 ++++++++++-
  drivers/media/tuners/r820t.h                          |   10 +
  drivers/media/usb/dvb-usb-v2/Kconfig                  |    2 +-
  drivers/media/usb/dvb-usb-v2/Makefile                 |    1 +
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c               |   90 +++++--
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h               |    2 +
  drivers/media/v4l2-core/v4l2-ctrls.c                  |    9 +
  drivers/media/v4l2-core/v4l2-ioctl.c                  |    2 +-
  drivers/staging/media/Kconfig                         |    2 +
  drivers/staging/media/Makefile                        |    2 +
  drivers/staging/media/msi3101/Kconfig                 |    7 +-
  drivers/staging/media/msi3101/Makefile                |    1 +
  drivers/staging/media/msi3101/msi001.c                |  500 
+++++++++++++++++++++++++++++++++++++++
  drivers/staging/media/msi3101/sdr-msi3101.c           | 1564 
+++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------
  drivers/staging/media/rtl2832u_sdr/Kconfig            |    7 +
  drivers/staging/media/rtl2832u_sdr/Makefile           |    6 +
  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c      | 1501 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h      |   51 ++++
  include/media/v4l2-subdev.h                           |    1 +
  include/uapi/linux/v4l2-controls.h                    |   15 +-
  include/uapi/linux/videodev2.h                        |   10 +-
  31 files changed, 3531 insertions(+), 1271 deletions(-)
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
  create mode 100644 drivers/staging/media/msi3101/msi001.c
  create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
  create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h

-- 
http://palosaari.fi/
