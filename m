Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36624 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754308AbeFUKyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 06:54:43 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id C75D7634C7F
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2018 13:54:41 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fVxEf-0000KN-JR
        for linux-media@vger.kernel.org; Thu, 21 Jun 2018 13:54:41 +0300
Date: Thu, 21 Jun 2018 13:54:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES for 4.18] Cadence compile fixes, imx258 rotation property
 check
Message-ID: <20180621105441.ac5aufscombnzzk2@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a few fixes for 4.18. Arnd's patches fix regular build errors and
the imx258 patch is there to prevent writing firmware they'll only find was
incomplete later on.

Please pull.


The following changes since commit e88f5e9ebd54bdf75c9833e3d9add7c2c0d39b0b:

  media: uvcvideo: Prevent setting unavailable flags (2018-06-05 08:53:17 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git fixes-4.18-1

for you to fetch changes up to 40cea33ed062c330a491c36bf172040c16f9088a:

  media: v4l: cadence: add VIDEO_V4L2 dependency (2018-06-21 12:22:49 +0300)

----------------------------------------------------------------
Arnd Bergmann (2):
      media: v4l: cadence: include linux/slab.h
      media: v4l: cadence: add VIDEO_V4L2 dependency

Sakari Ailus (1):
      imx258: Check the rotation property has a value of 180

 drivers/media/i2c/imx258.c                   | 8 ++++++++
 drivers/media/platform/cadence/Kconfig       | 2 ++
 drivers/media/platform/cadence/cdns-csi2rx.c | 1 +
 drivers/media/platform/cadence/cdns-csi2tx.c | 1 +
 4 files changed, 12 insertions(+)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
