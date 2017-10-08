Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34870 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751457AbdJHJXZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Oct 2017 05:23:25 -0400
Date: Sun, 8 Oct 2017 14:53:20 +0530
From: Aishwarya Pant <aishpant@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: outreachy-kernel@googlegroups.com
Subject: [PATCH 0/2] staginng: atomisp: memory allocation cleanups
Message-ID: <cover.1507454423.git.aishpant@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch series performs minor code cleanups using coccinelle to simplify memory
allocation tests and remove redundant OOM log messages.

Aishwarya Pant (2):
  staging: atomisp2: cleanup null check on memory allocation
  staging: atomisp: cleanup out of memory messages

 drivers/staging/media/atomisp/i2c/ap1302.c         |  4 +--
 drivers/staging/media/atomisp/i2c/gc0310.c         |  4 +--
 drivers/staging/media/atomisp/i2c/gc2235.c         |  4 +--
 drivers/staging/media/atomisp/i2c/imx/imx.c        |  4 +--
 drivers/staging/media/atomisp/i2c/lm3554.c         |  4 +--
 drivers/staging/media/atomisp/i2c/mt9m114.c        |  4 +--
 drivers/staging/media/atomisp/i2c/ov2680.c         |  4 +--
 drivers/staging/media/atomisp/i2c/ov2722.c         |  4 +--
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c  |  4 +--
 drivers/staging/media/atomisp/i2c/ov8858.c         |  6 +---
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |  4 +--
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  9 ++----
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 36 +++++++++++-----------
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |  6 ++--
 .../pci/atomisp2/css2400/sh_css_param_shading.c    |  4 +--
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        | 10 ++----
 .../atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c    |  6 +---
 .../atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c   |  5 +--
 .../media/atomisp/pci/atomisp2/hmm/hmm_vm.c        |  4 +--
 .../platform/intel-mid/atomisp_gmin_platform.c     |  4 +--
 20 files changed, 41 insertions(+), 89 deletions(-)

-- 
2.11.0
