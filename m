Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Wc6024237
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 92/94] [media] s921: Properly report the delivery system
Date: Fri, 30 Dec 2011 13:08:29 -0200
Message-Id: <1325257711-12274-93-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before this patch, a query for the delivery systems were
returned SYS_UNDEFINED.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    1 -
 drivers/media/dvb/frontends/s921.c        |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 9131f1a..9dd30be 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1309,7 +1309,6 @@ static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct
 		p->u.buffer.len = ncaps;
 		return;
 	}
-
 	switch (info->type) {
 	case FE_QPSK:
 		p->u.buffer.data[ncaps++] = SYS_DVBS;
diff --git a/drivers/media/dvb/frontends/s921.c b/drivers/media/dvb/frontends/s921.c
index 2e15f92..7652d3f 100644
--- a/drivers/media/dvb/frontends/s921.c
+++ b/drivers/media/dvb/frontends/s921.c
@@ -440,6 +440,7 @@ static int s921_get_frontend(struct dvb_frontend *fe,
 
 	/* FIXME: Probably it is possible to get it from regs f1 and f2 */
 	p->frequency = state->currentfreq;
+	p->delivery_system = SYS_ISDBT;
 
 	return 0;
 }
-- 
1.7.8.352.g876a6

