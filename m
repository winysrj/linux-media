Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34892 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaBLSIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 13:08:46 -0500
Received: from [82.128.187.60] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WDeEm-0006f9-Ta
	for linux-media@vger.kernel.org; Wed, 12 Feb 2014 20:08:44 +0200
Message-ID: <52FBB8AC.9010600@iki.fi>
Date: Wed, 12 Feb 2014 20:08:44 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.14] em28xx-dvb m88ts2022 tuner binding fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

   [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git pctv_461e_fix

for you to fetch changes up to 6d56b487e83787e7c532ba8f45de8f71a93aab76:

   em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-02-12 20:05:05 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       em28xx-dvb: fix PCTV 461e tuner I2C binding

  drivers/media/usb/em28xx/em28xx-dvb.c | 27 +++++++++++++++++++++++++--
  1 file changed, 25 insertions(+), 2 deletions(-)


-- 
http://palosaari.fi/
