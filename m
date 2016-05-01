Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36918 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751489AbcEAOPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 May 2016 10:15:54 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 8459B6009F
	for <linux-media@vger.kernel.org>; Sun,  1 May 2016 17:15:51 +0300 (EEST)
Date: Sun, 1 May 2016 17:15:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v4.7] Small fixes for adp1653, smiapp drivers
Message-ID: <20160501141521.GI26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains two fixes, error handing ling adp1653 driver and
passing information on image data start in the smiapp driver.

Please pull.


The following changes since commit 45c175c4ae9695d6d2f30a45ab7f3866cfac184b:

  [media] tw686x: avoid going past array (2016-04-26 06:38:53 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-v4.7

for you to fetch changes up to 84012c3e7839538050f8b0928b5c3a926a8006bd:

  smiapp: provide g_skip_top_lines method in sensor ops (2016-04-29 18:24:09 +0300)

----------------------------------------------------------------
Ivaylo Dimitrov (1):
      smiapp: provide g_skip_top_lines method in sensor ops

Vladimir Zapolskiy (1):
      media: i2c/adp1653: fix check of devm_gpiod_get() error code

 drivers/media/i2c/adp1653.c            |  4 ++--
 drivers/media/i2c/smiapp/smiapp-core.c | 12 ++++++++++++
 drivers/media/i2c/smiapp/smiapp.h      |  1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
