Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55597 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab3LCQoX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 11:44:23 -0500
Received: from 85-23-164-13.bb.dnainternet.fi ([85.23.164.13] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Vnt5C-0006IP-CJ
	for linux-media@vger.kernel.org; Tue, 03 Dec 2013 18:44:22 +0200
Message-ID: <529E0A65.1020302@iki.fi>
Date: Tue, 03 Dec 2013 18:44:21 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.13 v2] AF9035/AF9033 stack alloc regression fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

And as these stack alloc patches seems to requested for stable too, 
these 3 fixes should go stable also!

I am not very happy to situation that stack alloc patch set was 
requested to stable, with almost none testing. These patches appeared to 
media master *only* around one week ago. I tested tens of DVB devices 
during weekend and didn't any other non-working than AF9035. But I don't 
have all the devices to test...

regards
Antti

The following changes since commit fa507e4d32bf6c35eb5fe7dbc0593ae3723c9575:

   [media] media: marvell-ccic: use devm to release clk (2013-11-29 
14:46:47 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git fixes3.13_v2

for you to fetch changes up to 413f354edd6adbc52492d398b6f9f36dde9a9f48:

   af9035: unlock on error in af9035_i2c_master_xfer() (2013-12-03 
18:31:25 +0200)

----------------------------------------------------------------
Antti Palosaari (2):
       af9033: fix broken I2C
       af9035: fix broken I2C and USB I/O

Dan Carpenter (1):
       af9035: unlock on error in af9035_i2c_master_xfer()

  drivers/media/dvb-frontends/af9033.c  | 12 ++++++------
  drivers/media/usb/dvb-usb-v2/af9035.c | 15 +++++++++------
  2 files changed, 15 insertions(+), 12 deletions(-)



-- 
http://palosaari.fi/
