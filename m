Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1G2K5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:07 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 20/59] ARM: ap4evb: switch imx074 configuration to default number of lanes
Date: Fri, 29 Jul 2011 12:56:20 +0200
Message-Id: <1311937019-29914-21-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sh_mobile_csi2 driver will change meaning of the .lanes platform
data field from "bitmask of used lanes" to "number of used lanes."
To avoid a regression during this transition switch ap4evb to rely
on the 2 lane default.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/arm/mach-shmobile/board-ap4evb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index 67b3d0b..47151dc 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -931,7 +931,7 @@ static struct platform_device ap4evb_camera = {
 static struct sh_csi2_client_config csi2_clients[] = {
 	{
 		.phy		= SH_CSI2_PHY_MAIN,
-		.lanes		= 3,
+		.lanes		= 0,		/* default: 2 lanes */
 		.channel	= 0,
 		.pdev		= &ap4evb_camera,
 	},
-- 
1.7.2.5

