Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36431 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbbG0L6u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 07:58:50 -0400
Received: from 85-23-164-218.bb.dnainternet.fi ([85.23.164.218] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1ZJh3Q-0003P9-Tr
	for linux-media@vger.kernel.org; Mon, 27 Jul 2015 14:58:48 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL] a8293 & tda10071 improvements
Message-ID: <55B61CF8.7080905@iki.fi>
Date: Mon, 27 Jul 2015 14:58:48 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4dc102b2f53d63207fa12a6ad49c7b6448bc3301:

   [media] dvb_core: Replace memset with eth_zero_addr (2015-07-22 
13:32:21 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git tda10071_a8293

for you to fetch changes up to 2505ec5f7a1bb40fa1a86184779884c32a619473:

   tda10071: implement DVBv5 statistics (2015-07-27 14:32:23 +0300)

----------------------------------------------------------------
Antti Palosaari (12):
       em28xx: remove unused a8293 SEC config
       a8293: remove legacy media attach
       a8293: use i2c_master_send / i2c_master_recv for I2C I/O
       a8293: improve LNB register programming logic
       a8293: coding style issues
       tda10071: remove legacy media attach
       tda10071: rename device state struct to dev
       tda10071: convert to regmap I2C API
       tda10071: use jiffies when poll firmware status
       tda10071: protect firmware command exec with mutex
       tda10071: do not get_frontend() when not ready
       tda10071: implement DVBv5 statistics

  drivers/media/dvb-frontends/Kconfig         |   1 +
  drivers/media/dvb-frontends/a8293.c         | 167 
++++++--------------------------
  drivers/media/dvb-frontends/a8293.h         |  22 -----
  drivers/media/dvb-frontends/tda10071.c      | 835 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------------
  drivers/media/dvb-frontends/tda10071.h      |  63 +-----------
  drivers/media/dvb-frontends/tda10071_priv.h |  20 ++--
  drivers/media/usb/em28xx/em28xx-dvb.c       |   4 -
  7 files changed, 385 insertions(+), 727 deletions(-)

-- 
http://palosaari.fi/
