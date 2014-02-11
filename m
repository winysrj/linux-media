Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40802 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaBKCFO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 21:05:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 00/16] SDR API - drivers
Date: Tue, 11 Feb 2014 04:04:43 +0200
Message-Id: <1392084299-16549-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

*** BLURB HERE ***

Antti Palosaari (16):
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

 MAINTAINERS                                      |   10 +
 drivers/media/tuners/Kconfig                     |    1 +
 drivers/media/tuners/e4000.c                     |  598 +++++----
 drivers/media/tuners/e4000.h                     |   21 +-
 drivers/media/tuners/e4000_priv.h                |   86 +-
 drivers/media/tuners/r820t.c                     |  137 +-
 drivers/media/tuners/r820t.h                     |   10 +
 drivers/media/usb/dvb-usb-v2/Makefile            |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c          |   90 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h          |    2 +
 drivers/staging/media/Kconfig                    |    2 +
 drivers/staging/media/Makefile                   |    2 +
 drivers/staging/media/rtl2832u_sdr/Kconfig       |    7 +
 drivers/staging/media/rtl2832u_sdr/Makefile      |    6 +
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 1476 ++++++++++++++++++++++
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h |   51 +
 16 files changed, 2234 insertions(+), 266 deletions(-)
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h

-- 
1.8.5.3

