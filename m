Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46868 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751875AbeEWF1Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 01:27:25 -0400
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Fix issues reported by static analysis tool.
Date: Wed, 23 May 2018 10:51:30 +0530
Message-Id: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes some of the issues reported by static analysis
tool.

Pankaj Bharadiya (6):
  media: staging: atomisp: remove redundent check
  media: staging: atomisp: Remove useless if statement
  media: staging: atomisp: Remove useless "ifndef ISP2401"
  media: staging: atomisp: Fix potential NULL pointer dereference
  media: staging: atomisp: Fix potential NULL pointer dereference
  media: staging: atomisp: Fix potential NULL pointer dereference

 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c   | 14 --------------
 .../media/atomisp/pci/atomisp2/atomisp_compat_css20.c      |  2 --
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c  |  8 --------
 .../pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c |  3 ++-
 .../staging/media/atomisp/pci/atomisp2/css2400/sh_css.c    |  7 +++++--
 5 files changed, 7 insertions(+), 27 deletions(-)

-- 
2.7.4
