Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab3AQS7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:59:09 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0HIx88l027483
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 13:59:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv11 15/16] [media] mb86a20s: global stat is just a sum, and not an increment
Date: Thu, 17 Jan 2013 16:58:29 -0200
Message-Id: <1358449110-11203-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
References: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As global BER stat is already summing both BER counters, it should
not be incremented with its previous value.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index b612985..7d21473 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -1002,9 +1002,9 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		 * bit errors on all active layers.
 		 */
 		c->bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->bit_error.stat[0].uvalue += t_bit_error;
+		c->bit_error.stat[0].uvalue = t_bit_error;
 		c->bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->bit_count.stat[0].uvalue += t_bit_count;
+		c->bit_count.stat[0].uvalue = t_bit_count;
 
 		/* All BER measures need to be collected when ready */
 		for (i = 0; i < 3; i++)
-- 
1.7.11.7

