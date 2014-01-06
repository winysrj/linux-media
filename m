Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbaAFQI1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 11:08:27 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/6] em28xx: improve I2C code
Date: Mon,  6 Jan 2014 11:04:54 -0200
Message-Id: <1389013500-3110-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a series of cleanup patches for em28xx I2C. It was originally
part of a series of patches meant to split em28xx V4L2 module, but it
makes sense to submit as a separate patch set.

This series basically does:

	- make em28xx compilant with standard I2C errors, as defined
	  at Documentation/i2c/fault-codes;

	- Use jiffies for the timeouts, to make the timeout reliable;

	- Better define a value for the I2C timeout, according with
	  the SMBUS spec. This value works properly on the devices
	  tested (WinTV 2 USB, Kworld 305U and HVR-950);

	- Add 2 levels of I2C debug messages. On the first level,
	  it displays only the I2C I/O error messages. On the second
	  level, it displays the entire I2C transfer data;

	- Enable I2C timeout debug errors, if i2c_debug=1.

Thanks to Frank Schäfer <fschaefer.oss@googlemail.com> for his
pach review.

Mauro Carvalho Chehab (6):
  [media] em28xx: convert i2c wait completion logic to use jiffies
  [media] em28xx: rename I2C timeout to EM28XX_I2C_XFER_TIMEOUT
  [media] em28xx: use a better value for I2C timeouts
  em28xx-i2c: Fix error code for I2C error transfers
  [media] em28xx: cleanup I2C debug messages
  em28xx: add timeout debug information if i2c_debug enabled

 drivers/media/usb/em28xx/em28xx-i2c.c | 191 ++++++++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx.h     |  17 ++-
 2 files changed, 125 insertions(+), 83 deletions(-)

-- 
1.8.3.1

