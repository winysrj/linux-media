Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3LDA4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:31 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8562635A6A
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:39 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 10/25] v4l: omap4iss: isif: Ignore VD0 interrupts when no buffer is available
Date: Wed,  4 Dec 2013 01:56:10 +0100
Message-Id: <1386118585-12449-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ISIF generates VD0 interrupts even when writes are disabled.
Disabling the ISIF when no buffer is available is thus not be enough, we
need to handle the situation explicitly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_ipipeif.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 3d6cc88..47fb1d6 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -235,6 +235,13 @@ static void ipipeif_isr_buffer(struct iss_ipipeif_device *ipipeif)
 {
 	struct iss_buffer *buffer;
 
+	/* The ISIF generates VD0 interrupts even when writes are disabled.
+	 * deal with it anyway). Disabling the ISIF when no buffer is available
+	 * is thus not be enough, we need to handle the situation explicitly.
+	 */
+	if (list_empty(&ipipeif->video_out.dmaqueue))
+		return;
+
 	ipipeif_write_enable(ipipeif, 0);
 
 	buffer = omap4iss_video_buffer_next(&ipipeif->video_out);
-- 
1.8.3.2

