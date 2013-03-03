Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab3CCP7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Mar 2013 10:59:01 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?q?Alfredo=20Jes=C3=BAs=20Delaiti?=
	<alfredodelaiti@netscape.net>
Subject: [PATCH 00/11] Do some improvements/fixups on mb86a20s, cx231xx and em28xx
Date: Sun,  3 Mar 2013 12:58:40 -0300
Message-Id: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While working to add support for a new device, I discovered a
series of issues with mb86a20s and one with em28xx.

While here, I also changed cx231xx to improve its signal
detection, by using a different IF frequency and increasing the
IF signal level from the tuner by 12dB.

Mauro Carvalho Chehab (11):
  [media] mb86a20s: don't pollute dmesg with debug messages
  [media] mb86a20s: adjust IF based on what's set on the tuner
  [media] mb86a20s: provide CNR stats before FE_HAS_SYNC
  [media] mb86a20s: Fix signal strength calculus
  [media] mb86a20s: don't allow updating signal strength too fast
  [media] mb86a20s: change AGC tuning parameters
  [media] mb86a20s: Always reset the frontend with set_frontend
  [media] mb86a20s: Don't reset strength with the other stats
  [media] mb86a20s: cleanup the status at set_frontend()
  [media] cx231xx: Improve signal reception for PV SBTVD
  [media] em28xx-dvb: Don't put device in suspend mode at feed stop

 drivers/media/dvb-core/dmxdev.c         |   3 +-
 drivers/media/dvb-frontends/mb86a20s.c  | 200 +++++++++++++++++++++-----------
 drivers/media/usb/cx231xx/cx231xx-dvb.c |   4 +-
 drivers/media/usb/em28xx/em28xx-dvb.c   |   2 -
 4 files changed, 136 insertions(+), 73 deletions(-)

-- 
1.8.1.4

