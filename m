Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60852 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab3HGWq2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 18:46:28 -0400
Received: from dyn3-82-128-186-228.psoas.suomi.net ([82.128.186.228] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1V7CUt-00026Z-Kt
	for linux-media@vger.kernel.org; Thu, 08 Aug 2013 01:46:27 +0300
Message-ID: <5202CE1B.8050801@iki.fi>
Date: Thu, 08 Aug 2013 01:45:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.12] DVB USB v2 get rid of deferred probe
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 1c26190a8d492adadac4711fe5762d46204b18b0:

   [media] exynos4-is: Correct colorspace handling at FIMC-LITE 
(2013-06-28 15:33:27 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git dvb_usb_v2

for you to fetch changes up to c42f1abc409a87eb7791105ba9e1125924820655:

   dvb_usb_v2: get rid of deferred probe (2013-08-08 01:43:43 +0300)

----------------------------------------------------------------
Antti Palosaari (2):
       lme2510: do not use bInterfaceNumber from dvb_usb_v2
       dvb_usb_v2: get rid of deferred probe

  drivers/media/usb/dvb-usb-v2/dvb_usb.h      |   5 -----
  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 134 
+++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------
  drivers/media/usb/dvb-usb-v2/lmedm04.c      |   2 +-
  3 files changed, 46 insertions(+), 95 deletions(-)

-- 
http://palosaari.fi/
