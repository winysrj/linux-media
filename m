Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58290 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753877AbcIJVxk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 17:53:40 -0400
Received: from dyn3-82-128-186-128.psoas.suomi.net ([82.128.186.128] helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.80)
        (envelope-from <crope@iki.fi>)
        id 1biqDP-0004CE-Kt
        for linux-media@vger.kernel.org; Sun, 11 Sep 2016 00:53:35 +0300
To: linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL] cxd2820r improvements
Message-ID: <42eb4d28-e293-bfc6-bb94-5fd14c4b4a8b@iki.fi>
Date: Sun, 11 Sep 2016 00:53:35 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit fb6609280db902bd5d34445fba1c926e95e63914:

   [media] dvb_frontend: Use memdup_user() rather than duplicating its 
implementation (2016-08-24 17:20:45 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git cxd2820r

for you to fetch changes up to 18905adf08ffc82417663539d1a703014505582f:

   cxd2820r: convert to regmap api (2016-09-03 01:30:22 +0300)

----------------------------------------------------------------
Antti Palosaari (9):
       cxd2820r: improve IF frequency setting
       cxd2820r: dvbv5 statistics for DVB-T
       cxd2820r: dvbv5 statistics for DVB-T2
       cxd2820r: dvbv5 statistics for DVB-C
       cxd2820r: wrap legacy DVBv3 statistics via DVBv5 statistics
       cxd2820r: add I2C driver bindings
       cxd2820r: correct logging
       cxd2820r: improve lock detection
       cxd2820r: convert to regmap api

  drivers/media/dvb-frontends/Kconfig         |   1 +
  drivers/media/dvb-frontends/cxd2820r.h      |  26 ++++++
  drivers/media/dvb-frontends/cxd2820r_c.c    | 302 
+++++++++++++++++++++++++++++++++++-----------------------------------
  drivers/media/dvb-frontends/cxd2820r_core.c | 597 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
  drivers/media/dvb-frontends/cxd2820r_priv.h |  42 ++++------
  drivers/media/dvb-frontends/cxd2820r_t.c    | 300 
++++++++++++++++++++++++++++++++++-----------------------------------
  drivers/media/dvb-frontends/cxd2820r_t2.c   | 278 
+++++++++++++++++++++++++++++++---------------------------------
  7 files changed, 770 insertions(+), 776 deletions(-)

-- 
http://palosaari.fi/
