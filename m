Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37044 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753138AbdCHN1W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 08:27:22 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 9DD3A6009F
        for <linux-media@vger.kernel.org>; Wed,  8 Mar 2017 15:26:12 +0200 (EET)
Date: Wed, 8 Mar 2017 15:26:12 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.12] Sub-device driver fixes
Message-ID: <20170308132612.GL3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a few minor fixes for sub-device drivers recently added and a
documentation change.

Please pull.


The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

  Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-v4.12

for you to fetch changes up to b62e5d5c896052119975cc0b08de4728297a2f9d:

  ad5820: remove incorrect __exit markups (2017-03-08 09:42:02 +0200)

----------------------------------------------------------------
Dmitry Torokhov (1):
      ad5820: remove incorrect __exit markups

Javier Martinez Canillas (1):
      et8ek8: Export OF device ID as module aliases

Sakari Ailus (1):
      docs-rst: media: Explicitly refer to sub-sampling in scaling documentation

 Documentation/media/uapi/mediactl/media-types.rst | 3 ++-
 drivers/media/i2c/ad5820.c                        | 4 ++--
 drivers/media/i2c/et8ek8/et8ek8_driver.c          | 1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
