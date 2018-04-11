Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49466 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753424AbeDKQ0Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 12:26:24 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 939B1634C50
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2018 19:26:22 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1f6IZi-00039F-9z
        for linux-media@vger.kernel.org; Wed, 11 Apr 2018 19:26:22 +0300
Date: Wed, 11 Apr 2018 19:26:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES for 4.17] omap3isp IOMMU error handling fix
Message-ID: <20180411162621.jlfnlolicbwuev7j@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a fix for the omap3isp driver's IOMMU error handling in probe.

Please pull.


The following changes since commit a95845ba184b854106972f5d8f50354c2d272c06:

  media: v4l2-core: fix size of devnode_nums[] bitarray (2018-04-05 06:41:30 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git fixes-4.17-1

for you to fetch changes up to d4e0f478573131d424b7116cdb63f91e65164963:

  media: omap3isp: fix unbalanced dma_iommu_mapping (2018-04-11 18:07:37 +0300)

----------------------------------------------------------------
Suman Anna (1):
      media: omap3isp: fix unbalanced dma_iommu_mapping

 drivers/media/platform/omap3isp/isp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
