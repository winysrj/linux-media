Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45461 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbbEUTYx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 15:24:53 -0400
Received: from 85-23-164-23.bb.dnainternet.fi ([85.23.164.23] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1YvW5L-0006NL-Vh
	for linux-media@vger.kernel.org; Thu, 21 May 2015 22:24:52 +0300
Message-ID: <555E3103.6000605@iki.fi>
Date: Thu, 21 May 2015 22:24:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 4.2] m88ds3103 enhancements
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 2a80f296422a01178d0a993479369e94f5830127:

   [media] dvb-core: fix 32-bit overflow during bandwidth calculation 
(2015-05-20 14:01:46 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git m88ds3103_pull

for you to fetch changes up to bfdb54de213477ec9f5d45d43c91bdaa54382cda:

   m88ds3103: add I2C client binding (2015-05-21 22:17:10 +0300)

----------------------------------------------------------------
Antti Palosaari (5):
       m88ds3103: do not return error from get_frontend() when not ready
       m88ds3103: implement DVBv5 CNR statistics
       m88ds3103: implement DVBv5 BER
       m88ds3103: use jiffies when polling DiSEqC TX ready
       m88ds3103: add I2C client binding

  drivers/media/dvb-frontends/m88ds3103.c      | 642 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------
  drivers/media/dvb-frontends/m88ds3103.h      |  63 ++++++++++++++--
  drivers/media/dvb-frontends/m88ds3103_priv.h |   6 +-
  3 files changed, 456 insertions(+), 255 deletions(-)

-- 
http://palosaari.fi/
