Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:55695 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934168AbeCTAUL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 20:20:11 -0400
Received: from mobile-access-6df048-240.dhcp.inet.fi ([109.240.72.240] helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <crope@iki.fi>)
        id 1ey50a-0005dR-Lj
        for linux-media@vger.kernel.org; Tue, 20 Mar 2018 02:20:08 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL] af9013/af9015 improvements
Message-ID: <48c03259-66d8-00e2-3e26-59b8308283e8@iki.fi>
Date: Tue, 20 Mar 2018 02:20:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3f127ce11353fd1071cae9b65bc13add6aec6b90:

   media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 06:06:51 
-0500)

are available in the Git repository at:

   git://linuxtv.org/anttip/media_tree.git af9015_pull

for you to fetch changes up to 3a11388095b992f0da01238adaec8b68cbad5c09:

   af9015: correct some coding style issues (2018-03-14 01:32:56 +0200)

----------------------------------------------------------------
Antti Palosaari (18):
       af9013: change lock detection slightly
       af9013: dvbv5 signal strength
       af9013: dvbv5 cnr
       af9013: dvbv5 ber and per
       af9013: wrap dvbv3 statistics via dvbv5
       af9015: fix logging
       af9013: convert inittabs suitable for regmap_update_bits
       af9013: add i2c mux adapter for tuner bus
       af9015: attach demod using i2c binding
       af9013: remove all legacy media attach releated stuff
       af9013: add pid filter support
       af9015: use af9013 demod pid filters
       af9015: refactor firmware download
       af9015: refactor copy firmware to slave demod
       af9015: enhance streaming config
       dvb-usb-v2: add probe/disconnect callbacks
       af9015: convert to regmap api
       af9015: correct some coding style issues

  drivers/media/dvb-frontends/Kconfig         |    2 +-
  drivers/media/dvb-frontends/af9013.c        |  909 
+++++++++++++++++++++++++++++++++++++++++---------------------------------------
  drivers/media/dvb-frontends/af9013.h        |   48 ++---
  drivers/media/dvb-frontends/af9013_priv.h   | 1558 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------
  drivers/media/usb/dvb-usb-v2/Kconfig        |    1 +
  drivers/media/usb/dvb-usb-v2/af9015.c       |  985 
++++++++++++++++++++++++++++++++++++++++++++------------------------------------------
  drivers/media/usb/dvb-usb-v2/af9015.h       |   20 +-
  drivers/media/usb/dvb-usb-v2/dvb_usb.h      |    4 +
  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |   24 ++-
  9 files changed, 1778 insertions(+), 1773 deletions(-)

-- 
http://palosaari.fi/
