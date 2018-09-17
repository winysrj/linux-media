Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42450 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726826AbeIQPNb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 11:13:31 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 807E9634C7F
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 12:46:53 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1g1q7J-0000wQ-AK
        for linux-media@vger.kernel.org; Mon, 17 Sep 2018 12:46:53 +0300
Date: Mon, 17 Sep 2018 12:46:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Ov5640 fixes
Message-ID: <20180917094652.eogm4x5k4c54rbjt@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a bunch of ov5640 fixes and improvements from Jacopo and Hugues.

Please pull.


The following changes since commit 78cf8c842c111df656c63b5d04997ea4e40ef26a:

  media: drxj: fix spelling mistake in fall-through annotations (2018-09-12 11:21:52 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-5-0

for you to fetch changes up to dc56f982b811f79f66f1d82c9eba519c9aefc649:

  media: ov5640: fix restore of last mode set (2018-09-16 01:59:25 +0300)

----------------------------------------------------------------
ov5640 patches

----------------------------------------------------------------
Hugues Fruchet (5):
      media: ov5640: fix exposure regression
      media: ov5640: fix auto gain & exposure when changing mode
      media: ov5640: fix wrong binning value in exposure calculation
      media: ov5640: fix auto controls values when switching to manual mode
      media: ov5640: fix restore of last mode set

Jacopo Mondi (2):
      media: ov5640: Re-work MIPI startup sequence
      media: ov5640: Fix timings setup code

 drivers/media/i2c/ov5640.c | 275 ++++++++++++++++++++++++++++-----------------
 1 file changed, 172 insertions(+), 103 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
