Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2HEDaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Aug 2012 23:30:24 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/5] Convert az6007 to dvb-usb-v2
Date: Sun,  5 Aug 2012 00:30:06 -0300
Message-Id: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that dvb-usb-v2 patches got merged, convert az6007 to use it, as,
in thesis, several core bugs at dvb-usb were fixed.

Also, driver became a little more simple than before, as the number of
lines reduced a little bit.

No noticeable changes should be noticed... I hope ;)

Mauro Carvalho Chehab (5):
  [media] dvb-usb-v2: Fix cypress firmware compilation
  [media] dvb-usb-v2: Don't ask user to select Cypress firmware module
  [media] az6007: convert it to use dvb-usb-v2
  [media] az6007: fix the I2C W+R logic
  [media] az6007: Fix the number of parameters for QAM setup

 drivers/media/dvb/dvb-usb-v2/Kconfig               |  17 +-
 drivers/media/dvb/dvb-usb-v2/Makefile              |   6 +-
 drivers/media/dvb/{dvb-usb => dvb-usb-v2}/az6007.c | 385 +++++++++------------
 drivers/media/dvb/dvb-usb/Kconfig                  |   8 -
 drivers/media/dvb/dvb-usb/Makefile                 |   3 -
 5 files changed, 178 insertions(+), 241 deletions(-)
 rename drivers/media/dvb/{dvb-usb => dvb-usb-v2}/az6007.c (64%)

-- 
1.7.11.2

