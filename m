Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55455 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbcFHNkU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2016 09:40:20 -0400
Received: from [82.128.187.124] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1bAdiT-0000JS-TZ
	for linux-media@vger.kernel.org; Wed, 08 Jun 2016 16:40:17 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.8] rtl2832
Message-ID: <b724a37a-0d37-1bc4-820e-967d5be4e335@iki.fi>
Date: Wed, 8 Jun 2016 16:40:17 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 94d0eaa419871a6e2783f8c131b1d76d5f2a5524:

   [media] mn88472: move out of staging to media (2016-06-07 15:46:47 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl2832

for you to fetch changes up to b3ce3f22e249dd2fd8a8a7249132f0ad9873dc05:

   rtl2832: add support for slave ts pid filter (2016-06-08 16:35:31 +0300)

----------------------------------------------------------------
Martin Blumenstingl (1):
       rtl2832: add support for slave ts pid filter

  drivers/media/dvb-frontends/rtl2832.c      | 25 +++++++++++++++++++------
  drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
  2 files changed, 20 insertions(+), 6 deletions(-)

-- 
http://palosaari.fi/
