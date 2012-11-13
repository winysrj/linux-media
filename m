Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37596 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753967Ab2KMS3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 13:29:12 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id D2F276009F
	for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 20:29:09 +0200 (EET)
Date: Tue, 13 Nov 2012 20:29:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.8] V4L2 int device removal
Message-ID: <20121113182907.GS25623@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This removes V4L2 int device and drivers using it. They were in an unusable
state to begin with.

Please pull.

The following changes since commit 2c4e11b7c15af70580625657a154ea7ea70b8c76:

  [media] siano: fix RC compilation (2012-11-07 11:09:08 +0100)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git no-int-device

Sakari Ailus (3):
      omap24xxcam: Remove driver
      tcm825x: Remove driver
      v4l2-int-if: Remove interface

 drivers/media/i2c/Kconfig                 |    8 -
 drivers/media/i2c/Makefile                |    1 -
 drivers/media/i2c/tcm825x.c               |  937 --------------
 drivers/media/i2c/tcm825x.h               |  200 ---
 drivers/media/platform/Kconfig            |    7 -
 drivers/media/platform/Makefile           |    3 -
 drivers/media/platform/omap24xxcam-dma.c  |  601 ---------
 drivers/media/platform/omap24xxcam.c      | 1881 -----------------------------
 drivers/media/platform/omap24xxcam.h      |  593 ---------
 drivers/media/v4l2-core/Makefile          |    2 +-
 drivers/media/v4l2-core/v4l2-int-device.c |  164 ---
 include/media/v4l2-int-device.h           |  308 -----
 12 files changed, 1 insertions(+), 4704 deletions(-)
 delete mode 100644 drivers/media/i2c/tcm825x.c
 delete mode 100644 drivers/media/i2c/tcm825x.h
 delete mode 100644 drivers/media/platform/omap24xxcam-dma.c
 delete mode 100644 drivers/media/platform/omap24xxcam.c
 delete mode 100644 drivers/media/platform/omap24xxcam.h
 delete mode 100644 drivers/media/v4l2-core/v4l2-int-device.c
 delete mode 100644 include/media/v4l2-int-device.h

-- 
Regarda,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
