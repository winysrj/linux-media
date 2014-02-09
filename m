Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36304 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaBIItz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:55 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 00/86] SDR tree
Date: Sun,  9 Feb 2014 10:48:05 +0200
Message-Id: <1391935771-18670-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That is everything I have on my SDR queue. There is drivers for Mirics
MSi3101 and Realtek RTL2832U based devices. These drivers are still on
staging and I am not going to move those out of staging very soon as I
want get some experiments first.

That set is available via Git:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/sdr_review


Simplest way to test it in practice is listen FM radio using SDRSharp as a radio player.
I made simple plug-in for that:
https://github.com/palosaari/sdrsharp-v4l2

That plug-in supports currently only on 64-bit Kernel...


Installation is this simple (Fedora 20):

$ sudo yum install mono-core monodevelop
$ svn co https://subversion.assembla.com/svn/sdrsharp/trunk sdrsharp
$ cd sdrsharp
$ git clone https://github.com/palosaari/sdrsharp-v4l2.git V4L2
$ sed -i 's/Format Version 12\.00/Format Version 11\.00/' SDRSharp.sln

* Add following line to SDRSharp/App.config file inside frontendPlugins tag
    <add key="Linux Kernel V4L2" value="SDRSharp.V4L2.LibV4LIO,SDRSharp.V4L2" />

$ monodevelop SDRSharp.sln
* View > Default
* Solution SDRSharp > Add > Add Existing Project... > V4L2 > SDRSharp.V4L2.csproj
* Select Release|x86
* Build > Build All
* File > Quit
$ mono Release/SDRSharp.exe


regards
Antti


Antti Palosaari (85):
  rtl2832_sdr: Realtek RTL2832 SDR driver module
  rtl28xxu: attach SDR extension module
  rtl2832_sdr: use config struct from rtl2832 module
  rtl2832_sdr: initial support for R820T tuner
  rtl2832_sdr: use get_if_frequency()
  rtl2832_sdr: implement sampling rate
  rtl2832_sdr: initial support for FC0012 tuner
  rtl2832_sdr: initial support for FC0013 tuner
  rtl28xxu: constify demod config structs
  rtl2832: remove unused if_dvbt config parameter
  rtl2832: style changes and minor cleanup
  rtl2832_sdr: pixel format for SDR
  rtl2832_sdr: implement FMT IOCTLs
  msi3101: add signed 8-bit pixel format for SDR
  msi3101: implement FMT IOCTLs
  msi3101: move format 384 conversion to libv4lconvert
  msi3101: move format 336 conversion to libv4lconvert
  msi3101: move format 252 conversion to libv4lconvert
  rtl28xxu: add module parameter to disable IR
  rtl2832_sdr: increase USB buffers
  rtl2832_sdr: convert to SDR API
  msi3101: convert to SDR API
  msi3101: add u8 sample format
  msi3101: add u16 LE sample format
  msi3101: tons of small changes
  rtl2832_sdr: return NULL on rtl2832_sdr_attach failure
  rtl2832_sdr: calculate bandwidth if not set by user
  rtl2832_sdr: clamp ADC frequency to valid range always
  rtl2832_sdr: improve ADC device programming logic
  rtl2832_sdr: remove FMT buffer type checks
  rtl2832_sdr: switch FM to DAB mode
  msi3101: calculate tuner filters
  msi3101: remove FMT buffer type checks
  msi3101: improve ADC config stream format selection
  msi3101: clamp ADC and RF to valid range
  msi3101: disable all but u8 and u16le formats
  v4l: add RF tuner gain controls
  msi3101: use standard V4L gain controls
  e4000: convert DVB tuner to I2C driver model
  e4000: add manual gain controls
  rtl2832_sdr: expose E4000 gain controls to user space
  r820t: add manual gain controls
  rtl2832_sdr: expose R820 gain controls to user space
  e4000: fix PLL calc to allow higher frequencies
  msi3101: fix device caps to advertise SDR receiver
  rtl2832_sdr: fix device caps to advertise SDR receiver
  msi3101: add default FMT and ADC frequency
  msi3101: sleep USB ADC and tuner when streaming is stopped
  DocBook: document RF tuner gain controls
  DocBook: V4L: add V4L2_SDR_FMT_CU8 - 'CU08'
  DocBook: V4L: add V4L2_SDR_FMT_CU16LE - 'CU16'
  DocBook: media: document V4L2_CTRL_CLASS_RF_TUNER
  xc2028: silence compiler warnings
  v4l: add RF tuner channel bandwidth control
  msi3101: implement tuner bandwidth control
  rtl2832_sdr: implement tuner bandwidth control
  msi001: Mirics MSi001 silicon tuner driver
  msi3101: use msi001 tuner driver
  MAINTAINERS: add msi001 driver
  MAINTAINERS: add msi3101 driver
  MAINTAINERS: add rtl2832_sdr driver
  rtl28xxu: attach SDR module later
  e4000: implement controls via v4l2 control framework
  rtl2832_sdr: use E4000 tuner controls via V4L framework
  e4000: remove .set_config() which was for controls
  rtl28xxu: fix switch-case style issue
  v4l: reorganize RF tuner control ID numbers
  DocBook: document RF tuner bandwidth controls
  v4l: uapi: add SDR formats CU8 and CU16LE
  msi3101: use formats defined in V4L2 API
  rtl2832_sdr: use formats defined in V4L2 API
  v4l: add enum_freq_bands support to tuner sub-device
  msi001: implement .enum_freq_bands()
  msi3101: provide RF tuner bands from sub-device
  r820t/rtl2832u_sdr: implement gains using v4l2 controls
  v4l: add control for RF tuner PLL lock flag
  e4000: implement PLL lock v4l control
  DocBook: media: document PLL lock control
  rtl2832: provide muxed I2C adapter
  rtl2832: add muxed I2C adapter for demod itself
  rtl2832: implement delayed I2C gate close
  rtl28xxu: use muxed RTL2832 I2C adapters for E4000 and RTL2832_SDR
  e4000: get rid of DVB i2c_gate_ctrl()
  rtl2832_sdr: do not init tuner when only freq is changed
  e4000: convert to Regmap API

