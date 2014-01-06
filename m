Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaAFM0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 07:26:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2] em28xx: Fix support for audio-only interface on em2860
Date: Mon,  6 Jan 2014 07:22:53 -0200
Message-Id: <1389000175-7301-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver probing for em2860 is broken, causing an oops and making the audio
module to be probed forever.

Fixes it.

Tested with a KWorld 305U (USB ID: eb1a:e305). Note:
the board silkscreen of this device says that it is a PVR-310U-Dongle ver. A.

Mauro Carvalho Chehab (2):
  em28xx: prevent registering wrong interfaces for audio-only
  em28xx: only initialize extensions on the main interface

 drivers/media/usb/em28xx/em28xx-cards.c | 12 ++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   | 10 ++++++++++
 drivers/media/usb/em28xx/em28xx-input.c | 10 ++++++++++
 drivers/media/usb/em28xx/em28xx-video.c | 10 ++++++++++
 4 files changed, 42 insertions(+)

-- 
1.8.3.1

