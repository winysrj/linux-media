Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52657 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752875AbeD2MGv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Apr 2018 08:06:51 -0400
From: Colin King <colin.king@canonical.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: atomisp: fix spelling mistake: "diregard" -> "disregard"
Date: Sun, 29 Apr 2018 13:06:47 +0100
Message-Id: <20180429120647.10194-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in ia_css_print message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 .../css2400/css_2401_csi2p_system/host/csi_rx_private.h         | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h
index 9c0cb4a63862..4fa74e7a96e6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/host/csi_rx_private.h
@@ -202,7 +202,7 @@ static inline void csi_rx_be_ctrl_dump_state(
 		ia_css_print("CSI RX BE STATE Controller %d PEC ID %d custom pec 0x%x \n", ID, i, state->pec[i]);
 	}
 #endif
-	ia_css_print("CSI RX BE STATE Controller %d Global LUT diregard reg 0x%x \n", ID, state->global_lut_disregard_reg);
+	ia_css_print("CSI RX BE STATE Controller %d Global LUT disregard reg 0x%x \n", ID, state->global_lut_disregard_reg);
 	ia_css_print("CSI RX BE STATE Controller %d packet stall reg 0x%x \n", ID, state->packet_status_stall);
 	/*
 	 * Get the values of the register-set per
-- 
2.17.0
