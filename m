Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59134 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbaBLTtM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 14:49:12 -0500
Message-ID: <52FBD036.3080402@iki.fi>
Date: Wed, 12 Feb 2014 21:49:10 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [GIT PULL] AF9035 / IT9135
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

   [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035

for you to fetch changes up to 57f53ffd5db1c45f7b5253c1f6fadad7d87715ae:

   af9035: use default i2c slave address for af9035 too (2014-02-12 
21:44:13 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       af9035: use default i2c slave address for af9035 too

Malcolm Priestley (3):
       af9035: Move it913x single devices to af9035
       af9035: add default 0x9135 slave I2C address
       af9035: Add remaining it913x dual ids to af9035.

  drivers/media/usb/dvb-usb-v2/af9035.c | 39 
++++++++++++++++++++++++++++++++-------
  drivers/media/usb/dvb-usb-v2/it913x.c | 29 +++++------------------------
  2 files changed, 37 insertions(+), 31 deletions(-)


-- 
http://palosaari.fi/
