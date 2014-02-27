Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53276 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbaB0AZg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:25:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 0/6] SDR API - Mirics MSi3101 driver
Date: Thu, 27 Feb 2014 02:25:16 +0200
Message-Id: <1393460722-11774-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mirics MSi3101 driver.

Antti

Antti Palosaari (6):
  msi3101: convert to SDR API
  msi001: Mirics MSi001 silicon tuner driver
  msi3101: use msi001 tuner driver
  MAINTAINERS: add msi001 driver
  MAINTAINERS: add msi3101 driver
  msi3101: clamp mmap buffers to reasonable level

 MAINTAINERS                                 |   20 +
 drivers/staging/media/msi3101/Kconfig       |    7 +-
 drivers/staging/media/msi3101/Makefile      |    1 +
 drivers/staging/media/msi3101/msi001.c      |  499 +++++++++
 drivers/staging/media/msi3101/sdr-msi3101.c | 1560 ++++++++++-----------------
 5 files changed, 1096 insertions(+), 991 deletions(-)
 create mode 100644 drivers/staging/media/msi3101/msi001.c

-- 
1.8.5.3

