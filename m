Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab3LDA4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:42 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id EB839366B1
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:41 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 25/25] v4l: omap4iss: resizer: Fix comment regarding bypass mode
Date: Wed,  4 Dec 2013 01:56:25 +0100
Message-Id: <1386118585-12449-26-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comment explaining the usage of the bypass bit is wrong, fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_resizer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index c6225d8..ae831b8 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -190,7 +190,9 @@ static void resizer_configure(struct iss_resizer_device *resizer)
 	informat = &resizer->formats[RESIZER_PAD_SINK];
 	outformat = &resizer->formats[RESIZER_PAD_SOURCE_MEM];
 
-	/* Make sure we don't bypass the resizer */
+	/* Disable pass-through more. Despite its name, the BYPASS bit controls
+	 * pass-through mode, not bypass mode.
+	 */
 	iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_FMT0,
 		    RSZ_SRC_FMT0_BYPASS);
 
-- 
1.8.3.2

