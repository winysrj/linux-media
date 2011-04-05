Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43021 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab1DEH5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:15 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6853435B6E
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:11 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 07/14] omap3isp: stat: update struct ispstat_generic_config's comments
Date: Tue,  5 Apr 2011 09:57:29 +0200
Message-Id: <1301990256-6963-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: David Cohen <david.cohen@nokia.com>

struct ispstat_generic_config's comments refers to isph3a_aewb_config,
isph3a_af_config and isphist_config. But those structs have had their
names prefixed with 'omap3'. So, let's update the comments.

Signed-off-by: David Cohen <david.cohen@nokia.com>
---
 drivers/media/video/omap3isp/ispstat.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispstat.h b/drivers/media/video/omap3isp/ispstat.h
index 820950c..d86da94 100644
--- a/drivers/media/video/omap3isp/ispstat.h
+++ b/drivers/media/video/omap3isp/ispstat.h
@@ -131,9 +131,9 @@ struct ispstat {
 struct ispstat_generic_config {
 	/*
 	 * Fields must be in the same order as in:
-	 *  - isph3a_aewb_config
-	 *  - isph3a_af_config
-	 *  - isphist_config
+	 *  - omap3isp_h3a_aewb_config
+	 *  - omap3isp_h3a_af_config
+	 *  - omap3isp_hist_config
 	 */
 	u32 buf_size;
 	u16 config_counter;
-- 
1.7.3.4

