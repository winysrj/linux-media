Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52958 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbcFGH5p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 03:57:45 -0400
Received: from dyn3-82-128-184-205.psoas.suomi.net ([82.128.184.205] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1bABtP-0001hN-7z
	for linux-media@vger.kernel.org; Tue, 07 Jun 2016 10:57:43 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.8] mn88472
Message-ID: <790dd3a2-b6ee-753c-ca31-87b2099f5d2b@iki.fi>
Date: Tue, 7 Jun 2016 10:57:42 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6a2cf60b3e6341a3163d3cac3f4bede126c2e894:

   Merge tag 'v4.7-rc1' into patchwork (2016-05-30 18:16:14 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git mn88472

for you to fetch changes up to 4f4a390b2f195e5c26be370a4bc85183d6919aac:

   rtl28xxu: sort the config symbols which are auto-selected (2016-06-07 
10:46:02 +0300)

----------------------------------------------------------------
Antti Palosaari (3):
       rtl28xxu: increase failed I2C msg repeat count to 3
       mn88472: finalize driver
       mn88472: move out of staging to media

Julia Lawall (1):
       mn88472: fix typo

Martin Blumenstingl (2):
       rtl28xxu: auto-select more DVB-frontends and tuners
       rtl28xxu: sort the config symbols which are auto-selected

  MAINTAINERS 
|   4 +-
  drivers/media/dvb-frontends/Kconfig 
|   8 ++
  drivers/media/dvb-frontends/Makefile 
|   1 +
  drivers/{staging/media/mn88472 => media/dvb-frontends}/mn88472.c 
| 519 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------
  drivers/media/dvb-frontends/mn88472.h 
|  45 +++++-----
  drivers/{staging/media/mn88472 => media/dvb-frontends}/mn88472_priv.h 
|  11 ++-
  drivers/media/usb/dvb-usb-v2/Kconfig 
|  13 ++-
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c 
|   2 +-
  drivers/staging/media/Kconfig 
|   2 -
  drivers/staging/media/Makefile 
|   1 -
  drivers/staging/media/mn88472/Kconfig 
|   7 --
  drivers/staging/media/mn88472/Makefile 
|   5 --
  drivers/staging/media/mn88472/TODO 
|  21 -----
  13 files changed, 327 insertions(+), 312 deletions(-)
  rename drivers/{staging/media/mn88472 => 
media/dvb-frontends}/mn88472.c (58%)
  rename drivers/{staging/media/mn88472 => 
media/dvb-frontends}/mn88472_priv.h (88%)
  delete mode 100644 drivers/staging/media/mn88472/Kconfig
  delete mode 100644 drivers/staging/media/mn88472/Makefile
  delete mode 100644 drivers/staging/media/mn88472/TODO

-- 
http://palosaari.fi/
