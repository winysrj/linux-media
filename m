Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59264 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbbFGI6Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:58:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Magnus Damm <damm@opensource.se>
Subject: [PATCHv2 01/11] clock-sh7724.c: fix sh-vou clock identifier
Date: Sun,  7 Jun 2015 10:57:55 +0200
Message-Id: <1433667485-35711-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Bitrot has set in for this driver and the sh-vou clock was never enabled,
since the clock name in clock-sh7724.c was wrong. It should be sh-vou, not
sh-vou.0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Thanks-to: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Magnus Damm <damm@opensource.se>
---
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c b/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
index c187b95..f27c618 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7724.c
@@ -343,7 +343,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("2ddmac0", &mstp_clks[HWBLK_2DDMAC]),
 	CLKDEV_DEV_ID("sh_fsi.0", &mstp_clks[HWBLK_SPU]),
 	CLKDEV_CON_ID("jpu0", &mstp_clks[HWBLK_JPU]),
-	CLKDEV_DEV_ID("sh-vou.0", &mstp_clks[HWBLK_VOU]),
+	CLKDEV_DEV_ID("sh-vou", &mstp_clks[HWBLK_VOU]),
 	CLKDEV_CON_ID("beu0", &mstp_clks[HWBLK_BEU0]),
 	CLKDEV_DEV_ID("sh_mobile_ceu.0", &mstp_clks[HWBLK_CEU0]),
 	CLKDEV_CON_ID("veu0", &mstp_clks[HWBLK_VEU0]),
-- 
2.1.4

