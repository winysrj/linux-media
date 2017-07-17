Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44438 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751351AbdGQWOg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:14:36 -0400
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 4B9DB600C0
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 01:14:33 +0300 (EEST)
Received: from sailus by lanttu.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@iki.fi>)
        id 1dXEHi-00050D-Kt
        for linux-media@vger.kernel.org; Tue, 18 Jul 2017 01:14:34 +0300
Date: Tue, 18 Jul 2017 01:14:34 +0300
From: sakari.ailus@iki.fi
To: linux-media@vger.kernel.org
Subject: [GIT FIXES for 4.13] Atomisp array underflow fix
Message-ID: <20170717221434.wgbd7ijemad4mj6n@lanttu.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

One atomisp fix patch here...

Please pull.


The following changes since commit 2a2599c663684a1142dae0bff7737e125891ae6d:

  [media] media: entity: Catch unbalanced media_pipeline_stop calls (2017-06-23 09:23:36 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git atomisp-fix

for you to fetch changes up to aaa2809c75f4bf76771adf3252a864668c21841a:

  staging: atomisp: array underflow in ioctl (2017-07-18 00:36:48 +0300)

----------------------------------------------------------------
Dan Carpenter (1):
      staging: atomisp: array underflow in ioctl

 drivers/staging/media/atomisp/i2c/gc0310.h        | 2 +-
 drivers/staging/media/atomisp/i2c/gc2235.h        | 2 +-
 drivers/staging/media/atomisp/i2c/ov2680.h        | 3 +--
 drivers/staging/media/atomisp/i2c/ov2722.h        | 2 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h | 2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)


-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
