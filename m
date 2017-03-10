Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33867 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbdCJFNQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 00:13:16 -0500
Received: by mail-pf0-f194.google.com with SMTP id o126so9536954pfb.1
        for <linux-media@vger.kernel.org>; Thu, 09 Mar 2017 21:13:16 -0800 (PST)
From: simran singhal <singhalsimran0@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, jarod@wilsonet.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 0/3] staging: media: Clean up tests if NULL returned on failure
Date: Fri, 10 Mar 2017 10:43:09 +0530
Message-Id: <1489122792-8081-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series tests if functions like kmalloc/kzalloc return NULL
on failure. When NULL represents failure, !x is commonly used.

simran singhal (3):
  staging: atomisp_fops: Clean up tests if NULL returned on failure
  staging: vpfe_mc_capture: Clean up tests if NULL returned on failure
  staging: lirc_zilog: Clean up tests if NULL returned on failure

 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c | 2 +-
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c      | 4 ++--
 drivers/staging/media/lirc/lirc_zilog.c                   | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.7.4
