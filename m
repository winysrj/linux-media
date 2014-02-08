Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56007 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaBHJiv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Feb 2014 04:38:51 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/8] regmap API & kernel I2C driver model
Date: Sat,  8 Feb 2014 11:37:53 +0200
Message-Id: <1391852281-18291-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Converting DVB tuner driver to near kernel practices has been long on
my todo, as I have mentioned multiple times.
Here it is, looks pretty nice! No gate-control, nor home made I2C low
level access routines anymore...

Maybe the only downside is new dependency to regmap (and I2C mux, which
was done already). Fortunately regmap seems to be quite widely used, it
is likely enabled by default most distributions already.

Antti

Antti Palosaari (7):
  rtl2832: provide muxed I2C adapter
  rtl2832: add muxed I2C adapter for demod itself
  rtl2832: implement delayed I2C gate close
  rtl28xxu: use muxed RTL2832 I2C adapters for E4000 and RTL2832_SDR
  e4000: get rid of DVB i2c_gate_ctrl()
  rtl2832_sdr: do not init tuner when only freq is changed
  e4000: convert to Regmap API

Luis Alves (1):
  rtl2832: Fix deadlock on i2c mux select function.

 drivers/media/dvb-frontends/Kconfig              |   2 +-
 drivers/media/dvb-frontends/rtl2832.c            | 159 ++++++-
 drivers/media/dvb-frontends/rtl2832.h            |  25 ++
 drivers/media/dvb-frontends/rtl2832_priv.h       |   4 +
 drivers/media/tuners/Kconfig                     |   1 +
 drivers/media/tuners/e4000.c                     | 528 ++++++++---------------
 drivers/media/tuners/e4000_priv.h                |   4 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c          |  12 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h          |   1 +
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c |  25 +-
 10 files changed, 413 insertions(+), 348 deletions(-)

-- 
1.8.5.3

