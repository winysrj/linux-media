Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48212 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbZB0DhI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 22:37:08 -0500
Date: Fri, 27 Feb 2009 00:36:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.29] V4L/DVB updates
Message-ID: <20090227003652.2895e62c@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For a few fixes:

   - em28xx: register device to soundcard for sysfs;
   - soc-camera: fix S_CROP breakage on PXA and SuperH;
   - b2c2: fix software IRQ watchdog and update documentation to reflect the
     current usage of Technisat.

Cheers,
Mauro.

---

 Documentation/dvb/README.flexcop           |  205 ----------------------------
 Documentation/dvb/technisat.txt            |   34 +++--
 drivers/media/dvb/b2c2/flexcop-hw-filter.c |    1 +
 drivers/media/dvb/b2c2/flexcop-pci.c       |   65 ++++++---
 drivers/media/dvb/b2c2/flexcop.c           |    3 +-
 drivers/media/video/em28xx/em28xx-audio.c  |    2 +
 drivers/media/video/pxa_camera.c           |   26 ++--
 drivers/media/video/sh_mobile_ceu_camera.c |   13 +-
 8 files changed, 84 insertions(+), 265 deletions(-)
 delete mode 100644 Documentation/dvb/README.flexcop

Guennadi Liakhovetski (1):
      V4L/DVB (10663): soc-camera: fix S_CROP breakage on PXA and SuperH

Nicola Soranzo (1):
      V4L/DVB (10659): em28xx: register device to soundcard for sysfs

Patrick Boettcher (1):
      V4L/DVB (10694): [PATCH] software IRQ watchdog for Flexcop B2C2 DVB PCI cards

Uwe Bugla (2):
      V4L/DVB (10695): Update Technisat card documentation
      V4L/DVB (10696): Remove outdated README for the flexcop-driver

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
