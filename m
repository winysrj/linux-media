Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57450 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbbA2BWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:22:08 -0500
Received: by mail-pa0-f48.google.com with SMTP id ey11so32122316pad.7
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2015 17:22:08 -0800 (PST)
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: laurent.pinchart+renesas@ideasonboard.com
Cc: linux-media@vger.kernel.org,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 3/3] [media] v4l: vsp1: Fix VI6_DPR_ROUTE_FXA_MASK macro
Date: Thu, 29 Jan 2015 09:53:55 +0900
Message-Id: <1422492835-4398-3-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
In-Reply-To: <1422492835-4398-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1422492835-4398-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FXA bit of VI6_DPR_mod_ROUTE register starts from 16bit. But VI6_DPR_ROUTE_FXA_MASK
is set to become start from 8bit. This fixes shift size for VI6_DPR_ROUTE_FXA_MASK.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 4177f98..25b4873 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -304,7 +304,7 @@
 #define VI6_DPR_HST_ROUTE		0x2044
 #define VI6_DPR_HSI_ROUTE		0x2048
 #define VI6_DPR_BRU_ROUTE		0x204c
-#define VI6_DPR_ROUTE_FXA_MASK		(0xff << 8)
+#define VI6_DPR_ROUTE_FXA_MASK		(0xff << 16)
 #define VI6_DPR_ROUTE_FXA_SHIFT		16
 #define VI6_DPR_ROUTE_FP_MASK		(0x3f << 8)
 #define VI6_DPR_ROUTE_FP_SHIFT		8
-- 
2.1.3

