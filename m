Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51041 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbaCPV6x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 17:58:53 -0400
Received: from dyn3-82-128-190-236.psoas.suomi.net ([82.128.190.236] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WPJ52-00024r-FQ
	for linux-media@vger.kernel.org; Sun, 16 Mar 2014 23:58:52 +0200
Message-ID: <53261E9B.2070801@iki.fi>
Date: Sun, 16 Mar 2014 23:58:51 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] SDR / E4000 V4L2 dependency fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ed97a6fe5308e5982d118a25f0697b791af5ec50:

   [media] af9033: Don't export functions for the hardware filter 
(2014-03-14 20:26:59 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git sdr_review_v8

for you to fetch changes up to 50a30af2cbf149ee0354edd04be93aaef2335e32:

   e4000: make VIDEO_V4L2 dependency optional (2014-03-16 23:22:51 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       e4000: make VIDEO_V4L2 dependency optional

  drivers/media/tuners/Kconfig | 2 +-
  drivers/media/tuners/e4000.c | 6 ++++++
  2 files changed, 7 insertions(+), 1 deletion(-)

-- 
http://palosaari.fi/
