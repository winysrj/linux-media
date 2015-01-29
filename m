Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47367 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbbA2BSn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:18:43 -0500
Received: by mail-pa0-f50.google.com with SMTP id rd3so32026611pab.9
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2015 17:18:43 -0800 (PST)
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: laurent.pinchart+renesas@ideasonboard.com
Cc: linux-media@vger.kernel.org,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 1/3] [media] v4l: vsp1: Fix VI6_WPF_SZCLIP_SIZE_MASK macro
Date: Thu, 29 Jan 2015 09:53:53 +0900
Message-Id: <1422492835-4398-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clipping size bit of VI6_WPFn _HSZCLIP and VI6_WPFn _VSZCLIP register are from
0 bit to 11 bit. But VI6_WPF_SZCLIP_SIZE_MASK is set to 0x1FFF, this will mask
until the reserve bits. This fixes size for VI6_WPF_SZCLIP_SIZE_MASK.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index da3c573..f61e109 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -238,7 +238,7 @@
 #define VI6_WPF_SZCLIP_EN		(1 << 28)
 #define VI6_WPF_SZCLIP_OFST_MASK	(0xff << 16)
 #define VI6_WPF_SZCLIP_OFST_SHIFT	16
-#define VI6_WPF_SZCLIP_SIZE_MASK	(0x1fff << 0)
+#define VI6_WPF_SZCLIP_SIZE_MASK	(0xfff << 0)
 #define VI6_WPF_SZCLIP_SIZE_SHIFT	0
 
 #define VI6_WPF_OUTFMT			0x100c
-- 
2.1.3

