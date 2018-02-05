Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:34223 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751015AbeBEUKZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 15:10:25 -0500
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/4] v4l: vsp1: fix mask creation for MULT_ALPHA_RATIO
Date: Mon,  5 Feb 2018 21:09:58 +0100
Message-Id: <20180205201002.23621-2-wsa+renesas@sang-engineering.com>
In-Reply-To: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to a typo, the mask was destroyed by a comparison instead of a bit
shift. No regression since the mask has not been used yet.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
Only build tested. To be applied individually per subsystem.

 drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 26c4ffad2f4656..b1912c83a1dae2 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -225,7 +225,7 @@
 #define VI6_RPF_MULT_ALPHA_P_MMD_RATIO	(1 << 8)
 #define VI6_RPF_MULT_ALPHA_P_MMD_IMAGE	(2 << 8)
 #define VI6_RPF_MULT_ALPHA_P_MMD_BOTH	(3 << 8)
-#define VI6_RPF_MULT_ALPHA_RATIO_MASK	(0xff < 0)
+#define VI6_RPF_MULT_ALPHA_RATIO_MASK	(0xff << 0)
 #define VI6_RPF_MULT_ALPHA_RATIO_SHIFT	0
 
 /* -----------------------------------------------------------------------------
-- 
2.11.0
