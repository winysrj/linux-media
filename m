Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48228 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758489AbcEFP6M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 11:58:12 -0400
Received: from dyn3-82-128-185-211.psoas.suomi.net ([82.128.185.211] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1ayi8n-0005pQ-P2
	for linux-media@vger.kernel.org; Fri, 06 May 2016 18:58:09 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.7] af9035
Message-ID: <572CBF11.6080404@iki.fi>
Date: Fri, 6 May 2016 18:58:09 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 45c175c4ae9695d6d2f30a45ab7f3866cfac184b:

   [media] tw686x: avoid going past array (2016-04-26 06:38:53 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035

for you to fetch changes up to 9c3cda3783707e8028ec1335e9ec0a63edb4712b:

   af9035: correct eeprom offsets (2016-04-27 23:08:50 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       af9035: correct eeprom offsets

  drivers/media/usb/dvb-usb-v2/af9035.h | 24 ++++++++++++------------
  1 file changed, 12 insertions(+), 12 deletions(-)

-- 
http://palosaari.fi/
