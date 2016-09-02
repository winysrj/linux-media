Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36849 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753195AbcIBXkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 19:40:53 -0400
To: LMML <linux-media@vger.kernel.org>
Cc: =?UTF-8?Q?Stefan_P=c3=b6schel?= <basic.master@gmx.de>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL STABLE 4.6] af9035 regression
Message-ID: <1e077824-104b-4665-96c8-de46c1a63a5d@iki.fi>
Date: Sat, 3 Sep 2016 02:40:52 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 2dcd0af568b0cf583645c8a317dd12e344b1c72a:

   Linux 4.6 (2016-05-15 15:43:13 -0700)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035_fix

for you to fetch changes up to 7bb87ff5255defe87916f32cd1fcef163a489339:

   af9035: fix dual tuner detection with PCTV 79e (2016-09-03 02:23:44 
+0300)

----------------------------------------------------------------
Stefan Pöschel (1):
       af9035: fix dual tuner detection with PCTV 79e

  drivers/media/usb/dvb-usb-v2/af9035.c | 53 
+++++++++++++++++++++++++++++++++++------------------
  drivers/media/usb/dvb-usb-v2/af9035.h |  2 +-
  2 files changed, 36 insertions(+), 19 deletions(-)

-- 
http://palosaari.fi/
