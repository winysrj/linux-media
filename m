Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58854 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750698AbcBHI5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 03:57:06 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 8372C6009F
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2016 10:57:02 +0200 (EET)
Date: Mon, 8 Feb 2016 10:57:02 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES for v4.5] Error handling fixes
Message-ID: <20160208085702.GF32612@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are two patches for error handling fixes in adp1653 and davinci_vpfe
drivers. Please pull.


The following changes since commit 1f2c450185b7b8d50d38d37ee30387ff4cd337f8:

  [media] vb2-core: call threadio->fnc() if !VB2_BUF_STATE_ERROR (2016-02-04 09:15:51 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git fixes

for you to fetch changes up to ffc649a3bbe2274071874ea1613bdba9d72932ec:

  media: i2c/adp1653: probe: fix erroneous return value (2016-02-07 20:05:47 +0200)

----------------------------------------------------------------
Anton Protopopov (1):
      media: i2c/adp1653: probe: fix erroneous return value

Wei Yongjun (1):
      media: davinci_vpfe: fix missing unlock on error in vpfe_prepare_pipeline()

 drivers/media/i2c/adp1653.c                     | 2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
