Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48508 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932668AbeFKMr6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 08:47:58 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 7A61B634C83
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2018 15:47:56 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fSMEm-0001O4-9P
        for linux-media@vger.kernel.org; Mon, 11 Jun 2018 15:47:56 +0300
Date: Mon, 11 Jun 2018 15:47:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.19] Add "rotation" property for sensors, use it
Message-ID: <20180611124755.2uqbpjbvlltz2lkc@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request adds the "rotation" property already used for display
panels for sensors. Support for the property is added to the smiapp and
ov5640 drivers.

Please pull.


The following changes since commit f2809d20b9250c675fca8268a0f6274277cca7ff:

  media: omap2: fix compile-testing with FB_OMAP2=m (2018-06-05 09:56:56 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git v4l2-rotation

for you to fetch changes up to 8cb64987a0db499b61de3c76732ff34823fb5dc7:

  media: ov5640: add support of module orientation (2018-06-11 15:45:23 +0300)

----------------------------------------------------------------
Hugues Fruchet (2):
      media: ov5640: add HFLIP/VFLIP controls support
      media: ov5640: add support of module orientation

Sakari Ailus (2):
      dt-bindings: media: Define "rotation" property for sensors
      smiapp: Support the "rotation" property

 .../devicetree/bindings/media/i2c/nokia,smia.txt   |   2 +
 .../devicetree/bindings/media/i2c/ov5640.txt       |   3 +
 .../devicetree/bindings/media/video-interfaces.txt |   4 +
 drivers/media/i2c/ov5640.c                         | 127 ++++++++++++++++++---
 drivers/media/i2c/smiapp/smiapp-core.c             |  16 +++
 5 files changed, 134 insertions(+), 18 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
