Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:46805 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752758AbdJQNNp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 09:13:45 -0400
Date: Tue, 17 Oct 2017 18:43:38 +0530
From: Aishwarya Pant <aishpant@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: outreachy-kernel@googlegroups.com
Subject: [PATCH v3 0/2] staging: atomisp: memory allocation cleanups
Message-ID: <cover.1508245883.git.aishpant@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch series performs minor code cleanups using coccinelle to simplify memory
allocation tests and remove redundant OOM log messages.

Changes in v3:
Rebase changes over atomisp-next branch of the media tree
Changes in v2:
Rebase and re-send patches

Aishwarya Pant (2):
  staging: atomisp2: cleanup null check on memory allocation
  staging: atomisp: cleanup out of memory messages

 drivers/staging/media/atomisp/i2c/atomisp-ap1302.c |  4 +--
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c |  4 +--
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |  4 +--
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c |  4 +--
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |  4 +--
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |  4 +--
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c |  4 +--
 drivers/staging/media/atomisp/i2c/imx/imx.c        |  4 +--
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |  4 +--
 drivers/staging/media/atomisp/i2c/ov8858.c         |  6 +---
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |  4 +--
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  9 ++----
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 36 +++++++++++-----------
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |  7 ++---
 .../pci/atomisp2/css2400/sh_css_param_shading.c    |  4 +--
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        | 10 ++----
 .../atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c    |  6 +---
 .../atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c   |  5 +--
 .../media/atomisp/pci/atomisp2/hmm/hmm_vm.c        |  4 +--
 .../platform/intel-mid/atomisp_gmin_platform.c     |  4 +--
 20 files changed, 41 insertions(+), 90 deletions(-)

-- 
2.11.0
