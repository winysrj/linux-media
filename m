Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:53734 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab1CNN4Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 09:56:24 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 3/7] davinci: dm644x: Replace register base value with a defined macro
Date: Mon, 14 Mar 2011 19:26:08 +0530
Message-Id: <1300110968-16350-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Replace hard coded value of vpss register base to a define macro
DM644X_VPSS_REG_BASE for proper readability

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/dm644x.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 77dea11..73e74d0 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -586,13 +586,15 @@ static struct platform_device dm644x_asp_device = {
 	.resource	= dm644x_asp_resources,
 };
 
+#define DM644X_VPSS_REG_BASE           0x01c73400
+
 static struct resource dm644x_vpss_resources[] = {
 	{
 		/* VPSS Base address */
 		.name		= "vpss",
-		.start          = 0x01c73400,
-		.end            = 0x01c73400 + 0xff,
-		.flags          = IORESOURCE_MEM,
+		.start		= DM644X_VPSS_REG_BASE,
+		.end		= DM644X_VPSS_REG_BASE + 0xff,
+		.flags		= IORESOURCE_MEM,
 	},
 };
 
-- 
1.6.2.4

