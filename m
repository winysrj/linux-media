Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53266 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757635Ab3FCWzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jun 2013 18:55:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/4] af9035 changes
Date: Tue,  4 Jun 2013 01:54:22 +0300
Message-Id: <1370300066-13964-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nothing special. I will PULL request these.

Antti Palosaari (4):
  af9035: implement I2C adapter read operation
  af9035: make checkpatch.pl happy!
  af9035: minor log writing changes
  af9035: correct TS mode handling

 drivers/media/usb/dvb-usb-v2/af9035.c | 66 +++++++++++++++++++++++------------
 drivers/media/usb/dvb-usb-v2/af9035.h | 11 ++++--
 2 files changed, 52 insertions(+), 25 deletions(-)

-- 
1.7.11.7

