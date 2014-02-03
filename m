Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48203 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaBCLAK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Feb 2014 06:00:10 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/5] separate MSi001 driver from MSi3101 driver
Date: Mon,  3 Feb 2014 12:59:50 +0200
Message-Id: <1391425195-17865-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split MSi001 RF tuner driver out from MSi3101 module. It is
implemented as SPI driver binding model offering V4L subdevice as
control interface.

Wonder how much whine this will cause as implementing E4000 driver
using I2C driver model earlier... It is yet another, even much more
exotic bus than I2C. But I simply don't want to use any proprietary
models to bind these modules, nor abuse I2C model...

Antti


Antti Palosaari (5):
  msi001: Mirics MSi001 silicon tuner driver
  msi3101: use msi001 tuner driver
  MAINTAINERS: add msi001 driver
  MAINTAINERS: add msi3101 driver
  MAINTAINERS: add rtl2832_sdr driver

 MAINTAINERS                                 |  30 ++
 drivers/staging/media/msi3101/Kconfig       |   7 +
 drivers/staging/media/msi3101/Makefile      |   1 +
 drivers/staging/media/msi3101/msi001.c      | 472 ++++++++++++++++++++++++++++
 drivers/staging/media/msi3101/sdr-msi3101.c | 437 +++++++------------------
 5 files changed, 629 insertions(+), 318 deletions(-)
 create mode 100644 drivers/staging/media/msi3101/msi001.c

-- 
1.8.5.3

