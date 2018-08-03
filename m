Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39966 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729968AbeHDAEu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 20:04:50 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 020AE634C7D
        for <linux-media@vger.kernel.org>; Sat,  4 Aug 2018 01:06:39 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fliDX-0000vL-NI
        for linux-media@vger.kernel.org; Sat, 04 Aug 2018 01:06:39 +0300
Date: Sat, 4 Aug 2018 01:06:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.19] Fix for mt9v111 driver
Message-ID: <20180803220639.j6to6cj6vao3oa2x@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's one more patch for 4.19. It's a fix, but the driver isn't in the
fixes branch so it's on master.

Please pull.


The following changes since commit 2c3449fb95c318920ca8dc645d918d408db219ac:

  media: usb: hackrf: Replace GFP_ATOMIC with GFP_KERNEL (2018-08-02 19:16:17 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.19-5

for you to fetch changes up to 86f2c9ac5248b4a4d784a7af95270567bbb959e3:

  media: i2c: mt9v111: Fix v4l2-ctrl error handling (2018-08-04 01:05:44 +0300)

----------------------------------------------------------------
Jacopo Mondi (1):
      media: i2c: mt9v111: Fix v4l2-ctrl error handling

 drivers/media/i2c/mt9v111.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
