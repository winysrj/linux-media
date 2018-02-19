Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45962 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752486AbeBSLKD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 06:10:03 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 50E276010B
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 13:10:02 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1enjKb-0004Fq-Sw
        for linux-media@vger.kernel.org; Mon, 19 Feb 2018 13:10:01 +0200
Date: Mon, 19 Feb 2018 13:10:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.17] IPU3 CIO2 patches
Message-ID: <20180219111001.7xfm74uwwww42qtd@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a bugfix and a switch for the SPDX tags for IPU3 CIO2 driver.

Please pull.


The following changes since commit 29422737017b866d4a51014cc7522fa3a99e8852:

  media: rc: get start time just before calling driver tx (2018-02-14 14:17:21 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ipu3

for you to fetch changes up to 0df935a6d4b6f82de5b8f7e993cd192975171ea7:

  media: intel-ipu3: cio2: Use SPDX license headers (2018-02-19 10:31:37 +0200)

----------------------------------------------------------------
Yong Zhi (2):
      media: intel-ipu3: cio2: Disable and sync irq before stream off
      media: intel-ipu3: cio2: Use SPDX license headers

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 16 ++++++----------
 drivers/media/pci/intel/ipu3/ipu3-cio2.h | 14 ++------------
 2 files changed, 8 insertions(+), 22 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
