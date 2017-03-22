Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34867 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750721AbdCVE0R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 00:26:17 -0400
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: outreachy-kernel@googlegroups.com
Cc: linux-media@vger.kernel.org, gregkh@linuxfoundation.org,
        mchehab@kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 0/3] staging: media: Replace a bit shift.
Date: Wed, 22 Mar 2017 09:56:06 +0530
Message-Id: <20170322042609.23525-1-arushisinghal19971997@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace a bit shift by a use of BIT in media driver.

Arushi Singhal (3):
  staging: media: Replace a bit shift by a use of BIT.
  staging: media: davinci_vpfe: Replace a bit shift by a use of BIT.
  staging: media: omap4iss: Replace a bit shift by a use of BIT.

 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 12 +++++-----
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |  6 ++---
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |  6 ++---
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      | 18 +++++++--------
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    | 26 +++++++++++-----------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  6 ++---
 drivers/staging/media/omap4iss/iss_csi2.c          |  2 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |  2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  2 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |  2 +-
 13 files changed, 44 insertions(+), 44 deletions(-)

-- 
2.11.0
