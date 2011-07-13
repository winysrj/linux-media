Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1GMV0V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 17:26:21 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Chris Dodge <chris@redrat.co.uk>,
	Andrew Vincer <andrew.vincer@redrat.co.uk>,
	Stephen Cox <scox_nz@yahoo.com>
Subject: [PATCH 1/3] [media] redrat3: sending extra trailing space was useless
Date: Wed, 13 Jul 2011 17:26:05 -0400
Message-Id: <1310592367-11501-2-git-send-email-jarod@redhat.com>
In-Reply-To: <1310592367-11501-1-git-send-email-jarod@redhat.com>
References: <1310592367-11501-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We already add a trailing space, this wasn't doing anything useful, and
actually confused lirc userspace a bit. Rip it out.

CC: Chris Dodge <chris@redrat.co.uk>
CC: Andrew Vincer <andrew.vincer@redrat.co.uk>
CC: Stephen Cox <scox_nz@yahoo.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/redrat3.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 5147767..9134254 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -414,20 +414,10 @@ static u32 redrat3_us_to_len(u32 microsec)
 
 }
 
-/* timer callback to send long trailing space on receive timeout */
+/* timer callback to send reset event */
 static void redrat3_rx_timeout(unsigned long data)
 {
 	struct redrat3_dev *rr3 = (struct redrat3_dev *)data;
-	DEFINE_IR_RAW_EVENT(rawir);
-
-	rawir.pulse = false;
-	rawir.duration = rr3->rc->timeout;
-	rr3_dbg(rr3->dev, "storing trailing space with duration %d\n",
-		rawir.duration);
-	ir_raw_event_store_with_filter(rr3->rc, &rawir);
-
-	rr3_dbg(rr3->dev, "calling ir_raw_event_handle\n");
-	ir_raw_event_handle(rr3->rc);
 
 	rr3_dbg(rr3->dev, "calling ir_raw_event_reset\n");
 	ir_raw_event_reset(rr3->rc);
-- 
1.7.1

