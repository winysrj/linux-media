Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45960 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754659AbeEHJGT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 05:06:19 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 494D6634C4E
        for <linux-media@vger.kernel.org>; Tue,  8 May 2018 12:06:17 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fFyZc-0003mn-W7
        for linux-media@vger.kernel.org; Tue, 08 May 2018 12:06:16 +0300
Date: Tue, 8 May 2018 12:06:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.18] Omap3isp fixes
Message-ID: <20180508090616.recvrhbp3t5y56jb@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are some fixes for the omap3isp driver.

Please pull.


The following changes since commit f10379aad39e9da8bc7d1822e251b5f0673067ef:

  media: include/video/omapfb_dss.h: use IS_ENABLED() (2018-05-05 11:45:51 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git omap3isp

for you to fetch changes up to 68578cecbfd0909a6c2547578446da95537498c9:

  omap3isp: Don't use GFP_DMA (2018-05-07 16:25:03 +0300)

----------------------------------------------------------------
Arnd Bergmann (1):
      omap3isp: support 64-bit version of omap3isp_stat_data

Sakari Ailus (2):
      omap3isp: Remove useless NULL check in omap3isp_stat_config
      omap3isp: Don't use GFP_DMA

 drivers/media/platform/omap3isp/isph3a_aewb.c |  2 ++
 drivers/media/platform/omap3isp/isph3a_af.c   |  2 ++
 drivers/media/platform/omap3isp/isphist.c     |  2 ++
 drivers/media/platform/omap3isp/ispstat.c     | 29 ++++++++++++++++++---------
 drivers/media/platform/omap3isp/ispstat.h     |  4 +++-
 include/uapi/linux/omap3isp.h                 | 22 ++++++++++++++++++++
 6 files changed, 51 insertions(+), 10 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
