Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46686 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab2AMSan (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 13:30:43 -0500
Message-ID: <4F10784F.5000405@iki.fi>
Date: Fri, 13 Jan 2012 20:30:39 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.3 v3] HDIC HD29L2 DMB-TH demodulator driver
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Apply that if possible :)

regards
Antti

The following changes since commit 240ab508aa9fb7a294b0ecb563b19ead000b2463:

   [media] [PATCH] don't reset the delivery system on DTV_CLEAR 
(2012-01-10 23:44:07 -0200)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git hdic_v3

Antti Palosaari (1):
       revert patch: HDIC HD29L2 DMB-TH USB2.0 reference design driver

  drivers/media/dvb/dvb-usb/Kconfig  |    7 -
  drivers/media/dvb/dvb-usb/Makefile |    3 -
  drivers/media/dvb/dvb-usb/hdic.c   |  365 
------------------------------------
  drivers/media/dvb/dvb-usb/hdic.h   |   45 -----
  4 files changed, 0 insertions(+), 420 deletions(-)
  delete mode 100644 drivers/media/dvb/dvb-usb/hdic.c
  delete mode 100644 drivers/media/dvb/dvb-usb/hdic.h

-- 
http://palosaari.fi/
