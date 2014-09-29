Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbaI2CXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 22:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Johannes Stezenbach <js@linuxtv.org>
Subject: [PATCH 0/6] some fixes and cleanups for the em28xx-based HVR-930C
Date: Sun, 28 Sep 2014 23:23:17 -0300
Message-Id: <cover.1411956856.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series addresses some issues with suspend2ram of devices
based on DRX-K.

With this patch series, it is now possible to suspend to ram while
streaming. At resume, the stream will continue to play.

While doing that, I added a few other changes:

- I moved the init code to .init. That is an initial step to fix
  suspend to disk;

- There's a fix to an issue that happens at xc5000 removal (sent
  already as a RFC patch);

- A dprintk change at his logic to not require both a boot parameter and
  a dynamic_printk enablement. It also re-adds __func__ to the printks,
  that got previously removed;

- It removes the unused mfe_sharing var from the dvb attach logic.

Mauro Carvalho Chehab (6):
  [media] em28xx: remove firmware before releasing xc5000 priv state
  [media] drxk: Fix debug printks
  [media] em28xx-dvb: remove unused mfe_sharing
  [media] em28xx-dvb: handle to stop/start streaming at PM
  [media] em28xx: move board-specific init code
  [media] drxk: move device init code to .init callback

 drivers/media/dvb-frontends/drxk_hard.c | 117 ++++++++++++++++----------------
 drivers/media/tuners/xc5000.c           |   2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c   |  45 ++++++++----
 3 files changed, 92 insertions(+), 72 deletions(-)

-- 
1.9.3

