Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51289 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756642AbdJQM1h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 08:27:37 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, prabhakar.csengg@gmail.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 0/2] [media] davinci: make function arguments and structures const
Date: Tue, 17 Oct 2017 14:27:23 +0200
Message-Id: <1508243245-30849-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make some function arguments as const. After this changes make ccdc_hw_device
structures as const.

Bhumika Goyal (2):
  [media] davinci: make function arguments const
  [media] davinci: make ccdc_hw_device structures const

 drivers/media/platform/davinci/ccdc_hw_device.h | 4 ++--
 drivers/media/platform/davinci/dm355_ccdc.c     | 2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c    | 2 +-
 drivers/media/platform/davinci/isif.c           | 2 +-
 drivers/media/platform/davinci/vpfe_capture.c   | 6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.9.1
