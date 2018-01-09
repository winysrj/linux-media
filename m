Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42040 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755350AbeAIWp0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 17:45:26 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id ED66F600C8
        for <linux-media@vger.kernel.org>; Wed, 10 Jan 2018 00:45:24 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eZ2e4-0005Id-1N
        for linux-media@vger.kernel.org; Wed, 10 Jan 2018 00:45:24 +0200
Date: Wed, 10 Jan 2018 00:45:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.16] dw9714 PM fix, cleanups
Message-ID: <20180109224523.jncg5qlnssawz4iz@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a PM fix and a small cleanup for the dw9714 driver.

Please pull.


The following changes since commit e3ee691dbf24096ea51b3200946b11d68ce75361:

  media: ov5640: add support of RGB565 and YUYV formats (2018-01-05 12:54:14 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git dw9714

for you to fetch changes up to 973c0145c2b5ea837cdad467c928be653c6a5872:

  dw9714: Remove client field in driver's struct (2018-01-10 00:44:09 +0200)

----------------------------------------------------------------
Sakari Ailus (2):
      dw9714: Call pm_runtime_idle() at the end of probe()
      dw9714: Remove client field in driver's struct

 drivers/media/i2c/dw9714.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
