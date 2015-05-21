Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60895 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbbEUTXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 15:23:12 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 0/5] m88ds3103 improvements (DVBv5 stats and more)
Date: Thu, 21 May 2015 22:22:47 +0300
Message-Id: <1432236172-13964-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2
Meld some commits together.

Antti Palosaari (5):
  m88ds3103: do not return error from get_frontend() when not ready
  m88ds3103: implement DVBv5 CNR statistics
  m88ds3103: implement DVBv5 BER
  m88ds3103: use jiffies when polling DiSEqC TX ready
  m88ds3103: add I2C client binding

 drivers/media/dvb-frontends/m88ds3103.c      | 642 ++++++++++++++++-----------
 drivers/media/dvb-frontends/m88ds3103.h      |  63 ++-
 drivers/media/dvb-frontends/m88ds3103_priv.h |   6 +-
 3 files changed, 456 insertions(+), 255 deletions(-)

-- 
http://palosaari.fi/

