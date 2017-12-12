Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:17791 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdLLLDZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 06:03:25 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, a.hajda@samsung.com,
        jtp.park@samsung.com, kamil@wypas.org, smitha.t@samsung.com,
        b.zolnierkie@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-mfc: Fix encoder menu controls initialization
Date: Tue, 12 Dec 2017 12:02:46 +0100
Message-id: <20171212110246.11463-1-s.nawrocki@samsung.com>
References: <CGME20171212110322epcas2p11e3f36ba3de73a03f062b7877d797d2a@epcas2p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the menu_skip_mask field initialization
and addresses a following issue found by the SVACE static
analysis:

* NO_EFFECT.SELF: assignment to self in expression 'cfg.menu_skip_mask = cfg.menu_skip_mask'
  No effect at drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:2083

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2a5fd7c42cd5..0d5d465561be 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -2080,7 +2080,7 @@ int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx)
 
 			if (cfg.type == V4L2_CTRL_TYPE_MENU) {
 				cfg.step = 0;
-				cfg.menu_skip_mask = cfg.menu_skip_mask;
+				cfg.menu_skip_mask = controls[i].menu_skip_mask;
 				cfg.qmenu = mfc51_get_menu(cfg.id);
 			} else {
 				cfg.step = controls[i].step;
-- 
2.14.2
