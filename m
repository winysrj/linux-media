Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35858 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753172AbdJQIb1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 04:31:27 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id C77F66010A
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 11:31:25 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e4NHZ-0001LG-CM
        for linux-media@vger.kernel.org; Tue, 17 Oct 2017 11:31:25 +0300
Date: Tue, 17 Oct 2017 11:31:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] Drop dependency to s_power callback in smiapp
Message-ID: <20171017083124.723sedl5rnaamxpx@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The smiapp driver no longer depends on s_power with these patches.

Please pull.


The following changes since commit 8382e556b1a2f30c4bf866f021b33577a64f9ebf:

  Simplify major/minor non-dynamic logic (2017-10-11 15:32:11 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp

for you to fetch changes up to 56c46be8f6c048ab1124861a29225e19bd22e6de:

  smiapp: Rely on runtime PM (2017-10-17 11:27:36 +0300)

----------------------------------------------------------------
Sakari Ailus (2):
      smiapp: Use __v4l2_ctrl_handler_setup()
      smiapp: Rely on runtime PM

 drivers/media/i2c/smiapp/smiapp-core.c | 97 +++++++++++++---------------------
 drivers/media/i2c/smiapp/smiapp-regs.c |  3 ++
 drivers/media/i2c/smiapp/smiapp.h      |  1 +
 3 files changed, 40 insertions(+), 61 deletions(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
