Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36726 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755609AbdKCIaT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Nov 2017 04:30:19 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id C45F1600ED
        for <linux-media@vger.kernel.org>; Fri,  3 Nov 2017 10:30:17 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eAXMn-0001Z5-Bj
        for linux-media@vger.kernel.org; Fri, 03 Nov 2017 10:30:17 +0200
Date: Fri, 3 Nov 2017 10:30:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] V4L2 async and imx274 fixes
Message-ID: <20171103083016.b6cwfqqrvp5ottzn@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are two bugfixes for V4L2 async and imx274.

Please pull.

The following changes since commit 9917fbcfa20ab987d6381fd0365665e5c1402d75:

  media: camss-vfe: always initialize reg at vfe_set_xbar_cfg() (2017-11-01 12:25:59 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-6

for you to fetch changes up to f45a99c566983cb64726ce21ec24c51d80b144c3:

  media: v4l: async: fix return of unitialized variable ret (2017-11-03 10:27:37 +0200)

----------------------------------------------------------------
Colin Ian King (2):
      media: imx274: fix missing return assignment from call to imx274_mode_regs
      media: v4l: async: fix return of unitialized variable ret

 drivers/media/i2c/imx274.c           | 2 +-
 drivers/media/v4l2-core/v4l2-async.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
