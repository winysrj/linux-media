Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44694 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbaCKPma (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 11:42:30 -0400
Received: from dyn3-82-128-190-236.psoas.suomi.net ([82.128.190.236] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WNOp2-0004KX-Lq
	for linux-media@vger.kernel.org; Tue, 11 Mar 2014 17:42:28 +0200
Message-ID: <531F2EE3.9080204@iki.fi>
Date: Tue, 11 Mar 2014 17:42:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] m88ds3103 fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just noticed from patchwork these old patches are pending. It appears 
I have not pull requested or mail is just missed from the reason or the 
other. They are just fine for 3.15, but "m88ds3103: fix bug on 
.set_tone()" is stuff for 3.14 too. I know it is very late, but given 
the fact it fixes existing bug and that driver has gone to 3.14 I hope 
that one patch could be sent to 3.14.

regards
Antti


The following changes since commit 587d1b06e07b4a079453c74ba9edf17d21931049:

   [media] rc-core: reuse device numbers (2014-01-15 11:46:37 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git pctv_461e

for you to fetch changes up to e0d125fb17ac2bb5a992d2d761d1a0a2b42546aa:

   m88ds3103: fix bug on .set_tone() (2014-02-01 22:28:21 +0200)

----------------------------------------------------------------
Antti Palosaari (4):
       m88ds3103: remove dead code
       m88ds3103: remove dead code 2nd part
       m88ds3103: possible uninitialized scalar variable
       m88ds3103: fix bug on .set_tone()

  drivers/media/dvb-frontends/m88ds3103.c | 30 
++++++++----------------------
  1 file changed, 8 insertions(+), 22 deletions(-)

-- 
http://palosaari.fi/
