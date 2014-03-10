Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50859 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751986AbaCJJlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 05:41:14 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 7A1666008E
	for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 11:41:11 +0200 (EET)
Date: Mon, 10 Mar 2014 11:40:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.15] New flash faults, lm3560 cleanups, lm3646 driver
Message-ID: <20140310094039.GX15635@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are some cleanups for lm3560 and a driver for lm3646 flash controller
which also adds a few new flash fault control bits.

The following changes since commit f2d7313534072a5fe192e7cf46204b413acef479:

  [media] drx-d: add missing braces in drxd_hard.c:DRXD_init (2014-03-09 09:20:50 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git flash-for-3.15

for you to fetch changes up to 4473269ce76242fc13bd837ec299e8b588a43b7a:

  lm3646: add new dual LED Flash driver (2014-03-10 11:36:04 +0200)

----------------------------------------------------------------
Andy Shevchenko (3):
      lm3560: remove FSF address from the license
      lm3560: keep style for the comments
      lm3560: prevent memory leak in case of pdata absence

Daniel Jeong (3):
      v4l2-controls.h: Add addtional Flash fault bits
      controls.xml: Document addtional Flash fault bits
      lm3646: add new dual LED Flash driver

 Documentation/DocBook/media/v4l/controls.xml |   18 ++
 drivers/media/i2c/Kconfig                    |    9 +
 drivers/media/i2c/Makefile                   |    1 +
 drivers/media/i2c/lm3560.c                   |   22 +-
 drivers/media/i2c/lm3646.c                   |  414 ++++++++++++++++++++++++++
 include/media/lm3646.h                       |   87 ++++++
 include/uapi/linux/v4l2-controls.h           |    3 +
 7 files changed, 541 insertions(+), 13 deletions(-)
 create mode 100644 drivers/media/i2c/lm3646.c
 create mode 100644 include/media/lm3646.h

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
