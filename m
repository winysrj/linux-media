Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46674 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbcGOGTm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 02:19:42 -0400
To: LMML <linux-media@vger.kernel.org>
Cc: =?UTF-8?Q?Stefan_P=c3=b6schel?= <basic.master@gmx.de>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.7] af9035 bug fix
Message-ID: <14e55b25-9341-99d4-a79a-3ca1368e738b@iki.fi>
Date: Fri, 15 Jul 2016 09:19:37 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That is regression fix since 4.6. This patch applies only for 4.7 - new 
patch which applies to 4.6 stable is also needed.



The following changes since commit 5cac1f67ea0363d463a58ec2d9118268fe2ba5d6:

   [media] rc: nuvoton: fix hang if chip is configured for alternative 
EFM IO address (2016-07-13 15:49:01 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035

for you to fetch changes up to 15d24682241103014a4ba0b47cc602a89a58b97d:

   af9035: fix dual tuner detection with PCTV 79e (2016-07-15 08:57:59 
+0300)

----------------------------------------------------------------
Stefan Pöschel (1):
       af9035: fix dual tuner detection with PCTV 79e

  drivers/media/usb/dvb-usb-v2/af9035.c | 50 
+++++++++++++++++++++++++++++++++-----------------
  drivers/media/usb/dvb-usb-v2/af9035.h |  2 +-
  2 files changed, 34 insertions(+), 18 deletions(-)

-- 
http://palosaari.fi/
