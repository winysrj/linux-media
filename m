Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40363 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaLCXUs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 18:20:48 -0500
Received: from dyn3-82-128-190-178.psoas.suomi.net ([82.128.190.178] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XwJDz-0002ds-5k
	for linux-media@vger.kernel.org; Thu, 04 Dec 2014 01:20:47 +0200
Message-ID: <547F9ACE.9070705@iki.fi>
Date: Thu, 04 Dec 2014 01:20:46 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.19] rtl2832_sdr fix
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 504febc3f98c87a8bebd8f2f274f32c0724131e4:

   Revert "[media] lmed04: add missing breaks" (2014-11-25 22:16:25 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl2832_sdr

for you to fetch changes up to df12dc299d72779a1595b713909a706fe0785ece:

   rtl2832_sdr: control ADC (2014-12-04 01:16:24 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       rtl2832_sdr: control ADC

  drivers/media/dvb-frontends/rtl2832_sdr.c | 8 ++++++++
  1 file changed, 8 insertions(+)

-- 
http://palosaari.fi/
