Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58426 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750936AbdKIKhq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Nov 2017 05:37:46 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 72CF760123
        for <linux-media@vger.kernel.org>; Thu,  9 Nov 2017 12:37:44 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eCkDP-0002ml-SV
        for linux-media@vger.kernel.org; Thu, 09 Nov 2017 12:37:43 +0200
Date: Thu, 9 Nov 2017 12:37:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] imx274 fix
Message-ID: <20171109103743.q4bvjeqttohyxxga@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This fixes error handling in imx274 as well as adds an entry to
MAINTAINERS.

Please pull.

The following changes since commit eb0c19942288569e0ae492476534d5a485fb8ab4:

  media: dib0700: fix invalid dvb_detach argument (2017-11-07 05:52:52 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-5

for you to fetch changes up to 873e03462ce74c3650a34d2d1601b8c2e028ac3c:

  imx274: Fix error handling, add MAINTAINERS entry (2017-11-09 12:20:24 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      imx274: Fix error handling, add MAINTAINERS entry

 MAINTAINERS                | 8 ++++++++
 drivers/media/i2c/imx274.c | 5 ++---
 2 files changed, 10 insertions(+), 3 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
