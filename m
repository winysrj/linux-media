Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55809 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075AbaGYJoo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 05:44:44 -0400
Received: from 85-23-164-198.bb.dnainternet.fi ([85.23.164.198] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XAc3P-0004wa-9n
	for linux-media@vger.kernel.org; Fri, 25 Jul 2014 12:44:43 +0300
Message-ID: <53D2270A.6040403@iki.fi>
Date: Fri, 25 Jul 2014 12:44:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.17] SDR related build fixes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 488046c237f3b78f91046d45662b318cd2415f64:

   [media] rc: Fix compilation of st_rc and sunxi-cir (2014-07-23 
23:04:17 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git sdr_pull

for you to fetch changes up to 833f08be8e8661a5893450250bfff62120a73314:

   Kconfig: rtl2832_sdr must depends on USB (2014-07-25 12:40:24 +0300)

----------------------------------------------------------------
Antti Palosaari (2):
       Kconfig: fix tuners build warnings
       Kconfig: rtl2832_sdr must depends on USB

  drivers/media/dvb-frontends/Kconfig | 2 +-
  drivers/media/tuners/Kconfig        | 3 ++-
  2 files changed, 3 insertions(+), 2 deletions(-)

-- 
http://palosaari.fi/
