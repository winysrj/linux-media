Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-1.ms.rz.rwth-aachen.de ([134.130.7.72]:46650 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533Ab3AKPan (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 10:30:43 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0MGG00DH3V157H50@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-media@vger.kernel.org; Fri, 11 Jan 2013 16:00:41 +0100 (CET)
Received: from behemoth.local ([unknown] [137.226.57.124])
 by relay-auth-2.ms.rz.rwth-aachen.de
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec  9 2008))
 with ESMTPA id <0MGG003PVV15AG70@relay-auth-2.ms.rz.rwth-aachen.de> for
 linux-media@vger.kernel.org; Fri, 11 Jan 2013 16:00:41 +0100 (CET)
Message-id: <0MGG003PWV15AG70@relay-auth-2.ms.rz.rwth-aachen.de>
Date: Fri, 11 Jan 2013 16:00:19 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Johannes Schellen <Johannes.Schellen@rwth-aachen.de>
Subject: [PATCH] omap3isp: Fix histogram regions
Cc: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Johannes Schellen <Johannes.Schellen@rwth-aachen.de>

This patch fixes a bug which causes all histogram regions to start in the
top left corner of the image. The histogram region coordinates are 16 bit
values which share a 32 bit register. The bug is due to the region end
value assignments overwriting the region start values with zero.
Signed-off-by: Johannes Schellen <Johannes.Schellen@rwth-aachen.de>
---
The patch is against v3.8-rc3

--- linux-3.8-rc3/drivers/media/platform/omap3isp/isphist.c.orig
+++ linux-3.8-rc3/drivers/media/platform/omap3isp/isphist.c
@@ -114,14 +114,14 @@ static void hist_setup_regs(struct ispst
 	/* Regions size and position */
 	for (c = 0; c < OMAP3ISP_HIST_MAX_REGIONS; c++) {
 		if (c < conf->num_regions) {
-			reg_hor[c] = conf->region[c].h_start <<
-				     ISPHIST_REG_START_SHIFT;
-			reg_hor[c] = conf->region[c].h_end <<
-				     ISPHIST_REG_END_SHIFT;
-			reg_ver[c] = conf->region[c].v_start <<
-				     ISPHIST_REG_START_SHIFT;
-			reg_ver[c] = conf->region[c].v_end <<
-				     ISPHIST_REG_END_SHIFT;
+			reg_hor[c] = (conf->region[c].h_start <<
+				     ISPHIST_REG_START_SHIFT)
+			           | (conf->region[c].h_end <<
+				     ISPHIST_REG_END_SHIFT);
+			reg_ver[c] = (conf->region[c].v_start <<
+				     ISPHIST_REG_START_SHIFT)
+			           | (conf->region[c].v_end <<
+				     ISPHIST_REG_END_SHIFT);
 		} else {
 			reg_hor[c] = 0;
 			reg_ver[c] = 0;

