Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47613 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbbFAIbL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 04:31:11 -0400
Message-ID: <556C184C.1010506@iki.fi>
Date: Mon, 01 Jun 2015 11:31:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Adam Baker <linux@baker-net.org.uk>
Subject: [GIT PULL 4.2] si2157 RSSI
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d511eb7d642aaf513fefeb05514dc6177c53c350:

   [media] uvcvideo: Remove unneeded device disconnected flag 
(2015-05-30 12:12:58 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git silabs_pull

for you to fetch changes up to c7da453bbea128534bbe82cbec2c4c2bc5f24c3c:

   si2157: implement signal strength stats (2015-06-01 11:24:00 +0300)

----------------------------------------------------------------
Antti Palosaari (2):
       si2168: Implement own I2C adapter locking
       si2157: implement signal strength stats

  drivers/media/dvb-frontends/si2168.c      | 135 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------
  drivers/media/dvb-frontends/si2168_priv.h |   1 -
  drivers/media/tuners/si2157.c             |  40 
+++++++++++++++++++++++++++++++++++++++-
  drivers/media/tuners/si2157_priv.h        |   1 +
  4 files changed, 119 insertions(+), 58 deletions(-)

-- 
http://palosaari.fi/
