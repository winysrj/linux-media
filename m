Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41755 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab3JaOyN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Oct 2013 10:54:13 -0400
Received: from [82.128.187.194] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VbtdT-0001Od-Td
	for linux-media@vger.kernel.org; Thu, 31 Oct 2013 16:54:11 +0200
Message-ID: <52726F13.8050703@iki.fi>
Date: Thu, 31 Oct 2013 16:54:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.13] RTL2830 I2C adapter crash
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It does not crash anymore as I2C routines are fixed. Anyhow, every I2C 
adapter should have a parent. So pull it for 3.13 as enhancement.


The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

   [media] media: st-rc: Add ST remote control driver (2013-10-31 
08:20:08 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git i2c_adapter_crash

for you to fetch changes up to 56a885df5f6c96f8b609a2399aa71b9757271ee4:

   rtl2830: add parent for I2C adapter (2013-10-31 16:50:16 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       rtl2830: add parent for I2C adapter

  drivers/media/dvb-frontends/rtl2830.c | 1 +
  1 file changed, 1 insertion(+)


regards
Antti
-- 
http://palosaari.fi/
