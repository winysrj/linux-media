Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40926 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751595AbeCWRiA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 13:38:00 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 70549634C80
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2018 19:37:58 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ezQda-0000lG-73
        for linux-media@vger.kernel.org; Fri, 23 Mar 2018 19:37:58 +0200
Date: Fri, 23 Mar 2018 19:37:58 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.17] Add array size to v4l2_find_nearest_size
Message-ID: <20180323173757.q67bbhjm2ugnmsil@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just one patch here, to add the size of the array of the modes for
v4l2_find_nearest_size.

Please pull.


The following changes since commit 238f694e1b7f8297f1256c57e41f69c39576c9b4:

  media: v4l2-common: fix a compilation breakage (2018-03-21 16:07:01 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git v4l2-common-size2

for you to fetch changes up to ba46ac7f7047f21823bdf6cca5fd8c5ded0babdf:

  v4l: Bring back array_size parameter to v4l2_find_nearest_size (2018-03-23 17:33:33 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      v4l: Bring back array_size parameter to v4l2_find_nearest_size

 drivers/media/i2c/ov13858.c                  | 4 +++-
 drivers/media/i2c/ov5670.c                   | 4 +++-
 drivers/media/platform/vivid/vivid-vid-cap.c | 5 +++--
 include/media/v4l2-common.h                  | 5 +++--
 4 files changed, 12 insertions(+), 6 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
