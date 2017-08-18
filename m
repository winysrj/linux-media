Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36402 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdHRQHM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 12:07:12 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, vz@mleia.com, slemieux.tyco@gmail.com,
        wsa@the-dreams.de, gxt@mprc.pku.edu.cn, mchehab@kernel.org,
        isely@pobox.com, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 0/2] drivers: make i2c_algorithm const
Date: Fri, 18 Aug 2017 21:36:56 +0530
Message-Id: <1503072418-6887-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const.

Bhumika Goyal (2):
  i2c: busses: make i2c_algorithm const
  [media] usb: make i2c_algorithm const

 drivers/i2c/busses/i2c-pnx.c                 | 2 +-
 drivers/i2c/busses/i2c-puv3.c                | 2 +-
 drivers/media/usb/au0828/au0828-i2c.c        | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.9.1
