Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49755 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756752AbcLAArx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 19:47:53 -0500
Received: from [82.128.187.197] (helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.80)
        (envelope-from <crope@iki.fi>)
        id 1cCFXU-0003y9-CJ
        for linux-media@vger.kernel.org; Thu, 01 Dec 2016 02:47:52 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL STABLE] mn88472 & mn88473 chip id bug on probe
Message-ID: <da626faf-0ebd-95bc-9b2b-07809238dd81@iki.fi>
Date: Thu, 1 Dec 2016 02:47:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I already send these 2 simple patches to stable list, but not sure how 
to get those mainline so here is pull-request too. Both are same bug, 
which nacks driver probe when chip is already on warm state.

regards
Antti

The following changes since commit 003611334d5592984e319e08c6b66825aca00290:

   [media] s5p-mfc: Add support for MFC v8 available in Exynos 5433 SoCs 
(2016-11-30 09:22:07 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git mn88473

for you to fetch changes up to c4367e9f774e85da1cd00c7f48da5684b57b9b06:

   mn88472: fix chip id check on probe (2016-12-01 02:27:11 +0200)

----------------------------------------------------------------
Antti Palosaari (2):
       mn88473: fix chip id check on probe
       mn88472: fix chip id check on probe

  drivers/media/dvb-frontends/mn88472.c | 24 ++++++++++++------------
  drivers/media/dvb-frontends/mn88473.c | 24 ++++++++++++------------
  2 files changed, 24 insertions(+), 24 deletions(-)

-- 
http://palosaari.fi/
