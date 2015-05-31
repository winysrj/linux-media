Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46903 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbbEaOV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 10:21:26 -0400
Received: from dyn3-82-128-190-185.psoas.suomi.net ([82.128.190.185] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1Yz478-0003A5-W3
	for linux-media@vger.kernel.org; Sun, 31 May 2015 17:21:23 +0300
Message-ID: <556B18E2.7060409@iki.fi>
Date: Sun, 31 May 2015 17:21:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 4.2] tda10071 I2C bindings
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d511eb7d642aaf513fefeb05514dc6177c53c350:

   [media] uvcvideo: Remove unneeded device disconnected flag 
(2015-05-30 12:12:58 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git tda10071_pull

for you to fetch changes up to 7cdea690583de1c533d4ec6bb6fea1a38567b9e2:

   cx23885: Hauppauge WinTV-HVR5525 bind I2C SEC (2015-05-31 17:15:24 +0300)

----------------------------------------------------------------
Antti Palosaari (8):
       tda10071: implement I2C client bindings
       a8293: implement I2C client bindings
       em28xx: add support for DVB SEC I2C client
       em28xx: bind PCTV 460e using I2C client
       cx23885: add support for DVB I2C SEC client
       cx23885: Hauppauge WinTV Starburst bind I2C demod and SEC
       cx23885: Hauppauge WinTV-HVR4400/HVR5500 bind I2C demod and SEC
       cx23885: Hauppauge WinTV-HVR5525 bind I2C SEC

  drivers/media/dvb-frontends/a8293.c         |  87 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
  drivers/media/dvb-frontends/a8293.h         |  15 +++++++++++++++
  drivers/media/dvb-frontends/tda10071.c      |  95 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/dvb-frontends/tda10071.h      |  29 
+++++++++++++++++++++++++++++
  drivers/media/dvb-frontends/tda10071_priv.h |   1 +
  drivers/media/pci/cx23885/cx23885-dvb.c     | 133 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------
  drivers/media/pci/cx23885/cx23885.h         |   1 +
  drivers/media/usb/em28xx/em28xx-dvb.c       |  78 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
  8 files changed, 389 insertions(+), 50 deletions(-)

-- 
http://palosaari.fi/
