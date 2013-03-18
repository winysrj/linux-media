Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35862 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab3CRU2n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 16:28:43 -0400
Received: from dyn3-82-128-189-172.psoas.suomi.net ([82.128.189.172] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1UHgfh-0002MA-DP
	for linux-media@vger.kernel.org; Mon, 18 Mar 2013 22:28:41 +0200
Message-ID: <514778D5.1090800@iki.fi>
Date: Mon, 18 Mar 2013 22:28:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] dvb_usb_v2: PID filter and streaming ctrl related changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fix one bug where sync lock is hold over the userspace. Also it 
changes dvb_usb_v2 PID filter logic a little bit.

regards
Antti


The following changes since commit 4ca286610f664acf3153634f3930acd2de993a9f:

   [media] radio-rtrack2: fix mute bug (2013-03-05 15:20:07 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git dvb_usb_v2_pid_filter

for you to fetch changes up to 0d3f7b6d19f230fd73ceefbe370844c7e0b67357:

   it913x: fix pid filter (2013-03-18 22:21:31 +0200)

----------------------------------------------------------------
Antti Palosaari (5):
       dvb_usb_v2: replace Kernel userspace lock with wait queue
       dvb_usb_v2: make checkpatch.pl happy
       cypress_firmware: make checkpatch.pl happy
       dvb_usb_v2: rework USB streaming logic
       it913x: fix pid filter

  drivers/media/usb/dvb-usb-v2/cypress_firmware.c |   5 +--
  drivers/media/usb/dvb-usb-v2/dvb_usb.h          |   5 ++-
  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c     | 311 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------
  drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c      |   5 ++-
  drivers/media/usb/dvb-usb-v2/it913x.c           |   1 +
  drivers/media/usb/dvb-usb-v2/usb_urb.c          |  36 ++++++++-------
  6 files changed, 206 insertions(+), 157 deletions(-)

-- 
http://palosaari.fi/
