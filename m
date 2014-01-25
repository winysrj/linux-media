Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34281 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaAYRLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:01 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 00/52] SDR devel tree
Date: Sat, 25 Jan 2014 19:09:54 +0200
Message-Id: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Snapshot from my SDR devel tree.

Here is same kernel tree available via git:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/sdr

I uploaded some tools to use that API to GitHub:
https://github.com/palosaari

regards
Antti


Antti Palosaari (51):
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
  DocBook: fix wait.c location
  v4l: add device type for Software Defined Radio
  v4l: add new tuner types for SDR
  v4l: 1 Hz resolution flag for tuners
  v4l: add stream format for SDR receiver
  v4l: define own IOCTL ops for SDR FMT
  v4l: enable some IOCTLs for SDR receiver
  v4l: add device capability flag for SDR receiver
  DocBook: document 1 Hz flag
  DocBook: Software Defined Radio Interface
  DocBook: mark SDR API as Experimental
  v4l2-framework.txt: add SDR device type
  devices.txt: add video4linux device for Software Defined Radio
  rtl2832_sdr: convert to SDR API
  msi3101: convert to SDR API
  msi3101: add u8 sample format
  msi3101: add u16 LE sample format
  msi3101: tons of small changes
  v4l: disable lockdep on vb2_fop_mmap()
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

Hans Verkuil (1):
  v4l: do not allow modulator ioctls for non-radio devices

 Documentation/DocBook/device-drivers.tmpl          |    2 +-
 Documentation/DocBook/media/v4l/compat.xml         |   13 +
 Documentation/DocBook/media/v4l/dev-sdr.xml        |  110 ++
 Documentation/DocBook/media/v4l/io.xml             |    6 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    8 +
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   |    8 +-
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |    7 +
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |    5 +-
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |    6 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   15 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |    6 +
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    8 +-
 Documentation/devices.txt                          |    7 +
 Documentation/video4linux/v4l2-framework.txt       |    1 +
 drivers/media/dvb-frontends/rtl2832.c              |   32 +-
 drivers/media/dvb-frontends/rtl2832.h              |    9 +-
 drivers/media/dvb-frontends/rtl2832_priv.h         |   50 +-
 drivers/media/usb/dvb-usb-v2/Makefile              |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   34 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   15 +
 drivers/media/v4l2-core/v4l2-dev.c                 |   30 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   75 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   14 +-
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    2 +
 drivers/staging/media/msi3101/sdr-msi3101.c        |  887 ++++++------
 drivers/staging/media/rtl2832u_sdr/Kconfig         |    6 +
 drivers/staging/media/rtl2832u_sdr/Makefile        |    5 +
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c   | 1448 ++++++++++++++++++++
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h   |   51 +
 include/media/v4l2-dev.h                           |    3 +-
 include/media/v4l2-ioctl.h                         |    8 +
 include/trace/events/v4l2.h                        |    1 +
 include/uapi/linux/v4l2-controls.h                 |   11 +
 include/uapi/linux/videodev2.h                     |   16 +
 36 files changed, 2420 insertions(+), 483 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/dev-sdr.xml
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h

-- 
1.8.5.3

