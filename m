Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59370 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754184AbdGUOrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 10:47:12 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id A1FA7600D1
        for <linux-media@vger.kernel.org>; Fri, 21 Jul 2017 15:07:25 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dYWiK-00016x-Uu
        for linux-media@vger.kernel.org; Fri, 21 Jul 2017 15:07:25 +0300
Date: Fri, 21 Jul 2017 15:07:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES for 4.13] More atomisp fixes
Message-ID: <20170721120724.edjpp2i6hb67ckkj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A few more atomisp fixes here.

Please pull.

The following changes since commit 6538b02d210f52ef2a2e67d59fcb58be98451fbd:

  media: Make parameter of media_entity_remote_pad() const (2017-07-20 16:54:04 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git atomisp-fix

for you to fetch changes up to 6f304e954aea736d86c2b1d8ba0571c655827b86:

  atomisp2: array underflow in imx_enum_frame_size() (2017-07-21 14:54:45 +0300)

----------------------------------------------------------------
Dan Carpenter (3):
      atomisp2: Array underflow in atomisp_enum_input()
      atomisp2: array underflow in ap1302_enum_frame_size()
      atomisp2: array underflow in imx_enum_frame_size()

 drivers/staging/media/atomisp/i2c/ap1302.h                    | 4 ++--
 drivers/staging/media/atomisp/i2c/imx/imx.h                   | 2 +-
 drivers/staging/media/atomisp/i2c/ov8858.h                    | 2 +-
 drivers/staging/media/atomisp/i2c/ov8858_btns.h               | 2 +-
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
