Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43650 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754324AbeDWIG6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 04:06:58 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 90DA6634C57
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 11:06:56 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fAWUy-0000zN-BL
        for linux-media@vger.kernel.org; Mon, 23 Apr 2018 11:06:56 +0300
Date: Mon, 23 Apr 2018 11:06:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.18] ov7740 driver and tda1997x fixes, cleanups
 elsewhere
Message-ID: <20180423080656.k3jcbk5qp5xyerpo@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are fixes for the ov7740 and tda1997x drivers as well as a few
cleanups to the omap3isp (making things const) and the fwnode framework
(spelling).

Please pull.


The following changes since commit 1d338b86e17d87215cf57b1ad1d13b2afe582d33:

  media: v4l2-compat-ioctl32: better document the code (2018-04-20 08:24:13 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.18-1

for you to fetch changes up to 94927e3d6358d0012a6f3b0ae23a8811ee7353d8:

  media: v4l: fwnode: Fix comment incorrectly mentioning v4l2_fwnode_parse_endpoint (2018-04-23 10:54:49 +0300)

----------------------------------------------------------------
Bhumika Goyal (2):
      v4l: omap3isp: make v4l2_file_operations const
      omap3isp: make omap3isp_prev_csc and omap3isp_prev_rgbtorgb const

Leonard Crestez (1):
      media: v4l: fwnode: Fix comment incorrectly mentioning v4l2_fwnode_parse_endpoint

Sakari Ailus (5):
      ov7740: Fix number of controls hint
      ov7740: Check for possible NULL return value in control creation
      ov7740: Fix control handler error at the end of control init
      ov7740: Set subdev HAS_EVENT flag
      tda1997x: Use bitwise or for setting subdev flags

 drivers/media/i2c/ov7740.c                   | 22 +++++++++++++++++-----
 drivers/media/i2c/tda1997x.c                 |  2 +-
 drivers/media/platform/omap3isp/isppreview.c |  4 ++--
 drivers/media/platform/omap3isp/ispvideo.c   |  2 +-
 include/media/v4l2-fwnode.h                  |  2 +-
 5 files changed, 22 insertions(+), 10 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
