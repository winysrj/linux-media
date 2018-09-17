Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42426 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726979AbeIQPJs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 11:09:48 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id C4D0B634C7F
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 12:43:10 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1g1q3i-0000wD-HD
        for linux-media@vger.kernel.org; Mon, 17 Sep 2018 12:43:10 +0300
Date: Mon, 17 Sep 2018 12:43:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Small lens driver fixes
Message-ID: <20180917094310.pbrd6sjy77vzv4tt@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are two patches for assing maintainers for dw9714 and dw9807 and
a small cleanup for the dw9807-vcm driver.

Please pull.


The following changes since commit 78cf8c842c111df656c63b5d04997ea4e40ef26a:

  media: drxj: fix spelling mistake in fall-through annotations (2018-09-12 11:21:52 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-2-0

for you to fetch changes up to 7e5b31af58cbc946574c36ca4923d5bb7fe01efd:

  dw9807-vcm: Remove redundant pm_runtime_set_suspended in remove (2018-09-16 01:43:47 +0300)

----------------------------------------------------------------
some lens driver patches

----------------------------------------------------------------
Sakari Ailus (2):
      dt-bindings: dw9714, dw9807-vcm: Add files to MAINTAINERS, rename files
      dw9807-vcm: Remove redundant pm_runtime_set_suspended in remove

 .../bindings/media/i2c/{dongwoon,dw9807.txt => dongwoon,dw9807-vcm.txt} | 0
 MAINTAINERS                                                             | 2 ++
 drivers/media/i2c/dw9807-vcm.c                                          | 1 -
 3 files changed, 2 insertions(+), 1 deletion(-)
 rename Documentation/devicetree/bindings/media/i2c/{dongwoon,dw9807.txt => dongwoon,dw9807-vcm.txt} (100%)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
