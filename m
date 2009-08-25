Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:57038 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZHYNUl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 09:20:41 -0400
Received: by ewy2 with SMTP id 2so406373ewy.17
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2009 06:20:42 -0700 (PDT)
Message-ID: <4A93E63F.90802@gmail.com>
Date: Tue, 25 Aug 2009 15:25:19 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] V4L/DVB: Fix test of bandwidth range in cx22700_set_tps()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the bandwidth to be less than 8 MHZ and greater than 6 MHZ is logically
impossible.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/dvb/frontends/cx22700.c b/drivers/media/dvb/frontends/cx22700.c
index fbd838e..5fbc0fc 100644
--- a/drivers/media/dvb/frontends/cx22700.c
+++ b/drivers/media/dvb/frontends/cx22700.c
@@ -155,7 +155,7 @@ static int cx22700_set_tps (struct cx22700_state *state, struct dvb_ofdm_paramet
 	    p->hierarchy_information > HIERARCHY_4)
 		return -EINVAL;
 
-	if (p->bandwidth < BANDWIDTH_8_MHZ && p->bandwidth > BANDWIDTH_6_MHZ)
+	if (p->bandwidth < BANDWIDTH_8_MHZ || p->bandwidth > BANDWIDTH_6_MHZ)
 		return -EINVAL;
 
 	if (p->bandwidth == BANDWIDTH_7_MHZ)
