Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43851 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab3IHAXA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Sep 2013 20:23:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/3] fixes for 3.12
Date: Sun,  8 Sep 2013 03:21:48 +0300
Message-Id: <1378599711-26875-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PULL-request will follow soon.

I will send e4000 fix to stable too after a week or two.

Antti Palosaari (2):
  e4000: fix PLL calc bug on 32-bit arch
  msi3101: Kconfig select VIDEOBUF2_VMALLOC

Fengguang Wu (1):
  msi3101: msi3101_ioctl_ops can be static

 drivers/media/tuners/e4000.c                | 2 +-
 drivers/staging/media/msi3101/Kconfig       | 1 +
 drivers/staging/media/msi3101/sdr-msi3101.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

-- 
1.7.11.7

