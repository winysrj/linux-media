Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37752 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbbELPn2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 11:43:28 -0400
Message-ID: <55521F9C.20705@iki.fi>
Date: Tue, 12 May 2015 18:43:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [GIT PULL 4.2] rtl28xxu error check fix
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even it is clear bug, I think it is not worth to stable. So let it go to 
4.2.

regards
Antti

The following changes since commit b2624ff4bf46869df66148b2e1e675981565742e:

   [media] mantis: fix error handling (2015-05-12 08:12:18 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl28xxu

for you to fetch changes up to 635eb191a7bd9cae0cbe69bcb2e9a69b8753d9bc:

   rtl28xxu: fix return value check in rtl2832u_tuner_attach() 
(2015-05-12 18:38:26 +0300)

----------------------------------------------------------------
Wei Yongjun (1):
       rtl28xxu: fix return value check in rtl2832u_tuner_attach()

  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

-- 
http://palosaari.fi/
