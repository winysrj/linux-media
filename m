Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46756 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934976AbeEINXN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 09:23:13 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 64163634C7E
        for <linux-media@vger.kernel.org>; Wed,  9 May 2018 16:23:11 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fGP3n-0000G3-5W
        for linux-media@vger.kernel.org; Wed, 09 May 2018 16:23:11 +0300
Date: Wed, 9 May 2018 16:23:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 for 4.18] Omap3isp cleanups
Message-ID: <20180509132310.4zh5vu5jmmqluoz3@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are some fixes for the omap3isp driver.

Since v1, I've added a fix that was intended to be included in v1 (in
Arnd's patch):

<URL:https://patchwork.linuxtv.org/patch/49369/>

Please pull.


The following changes since commit f10379aad39e9da8bc7d1822e251b5f0673067ef:

  media: include/video/omapfb_dss.h: use IS_ENABLED() (2018-05-05 11:45:51 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git omap3isp

for you to fetch changes up to aa5b856d6c0be0600cb68ff619bbcad8e7aecb53:

  omap3isp: Don't use GFP_DMA (2018-05-09 16:22:05 +0300)

----------------------------------------------------------------
Arnd Bergmann (1):
      omap3isp: support 64-bit version of omap3isp_stat_data

Sakari Ailus (2):
      omap3isp: Remove useless NULL check in omap3isp_stat_config
      omap3isp: Don't use GFP_DMA

 drivers/media/platform/omap3isp/isph3a_aewb.c |  2 ++
 drivers/media/platform/omap3isp/isph3a_af.c   |  2 ++
 drivers/media/platform/omap3isp/isphist.c     |  2 ++
 drivers/media/platform/omap3isp/ispstat.c     | 31 +++++++++++++++++++--------
 drivers/media/platform/omap3isp/ispstat.h     |  4 +++-
 include/uapi/linux/omap3isp.h                 | 22 +++++++++++++++++++
 6 files changed, 53 insertions(+), 10 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
