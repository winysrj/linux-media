Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50709 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab3LARD2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Dec 2013 12:03:28 -0500
Received: from 85-23-164-13.bb.dnainternet.fi ([85.23.164.13] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VnAQZ-0003WZ-3L
	for linux-media@vger.kernel.org; Sun, 01 Dec 2013 19:03:27 +0200
Message-ID: <529B6BDE.8040303@iki.fi>
Date: Sun, 01 Dec 2013 19:03:26 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.13] AF9035 and AF9033 regression bug fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit fa507e4d32bf6c35eb5fe7dbc0593ae3723c9575:

   [media] media: marvell-ccic: use devm to release clk (2013-11-29 
14:46:47 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git fixes3.13

for you to fetch changes up to 7f704d6c9426d349763c9a27b2b3259f25c51bde:

   af9035: fix broken I2C and USB I/O (2013-12-01 18:56:42 +0200)

----------------------------------------------------------------
Antti Palosaari (2):
       af9033: fix broken I2C
       af9035: fix broken I2C and USB I/O

  drivers/media/dvb-frontends/af9033.c  | 2 +-
  drivers/media/usb/dvb-usb-v2/af9035.c | 8 ++++----
  2 files changed, 5 insertions(+), 5 deletions(-)

-- 
http://palosaari.fi/
