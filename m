Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56136 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbaKCVnY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 16:43:24 -0500
Received: from dyn3-82-128-186-135.psoas.suomi.net ([82.128.186.135] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XlPPH-00017z-L5
	for linux-media@vger.kernel.org; Mon, 03 Nov 2014 23:43:23 +0200
Message-ID: <5457F6FB.1040204@iki.fi>
Date: Mon, 03 Nov 2014 23:43:23 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.19] one trivial si2168 patch
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f4df95bcbb7b142bdb4cf201f5e1bd3985f8c804:

   [media] m88ds3103: add support for the demod of M88RS6000 (2014-11-03 
18:24:15 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git si2168

for you to fetch changes up to 991b315b248c4d773f1142778ec02e060b17a9fc:

   si2168: do not print device is warm every-time when opened 
(2014-11-03 23:28:39 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       si2168: do not print device is warm every-time when opened

  drivers/media/dvb-frontends/si2168.c | 3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

-- 
http://palosaari.fi/
