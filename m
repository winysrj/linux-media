Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55211 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760406Ab3DIXyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 19:54:23 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/5] fix buggy mxl5007t register read
Date: Wed, 10 Apr 2013 02:53:15 +0300
Message-Id: <1365551600-3394-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current MxL5007t driver implements repeated start condition (badly)
whilst device uses stop before read operation.

I added "use_broken_read_reg_intentionally" config option to avoid
regressions as I don't have all devices to test / fix.

Antti Palosaari (5):
  mxl5007t: fix buggy register read
  af9015: fix I2C adapter read (without REPEATED STOP)
  af9015: do not use buggy mxl5007t read reg
  af9035: implement I2C adapter read operation
  af9035: do not use buggy mxl5007t read reg

 drivers/media/tuners/mxl5007t.c             | 56 ++++++++++++++++++++++++++++-
 drivers/media/tuners/mxl5007t.h             |  7 ++++
 drivers/media/usb/au0828/au0828-dvb.c       |  1 +
 drivers/media/usb/dvb-usb-v2/af9015.c       |  2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c       | 22 ++++++++++--
 drivers/media/usb/dvb-usb/dib0700_devices.c |  1 +
 6 files changed, 85 insertions(+), 4 deletions(-)

-- 
1.7.11.7

