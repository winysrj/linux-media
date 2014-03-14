Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40582 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbaCNT23 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 15:28:29 -0400
Received: from dyn3-82-128-190-236.psoas.suomi.net ([82.128.190.236] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WOXmO-0001km-J9
	for linux-media@vger.kernel.org; Fri, 14 Mar 2014 21:28:28 +0200
Message-ID: <5323585B.8040200@iki.fi>
Date: Fri, 14 Mar 2014 21:28:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] 2 SDR fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These were reported by kbuild test robot <fengguang.wu@intel.com> after 
todays rtl2832_sdr driver commit.

regards
Antti


The following changes since commit ba35ca07080268af1badeb47de0f9eff28126339:

   [media] em28xx-audio: make sure audio is unmuted on open() 
(2014-03-14 10:17:18 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git sdr_review_v7

for you to fetch changes up to 78d81c0fbbd382fe0e0d688956413d9a035c8e21:

   rtl2832_sdr: do not use dynamic stack allocation (2014-03-14 21:20:40 
+0200)

----------------------------------------------------------------
Antti Palosaari (2):
       e4000: fix 32-bit build error
       rtl2832_sdr: do not use dynamic stack allocation

  drivers/media/tuners/e4000.c                     | 6 ++++--
  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 7 ++++++-
  2 files changed, 10 insertions(+), 3 deletions(-)

-- 
http://palosaari.fi/
