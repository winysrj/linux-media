Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52003 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3L2Cok (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 21:44:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2] some improvements for em28xx-audio
Date: Sun, 29 Dec 2013 00:44:20 -0200
Message-Id: <1388285062-29217-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do some improvements for em28xx-audio:
	- instead of allocating the transfer buffers directly, use
usb_alloc coherent. That helps to make it more compatible with arm.
	- Move the code that allocates/deallocates URB audio buffers
to device init/finish code.

Mauro Carvalho Chehab (2):
  em28xx: use usb_alloc_coherent() for audio
  em28xx-audio: allocate URBs at device driver init

 drivers/media/usb/em28xx/em28xx-audio.c | 127 +++++++++++++++++++-------------
 1 file changed, 77 insertions(+), 50 deletions(-)

-- 
1.8.3.1

