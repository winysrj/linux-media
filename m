Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36534 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbaFOJcK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 05:32:10 -0400
Received: from 85-23-164-3.bb.dnainternet.fi ([85.23.164.3] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Ww6nI-0007GG-Se
	for linux-media@vger.kernel.org; Sun, 15 Jun 2014 12:32:08 +0300
Message-ID: <539D6818.1090500@iki.fi>
Date: Sun, 15 Jun 2014 12:32:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [PULL 3.16] si2168 and si2157 fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a2668e10d7246e782f7708dc47c00f035da23a81:

   [media] au0828-dvb: restore its permission to 644 (2014-06-04 
15:19:36 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git silabs_fixes

for you to fetch changes up to 6b344e9ee2ecbeca3e0bded05cd11788d447074f:

   si2168: firmware download fix (2014-06-15 12:04:00 +0300)

----------------------------------------------------------------
Antti Palosaari (3):
       si2168: add one missing parenthesis
       si2157: add one missing parenthesis
       si2168: firmware download fix

  drivers/media/dvb-frontends/si2168.c      | 16 +---------------
  drivers/media/dvb-frontends/si2168_priv.h |  2 +-
  drivers/media/tuners/si2157.c             |  2 +-
  3 files changed, 3 insertions(+), 17 deletions(-)


-- 
http://palosaari.fi/
