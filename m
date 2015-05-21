Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54078 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbbEUUFu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 16:05:50 -0400
Received: from 85-23-164-23.bb.dnainternet.fi ([85.23.164.23] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1YvWiz-0004DQ-3I
	for linux-media@vger.kernel.org; Thu, 21 May 2015 23:05:49 +0300
Message-ID: <555E3A9C.8080009@iki.fi>
Date: Thu, 21 May 2015 23:05:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] af9035: add USB ID 07ca:0337 AVerMedia HD Volar (A867)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 2a80f296422a01178d0a993479369e94f5830127:

   [media] dvb-core: fix 32-bit overflow during bandwidth calculation 
(2015-05-20 14:01:46 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035_pull

for you to fetch changes up to a12c204cc89dbcbc23489bd755608c7d5fd5ebd0:

   af9035: add USB ID 07ca:0337 AVerMedia HD Volar (A867) (2015-05-21 
22:54:40 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       af9035: add USB ID 07ca:0337 AVerMedia HD Volar (A867)

  drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
  1 file changed, 2 insertions(+)

-- 
http://palosaari.fi/
