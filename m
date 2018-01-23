Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58642 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751056AbeAWMEj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 07:04:39 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 3F90D600FB
        for <linux-media@vger.kernel.org>; Tue, 23 Jan 2018 14:04:37 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1edxJc-0007fi-MY
        for linux-media@vger.kernel.org; Tue, 23 Jan 2018 14:04:36 +0200
Date: Tue, 23 Jan 2018 14:04:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PULL FOR 4.16] Sensor driver fixes
Message-ID: <20180123120436.vln6k6pver65ziff@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are sensor driver fixes for 4.16, on top of the master branch.

Please pull.


The following changes since commit e3ee691dbf24096ea51b3200946b11d68ce75361:

  media: ov5640: add support of RGB565 and YUYV formats (2018-01-05 12:54:14 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git fixes-4.16-1

for you to fetch changes up to c308222e2056eda4e2ab03a2f925f783e4a1678c:

  media: i2c: ov7740: use gpio/consumer.h instead of gpio.h (2018-01-23 13:53:16 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      media: i2c: ov7740: use gpio/consumer.h instead of gpio.h

Hugues Fruchet (1):
      media: ov5640: fix spurious streamon failures

Sakari Ailus (1):
      media: entity: Add a nop variant of media_entity_cleanup

 drivers/media/i2c/mt9m111.c  | 2 --
 drivers/media/i2c/ov2640.c   | 4 ----
 drivers/media/i2c/ov2659.c   | 4 ----
 drivers/media/i2c/ov5640.c   | 1 +
 drivers/media/i2c/ov7670.c   | 4 ----
 drivers/media/i2c/ov7740.c   | 4 +---
 drivers/media/i2c/tvp514x.c  | 4 ----
 include/media/media-entity.h | 6 +++++-
 8 files changed, 7 insertions(+), 22 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
