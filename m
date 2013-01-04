Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab3ADVQd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 16:16:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] Some IR fixes for I2C devices on em28xx
Date: Fri,  4 Jan 2013 19:15:48 -0200
Message-Id: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Frank pointed that IR was not working with I2C devices. So, I took some
time to fix them.

Tested with Hauppauge WinTV USB2.

Mauro Carvalho Chehab (4):
  [media] em28xx: initialize button/I2C IR earlier
  [media] em28xx: autoload em28xx-rc if the device has an I2C IR
  [media] em28xx: simplify IR names on I2C devices
  [media] em28xx: tell ir-kbd-i2c that WinTV uses an RC5 protocol

 drivers/media/usb/em28xx/em28xx-cards.c |  2 +-
 drivers/media/usb/em28xx/em28xx-input.c | 29 ++++++++++++++++-------------
 2 files changed, 17 insertions(+), 14 deletions(-)

-- 
1.7.11.7

