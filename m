Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43964 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750985AbdLUWiK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 17:38:10 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 0328E600DC
        for <linux-media@vger.kernel.org>; Fri, 22 Dec 2017 00:38:07 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eS9Tb-00027w-Gv
        for linux-media@vger.kernel.org; Fri, 22 Dec 2017 00:38:07 +0200
Date: Fri, 22 Dec 2017 00:38:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 for 4.16] An ordinary pile of atomisp cleanups and fixes
Message-ID: <20171221223807.vsqqqv5zeq52ildm@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the regular pile of atomisp cleanups and some fixes, too.

since v1:

- Add Andy's cleanups and fixes.

Please pull.


The following changes since commit ae49432810c5cca2143afc1445edad6582c9f270:

  media: ddbridge: improve ddb_ports_attach() failure handling (2017-12-19 07:18:38 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git atomisp

for you to fetch changes up to e4e1b698c1a67f1d58ca5c232c1b44fa77bd1a7b:

  staging: atomisp: Fix DMI matching entry for MRD7 (2017-12-21 23:44:26 +0200)

----------------------------------------------------------------
Aishwarya Pant (1):
      staging: atomisp2: replace DEVICE_ATTR with DEVICE_ATTR_RO

Andy Shevchenko (10):
      staging: atomisp: Don't leak GPIO resources if clk_get() failed
      staging: atomisp: Remove duplicate NULL-check
      staging: atomisp: lm3554: Fix control values
      staging: atomisp: Disable custom format for now
      staging: atomisp: Remove non-ACPI leftovers
      staging: atomisp: Switch to use struct device_driver directly
      staging: atomisp: Remove redundant PCI code
      staging: atomisp: Unexport local function
      staging: atomisp: Use standard DMI match table
      staging: atomisp: Fix DMI matching entry for MRD7

Arnd Bergmann (1):
      staging: atomisp: convert timestamps to ktime_t

Jeremy Sowden (2):
      media: staging: atomisp: fix for sparse "using plain integer as NULL pointer" warnings.
      media: staging: atomisp: fixes for "symbol was not declared. Should it be static?" sparse warnings.

Riccardo Schirone (4):
      staging: add missing blank line after declarations in atomisp-ov5693
      staging: improve comments usage in atomisp-ov5693
      staging: improves comparisons readability in atomisp-ov5693
      staging: fix indentation in atomisp-ov5693

Sergiy Redko (1):
      Staging: media: atomisp: made function static

Sinan Kaya (1):
      atomisp: deprecate pci_get_bus_and_slot()

 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c |  10 +-
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |   8 +-
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c |  38 +++---
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |   8 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |  10 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c |  17 +--
 drivers/staging/media/atomisp/i2c/ov2680.h         |   1 -
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |  94 ++++++++-------
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |   2 +-
 drivers/staging/media/atomisp/i2c/ov8858.c         |  43 ++++---
 .../staging/media/atomisp/include/linux/atomisp.h  |   2 +
 .../atomisp/include/linux/atomisp_gmin_platform.h  |   1 -
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |  17 ++-
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.h     |   5 +-
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |   1 -
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |   5 +-
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |   2 +
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  12 +-
 .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        |  24 ++--
 .../css2400/runtime/debug/src/ia_css_debug.c       |   1 +
 .../isp_param/interface/ia_css_isp_param_types.h   |   2 +-
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |   8 +-
 .../platform/intel-mid/atomisp_gmin_platform.c     | 129 +++++++++++++--------
 23 files changed, 221 insertions(+), 219 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
