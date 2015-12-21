Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46241 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbLUDDR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2015 22:03:17 -0500
Received: from dyn3-82-128-188-254.psoas.suomi.net ([82.128.188.254] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1aAqkl-0003gv-Hi
	for linux-media@vger.kernel.org; Mon, 21 Dec 2015 05:03:15 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.5] rtl2832u changes
Message-ID: <56776BF3.4020202@iki.fi>
Date: Mon, 21 Dec 2015 05:03:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0aff8a894a2be4c22e6414db33061153a4b35bc9:

   [media] uvcvideo: small cleanup in uvc_video_clock_update() 
(2015-12-18 15:21:35 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl2832u_pull

for you to fetch changes up to bbed859d68218c043fa88ccdd9785d9567d8fb5d:

   rtl2832: do not filter out slave TS null packets (2015-12-20 04:57:20 
+0200)

----------------------------------------------------------------
Antti Palosaari (3):
       rtl28xxu: return demod reg page from driver cache
       rtl2832: print reg number on error case
       rtl2832: do not filter out slave TS null packets

  drivers/media/dvb-frontends/rtl2832.c   | 21 ++++++---------------
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 16 +++++++++++-----
  2 files changed, 17 insertions(+), 20 deletions(-)

-- 
http://palosaari.fi/
