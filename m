Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54066 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168AbbERURx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 16:17:53 -0400
Received: from dyn3-82-128-184-18.psoas.suomi.net ([82.128.184.18] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1YuRTz-0007Ob-PV
	for linux-media@vger.kernel.org; Mon, 18 May 2015 23:17:51 +0300
Message-ID: <555A48EF.1020608@iki.fi>
Date: Mon, 18 May 2015 23:17:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 4.2] fix 32-bit overflow during bandwidth calculation
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to sent that to stable as none is using that value on DVB-S/S2 
driver which is only standard symbol rates could be so high that 
calculation overflows.

Antti

The following changes since commit 9cae84b32dd52768cf2fd2fcb214c3f570676c4b:

   [media] DocBook/media: fix syntax error (2015-05-18 16:27:31 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git dvb-core_pull

for you to fetch changes up to 8f8020b864a97b6a5dfdbc77f5645ec7abf395c1:

   dvb-core: fix 32-bit overflow during bandwidth calculation 
(2015-05-18 23:14:29 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       dvb-core: fix 32-bit overflow during bandwidth calculation

  drivers/media/dvb-core/dvb_frontend.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

-- 
http://palosaari.fi/
