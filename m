Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59236 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbbCNQxR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 12:53:17 -0400
Received: from 85-23-164-4.bb.dnainternet.fi ([85.23.164.4] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1YWpJK-00035H-TO
	for linux-media@vger.kernel.org; Sat, 14 Mar 2015 18:53:14 +0200
Message-ID: <5504677A.8010908@iki.fi>
Date: Sat, 14 Mar 2015 18:53:14 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 4.0] rtl28xx fixes for 4.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 41f03a00536ebb3d72c051f9e7efe2d4ab76ebc8:

   [media] s5p-mfc: Fix NULL pointer dereference caused by not set 
q->lock (2015-03-04 08:59:58 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl28xx_fixes

for you to fetch changes up to 536c12e1da3491d6ee263995ac267b487a9cd33b:

   rtl28xxu: return success for unimplemented FE callback (2015-03-14 
18:03:55 +0200)

----------------------------------------------------------------
Antti Palosaari (2):
       rtl2832: disable regmap register cache
       rtl28xxu: return success for unimplemented FE callback

  drivers/media/dvb-frontends/rtl2832.c   | 2 +-
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 --
  2 files changed, 1 insertion(+), 3 deletions(-)

-- 
http://palosaari.fi/
