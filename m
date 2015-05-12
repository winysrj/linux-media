Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40814 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933003AbbELRtF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 13:49:05 -0400
Received: from dyn3-82-128-190-23.psoas.suomi.net ([82.128.190.23] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1YsEIh-00063r-H4
	for linux-media@vger.kernel.org; Tue, 12 May 2015 20:49:03 +0300
Message-ID: <55523D0E.1090605@iki.fi>
Date: Tue, 12 May 2015 20:49:02 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 4.2] fc2580 / tua9001 / rtl2832_sdr
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 250d2ff01623e80943c4ffed0308b0d19fe6625d:

   [media] rtl28xxu: fix return value check in rtl2832u_tuner_attach() 
(2015-05-12 13:27:22 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git fc2580_tua9001

for you to fetch changes up to bb397f414b1e8bc100f3744ae5278897bf5ee790:

   rtl28xxu: load SDR module for fc2580 based devices (2015-05-12 
20:45:15 +0300)

----------------------------------------------------------------
Antti Palosaari (21):
       fc2580: implement I2C client bindings
       rtl28xxu: bind fc2580 using I2C binding
       af9035: bind fc2580 using I2C binding
       fc2580: remove obsolete media attach
       fc2580: improve set params logic
       fc2580: cleanups and variable renames
       fc2580: use regmap for register I2C access
       af9035: fix device order in ID list
       tua9001: add I2C bindings
       af9035: bind tua9001 using I2C binding
       rtl28xxu: bind tua9001 using I2C binding
       tua9001: remove media attach
       tua9001: various minor changes
       tua9001: use regmap for I2C register access
       tua9001: use div_u64() for frequency calculation
       rtl2832: add inittab for FC2580 tuner
       rtl28xxu: set correct FC2580 tuner for RTL2832 demod
       fc2580: calculate filter control word dynamically
       fc2580: implement V4L2 subdevice for SDR control
       rtl2832_sdr: add support for fc2580 tuner
       rtl28xxu: load SDR module for fc2580 based devices

  drivers/media/dvb-frontends/rtl2832.c      |   4 +
  drivers/media/dvb-frontends/rtl2832.h      |   1 +
  drivers/media/dvb-frontends/rtl2832_priv.h |  24 +++++
  drivers/media/dvb-frontends/rtl2832_sdr.c  | 110 +++++++++++++++++++----
  drivers/media/dvb-frontends/rtl2832_sdr.h  |   1 +
  drivers/media/tuners/Kconfig               |   4 +-
  drivers/media/tuners/fc2580.c              | 780 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------
  drivers/media/tuners/fc2580.h              |  40 ++++-----
  drivers/media/tuners/fc2580_priv.h         |  36 +++++---
  drivers/media/tuners/tua9001.c             | 331 
+++++++++++++++++++++++++++++++++-----------------------------------
  drivers/media/tuners/tua9001.h             |  35 +++-----
  drivers/media/tuners/tua9001_priv.h        |  19 ++--
  drivers/media/usb/dvb-usb-v2/af9035.c      |  55 +++++++-----
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |  66 ++++++++++----
  14 files changed, 865 insertions(+), 641 deletions(-)

-- 
http://palosaari.fi/
