Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39286 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1763488AbdLSOdb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 09:33:31 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 6F852600D8
        for <linux-media@vger.kernel.org>; Tue, 19 Dec 2017 16:33:30 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eRIxW-0001i3-1T
        for linux-media@vger.kernel.org; Tue, 19 Dec 2017 16:33:30 +0200
Date: Tue, 19 Dec 2017 16:33:29 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.16] An ordinary pile of atomisp cleanups and fixes
Message-ID: <20171219143329.bael34cmnjhl7rmc@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the regular pile of atomisp cleanups and some fixes, too.

Please pull.


The following changes since commit 8ea636dcecfa7b05d60309a50beabc5317a845bf:

  media: ir-spi: add SPDX identifier (2017-12-18 15:22:50 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git atomisp

for you to fetch changes up to 6a0ed1a9cf6a0679772688aaf1bfec2ccd22fd47:

  staging: atomisp2: replace DEVICE_ATTR with DEVICE_ATTR_RO (2017-12-19 14:15:12 +0200)

----------------------------------------------------------------
Aishwarya Pant (1):
      staging: atomisp2: replace DEVICE_ATTR with DEVICE_ATTR_RO

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

 drivers/staging/media/atomisp/i2c/ov2680.h         |  1 -
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      | 82 ++++++++++++++--------
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |  2 +-
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  2 +-
 .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        | 24 +++----
 .../css2400/runtime/debug/src/ia_css_debug.c       |  1 +
 .../isp_param/interface/ia_css_isp_param_types.h   |  2 +-
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |  8 +--
 8 files changed, 72 insertions(+), 50 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
