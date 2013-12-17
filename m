Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39041 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab3LQAKy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 19:10:54 -0500
Received: from dyn3-82-128-185-139.psoas.suomi.net ([82.128.185.139] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VsiFR-0005Oa-D1
	for linux-media@vger.kernel.org; Tue, 17 Dec 2013 02:10:53 +0200
Message-ID: <52AF968C.6060305@iki.fi>
Date: Tue, 17 Dec 2013 02:10:52 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.13] Anysee bug fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 675722b0e3917c6c917f1aa5f6d005cd3a0479f5:

   Merge branch 'upstream-fixes' into patchwork (2013-12-13 05:04:00 -0200)

are available in the git repository at:


   git://linuxtv.org/anttip/media_tree.git anysee_fix

for you to fetch changes up to 49fcf427186630d2624f4b7dea412fc6733119dc:

   anysee: fix non-working E30 Combo Plus DVB-T (2013-12-17 02:06:07 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       anysee: fix non-working E30 Combo Plus DVB-T

  drivers/media/usb/dvb-usb-v2/anysee.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

-- 
http://palosaari.fi/
