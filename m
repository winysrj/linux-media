Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45043 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab3LCQhm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 11:37:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2 0/3] AF9035/AF9033 stack alloc fixes
Date: Tue,  3 Dec 2013 18:37:25 +0200
Message-Id: <1386088648-13463-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now with a fix from Dan too.

Antti Palosaari (2):
  af9033: fix broken I2C
  af9035: fix broken I2C and USB I/O

Dan Carpenter (1):
  af9035: unlock on error in af9035_i2c_master_xfer()

 drivers/media/dvb-frontends/af9033.c  | 12 ++++++------
 drivers/media/usb/dvb-usb-v2/af9035.c | 15 +++++++++------
 2 files changed, 15 insertions(+), 12 deletions(-)

-- 
1.8.4.2

