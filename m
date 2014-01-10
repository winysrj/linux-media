Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42230 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaAJVtQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 16:49:16 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/4] Fix em28xx audio when using a xHCI USB port
Date: Fri, 10 Jan 2014 16:45:35 -0200
Message-Id: <1389379539-31550-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some bugs preventing the usage of audio with a xHCI port:

1) The URB interval equal to 1 means a IRQ rate of 64 x 125 us, with
   xHCI (a period of 8ms), while it means a period of 64 ms with EHCI;

2) The period value was never 64 bytes.

Properly address the two above issues and prepare the driver to estimate
all parameters in realtime.

Mauro Carvalho Chehab (4):
  em28xx: use bInterval on em28xx-audio
  em28xx-audio: Fix error path
  em28xx: don't hardcode audio URB calculus
  em28x-audio: fix the period size in bytes

 drivers/media/usb/em28xx/em28xx-audio.c | 187 +++++++++++++++++++++++++++-----
 drivers/media/usb/em28xx/em28xx.h       |   8 +-
 2 files changed, 160 insertions(+), 35 deletions(-)

-- 
1.8.3.1

