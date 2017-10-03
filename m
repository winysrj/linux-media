Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38176 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbdJCLoo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 07:44:44 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: gregkh@linuxfoundation.org, jacobvonchorus@cwphoto.ca,
        mchehab@kernel.org, eric@anholt.net, stefan.wahren@i2se.com,
        f.fainelli@gmail.com, rjui@broadcom.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 0/4] staging: rtlwifi: pr_err() strings should end with newlines
Date: Tue,  3 Oct 2017 17:13:22 +0530
Message-Id: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pr_err() messages should end with a new-line to avoid other messages
being concatenated.

Arvind Yadav (4):
  [PATCH 1/4] staging: gs_fpgaboot: pr_err() strings should end with newlines
  [PATCH 2/4] staging: media: davinci_vpfe: pr_err() strings should end with
    newlines
  [PATCH 3/4] staging: bcm2835-camera: pr_err() strings should end with newlines
  [PATCH 4/4] staging: rtlwifi: pr_err() strings should end with newlines

 drivers/staging/gs_fpgaboot/gs_fpgaboot.c                     | 2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c           | 2 +-
 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c | 6 +++---
 drivers/staging/rtlwifi/rtl8822be/phy.c                       | 4 ++--
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c     | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.9.1
