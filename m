Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32983 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaCKQQA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 12:16:00 -0400
Received: from dyn3-82-128-190-236.psoas.suomi.net ([82.128.190.236] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WNPLS-0003Ic-UX
	for linux-media@vger.kernel.org; Tue, 11 Mar 2014 18:15:58 +0200
Message-ID: <531F36BE.5060202@iki.fi>
Date: Tue, 11 Mar 2014 18:15:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.14] m88ds3103 bugfix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have forgotten to pull request that earlier. It is simple one bit 
wrong in one register.

regards
Antti

The following changes since commit 81d428cbdb9e630f4424bf81522cd35394beba76:

   [media] saa7134: fix WARN_ON during resume (2014-03-11 10:17:06 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git m88ds3103_bugfix_3.14

for you to fetch changes up to 9f0a66dd910d16165a9c3862c86283010e4bf5c0:

   m88ds3103: fix bug on .set_tone() (2014-03-11 18:08:51 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       m88ds3103: fix bug on .set_tone()

  drivers/media/dvb-frontends/m88ds3103.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)


-- 
http://palosaari.fi/
