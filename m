Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50469 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963AbaLMLxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:53:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/10] av7110: fix sparse warning
Date: Sat, 13 Dec 2014 12:52:51 +0100
Message-Id: <1418471580-26510-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/ttpci/av7110.c:1226:15: warning: memset with byte count of 192512

Instead of memsetting this in one go, loop over each line and memset each line
separately.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ttpci/av7110.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index c1f0617..45199a1 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -1219,11 +1219,14 @@ static int stop_ts_capture(struct av7110 *budget)
 
 static int start_ts_capture(struct av7110 *budget)
 {
+	unsigned y;
+
 	dprintk(2, "budget: %p\n", budget);
 
 	if (budget->feeding1)
 		return ++budget->feeding1;
-	memset(budget->grabbing, 0x00, TS_BUFLEN);
+	for (y = 0; y < TS_HEIGHT; y++)
+		memset(budget->grabbing + y * TS_WIDTH, 0x00, TS_WIDTH);
 	budget->ttbp = 0;
 	SAA7146_ISR_CLEAR(budget->dev, MASK_10);  /* VPE */
 	SAA7146_IER_ENABLE(budget->dev, MASK_10); /* VPE */
-- 
2.1.3

