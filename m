Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50898 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751064AbdA0WUa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 17:20:30 -0500
Received: from [82.128.187.92] (helo=c-46-246-87-105.ip4.frootvpn.com)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <crope@iki.fi>)
        id 1cXDf8-0007eO-JS
        for linux-media@vger.kernel.org; Fri, 27 Jan 2017 23:02:26 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.11] af9035 misc changes
Message-ID: <6a707d21-3a4f-6cff-4b50-987d0814bd22@iki.fi>
Date: Fri, 27 Jan 2017 23:02:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d183e4efcae8d88a2f252e546978658ca6d273cc:

   [media] v4l: tvp5150: Add missing break in set control handler 
(2016-12-12 07:49:58 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035

for you to fetch changes up to 935e7e49e1cdf6f4c9beb1366c060fb1226c23ae:

   af9033: estimate cnr from formula (2016-12-19 18:38:23 +0200)

----------------------------------------------------------------
Antti Palosaari (10):
       af9035: read and store whole eeprom
       af9033: convert to regmap api
       af9033: use 64-bit div macro where possible
       af9033: style related and minor changes
       af9033: return regmap for integrated IT913x tuner driver
       it913x: change driver model from i2c to platform
       af9035: register it9133 tuner using platform binding
       it913x: add chip device ids for binding
       af9035: correct demod i2c addresses
       af9033: estimate cnr from formula

  drivers/media/dvb-frontends/Kconfig       |   1 +
  drivers/media/dvb-frontends/af9033.c      | 837 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------
  drivers/media/dvb-frontends/af9033.h      |  13 ++-
  drivers/media/dvb-frontends/af9033_priv.h | 185 
+++++++++++--------------------
  drivers/media/tuners/it913x.c             |  92 +++++++---------
  drivers/media/tuners/it913x.h             |  26 ++---
  drivers/media/usb/dvb-usb-v2/af9035.c     | 267 
+++++++++++++++++++++------------------------
  drivers/media/usb/dvb-usb-v2/af9035.h     |   7 +-
  8 files changed, 582 insertions(+), 846 deletions(-)

-- 
http://palosaari.fi/
