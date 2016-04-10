Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53124 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbcDJWQR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2016 18:16:17 -0400
Received: from dyn3-82-128-189-135.psoas.suomi.net ([82.128.189.135] helo=c-46-246-82-226.ip4.frootvpn.com)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1apNeQ-000797-Je
	for linux-media@vger.kernel.org; Mon, 11 Apr 2016 01:16:14 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.6] m88ds3103 fix
Message-ID: <570AD0AE.9080400@iki.fi>
Date: Mon, 11 Apr 2016 01:16:14 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That is actually bug fix for 3.19+, but according to my tests its effect 
is very minor, so no need for stable. It fixes demod carrier offset 
calculation.


The following changes since commit da470473c9cf9c4ebb40d046b306c76427b6df94:

   [media] media: au0828 fix to clear enable/disable/change source 
handlers (2016-03-13 10:12:53 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git m88ds3103_fix

for you to fetch changes up to d717c129756c46321e277045706c70f602595ba1:

   m88ds3103: fix undefined division (2016-04-11 01:07:59 +0300)

----------------------------------------------------------------
Peter Rosin (1):
       m88ds3103: fix undefined division

  drivers/media/dvb-frontends/m88ds3103_priv.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

-- 
http://palosaari.fi/
