Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53862
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751338AbdHELMm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 07:12:42 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-arm-kernel@lists.infradead.org
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net
Subject: [PATCH 0/6] constify vb2_ops structures
Date: Sat,  5 Aug 2017 12:47:07 +0200
Message-Id: <1501930033-18249-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These vb2_ops structures are only stored in the ops field of a
vb2_queue structure, which is declared as const.  Thus the vb2_ops
structures themselves can be const.

Done with the help of Coccinelle.

---

 drivers/media/platform/blackfin/bfin_capture.c                |    2 +-
 drivers/media/platform/davinci/vpbe_display.c                 |    2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c               |    2 +-
 drivers/staging/media/imx/imx-media-capture.c                 |    4 ++--
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c |    2 +-
 samples/v4l/v4l2-pci-skeleton.c                               |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)
