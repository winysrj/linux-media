Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab3LOODT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 09:03:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/3] Make dib807x to work again
Date: Sun, 15 Dec 2013 09:00:07 -0200
Message-Id: <1387105210-6893-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At least with my Pixelview PV-D231U stick, the dib8000 driver is
deadly broken.

One issue was caused by a regression already solved by Oliver.
Not sure why, but the patch was never merged upstream.

The other issue took me a long time to properly track and fix it.

It is a race condition that it is detected by calling FE_GET_PROPERTY
just after tuning into a channel.

It seems that trying to read the TMCC tables before locking causes
the tuner logic to fail. 

So, be sure that FE_HAS_SYNC is there before executing the
get_frontend() logic.

Mauro Carvalho Chehab (2):
  [media] dib8000: make 32 bits read atomic
  [media] dib8000: Don't let tuner hang due to a call to get_frontend()

Olivier Grenie (1):
  [media] dib8000: fix regression with dib807x

 drivers/media/dvb-frontends/dib8000.c | 56 +++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 12 deletions(-)

-- 
1.8.3.1

