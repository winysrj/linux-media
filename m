Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab3AXQ24 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 11:28:56 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0OGStNm011384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Jan 2013 11:28:55 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/5] [media] mb86a20s: remove global BER/PER counters if per-layer counters vanish
Date: Thu, 24 Jan 2013 14:28:51 -0200
Message-Id: <1359044931-13058-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1359044931-13058-1-git-send-email-mchehab@redhat.com>
References: <1359044931-13058-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If, for any reason, all per-layers counters stop, remove the
corresponding global counter.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index ed39ee1..f19cd73 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -1604,7 +1604,6 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 					"%s: Can't get BER for layer %c (error %d).\n",
 					__func__, 'A' + i, rc);
 			}
-
 			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
 				pre_ber_layers++;
 
@@ -1627,7 +1626,6 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 					"%s: Can't get BER for layer %c (error %d).\n",
 					__func__, 'A' + i, rc);
 			}
-
 			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
 				post_ber_layers++;
 
@@ -1652,7 +1650,6 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 					__func__, 'A' + i, rc);
 
 			}
-
 			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
 				per_layers++;
 
@@ -1686,6 +1683,9 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		c->pre_bit_error.stat[0].uvalue = t_pre_bit_error;
 		c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 		c->pre_bit_count.stat[0].uvalue = t_pre_bit_count;
+	} else {
+		c->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 	}
 
 	/*
@@ -1704,6 +1704,9 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		c->post_bit_error.stat[0].uvalue = t_post_bit_error;
 		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 		c->post_bit_count.stat[0].uvalue = t_post_bit_count;
+	} else {
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 	}
 
 	if (per_layers) {
@@ -1718,6 +1721,9 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		c->block_error.stat[0].uvalue = t_block_error;
 		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
 		c->block_count.stat[0].uvalue = t_block_count;
+	} else {
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
 	}
 
 	return rc;
-- 
1.8.1

