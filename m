Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35961 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbbKGM0l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2015 07:26:41 -0500
Received: from dyn3-82-128-185-10.psoas.suomi.net ([82.128.185.10] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1Zv2Zs-0007Ae-CL
	for linux-media@vger.kernel.org; Sat, 07 Nov 2015 14:26:40 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL STABLE] airspy: increase USB control message buffer size
Message-ID: <563DEE00.5050908@iki.fi>
Date: Sat, 7 Nov 2015 14:26:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 79f5b6ae960d380c829fb67d5dadcd1d025d2775:

   [media] c8sectpfe: Remove select on 
CONFIG_FW_LOADER_USER_HELPER_FALLBACK (2015-10-20 16:02:41 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git airspy

for you to fetch changes up to 79d7c879f3a994da146d7c19feb71cd2ab6b2215:

   airspy: increase USB control message buffer size (2015-11-05 05:01:30 
+0200)

----------------------------------------------------------------
Antti Palosaari (1):
       airspy: increase USB control message buffer size

  drivers/media/usb/airspy/airspy.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

-- 
http://palosaari.fi/
