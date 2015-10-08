Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40594 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbbJHBgT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2015 21:36:19 -0400
To: LMML <linux-media@vger.kernel.org>
Cc: Mark Clarkstone <hello@markclarkstone.co.uk>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL STABLE 4.2+] m88ds3103 bugfix
Message-ID: <5615C891.90205@iki.fi>
Date: Thu, 8 Oct 2015 04:36:17 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ca739eb086155007d7264be7ccc07f894d5a7bbe:

   Revert "[media] rcar_vin: call g_std() instead of querystd()" 
(2015-10-01 15:49:17 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git m88ds3103_bugfix

for you to fetch changes up to 52a1d419371a2f8d3cd76d59d5b27309c86d65af:

   m88ds3103: use own reg update_bits() implementation (2015-10-04 
00:59:24 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       m88ds3103: use own reg update_bits() implementation

  drivers/media/dvb-frontends/m88ds3103.c | 73 
+++++++++++++++++++++++++++++++++++++++++++++++--------------------------
  1 file changed, 47 insertions(+), 26 deletions(-)

-- 
http://palosaari.fi/
