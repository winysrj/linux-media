Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48428 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbaIGCBo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 22:01:44 -0400
Received: from dyn3-82-128-191-243.psoas.suomi.net ([82.128.191.243] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XQRnT-0004rG-3Q
	for linux-media@vger.kernel.org; Sun, 07 Sep 2014 05:01:43 +0300
Message-ID: <540BBC85.7000606@iki.fi>
Date: Sun, 07 Sep 2014 05:01:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] tda18212 improvements
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 89fffac802c18caebdf4e91c0785b522c9f6399a:

   [media] drxk_hard: fix bad alignments (2014-09-03 19:19:18 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git tda18212

for you to fetch changes up to 69afce975bd1978941b5174eb20f14bad58db667:

   tda18212: convert to RegMap API (2014-09-07 04:56:45 +0300)

----------------------------------------------------------------
Antti Palosaari (8):
       tda18212: add support for slave chip version
       tda18212: prepare for I2C client conversion
       anysee: convert tda18212 tuner to I2C client
       em28xx: convert tda18212 tuner to I2C client
       tda18212: convert driver to I2C binding
       tda18212: clean logging
       tda18212: rename state from 'priv' to 'dev'
       tda18212: convert to RegMap API

  drivers/media/tuners/Kconfig          |   1 +
  drivers/media/tuners/tda18212.c       | 272 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------
  drivers/media/tuners/tda18212.h       |  19 +++-------
  drivers/media/usb/dvb-usb-v2/anysee.c | 185 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
  drivers/media/usb/dvb-usb-v2/anysee.h |   3 ++
  drivers/media/usb/em28xx/em28xx-dvb.c |  32 +++++++++++++----
  6 files changed, 292 insertions(+), 220 deletions(-)

-- 
http://palosaari.fi/
