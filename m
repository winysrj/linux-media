Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32818 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbbFAI22 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 04:28:28 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Adam Baker <linux@baker-net.org.uk>, Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 0/2] si2157 rssi and si2168 I2C adapter locking
Date: Mon,  1 Jun 2015 11:28:05 +0300
Message-Id: <1433147287-29932-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2:
* si2168 declare functions as static
* i2157 set FE_SCALE_NOT_AVAILABLE if stats polling stopped due to IO error


Antti Palosaari (2):
  si2168: Implement own I2C adapter locking
  si2157: implement signal strength stats

 drivers/media/dvb-frontends/si2168.c      | 135 +++++++++++++++++-------------
 drivers/media/dvb-frontends/si2168_priv.h |   1 -
 drivers/media/tuners/si2157.c             |  40 ++++++++-
 drivers/media/tuners/si2157_priv.h        |   1 +
 4 files changed, 119 insertions(+), 58 deletions(-)

-- 
http://palosaari.fi/

