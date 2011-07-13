Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab1GMV0V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 17:26:21 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Chris Dodge <chris@redrat.co.uk>,
	Andrew Vincer <andrew.vincer@redrat.co.uk>,
	Stephen Cox <scox_nz@yahoo.com>
Subject: [PATCH 2/3] [media] redrat3: cap duration in the right place
Date: Wed, 13 Jul 2011 17:26:06 -0400
Message-Id: <1310592367-11501-3-git-send-email-jarod@redhat.com>
In-Reply-To: <1310592367-11501-1-git-send-email-jarod@redhat.com>
References: <1310592367-11501-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trying to cap duration before multiplying it was obviously wrong.

CC: Chris Dodge <chris@redrat.co.uk>
CC: Andrew Vincer <andrew.vincer@redrat.co.uk>
CC: Stephen Cox <scox_nz@yahoo.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/redrat3.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 9134254..5312e34 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -496,9 +496,6 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 		u16 val = len_vals[data_vals[i]];
 		single_len = redrat3_len_to_us((u32)be16_to_cpu(val));
 
-		/* cap the value to IR_MAX_DURATION */
-		single_len &= IR_MAX_DURATION;
-
 		/* we should always get pulse/space/pulse/space samples */
 		if (i % 2)
 			rawir.pulse = false;
@@ -506,6 +503,9 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 			rawir.pulse = true;
 
 		rawir.duration = US_TO_NS(single_len);
+		/* cap the value to IR_MAX_DURATION */
+		rawir.duration &= IR_MAX_DURATION;
+
 		rr3_dbg(dev, "storing %s with duration %d (i: %d)\n",
 			rawir.pulse ? "pulse" : "space", rawir.duration, i);
 		ir_raw_event_store_with_filter(rr3->rc, &rawir);
-- 
1.7.1

