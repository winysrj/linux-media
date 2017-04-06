Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37359 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932442AbdDFKpO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 06:45:14 -0400
Received: from dyn3-82-128-188-78.psoas.suomi.net ([82.128.188.78] helo=c-46-246-82-5.ip4.frootvpn.com)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <crope@iki.fi>)
        id 1cw4ud-0004ka-Ss
        for linux-media@vger.kernel.org; Thu, 06 Apr 2017 13:45:11 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.12] mn88472 statistics
Message-ID: <04ff9734-7195-233a-7aa9-7aaf989a26cb@iki.fi>
Date: Thu, 6 Apr 2017 13:45:11 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

   Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git mn88472

for you to fetch changes up to ea003f23ec598c46a31ad9bfe0e4d258f04edc0b:

   mn88472: implement PER statistics (2017-03-17 18:45:48 +0200)

----------------------------------------------------------------
Antti Palosaari (3):
       mn88472: implement signal strength statistics
       mn88472: implement cnr statistics
       mn88472: implement PER statistics

  drivers/media/dvb-frontends/mn88472.c      | 134 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
  drivers/media/dvb-frontends/mn88472_priv.h |   1 +
  2 files changed, 133 insertions(+), 2 deletions(-)

-- 
http://palosaari.fi/
