Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33394 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751307AbdKEXOi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 18:14:38 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 5675F60103
        for <linux-media@vger.kernel.org>; Mon,  6 Nov 2017 01:14:37 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eBU7g-00027W-QY
        for linux-media@vger.kernel.org; Mon, 06 Nov 2017 01:14:36 +0200
Date: Mon, 6 Nov 2017 01:14:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] V4L2 async NULL dereference fix
Message-ID: <20171105231436.xdq6lslrgc22xu77@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

There was a rather subtle problem in the recent V4L2 async patches that
could lead to NULL pointer dereference in some situations. This simple
patch from Niklas addresses that.

Please pull.


The following changes since commit 9917fbcfa20ab987d6381fd0365665e5c1402d75:

  media: camss-vfe: always initialize reg at vfe_set_xbar_cfg() (2017-11-01 12:25:59 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-7

for you to fetch changes up to a01b5d89dc19d7b622104bbd27698687bbb2ffe6:

  media: v4l: async: fix unregister for implicitly registered sub-device notifiers (2017-11-06 00:44:45 +0200)

----------------------------------------------------------------
Niklas Söderlund (1):
      media: v4l: async: fix unregister for implicitly registered sub-device notifiers

 drivers/media/v4l2-core/v4l2-async.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
