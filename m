Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47858 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728529AbeJEUEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 16:04:24 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 71F4E634C8B
        for <linux-media@vger.kernel.org>; Fri,  5 Oct 2018 16:05:44 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1g8Pnc-0000iB-9u
        for linux-media@vger.kernel.org; Fri, 05 Oct 2018 16:05:44 +0300
Date: Fri, 5 Oct 2018 16:05:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Ov7670 and ov9650 fixes
Message-ID: <20181005130544.fp6nfpfdqvgzhhsj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are fixes for the Omnivision sensor drivers. Please pull.


The following changes since commit f492fb4f5b41e8e62051e710369320e9ffa7a1ea:

  media: MAINTAINERS: Fix entry for the renamed dw9807 driver (2018-10-05 08:40:00 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-9-sign-2

for you to fetch changes up to f974cffdf34ec08ac0b27ace938c07f4aa078b4c:

  media: ov5640: fix framerate update (2018-10-05 16:04:12 +0300)

----------------------------------------------------------------
ov sensor driver fixes

----------------------------------------------------------------
Arnd Bergmann (1):
      media: ov9650: avoid maybe-uninitialized warnings

Hugues Fruchet (1):
      media: ov5640: fix framerate update

Lubomir Rintel (1):
      ov7670: make "xclk" clock optional

 drivers/media/i2c/ov5640.c |  7 ++++---
 drivers/media/i2c/ov7670.c | 27 +++++++++++++++++----------
 drivers/media/i2c/ov9650.c |  2 ++
 3 files changed, 23 insertions(+), 13 deletions(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
