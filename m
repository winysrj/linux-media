Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52942 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbaBJQMt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:49 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 0/8] SDR API - misc changes
Date: Mon, 10 Feb 2014 18:12:25 +0200
Message-Id: <1392048753-13292-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split / group / merge changes as requested by Hans.

This is first set, containing some not so directly SDR related changes.

Antti

Antti Palosaari (7):
  xc2028: silence compiler warnings
  rtl28xxu: add module parameter to disable IR
  rtl2832: remove unused if_dvbt config parameter
  rtl2832: style changes and minor cleanup
  rtl2832: provide muxed I2C adapter
  rtl2832: add muxed I2C adapter for demod itself
  rtl2832: implement delayed I2C gate close

Luis Alves (1):
  rtl2832: Fix deadlock on i2c mux select function.

 drivers/media/dvb-frontends/Kconfig        |   2 +-
 drivers/media/dvb-frontends/rtl2832.c      | 191 +++++++++++++++++++++++++----
 drivers/media/dvb-frontends/rtl2832.h      |  34 +++--
 drivers/media/dvb-frontends/rtl2832_priv.h |  54 ++++----
 drivers/media/tuners/tuner-xc2028.c        |   3 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |   9 +-
 6 files changed, 235 insertions(+), 58 deletions(-)

-- 
1.8.5.3

