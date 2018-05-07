Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37882 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751968AbeEGMgo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:36:44 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id AA404634C50
        for <linux-media@vger.kernel.org>; Mon,  7 May 2018 15:36:43 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fFfNj-0003gw-Fn
        for linux-media@vger.kernel.org; Mon, 07 May 2018 15:36:43 +0300
Date: Mon, 7 May 2018 15:36:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.18] IPU3 CIO2 fix
Message-ID: <20180507123643.ftdo6z3x6cwhwwej@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a fix for the IPU3 CIO2 driver.

Please pull.


The following changes since commit f10379aad39e9da8bc7d1822e251b5f0673067ef:

  media: include/video/omapfb_dss.h: use IS_ENABLED() (2018-05-05 11:45:51 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ipu3

for you to fetch changes up to fdb5fbc5020b63841e8bd9d4a11429f6bcba13b9:

  media: intel-ipu3: cio2: Handle IRQs until INT_STS is cleared (2018-05-07 14:50:00 +0300)

----------------------------------------------------------------
Bingbu Cao (1):
      media: intel-ipu3: cio2: Handle IRQs until INT_STS is cleared

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
