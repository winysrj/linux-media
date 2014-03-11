Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42902 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbaCKQYj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 12:24:39 -0400
Received: from dyn3-82-128-190-236.psoas.suomi.net ([82.128.190.236] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WNPTp-0004t0-Uc
	for linux-media@vger.kernel.org; Tue, 11 Mar 2014 18:24:38 +0200
Message-ID: <531F38C5.5040400@iki.fi>
Date: Tue, 11 Mar 2014 18:24:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.15] m88ds3103 fix non-important issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are reported by Coverity and has no functionality changes.

regards
Antti

The following changes since commit c3c2077d9579472b07581ecdaf6cc5a60b1700bc:

   [media] nuvoton-cir: Activate PNP device when probing (2014-03-11 
12:22:50 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git m88ds3103_3.15

for you to fetch changes up to f8b959e39d19e44a008cea3730af0256f4be5f5c:

   m88ds3103: possible uninitialized scalar variable (2014-03-11 
18:17:29 +0200)

----------------------------------------------------------------
Antti Palosaari (3):
       m88ds3103: remove dead code
       m88ds3103: remove dead code 2nd part
       m88ds3103: possible uninitialized scalar variable

  drivers/media/dvb-frontends/m88ds3103.c | 28 +++++++---------------------
  1 file changed, 7 insertions(+), 21 deletions(-)

-- 
http://palosaari.fi/
