Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaAMCE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 21:04:27 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/7] Fix remaining issues with em28xx device removal
Date: Sun, 12 Jan 2014 21:00:42 -0200
Message-Id: <1389567649-26838-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even after Frank's series, there are several issues with device module
removal.

This series fix those issues, by use kref to deallocate the common
data (struct em28xx *dev).

It also fixes a circular deppendency inside em28xx-audio.

Mauro Carvalho Chehab (7):
  em28xx-audio: fix return code on device disconnect
  em28xx-audio: simplify error handling
  em28xx: Only deallocate struct em28xx after finishing all extensions
  em28xx-audio: disconnect before freeing URBs
  em28xx-audio: remove a deplock circular dependency
  em28xx: print a message at disconnect
  em28xx: Fix usb diconnect logic

 drivers/media/usb/em28xx/em28xx-audio.c | 47 ++++++++++++++++++++-------------
 drivers/media/usb/em28xx/em28xx-cards.c | 41 +++++++++++++---------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |  7 ++++-
 drivers/media/usb/em28xx/em28xx-input.c | 10 ++++++-
 drivers/media/usb/em28xx/em28xx-video.c | 13 ++++-----
 drivers/media/usb/em28xx/em28xx.h       |  9 +++++--
 6 files changed, 76 insertions(+), 51 deletions(-)

-- 
1.8.3.1

