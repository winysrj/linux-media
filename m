Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49660 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaKRHZM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 02:25:12 -0500
Received: from dyn3-82-128-189-20.psoas.suomi.net ([82.128.189.20] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Xqd9y-00047a-U5
	for linux-media@vger.kernel.org; Tue, 18 Nov 2014 09:25:10 +0200
Message-ID: <546AF456.4080906@iki.fi>
Date: Tue, 18 Nov 2014 09:25:10 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] rtl28xxu / mn88472 / mn88473
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V2. Fixed issues pointed by Mauro.

regards
Antti

The following changes since commit c02ef64aab828d80040b5dce934729312e698c33:

   [media] cx23885: add DVBSky T982(Dual DVB-T2/T/C) support (2014-11-14 
18:28:41 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git astrometa

for you to fetch changes up to 52028b9f5b3a4c4c349a50ac626f7a97a48a51ca:

   rtl28xxu: add SDR module for devices having R828D tuner (2014-11-18 
09:16:54 +0200)

----------------------------------------------------------------
Antti Palosaari (6):
       rtl2832: implement option to bypass slave demod TS
       rtl28xxu: add support for Panasonic MN88472 slave demod
       rtl28xxu: add support for Panasonic MN88473 slave demod
       rtl28xxu: rename tuner I2C client pointer
       rtl28xxu: remove unused SDR attach logic
       rtl28xxu: add SDR module for devices having R828D tuner

  drivers/media/dvb-frontends/rtl2832.c   |  60 
++++++++++++++++++++++++++++++++++++++++++++++++---
  drivers/media/dvb-frontends/rtl2832.h   |  11 ++++++++++
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 194 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   7 +++++-

-- 
http://palosaari.fi/
