Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:49372
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751242AbdHFIu4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Aug 2017 04:50:56 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-mediatek@lists.infradead.org
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 00/12] constify v4l2_m2m_ops structures
Date: Sun,  6 Aug 2017 10:25:09 +0200
Message-Id: <1502007921-22968-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_m2m_ops structures are only passed as the only
argument to v4l2_m2m_init, which is declared as const.
Thus the v4l2_m2m_ops structures themselves can be const.

Done with the help of Coccinelle.

---

 drivers/media/platform/exynos-gsc/gsc-m2m.c     |    2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c    |    2 +-
 drivers/media/platform/m2m-deinterlace.c        |    2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c |    2 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c    |    2 +-
 drivers/media/platform/mx2_emmaprp.c            |    2 +-
 drivers/media/platform/rcar_jpu.c               |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c            |    2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c   |    2 +-
 drivers/media/platform/sti/delta/delta-v4l2.c   |    2 +-
 drivers/media/platform/ti-vpe/vpe.c             |    2 +-
 drivers/media/platform/vim2m.c                  |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)
