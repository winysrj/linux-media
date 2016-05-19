Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56482 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbcESXl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 19:41:59 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/3] v4l: vsp1: Fix typo in register field names
Date: Fri, 20 May 2016 02:41:56 +0300
Message-Id: <1463701318-22081-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1463701318-22081-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1463701318-22081-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VI6_RPF_ALPH_SEL ALPHA0 and ALPHA1 fields are inverted, swap them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 927b5fb94c48..7657545a75ed 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -154,10 +154,10 @@
 #define VI6_RPF_ALPH_SEL_AEXT_EXT	(1 << 18)
 #define VI6_RPF_ALPH_SEL_AEXT_ONE	(2 << 18)
 #define VI6_RPF_ALPH_SEL_AEXT_MASK	(3 << 18)
-#define VI6_RPF_ALPH_SEL_ALPHA0_MASK	(0xff << 8)
-#define VI6_RPF_ALPH_SEL_ALPHA0_SHIFT	8
-#define VI6_RPF_ALPH_SEL_ALPHA1_MASK	(0xff << 0)
-#define VI6_RPF_ALPH_SEL_ALPHA1_SHIFT	0
+#define VI6_RPF_ALPH_SEL_ALPHA1_MASK	(0xff << 8)
+#define VI6_RPF_ALPH_SEL_ALPHA1_SHIFT	8
+#define VI6_RPF_ALPH_SEL_ALPHA0_MASK	(0xff << 0)
+#define VI6_RPF_ALPH_SEL_ALPHA0_SHIFT	0
 
 #define VI6_RPF_VRTCOL_SET		0x0318
 #define VI6_RPF_VRTCOL_SET_LAYA_MASK	(0xff << 24)
-- 
2.7.3

