Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42583 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3FGO4S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jun 2013 10:56:18 -0400
Received: from dyn3-82-128-191-187.psoas.suomi.net ([82.128.191.187] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Uky5P-0005q8-Tr
	for linux-media@vger.kernel.org; Fri, 07 Jun 2013 17:56:15 +0300
Message-ID: <51B1F469.90808@iki.fi>
Date: Fri, 07 Jun 2013 17:55:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] rtl28xxu changes
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit aa4f608478acb7ed69dfcff4f3c404100b78ac49:

   Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k 
(2013-06-03 18:09:42 +0900)

are available in the git repository at:


   git://linuxtv.org/anttip/media_tree.git rtl28xxu

for you to fetch changes up to 3087c364fc03a6a1f2b7d44a79ad6db39840ce35:

   rtl28xxu: correct latest device name (2013-06-05 01:43:30 +0300)

----------------------------------------------------------------
Alessandro Miceli (1):
       Add support for Crypto Redi PC50A device (rtl2832u + FC0012 tuner)

Antti Palosaari (6):
       rtl28xxu: reimplement rtl2832u remote controller
       rtl28xxu: remove redundant IS_ENABLED macro
       rtl28xxu: correct some device names
       rtl28xxu: map remote for TerraTec Cinergy T Stick Black
       rtl28xxu: use masked reg write where possible
       rtl28xxu: correct latest device name

Miroslav Šustek (1):
       rtl28xxu: Add USB ID for Leadtek WinFast DTV Dongle mini

Rodrigo Tartajo (1):
       rtl2832u: restore ir remote control support.

  drivers/media/dvb-core/dvb-usb-ids.h    |   1 +
  drivers/media/usb/dvb-usb-v2/dvb_usb.h  |   2 +-
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 180 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   6 +++++
  4 files changed, 88 insertions(+), 101 deletions(-)


-- 
http://palosaari.fi/
