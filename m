Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48574 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751128AbdFTL3k (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 07:29:40 -0400
Received: from dyn3-82-128-189-68.psoas.suomi.net ([82.128.189.68] helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <crope@iki.fi>)
        id 1dNHLm-00068X-Uz
        for linux-media@vger.kernel.org; Tue, 20 Jun 2017 14:29:39 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.13] af9015/af9013 changes
Message-ID: <ce195769-d354-b21f-b995-b9a989332d93@iki.fi>
Date: Tue, 20 Jun 2017 14:29:38 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3622d3e77ecef090b5111e3c5423313f11711dfa:

   [media] ov2640: print error if devm_*_optional*() fails (2017-04-25 
07:08:21 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9015_pull

for you to fetch changes up to 2a32db020ab01e3ac99febad90a42112aa28b2ee:

   af9013: refactor power control (2017-06-18 05:42:25 +0300)

----------------------------------------------------------------
Antti Palosaari (15):
       af9015: use correct 7-bit i2c addresses
       af9013: move config values directly under driver state
       af9013: add i2c client bindings
       af9013: use kernel 64-bit division
       af9013: fix logging
       af9013: convert to regmap api
       af9013: fix error handling
       af9013: add dvbv5 cnr
       af9015: fix and refactor i2c adapter algo logic
       af9015: enable 2nd TS flow control when dual mode
       af9013: add configurable TS output pin
       af9013: remove unneeded register writes
       af9015: move 2nd demod power-up wait different location
       af9013: refactor firmware download routine
       af9013: refactor power control

Gustavo A. R. Silva (1):
       af9013: add check on af9013_wr_regs() return value

  drivers/media/dvb-frontends/Kconfig       |    1 +
  drivers/media/dvb-frontends/af9013.c      | 1185 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
  drivers/media/dvb-frontends/af9013.h      |   86 +++++------
  drivers/media/dvb-frontends/af9013_priv.h |    2 +
  drivers/media/usb/dvb-usb-v2/af9015.c     |  198 +++++++++++++-----------
  drivers/media/usb/dvb-usb-v2/af9015.h     |    4 +-
  6 files changed, 752 insertions(+), 724 deletions(-)

-- 
http://palosaari.fi/
