Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45255 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893AbaBAOYq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 09:24:46 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 00/17] SDR API - controls, stream formats
Date: Sat,  1 Feb 2014 16:24:17 +0200
Message-Id: <1391264674-4395-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RF tuner gains, RF tuner channel bandwidth, stream formats.

regards
Antti

Antti Palosaari (17):
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

 Documentation/DocBook/media/v4l/controls.xml       |  91 +++++++++
 .../DocBook/media/v4l/pixfmt-sdr-cu08.xml          |  44 +++++
 .../DocBook/media/v4l/pixfmt-sdr-cu16le.xml        |  46 +++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |   3 +
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   7 +-
 drivers/media/tuners/e4000.c                       |  82 +++++++-
 drivers/media/tuners/e4000.h                       |   6 +
 drivers/media/tuners/e4000_priv.h                  |  63 ++++++
 drivers/media/tuners/r820t.c                       |  38 ++++
 drivers/media/tuners/r820t.h                       |   7 +
 drivers/media/tuners/tuner-xc2028.c                |   3 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |   4 +
 drivers/staging/media/msi3101/sdr-msi3101.c        |  64 ++++---
 drivers/staging/media/rtl2832u_sdr/Makefile        |   1 +
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c   | 211 +++++++++++++++------
 include/uapi/linux/v4l2-controls.h                 |   2 +
 16 files changed, 580 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml

-- 
1.8.5.3

