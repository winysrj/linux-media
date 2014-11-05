Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35346 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaKELXt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 06:23:49 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] [media] stv090x: Fix delivery system setting
Date: Wed,  5 Nov 2014 09:23:38 -0200
Message-Id: <1011d24a2148f77aaa2d4afc1c0f48e40589d020.1415186611.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As sparse complains:
	drivers/media/dvb-frontends/stv090x.c:3471:30: warning: mixing different enum types
	drivers/media/dvb-frontends/stv090x.c:3471:30:     int enum fe_delivery_system  versus
	drivers/media/dvb-frontends/stv090x.c:3471:30:     int enum stv090x_delsys

There's actually an error when setting the delivery system on
stv090x_search(): it is using the DVBv5 macros as if they were
the stv090x ones.

Instead, we should convert between the two namespaces, returning
an error if an unsupported delivery system is requested.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 93f4979ea6e9..f8050b984a8f 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -3468,7 +3468,20 @@ static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
 	if (props->frequency == 0)
 		return DVBFE_ALGO_SEARCH_INVALID;
 
-	state->delsys = props->delivery_system;
+	switch (props->delivery_system) {
+	case SYS_DSS:
+		state->delsys = STV090x_DSS;
+		break;
+	case SYS_DVBS:
+		state->delsys = STV090x_DVBS1;
+		break;
+	case SYS_DVBS2:
+		state->delsys = STV090x_DVBS2;
+		break;
+	default:
+		return DVBFE_ALGO_SEARCH_INVALID;
+	}
+
 	state->frequency = props->frequency;
 	state->srate = props->symbol_rate;
 	state->search_mode = STV090x_SEARCH_AUTO;
-- 
1.9.3

