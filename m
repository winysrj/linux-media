Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43164 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728263AbeHaShA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 14:37:00 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 8856B634C7F
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 17:29:14 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fvkQE-00016g-6N
        for linux-media@vger.kernel.org; Fri, 31 Aug 2018 17:29:14 +0300
Date: Fri, 31 Aug 2018 17:29:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES for 4.19] mt9v111 control handler init fix
Message-ID: <20180831142913.pr2nsy5t3bidlr4d@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a single fix for the mt9v111 driver added recently.

Please pull.


The following changes since commit 3799eca51c5be3cd76047a582ac52087373b54b3:

  media: camss: add missing includes (2018-08-29 14:02:06 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git fixes-4.19-1

for you to fetch changes up to 7dfd7927b109337ece5ad3fe382ae91134bdd636:

  media: i2c: mt9v111: Fix v4l2-ctrl error handling (2018-08-31 15:49:50 +0300)

----------------------------------------------------------------
Jacopo Mondi (1):
      media: i2c: mt9v111: Fix v4l2-ctrl error handling

 drivers/media/i2c/mt9v111.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
