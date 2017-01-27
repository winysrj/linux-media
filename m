Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44863 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751315AbdA0U7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 15:59:10 -0500
Received: from [82.128.187.92] (helo=c-46-246-87-105.ip4.frootvpn.com)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <crope@iki.fi>)
        id 1cXDbx-0006XQ-4A
        for linux-media@vger.kernel.org; Fri, 27 Jan 2017 22:59:09 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.11] si2168 ber and ucb statistics
Message-ID: <24add81b-8c80-779a-4ecf-addb0e112c18@iki.fi>
Date: Fri, 27 Jan 2017 22:59:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d183e4efcae8d88a2f252e546978658ca6d273cc:

   [media] v4l: tvp5150: Add missing break in set control handler 
(2016-12-12 07:49:58 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git si2168

for you to fetch changes up to 7a6d7b07e36a8161b56924d7e18a00f1b7e2436a:

   si2168: implement ucb statistics (2016-12-19 19:55:15 +0200)

----------------------------------------------------------------
Antti Palosaari (2):
       si2168: implement ber statistics
       si2168: implement ucb statistics

  drivers/media/dvb-frontends/si2168.c      | 70 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
  drivers/media/dvb-frontends/si2168_priv.h |  1 +
  2 files changed, 69 insertions(+), 2 deletions(-)

-- 
http://palosaari.fi/
