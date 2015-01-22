Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56121 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbbAVKMB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 05:12:01 -0500
Received: from [82.128.187.65] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1YEEk3-0007VM-Qx
	for linux-media@vger.kernel.org; Thu, 22 Jan 2015 12:11:59 +0200
Message-ID: <54C0CCEF.8080500@iki.fi>
Date: Thu, 22 Jan 2015 12:11:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.19] si2168 fix
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That patch must go also stable v3.16+ as tagged Cc.

regards
Antti

The following changes since commit 2c0108e1c02f9fc95f465adc4d2ce1ad8688290a:

   [media] omap3isp: Correctly set QUERYCAP capabilities (2015-01-21 
21:09:11 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git si2168_fix

for you to fetch changes up to a85385413c60602b529a1555146c4e81a5935e98:

   si2168: increase timeout to fix firmware loading (2015-01-22 12:06:20 
+0200)

----------------------------------------------------------------
Jurgen Kramer (1):
       si2168: increase timeout to fix firmware loading

  drivers/media/dvb-frontends/si2168.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

-- 
http://palosaari.fi/
