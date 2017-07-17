Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44428 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751435AbdGQWOa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:14:30 -0400
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 6BD59600C0
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 01:14:27 +0300 (EEST)
Received: from sailus by lanttu.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@iki.fi>)
        id 1dXEHc-000505-Qq
        for linux-media@vger.kernel.org; Tue, 18 Jul 2017 01:14:28 +0300
Date: Tue, 18 Jul 2017 01:14:28 +0300
From: sakari.ailus@iki.fi
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] Atomisp cleanups
Message-ID: <20170717221428.bgj4judsvquaas26@lanttu.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set contains a pretty big pile of atomisp patches for 4.14.

Please pull.


The following changes since commit a3db9d60a118571e696b684a6e8c692a2b064941:

  Merge tag 'v4.13-rc1' into patchwork (2017-07-17 11:17:36 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git atomisp

for you to fetch changes up to db12cb63f3796716e8f99cc638b0a3794919b05e:

  staging: atomisp: fixed trivial coding style issue (2017-07-18 00:37:10 +0300)

----------------------------------------------------------------
Amitoj Kaur Chawla (2):
      staging: atomisp: Remove unnecessary return statement in void function
      staging: atomisp: Use kvfree() instead of kfree()/vfree()

Arvind Yadav (8):
      staging: atomisp: lm3554: constify acpi_device_id.
      staging: atomisp: ov2680: constify acpi_device_id.
      staging: atomisp: ov8858: constify acpi_device_id.
      staging: atomisp: gc0310: constify acpi_device_id.
      staging: atomisp: ov2722: constify acpi_device_id.
      staging: atomisp: ov5693: constify acpi_device_id.
      staging: atomisp: mt9m114: constify acpi_device_id.
      staging: atomisp: gc2235: constify acpi_device_id.

Guillermo O. Freschi (1):
      staging: atomisp: gc2235: fix sparse warning: missing static

Hari Prasath (1):
      staging: atomisp: use kstrdup to replace kmalloc and memcpy

Ivan Menshykov (1):
      staging: atomisp: i2c: ov5693: Fix style a coding style issue

Mauro Carvalho Chehab (1):
      staging: atomisp: disable warnings with cc-disable-warning

Philipp Guendisch (2):
      staging: atomisp: hmm: Fixed comment style
      staging: atomisp: hmm: Alignment code (rebased)

Shy More (2):
      staging: atomisp: fixed trivial coding style warning
      staging: atomisp: fixed trivial coding style issue

 drivers/staging/media/atomisp/i2c/gc0310.c         |   2 +-
 drivers/staging/media/atomisp/i2c/gc2235.c         |   4 +-
 drivers/staging/media/atomisp/i2c/gc2235.h         |   6 +-
 drivers/staging/media/atomisp/i2c/lm3554.c         |   2 +-
 drivers/staging/media/atomisp/i2c/mt9m114.c        |   2 +-
 drivers/staging/media/atomisp/i2c/ov2680.c         |   2 +-
 drivers/staging/media/atomisp/i2c/ov2722.c         |   2 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c  |   8 +-
 drivers/staging/media/atomisp/i2c/ov8858.c         |   2 +-
 .../staging/media/atomisp/pci/atomisp2/Makefile    |  10 +-
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |  19 +--
 .../media/atomisp/pci/atomisp2/atomisp_cmd.h       |   1 -
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |   4 +-
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |   2 -
 .../css2400/runtime/isys/src/ibuf_ctrl_rmgr.c      |  27 ++--
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |   8 +-
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   | 139 ++++++++++-----------
 17 files changed, 110 insertions(+), 130 deletions(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
