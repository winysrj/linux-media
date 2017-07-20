Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37991 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964819AbdGTI4m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 04:56:42 -0400
Received: by mail-wr0-f194.google.com with SMTP id p12so1822206wrc.5
        for <linux-media@vger.kernel.org>; Thu, 20 Jul 2017 01:56:42 -0700 (PDT)
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Sekhar Nori <nsekhar@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [v3 0/2] media: platform: davinci: remove VPFE_CMD_S_CCDC_RAW_PARAMS IOCTL
Date: Thu, 20 Jul 2017 09:56:29 +0100
Message-Id: <1500540991-27430-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series drops VPFE_CMD_S_CCDC_RAW_PARAMS ioctl, from davicni
vpfe_capture driver because of following reasons:

- The function constantly mixes up pointers and phys_addr_t numbers
- This is part of a 'VPFE_CMD_S_CCDC_RAW_PARAMS' ioctl command that is
  described as an 'experimental ioctl that will change in future kernels',
  but if we have users that probably won't happen.
- The code to allocate the table never gets called after we copy_from_user
  the user input over the kernel settings, and then compare them
  for inequality.
- We then go on to use an address provided by user space as both the
  __user pointer for input and pass it through phys_to_virt to come up
  with a kernel pointer to copy the data to. This looks like a trivially
  exploitable root hole.


As discussed at [1], there wouldn’t be any possible users of
the VPFE_CMD_S_CCDC_RAW_PARAMS IOCTL, but if someone complains
we might end up reverting the removal and fix it differently.

[1] https://patchwork.kernel.org/patch/9779385/

Note: Patch 0001 is intended to apply for backports so as the reason
minimalistic changes have been done since the ioctl was added in
kernel 2.6.32 [2] and applying too many changes would produce conflicts,
just applying this patch would produce build warning of unused functions.

[2] commit 5f15fbb68fd7 ("V4L/DVB (12251): v4l: dm644x ccdc module for vpfe capture driver")

Lad, Prabhakar (2):
  media: platform: davinci: prepare for removal of
    VPFE_CMD_S_CCDC_RAW_PARAMS ioctl
  media: platform: davinci: drop VPFE_CMD_S_CCDC_RAW_PARAMS

 drivers/media/platform/davinci/ccdc_hw_device.h |  10 --
 drivers/media/platform/davinci/dm355_ccdc.c     |  92 +--------------
 drivers/media/platform/davinci/dm644x_ccdc.c    | 151 +-----------------------
 drivers/media/platform/davinci/vpfe_capture.c   |  93 ---------------
 include/media/davinci/dm644x_ccdc.h             |  12 --
 include/media/davinci/vpfe_capture.h            |  10 --
 6 files changed, 4 insertions(+), 364 deletions(-)

-- 
2.7.4