Luis Alves (1):
  rtl2832: Fix deadlock on i2c mux select function.

 Documentation/DocBook/media/v4l/controls.xml       |  119 ++
 .../DocBook/media/v4l/pixfmt-sdr-cu08.xml          |   44 +
 .../DocBook/media/v4l/pixfmt-sdr-cu16le.xml        |   46 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    3 +
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +-
 MAINTAINERS                                        |   30 +
 drivers/media/dvb-frontends/Kconfig                |    2 +-
 drivers/media/dvb-frontends/rtl2832.c              |  191 ++-
 drivers/media/dvb-frontends/rtl2832.h              |   34 +-
 drivers/media/dvb-frontends/rtl2832_priv.h         |   54 +-
 drivers/media/tuners/Kconfig                       |    1 +
 drivers/media/tuners/e4000.c                       |  598 +++++---
 drivers/media/tuners/e4000.h                       |   21 +-
 drivers/media/tuners/e4000_priv.h                  |   86 +-
 drivers/media/tuners/r820t.c                       |  137 +-
 drivers/media/tuners/r820t.h                       |   10 +
 drivers/media/tuners/tuner-xc2028.c                |    3 +
 drivers/media/usb/dvb-usb-v2/Makefile              |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   99 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h            |    2 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |   24 +
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    2 +
 drivers/staging/media/msi3101/Kconfig              |    7 +-
 drivers/staging/media/msi3101/Makefile             |    1 +
 drivers/staging/media/msi3101/msi001.c             |  499 +++++++
 drivers/staging/media/msi3101/sdr-msi3101.c        | 1558 +++++++-------------
 drivers/staging/media/rtl2832u_sdr/Kconfig         |    7 +
 drivers/staging/media/rtl2832u_sdr/Makefile        |    6 +
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c   | 1476 +++++++++++++++++++
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h   |   51 +
 include/media/v4l2-subdev.h                        |    1 +
 include/uapi/linux/v4l2-controls.h                 |   14 +
 include/uapi/linux/videodev2.h                     |    4 +
 34 files changed, 3825 insertions(+), 1315 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
 create mode 100644 drivers/staging/media/msi3101/msi001.c
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h

-- 
1.8.5.3

