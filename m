Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:39249 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752688AbeCDPtN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2018 10:49:13 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: alan@linux.intel.com
Cc: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 0/3] staging: media: cleanup
Date: Sun,  4 Mar 2018 21:18:24 +0530
Message-Id: <1520178507-25141-1-git-send-email-arushisinghal19971997@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Spellcheck the comments.
Remove the repeated, consecutive words with single word.

Arushi Singhal (3):
  staging: media: Replace "be be" with "be"
  staging: media: Replace "cant" with "can't"
  staging: media: Replace "dont" with "don't"

 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h | 2 +-
 drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c                | 2 +-
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c                    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4
