Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36250 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754278AbeAKMne (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 07:43:34 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 3B74E60100
        for <linux-media@vger.kernel.org>; Thu, 11 Jan 2018 14:43:32 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eZcCh-0005ac-Kl
        for linux-media@vger.kernel.org; Thu, 11 Jan 2018 14:43:31 +0200
Date: Thu, 11 Jan 2018 14:43:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.16] Print fwnode parsing results, add nop
 media_entity_cleanup
Message-ID: <20180111124330.cgsvv5wugb527gl4@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request adds printing fwnode parsing debug information and a nop
variant for media_entity_cleanup, which makes a little easier to write
drivers that support operation with and without MC.

Please pull.

The following changes since commit e3ee691dbf24096ea51b3200946b11d68ce75361:

  media: ov5640: add support of RGB565 and YUYV formats (2018-01-05 12:54:14 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.16-3

for you to fetch changes up to 5a7d72afcc70c9842a3738becec2d76bfbe2eeb4:

  media: entity: Add a nop variant of media_entity_cleanup (2018-01-11 14:14:27 +0200)

----------------------------------------------------------------
Sakari Ailus (2):
      v4l: fwnode: Add debug prints for V4L2 endpoint property parsing
      media: entity: Add a nop variant of media_entity_cleanup

 drivers/media/i2c/mt9m111.c           |   2 -
 drivers/media/i2c/ov2640.c            |   4 --
 drivers/media/i2c/ov2659.c            |   4 --
 drivers/media/i2c/ov7670.c            |   4 --
 drivers/media/i2c/ov7740.c            |   2 -
 drivers/media/i2c/tvp514x.c           |   4 --
 drivers/media/v4l2-core/v4l2-fwnode.c | 101 +++++++++++++++++++++++++++-------
 include/media/media-entity.h          |   6 +-
 8 files changed, 85 insertions(+), 42 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
