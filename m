Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41018 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaBJT3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 14:29:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 0/5] SDR API - Mirics MSi3101 driver
Date: Mon, 10 Feb 2014 21:28:58 +0200
Message-Id: <1392060543-3972-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split / group / merge changes as requested by Hans.

Antti

Antti Palosaari (5):
  msi3101: convert to SDR API
  msi001: Mirics MSi001 silicon tuner driver
  msi3101: use msi001 tuner driver
  MAINTAINERS: add msi001 driver
  MAINTAINERS: add msi3101 driver

 MAINTAINERS                                 |   20 +
 drivers/staging/media/msi3101/Kconfig       |    7 +-
 drivers/staging/media/msi3101/Makefile      |    1 +
 drivers/staging/media/msi3101/msi001.c      |  499 +++++++++
 drivers/staging/media/msi3101/sdr-msi3101.c | 1558 ++++++++++-----------------
 5 files changed, 1095 insertions(+), 990 deletions(-)
 create mode 100644 drivers/staging/media/msi3101/msi001.c

-- 
1.8.5.3

