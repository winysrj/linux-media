Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab3LDA4e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:34 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5C284366A4
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 15/25] v4l: omap4iss: resizer: Stop the whole resizer to avoid FIFO overflows
Date: Wed,  4 Dec 2013 01:56:15 +0100
Message-Id: <1386118585-12449-16-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When stopping the resizer due to a buffer underrun, disabling RZA only
produces input FIFO overflows, most probably when the next frame is
received. Disable the whole resizer to work around the problem.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_resizer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 793325c..5bf5080 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -266,10 +266,12 @@ static void resizer_configure(struct iss_resizer_device *resizer)
 
 static void resizer_isr_buffer(struct iss_resizer_device *resizer)
 {
-	struct iss_device *iss = to_iss_device(resizer);
 	struct iss_buffer *buffer;
 
-	iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_EN, RSZ_EN_EN);
+	/* The whole resizer needs to be stopped. Disabling RZA only produces
+	 * input FIFO overflows, most probably when the next frame is received.
+	 */
+	resizer_enable(resizer, 0);
 
 	buffer = omap4iss_video_buffer_next(&resizer->video_out);
 	if (buffer == NULL)
@@ -277,7 +279,7 @@ static void resizer_isr_buffer(struct iss_resizer_device *resizer)
 
 	resizer_set_outaddr(resizer, buffer->iss_addr);
 
-	iss_reg_set(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_EN, RSZ_EN_EN);
+	resizer_enable(resizer, 1);
 }
 
 /*
-- 
1.8.3.2

