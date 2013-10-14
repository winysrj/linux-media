Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36927 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab3JNOIH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 10:08:07 -0400
Received: from dyn3-82-128-185-216.psoas.suomi.net ([82.128.185.216] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VVioY-0004jP-W0
	for linux-media@vger.kernel.org; Mon, 14 Oct 2013 17:08:07 +0300
Message-ID: <525BFAC6.8050107@iki.fi>
Date: Mon, 14 Oct 2013 17:08:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL]  em28xx_drxk_tda18271
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

   Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git em28xx_drxk_tda18271

for you to fetch changes up to ae5fb7d82d978c786910833868d986c0b116c33d:

   em28xx: MaxMedia UB425-TC change demod settings (2013-10-14 17:04:42 
+0300)

----------------------------------------------------------------
Antti Palosaari (3):
       em28xx: MaxMedia UB425-TC offer firmware for demodulator
       em28xx: MaxMedia UB425-TC switch RF tuner driver to another
       em28xx: MaxMedia UB425-TC change demod settings

  drivers/media/usb/em28xx/em28xx-dvb.c | 13 ++++++-------
  1 file changed, 6 insertions(+), 7 deletions(-)

-- 
http://palosaari.fi/
