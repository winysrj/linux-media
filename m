Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51621 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaGDJMV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jul 2014 05:12:21 -0400
Received: from 85-23-164-97.bb.dnainternet.fi ([85.23.164.97] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1X2zXX-0008Og-2W
	for linux-media@vger.kernel.org; Fri, 04 Jul 2014 12:12:19 +0300
Message-ID: <53B66FF2.5050201@iki.fi>
Date: Fri, 04 Jul 2014 12:12:18 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] 3.16 af9035 fix
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 13936af3d2f04f173a83cc050dbc4b20d8562b81:

   [media] saa7134: use unlocked_ioctl instead of ioctl (2014-06-19 
13:14:51 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git fixes

for you to fetch changes up to 14f0db438e16f12c884e7dcc13fe5faa7ebe4554:

   af9035: override tuner id when bad value set into eeprom (2014-06-24 
16:52:24 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       af9035: override tuner id when bad value set into eeprom

  drivers/media/usb/dvb-usb-v2/af9035.c | 40 
+++++++++++++++++++++++++++++++++-------
  1 file changed, 33 insertions(+), 7 deletions(-)


-- 
http://palosaari.fi/
