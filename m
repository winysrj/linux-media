Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46820 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751214AbdHXHIR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 03:08:17 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id E9E73600E0
        for <linux-media@vger.kernel.org>; Thu, 24 Aug 2017 10:08:15 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dkmFT-0000Pu-ER
        for linux-media@vger.kernel.org; Thu, 24 Aug 2017 10:08:15 +0300
Date: Thu, 24 Aug 2017 10:08:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] omap3isp and smiapp fixes
Message-ID: <20170824070814.lffozsn2itipdjfm@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are two fixes for the smiapp and omap3isp drivers.

Please pull.

The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.14-5

for you to fetch changes up to ecee8b797cc74b35587fd2e8ab9e916a85f09e66:

  smiapp: check memory allocation failure (2017-08-24 09:53:46 +0300)

----------------------------------------------------------------
Arnd Bergmann (1):
      media: omap3isp: fix uninitialized variable use

Christophe JAILLET (1):
      smiapp: check memory allocation failure

 drivers/media/i2c/smiapp/smiapp-core.c | 2 ++
 drivers/media/platform/omap3isp/isp.c  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
