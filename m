Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab3CCP66 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Mar 2013 10:58:58 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r23FwvnJ004186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 3 Mar 2013 10:58:57 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/11] [media] mb86a20s: Don't reset strength with the other stats
Date: Sun,  3 Mar 2013 12:58:48 -0300
Message-Id: <1362326331-17541-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
References: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signal strength is always available. There's no reason to reset
it, as it has its own logic to reset it already.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 1589662..7238947 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -754,7 +754,6 @@ static int mb86a20s_reset_counters(struct dvb_frontend *fe)
 
 	/* Reset the counters, if the channel changed */
 	if (state->last_frequency != c->frequency) {
-		memset(&c->strength, 0, sizeof(c->strength));
 		memset(&c->cnr, 0, sizeof(c->cnr));
 		memset(&c->pre_bit_error, 0, sizeof(c->pre_bit_error));
 		memset(&c->pre_bit_count, 0, sizeof(c->pre_bit_count));
-- 
1.8.1.4

