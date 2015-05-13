Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44495 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbbEMUYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 16:24:07 -0400
Received: from dyn3-82-128-190-23.psoas.suomi.net ([82.128.190.23] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1YsdCH-0003AK-GG
	for linux-media@vger.kernel.org; Wed, 13 May 2015 23:24:05 +0300
Message-ID: <5553B2E4.80002@iki.fi>
Date: Wed, 13 May 2015 23:24:04 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 4.2] msi2500 / msi001 enhancements
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 356484cabe44984d2dc66a90bd5e3465ba1f64fb:

   [media] dw2102: resync fifo when demod locks (2015-05-13 17:12:42 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git mirics_pull

for you to fetch changes up to d86c4b050488c08397bec61da971f9223a881b10:

   msi2500: cleanups (2015-05-13 23:22:15 +0300)

----------------------------------------------------------------
Antti Palosaari (4):
       msi001: revise synthesizer calculation
       msi001: cleanups / renames
       msi2500: revise synthesizer calculation
       msi2500: cleanups

  drivers/media/tuners/msi001.c       | 267 
++++++++++++++++++++++++++++++++++++--------------------------------
  drivers/media/usb/msi2500/msi2500.c | 655 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------------
  2 files changed, 482 insertions(+), 440 deletions(-)

-- 
http://palosaari.fi/
