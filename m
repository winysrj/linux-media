Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43882 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932170AbdHVICH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 04:02:07 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 9C865600EF
        for <linux-media@vger.kernel.org>; Tue, 22 Aug 2017 11:02:06 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dk48U-0008TX-5j
        for linux-media@vger.kernel.org; Tue, 22 Aug 2017 11:02:06 +0300
Date: Tue, 22 Aug 2017 11:02:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] Fix fwnode lane-polarities property parsing
Message-ID: <20170822080205.chefr3xpmnzdgrc2@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Fwnode property parings was recently broken by a smatch warning fix. Fix
this.

Please pull.


The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git fwnode-fix

for you to fetch changes up to 2a565a3828d0274ec1e911e7866d98c751370c0c:

  v4l: fwnode: Use a less clash-prone name for MAX_DATA_LANES macro (2017-08-22 10:57:52 +0300)

----------------------------------------------------------------
Sakari Ailus (3):
      v4l: fwnode: Fix lane-polarities property parsing
      v4l: fwnode: The clock lane is the first lane in lane_polarities
      v4l: fwnode: Use a less clash-prone name for MAX_DATA_LANES macro

 drivers/media/v4l2-core/v4l2-fwnode.c | 15 ++++++++++-----
 include/media/v4l2-fwnode.h           |  6 +++---
 2 files changed, 13 insertions(+), 8 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
