Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60938 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893AbaBAOgi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 09:36:38 -0500
Message-ID: <52ED0674.3040509@iki.fi>
Date: Sat, 01 Feb 2014 16:36:36 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Stefan Becker <schtefan@gmx.net>
Subject: [GIT PULL 3.14] new AF9035 device USB ID
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PULL that for 3.14. It is only single new USB ID which is suitable stuff 
for that late (even for stable 3.?? if someone wants to submit there too).

regards
Antti


The following changes since commit 587d1b06e07b4a079453c74ba9edf17d21931049:

   [media] rc-core: reuse device numbers (2014-01-15 11:46:37 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035_hauppauge

for you to fetch changes up to 4cb73c085a0cedb590990c9c0e3c48bab6639764:

   af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2 (2014-02-01 
16:27:21 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

  drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
  1 file changed, 2 insertions(+)


-- 
http://palosaari.fi/
