Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52431 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbaGVIwX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 04:52:23 -0400
Received: from 85-23-164-198.bb.dnainternet.fi ([85.23.164.198] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1X9Vo6-0004nC-FS
	for linux-media@vger.kernel.org; Tue, 22 Jul 2014 11:52:22 +0300
Message-ID: <53CE2645.3040204@iki.fi>
Date: Tue, 22 Jul 2014 11:52:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] Mirics MSi3101/MSi2500 driver changes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a733291d6934d0663af9e7d9f2266ab87a2946cd:

   Merge commit '67dd8f35c2d8ed80f26c9654b474cffc11c6674d' into 
patchwork (2014-07-22 02:03:59 -0300)

are available in the git repository at:


   git://linuxtv.org/anttip/media_tree.git sdr_pull

for you to fetch changes up to 7b845e2cd9081683743f3f3688456ea3b09c8ad8:

   msi2500: rename namespace msi3101 => msi2500 (2014-07-22 11:47:29 +0300)

----------------------------------------------------------------
Antti Palosaari (3):
       msi2500: correct style issues
       msi2500: refactor USB stream copying
       msi2500: rename namespace msi3101 => msi2500

  drivers/media/usb/msi2500/msi2500.c | 745 
++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------------------
  1 file changed, 273 insertions(+), 472 deletions(-)

-- 
http://palosaari.fi/
