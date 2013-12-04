Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab3LDA4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:30 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 34B3F363F9
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:39 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/25] v4l: omap4iss: Don't make IRQ debugging functions inline
Date: Wed,  4 Dec 2013 01:56:08 +0100
Message-Id: <1386118585-12449-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let the compiler decide.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 65a1680..e6528fa 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -198,7 +198,7 @@ void omap4iss_configure_bridge(struct iss_device *iss,
 }
 
 #if defined(DEBUG) && defined(ISS_ISR_DEBUG)
-static inline void iss_isr_dbg(struct iss_device *iss, u32 irqstatus)
+static void iss_isr_dbg(struct iss_device *iss, u32 irqstatus)
 {
 	static const char * const name[] = {
 		"ISP_0",
@@ -245,7 +245,7 @@ static inline void iss_isr_dbg(struct iss_device *iss, u32 irqstatus)
 	pr_cont("\n");
 }
 
-static inline void iss_isp_isr_dbg(struct iss_device *iss, u32 irqstatus)
+static void iss_isp_isr_dbg(struct iss_device *iss, u32 irqstatus)
 {
 	static const char * const name[] = {
 		"ISIF_0",
-- 
1.8.3.2

