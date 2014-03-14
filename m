Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33725 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaCNAOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:14:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 00/17] SDR API - rtl2832_sdr driver
Date: Fri, 14 Mar 2014 02:14:14 +0200
Message-Id: <1394756071-22410-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I decided to drop r820t changes (gain controls and bandwidth) as for
now. Some small changes also done and rebased. Removed e4000 export
and it uses now e4000 attach model that is quite copy & pasted from
V4L2.

Antti

Antti Palosaari (16):
  e4000: convert DVB tuner to I2C driver model
  e4000: implement controls via v4l2 control framework
  e4000: fix PLL calc to allow higher frequencies
  e4000: implement PLL lock v4l control
  rtl2832_sdr: Realtek RTL2832 SDR driver module
  rtl2832_sdr: expose e4000 controls to user
  rtl28xxu: constify demod config structs
  rtl28xxu: attach SDR extension module
  rtl28xxu: fix switch-case style issue
  rtl28xxu: use muxed RTL2832 I2C adapters for E4000 and RTL2832_SDR
  rtl28xxu: depends on I2C_MUX
  e4000: get rid of DVB i2c_gate_ctrl()
  e4000: convert to Regmap API
  e4000: rename some variables
  rtl2832_sdr: clamp bandwidth to nearest legal value in automode
  MAINTAINERS: add rtl2832_sdr driver

Hans Verkuil (1):
  rtl2832_sdr: fixing v4l2-compliance issues

 MAINTAINERS                                      |   10 +
 drivers/media/tuners/Kconfig                     |    3 +-
 drivers/media/tuners/e4000.c                     |  600 +++++----
 drivers/media/tuners/e4000.h                     |   21 +-
 drivers/media/tuners/e4000_priv.h                |   88 +-
 drivers/media/usb/dvb-usb-v2/Kconfig             |    2 +-
 drivers/media/usb/dvb-usb-v2/Makefile            |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c          |  105 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h          |    2 +
 drivers/staging/media/Kconfig                    |    2 +
 drivers/staging/media/Makefile                   |    2 +
 drivers/staging/media/rtl2832u_sdr/Kconfig       |    7 +
 drivers/staging/media/rtl2832u_sdr/Makefile      |    6 +
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 1495 ++++++++++++++++++++++
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h |   54 +
 15 files changed, 2125 insertions(+), 273 deletions(-)
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h

-- 
1.8.5.3

