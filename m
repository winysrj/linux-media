Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42319 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFFPVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 11:21:24 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.142.25])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3F0CE363E1
	for <linux-media@vger.kernel.org>; Fri,  6 Jun 2014 17:20:54 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] MAINTAINERS: Add the OMAP4 ISS driver
Date: Fri,  6 Jun 2014 17:21:46 +0200
Message-Id: <1402068106-32677-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the OMAP Image Signal Processor entry to cover both the OMAP3 ISP
and OMAP4 ISS.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b7c633..6f2f537 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6402,11 +6402,12 @@ L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mach-omap2/omap_hwmod_44xx_data.c
 
-OMAP IMAGE SIGNAL PROCESSOR (ISP)
+OMAP IMAGING SUBSYSTEM (OMAP3 ISP and OMAP4 ISS)
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/platform/omap3isp/
+F:	drivers/staging/media/omap4iss/
 
 OMAP USB SUPPORT
 M:	Felipe Balbi <balbi@ti.com>
-- 
1.8.5.5

