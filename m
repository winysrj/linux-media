Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57317 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752384AbdBAQv1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 11:51:27 -0500
Received: from [82.128.187.92] (helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <crope@iki.fi>)
        id 1cYy7y-0000JG-7e
        for linux-media@vger.kernel.org; Wed, 01 Feb 2017 18:51:26 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.11] drop unused hd29l2 driver
Message-ID: <6e97f7f7-73f2-6107-1308-7496a6523ab7@iki.fi>
Date: Wed, 1 Feb 2017 18:51:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d183e4efcae8d88a2f252e546978658ca6d273cc:

   [media] v4l: tvp5150: Add missing break in set control handler 
(2016-12-12 07:49:58 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git hdic

for you to fetch changes up to aacb6916b411c17d8372a5da46f94b39c5fd297a:

   hd29l2: remove unused driver (2017-01-27 19:25:19 +0200)

----------------------------------------------------------------
Antti Palosaari (2):
       MAINTAINERS: remove hd29l2
       hd29l2: remove unused driver

  MAINTAINERS                               |  10 --
  drivers/media/dvb-frontends/Kconfig       |   7 --
  drivers/media/dvb-frontends/Makefile      |   1 -
  drivers/media/dvb-frontends/hd29l2.c      | 870 
--------------------------------------------------------------------------------------------------------------------------------------------
  drivers/media/dvb-frontends/hd29l2.h      |  65 -----------
  drivers/media/dvb-frontends/hd29l2_priv.h | 301 
-------------------------------------------------
  6 files changed, 1254 deletions(-)
  delete mode 100644 drivers/media/dvb-frontends/hd29l2.c
  delete mode 100644 drivers/media/dvb-frontends/hd29l2.h
  delete mode 100644 drivers/media/dvb-frontends/hd29l2_priv.h

-- 
http://palosaari.fi/
